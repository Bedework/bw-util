/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.elasticsearch;

import org.bedework.util.indexing.IndexException;
import org.bedework.util.jmx.ConfBase;
import org.bedework.util.jmx.MBeanUtil;
import org.bedework.util.logging.Logged;
import org.bedework.util.misc.Util;
import org.bedework.util.timezones.DateTimeUtil;

import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.ActionFuture;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthRequestBuilder;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthResponse;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthStatus;
import org.elasticsearch.action.admin.cluster.state.ClusterStateRequest;
import org.elasticsearch.action.admin.indices.alias.IndicesAliasesRequestBuilder;
import org.elasticsearch.action.admin.indices.alias.IndicesAliasesResponse;
import org.elasticsearch.action.admin.indices.alias.get.GetAliasesRequestBuilder;
import org.elasticsearch.action.admin.indices.alias.get.GetAliasesResponse;
import org.elasticsearch.action.admin.indices.create.CreateIndexRequest;
import org.elasticsearch.action.admin.indices.create.CreateIndexRequestBuilder;
import org.elasticsearch.action.admin.indices.create.CreateIndexResponse;
import org.elasticsearch.action.admin.indices.delete.DeleteIndexRequestBuilder;
import org.elasticsearch.action.admin.indices.delete.DeleteIndexResponse;
import org.elasticsearch.action.admin.indices.status.IndicesStatusRequestBuilder;
import org.elasticsearch.action.admin.indices.status.IndicesStatusResponse;
import org.elasticsearch.action.get.GetRequestBuilder;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexRequestBuilder;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.ClusterAdminClient;
import org.elasticsearch.client.IndicesAdminClient;
import org.elasticsearch.client.Requests;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.cluster.metadata.AliasMetaData;
import org.elasticsearch.common.Strings;
import org.elasticsearch.common.collect.ImmutableOpenMap;
import org.elasticsearch.common.io.Streams;
import org.elasticsearch.common.settings.ImmutableSettings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.index.VersionType;
import org.elasticsearch.node.Node;
import org.elasticsearch.node.NodeBuilder;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.management.ObjectName;

/**
 * User: mike Date: 3/13/16 Time: 23:28
 */
public class EsUtil implements Logged {
  private final String host;
  private int port = 9300;

  private static Client theClient;
  private static final Object clientSyncher = new Object();

  private final IndexProperties idxpars;
  
  public EsUtil(final IndexProperties idxpars) {
    this.idxpars = idxpars;

    final String url = idxpars.getIndexerURL();

    if (url == null) {
      host = "localhost";
    } else {
      final int pos = url.indexOf(":");

      if (pos < 0) {
        host = url;
      } else {
        host = url.substring(0, pos);
        if (pos < url.length()) {
          port = Integer.valueOf(url.substring(pos + 1));
        }
      }
    }
  }
  
  private static EsCtlMBean esCtl;

  static class Configurator extends ConfBase {
    EsCtl esCtl;

    Configurator() {
      super("org.bedework.es:service=es");
    }

    @Override
    public String loadConfig() {
      return null;
    }

    @Override
    public void start() {
      String status = null;
      
      try {
        getManagementContext().start();

        esCtl = new EsCtl();
        register(new ObjectName(esCtl.getServiceName()),
                 esCtl);

        status = esCtl.loadConfig();
      } catch (Throwable t){
        t.printStackTrace();
        throw new RuntimeException(t);
      }

      if (!"OK".equals(status)) {
        throw new RuntimeException("Unable to load configuration. " +
                                           "Status: " + status);
      }
    }

    @Override
    public void stop() {
      try {
        getManagementContext().stop();
      } catch (Throwable t){
        t.printStackTrace();
      }
    }
    
    boolean isRegistered() {
      try {
        return getManagementContext()
                .getMBeanServer()
                .isRegistered(new ObjectName(EsCtlMBean.serviceName));
      } catch (final Throwable t) {
        t.printStackTrace();
        throw new RuntimeException(t);
      }
    }
  }

  private static Configurator conf = new Configurator();

  public static EsCtlMBean getEsCtl() throws IndexException {
    if (esCtl != null) {
      return esCtl;
    }

    try {
      /* See if somebody else registered the mbean
       */
      if (!conf.isRegistered()) {
        /* We need to register it */
        conf.start();
      }
      
      esCtl = (EsCtlMBean)MBeanUtil.getMBean(EsCtlMBean.class,
                                             EsCtlMBean.serviceName);
    } catch (final Throwable t) {
      throw new IndexException(t);
    }

    return esCtl;
  }

