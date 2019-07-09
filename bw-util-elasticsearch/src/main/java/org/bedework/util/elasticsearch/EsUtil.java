/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.elasticsearch;

import org.bedework.util.indexing.IndexException;
import org.bedework.util.jmx.ConfBase;
import org.bedework.util.jmx.MBeanUtil;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;
import org.bedework.util.misc.Util;
import org.bedework.util.timezones.DateTimeUtil;

import org.apache.http.HttpHost;
import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthRequest;
import org.elasticsearch.action.admin.cluster.health.ClusterHealthResponse;
import org.elasticsearch.action.admin.indices.alias.IndicesAliasesRequest;
import org.elasticsearch.action.admin.indices.alias.IndicesAliasesRequest.AliasActions;
import org.elasticsearch.action.admin.indices.alias.get.GetAliasesRequest;
import org.elasticsearch.action.admin.indices.delete.DeleteIndexRequest;
import org.elasticsearch.action.get.GetRequest;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.support.master.AcknowledgedResponse;
import org.elasticsearch.client.GetAliasesResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.indices.CreateIndexRequest;
import org.elasticsearch.client.indices.CreateIndexResponse;
import org.elasticsearch.cluster.health.ClusterHealthStatus;
import org.elasticsearch.cluster.metadata.AliasMetaData;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.VersionType;
import org.elasticsearch.rest.RestStatus;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Stream;

import javax.management.ObjectName;

/**
 * User: mike Date: 3/13/16 Time: 23:28
 */
public class EsUtil implements Logged {
  private static class HostPort {
    private final String host;
    private int port = 9300;

    HostPort(final String url) {
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

    String getHost() {
      return host;
    }

    int getPort() {
      return port;
    }
  }

  private final List<HostPort> esHosts = new ArrayList<>();
  private static RestHighLevelClient theClient;
  private static final Object clientSyncher = new Object();

  private final IndexProperties idxpars;
  