  public Client getClient() throws IndexException {
    if (theClient != null) {
      return theClient;
    }

    synchronized (clientSyncher) {
      if (theClient != null) {
        return theClient;
      }

      if (idxpars.getEmbeddedIndexer()) {
        /* Start up a node and get a client from it.
         */
        final ImmutableSettings.Builder settings =
                ImmutableSettings.settingsBuilder();

        if (idxpars.getNodeName() != null) {
          settings.put("node.name", idxpars.getNodeName());
        }

        settings.put("path.data", idxpars.getDataDir());

        if (idxpars.getHttpEnabled()) {
          warn("*************************************************************");
          warn("*************************************************************");
          warn("*************************************************************");
          warn("http is enabled for the indexer. This is a security risk.    ");
          warn("Turn it off in the indexer configuration.                    ");
          warn("*************************************************************");
          warn("*************************************************************");
          warn("*************************************************************");
        }
        settings.put("http.enabled", idxpars.getHttpEnabled());
        final NodeBuilder nbld = NodeBuilder.nodeBuilder()
                                            .settings(settings);

        if (idxpars.getClusterName() != null) {
          nbld.clusterName(idxpars.getClusterName());
        }

        final Node theNode = nbld.data(true).local(true).node();

        theClient = theNode.client();
      } else {
        /* Not embedded - use the URL */
        TransportClient tClient = new TransportClient();

        tClient = tClient.addTransportAddress(
                new InetSocketTransportAddress(host, port));

        theClient = tClient;
      }

      /* Ensure status is at least yellow */

      int tries = 0;
      int yellowTries = 0;

      for (;;) {
        final ClusterHealthRequestBuilder chrb =
                theClient.admin().cluster().prepareHealth();

        final ClusterHealthResponse chr = chrb.execute().actionGet();

        if (chr.getStatus() == ClusterHealthStatus.GREEN) {
          break;
        }

        if (chr.getStatus() == ClusterHealthStatus.YELLOW) {
          yellowTries++;

          if (yellowTries > 60) {
            warn("Going ahead anyway on YELLOW status");
          }

          break;
        }

        tries++;

        if (tries % 5 == 0) {
          warn("Cluster status for " + chr.getClusterName() +
                       " is still " + chr.getStatus() +
                       " after " + tries + " tries");
        }

        try {
          Thread.sleep(1000);
        } catch(final InterruptedException ex) {
          throw new IndexException("Interrupted out of getClient");
        }
      }

      return theClient;
    }
  }

  public IndexResponse indexDoc(final EsDocInfo di,
                                final String targetIndex) throws IndexException {
    //batchCurSize++;
    final IndexRequestBuilder req = getClient().
                 prepareIndex(targetIndex, di.getType(), di.getId());

    req.setSource(di.getSource());

    if (di.getVersion() != 0) {
      req.setVersion(di.getVersion()).setVersionType(VersionType.EXTERNAL);
    }

    if (debug()) {
      debug("Indexing to index " + targetIndex +
                    " with DocInfo " + di);
    }

    return req.execute().actionGet();
  }
  
  public GetResponse get(final String index,
                         final String docType,
                         final String id) throws IndexException {
    final GetRequestBuilder grb = getClient().prepareGet(index,
                                                         docType,
                                                         id);
    final GetResponse gr = grb.execute().actionGet();

    if (!gr.isExists()) {
      return null;
    }

    return gr;
  }

  /** create a new index and return its name. No alias will point to 
   * the new index.
   *
   * @param name basis for new name 
   * @param mappingPath path to mapping file.
   * @return name of created index.
   * @throws IndexException for errors
   */
  public String newIndex(final String name,
                         final String mappingPath) throws IndexException {
    try {
      final String newName = name + newIndexSuffix();

      final IndicesAdminClient idx = getAdminIdx();

      final CreateIndexRequestBuilder cirb = idx.prepareCreate(newName);

      final File f = new File(mappingPath);

      final byte[] sbBytes = Streams.copyToByteArray(f);

      cirb.setSource(sbBytes);

      final CreateIndexRequest cir = cirb.request();

      final ActionFuture<CreateIndexResponse> af = idx.create(cir);

      /*resp = */af.actionGet();

      //index(new UpdateInfo());

      info("Index created");

      return newName;
    } catch (final ElasticsearchException ese) {
      // Failed somehow
      error(ese);
      return null;
    } catch (final IndexException ie) {
      throw ie;
    } catch (final Throwable t) {
      error(t);
      throw new IndexException(t);
    }
  }
  