  public EsUtil(final IndexProperties idxpars) {
    this.idxpars = idxpars;

    final String urls = idxpars.getIndexerURL();

    if (urls == null) {
      esHosts.add(new HostPort("localhost"));
    } else {
      final String[] urlsSplit = urls.split(",");

      for (final String url : urlsSplit) {
        if ((url != null) && (url.length() > 0)) {
          esHosts.add(new HostPort(url));
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

  public RestHighLevelClient getClient() throws IndexException {
    if (theClient != null) {
      return theClient;
    }

    synchronized (clientSyncher) {
      if (theClient != null) {
        return theClient;
      }

      final HttpHost[] hosts = new HttpHost[esHosts.size()];

      for (int i = 0; i < esHosts.size(); i++) {
        final HostPort hp = esHosts.get(i);
        hosts[i] = new HttpHost(hp.getHost(), hp.getPort());
      }

      theClient = new RestHighLevelClient(RestClient.builder(hosts));

      /* Ensure status is at least yellow */

      int tries = 0;
      int yellowTries = 0;

      for (;;) {
        try {
          ClusterHealthRequest request = new ClusterHealthRequest();
          final ClusterHealthResponse chr =
                  theClient.cluster().health(request, RequestOptions.DEFAULT);

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

          Thread.sleep(1000);
        } catch(final InterruptedException ex) {
          throw new IndexException("Interrupted out of getClient");
        } catch (final Throwable t) {
          throw new IndexException(t);
        }
      }

      return theClient;
    }
  }

  public IndexResponse indexDoc(final EsDocInfo di,
                                final String targetIndex) throws IndexException {
    final IndexRequest req =
            new IndexRequest(targetIndex)
                    .id(di.getId())
                    .source(di.getSource())
                    .versionType(VersionType.EXTERNAL);

    if (di.getVersion() != 0) {
      req.version(di.getVersion());
    }

    if (debug()) {
      debug("Indexing to index " + targetIndex +
                    " with DocInfo " + di);
    }

    try {
      return getClient().index(req, RequestOptions.DEFAULT);
    } catch (final Throwable t) {
      throw new IndexException(t);
    }
  }
  
  public GetResponse get(final String index,
                         final String docType,
                         final String id) throws IndexException {
    final GetRequest req = new GetRequest(index,
                                         id);
    try {
      final GetResponse resp = getClient().get(req, RequestOptions.DEFAULT);

      if (!resp.isExists()) {
        return null;
      }

      return resp;
    } catch (final Throwable t) {
      throw new IndexException(t);
    }
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

      final CreateIndexRequest req = new CreateIndexRequest(newName);

      final String mappingStr = fileToString(mappingPath);

      req.source(mappingStr, XContentType.JSON);

      final CreateIndexResponse resp =
              getClient().indices().create(req, RequestOptions.DEFAULT);

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
      GetAliasesRequest req = new GetAliasesRequest();

      final GetAliasesResponse resp =
              getClient().indices().getAlias(req, RequestOptions.DEFAULT);

      Map<String, Set<AliasMetaData>> aliases = resp.getAliases();

      for (final String inm: aliases.keySet()) {
        final IndexInfo ii = new IndexInfo(inm);
        res.add(ii);

        final Set<AliasMetaData> amds = aliases.get(inm);

        if (amds == null) {
          continue;
        }

        for (final AliasMetaData amd: amds) {
          ii.addAlias(amd.alias());
        }
      }

      return res;
    } catch (final Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Changes the given alias to refer to the supplied index name
   * 
   * @param index the index we were building 
   * @param alias to refer to this index
   * @return 0 fir ok <0 for not ok
   * @throws IndexException on fatal error
   */
  public int swapIndex(final String index,
                       final String alias) throws IndexException {
    //IndicesAliasesResponse resp = null;
    try {
      /* index is the index we were just indexing into
       */

      GetAliasesRequest req = new GetAliasesRequest(alias);

      final GetAliasesResponse resp =
              getClient().indices().getAlias(req, RequestOptions.DEFAULT);

      if (resp.status() == RestStatus.OK) {
        final Map<String, Set<AliasMetaData>> aliases =
                resp.getAliases();
        for (final String inm: aliases.keySet()) {
          final Set<AliasMetaData> amds = aliases.get(inm);

          if (amds == null) {
            continue;
          }

          for (final AliasMetaData amd: amds) {
            final IndicesAliasesRequest ireq = new IndicesAliasesRequest();
            final AliasActions removeAction =
                    new AliasActions(AliasActions.Type.REMOVE)
                            .index(inm)
                            .alias(amd.alias());
            ireq.addAliasAction(removeAction);
            AcknowledgedResponse ack =
                    getClient().indices().updateAliases(ireq, RequestOptions.DEFAULT);
        }
      }

      final IndicesAliasesRequest ireq = new IndicesAliasesRequest();
      final AliasActions addAction =
              new AliasActions(AliasActions.Type.ADD)
                      .index(index)
                      .alias(alias);
      ireq.addAliasAction(addAction);
      AcknowledgedResponse ack =
              getClient().indices().updateAliases(ireq, RequestOptions.DEFAULT);          }

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

  /** Remove any index that doesn't have an alias and starts with
   * the given prefix
   *
   * @param prefixes Ignore indexes that have names that don't start
   *                 with any of these
   * @return list of purged indexes
   * @throws IndexException on fatal error
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

  private void deleteIndexes(final List<String> names) throws IndexException {
    try {
      final DeleteIndexRequest request = new DeleteIndexRequest(names.toArray(new String[names.size()]));

      final AcknowledgedResponse deleteIndexResponse =
              getClient().indices().delete(request, RequestOptions.DEFAULT);
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

  private String fileToString(final String path) throws IndexException {
    final StringBuilder content = new StringBuilder();
    try (Stream<String> stream = Files.lines(Paths.get(path),
                                             StandardCharsets.UTF_8)) {
      stream.forEach(s -> content.append(s).append("\n"));
    } catch (final Throwable t) {
      throw new IndexException(t);
    }

    return content.toString();
  }

  /* ====================================================================
   *                   Logged methods
   * ==================================================================== */

  private BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