  public Set<IndexInfo> getIndexInfo() throws IndexException {
    final Set<IndexInfo> res = new TreeSet<>();

    try {
      final IndicesAdminClient idx = getAdminIdx();

      final IndicesStatusRequestBuilder isrb =
              idx.prepareStatus(Strings.EMPTY_ARRAY);

      final ActionFuture<IndicesStatusResponse> sr = idx.status(
              isrb.request());
      final IndicesStatusResponse sresp  = sr.actionGet();

      for (final String inm: sresp.getIndices().keySet()) {
        final IndexInfo ii = new IndexInfo(inm);
        res.add(ii);

        final ClusterStateRequest clusterStateRequest = Requests
                .clusterStateRequest()
                .routingTable(true)
                .nodes(true)
                .indices(inm);

        final Iterator<String> it =
                getAdminCluster().state(clusterStateRequest).
                        actionGet().getState().getMetaData().aliases().keysIt();
        while (it.hasNext()) {
          ii.addAlias(it.next());
        }
      }

      return res;
    } catch (final Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Remove any index that doesn't have an alias and starts with 
   * the given prefix
   * 
   * @param prefixes Ignore indexes that have names that don't start 
   *                 with any of these
   * @return list of purged indexes
   * @throws IndexException
   */
  public List<String> purgeIndexes(final Set<String> prefixes) 
          throws IndexException {
    final Set<IndexInfo> indexes = getIndexInfo();
    final List<String> purged = new ArrayList<>();

    if (Util.isEmpty(indexes)) {
      return purged;
    }

    purge:
    for (final IndexInfo ii: indexes) {
      final String idx = ii.getIndexName();

      if (!hasPrefix(idx, prefixes)) {
        continue purge;
      }

      /* Don't delete those pointed to by any aliases */

      if (!Util.isEmpty(ii.getAliases())) {
        continue purge;
      }

      purged.add(idx);
    }

    deleteIndexes(purged);

    return purged;
  }

  /** Changes the givenm alias to refer tot eh supplied index name
   * 
   * @param index the index we were building 
   * @param alias to refer to this index
   * @return 0 fir ok <0 for not ok
   * @throws IndexException
   */
  public int swapIndex(final String index,
                       final String alias) throws IndexException {
    //IndicesAliasesResponse resp = null;
    try {
      /* index is the index we were just indexing into
       */

      final IndicesAdminClient idx = getAdminIdx();

      final GetAliasesRequestBuilder igarb = idx.prepareGetAliases(
              alias);

      final ActionFuture<GetAliasesResponse> getAliasesAf =
              idx.getAliases(igarb.request());
      final GetAliasesResponse garesp = getAliasesAf.actionGet();

      final ImmutableOpenMap<String, List<AliasMetaData>> aliasesmeta =
              garesp.getAliases();

      final IndicesAliasesRequestBuilder iarb = idx.prepareAliases();

      final Iterator<String> it = aliasesmeta.keysIt();

      while (it.hasNext()) {
        final String indexName = it.next();

        for (final AliasMetaData amd: aliasesmeta.get(indexName)) {
          if(amd.getAlias().equals(alias)) {
            iarb.removeAlias(indexName, alias);
          }
        }
      }

      iarb.addAlias(index, alias);

      final ActionFuture<IndicesAliasesResponse> af =
              idx.aliases(iarb.request());

      /*resp = */af.actionGet();

      return 0;
    } catch (final ElasticsearchException ese) {
      // Failed somehow
      error(ese);
      return -1;
    } catch (final IndexException ie) {
      throw ie;
    } catch (final Throwable t) {
      throw new IndexException(t);
    }
  }

  public IndicesAdminClient getAdminIdx() throws IndexException {
    return getClient().admin().indices();
  }

  public ClusterAdminClient getAdminCluster() throws IndexException {
    return getClient().admin().cluster();
  }

  private void deleteIndexes(final List<String> names) throws IndexException {
    try {
      final IndicesAdminClient idx = getAdminIdx();
      final DeleteIndexRequestBuilder dirb = getAdminIdx().prepareDelete(
              names.toArray(new String[names.size()]));

      final ActionFuture<DeleteIndexResponse> dr = idx.delete(
              dirb.request());
      /*DeleteIndexResponse dir = */dr.actionGet();
    } catch (final Throwable t) {
      throw new IndexException(t);
    }
  }
  
  private boolean hasPrefix(final String name, 
                           final Set<String> prefixes) {
    for (final String prefix: prefixes) {
      if (name.startsWith(prefix)) {
        return true;
      }
    }
    
    return false;
  }

  private String newIndexSuffix() {
    // ES only allows lower case letters in names (and digits)
    final StringBuilder suffix = new StringBuilder("p");

    final char[] ch = DateTimeUtil.isoDateTimeUTC(new Date()).toCharArray();

    for (int i = 0; i < 8; i++) {
      suffix.append(ch[i]);
    }

    suffix.append('t');

    for (int i = 9; i < 15; i++) {
      suffix.append(ch[i]);
    }

    return suffix.toString();
  }
}
