package org.bedework.util.deployment;

import org.bedework.util.args.Args;
import org.bedework.util.dav.DavUtil;
import org.bedework.util.dav.DavUtil.DavChild;
import org.bedework.util.http.BasicHttpClient;
import org.bedework.util.misc.Util;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.logging.Log;
import org.apache.maven.plugins.annotations.Mojo;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/** Process a ear for deployment. The ear is in its exploded form -
 * nothing zipped. This app will use the wars inside as patterns
 * and update them to include virtual host and security domains.
 *
 * <p>Some wars may be duplicated e.g. to provide a calendar suite</p>
 *
 * <p>War names are of the form <br/>
 * &lt;name-part&gt;-&lt;version&gt;.war<br/>
 * where the name part identifies the war and can be used as a
 * template name for duplication. It is also used as the key to
 * properties.</p>
 *
 * @author douglm
 */
@Mojo(name = "bedework-deploy")
public class ProcessEars extends AbstractMojo {
  /** The path of the properties file */
  public static final String propPropertiesFile =
          "org.bedework.global.propertiesFile";

  /** The path of directory containing the properties file */
  public static final String propPropertiesDir =
          "org.bedework.global.propertiesDir";

  static void usage(final String error_msg) {
    if (error_msg != null) {
      System.err.println(error_msg);
    }

    System.out.print("Usage: processEar [options]\n" +
                        "Options:\n" +
                        "    -h             Print this help and exit\n" +
                        "    --in           Directory for ears\n" +
                        "    --inurl        WebDAV location for ears\n" +
                        "    --out          Directory for modified ears\n" +
                        "    --deploy       Directory to deploy modified ears\n" +
                        "    --resources    Base for resource references\n" +
                        "    --noclean      Don't delete temp dirs - helps debugging\n" +
                        "    --noversion    If specified suppress version check\n" +
                        "    --checkonly    Display what would be deployed without this flag\n" +
                        "    --delete       If specified delete target ear if it exists\n" +
                        "    --prop         Path to property file defining configuration\n" +
                        "    --ear          If specified restrict processing to named ear\n" +
                        "    --debug        Enable debugging messages\n" +
                        "\n" +
                        "Description:\n" +
                        "    This utility updates an exploded ear making it ready\n" +
                        "    for deployment.\n" +
                        "\n" +
                        "    Only ear files later than the currently deployed ears\n" +
                        "    will be processed.\n" +
                        "\n" +
                        "    The 'out' directory is first deleted and recreated\n" +
                        "\n" +
                        "    If 'inurl' is specified a list of the latest ears from\n" +
                        "    that location is created. These ears will be downloaded to a\n" +
                        "    temporary input directory and unzipped.\n" +
                        "\n" +
                        "    The ear is copied from the specified 'in' directory \n" +
                        "    to the 'out' and then modified.\n" +
                        "\n" +
                        "    If '--deploy' has been specified the modified ear is then \n" +
                        "    copied from the 'out' directory to the 'deploy' directory.\n" +
                        "\n" +
                        "    This process avoids the application server attempting to \n" +
                        "    deploy partially modified ears.\n");

    if (error_msg != null) {
      throw new RuntimeException(error_msg);
    }
  }

  private boolean debug;

  private boolean error;

  private String inUrl;

  private String inDirPath;

  private String outDirPath;

  private String deployDirPath;

  private boolean noversion;

  private boolean checkonly;

  private boolean delete;

  private boolean cleanup = true;

  private String earName;

  private String resourcesBase;

  private String propsPath;

  private Properties props;

  private Utils utils;

  private final PropertiesChain pc = new PropertiesChain();

  private final Map<String, Ear> ears = new HashMap<>();

  private final List<Path> tempDirs = new ArrayList<>();

  private void loadProperties() throws Throwable {
    final File f = utils.file(propsPath);

    final FileReader fr = new FileReader(f);

    props = new Properties();

    props.load(fr);

    props.setProperty("org.bedework.global.propertiesFile", propsPath);
    props.setProperty("org.bedework.global.propertiesDir", f.getParent());
  }

  boolean processArgs(final Args args) throws Throwable {
    if (args == null) {
      return true;
    }

    while (args.more()) {
      if (args.ifMatch("")) {
        continue;
      }

      if (args.ifMatch("-h")) {
        usage(null);
      } else if (args.ifMatch("--in")) {
        if (inUrl != null) {
          usage("Only one of --in or --inurl: " + args.current());
          return false;
        }

        inDirPath = args.next();
      } else if (args.ifMatch("--inurl")) {
        if (inDirPath != null) {
          usage("Only one of --in or --inurl: " + args.current());
          return false;
        }

        inUrl = args.next();
      } else if (args.ifMatch("--out")) {
        outDirPath = args.next();
      } else if (args.ifMatch("--props")) {
        propsPath = args.next();
      } else if (args.ifMatch("--noclean")) {
        cleanup = false;
      } else if (args.ifMatch("--noversion")) {
        noversion = true;
      } else if (args.ifMatch("--checkonly")) {
        checkonly = true;
      } else if (args.ifMatch("--delete")) {
        delete = true;
      } else if (args.ifMatch("--ear")) {
        earName = args.next();
      } else if (args.ifMatch("--debug")) {
        debug = true;
      } else if (args.ifMatch("--resources")) {
        resourcesBase = args.next();
      } else if (args.ifMatch("--h")) {
        usage(null);
        return false;
      } else {
        usage("Unrecognized option: " + args.current());
        return false;
      }
    }

    return true;
  }

  /** Used by the runnable version with no log4j
   *
   */
  private static class Logger implements Log {
    public boolean debug;

    @Override
    public boolean isDebugEnabled() {
      return debug;
    }

    @Override
    public void debug(final CharSequence charSequence) {
      System.out.println("DEBUG: " + charSequence);
    }

    @Override
    public void debug(final CharSequence charSequence,
                      final Throwable throwable) {
      System.out.println("DEBUG: " + charSequence);
      throwable.printStackTrace();
    }

    @Override
    public void debug(final Throwable throwable) {
      System.out.println("DEBUG: " + throwable.getLocalizedMessage());
      throwable.printStackTrace();
    }

    @Override
    public boolean isInfoEnabled() {
      return true;
    }

    @Override
    public void info(final CharSequence charSequence) {
      System.out.println("INFO: " + charSequence);
    }

    @Override
    public void info(final CharSequence charSequence,
                     final Throwable throwable) {
      System.out.println("INFO: " + charSequence +
                                 throwable.getLocalizedMessage());
    }

    @Override
    public void info(final Throwable throwable) {
      System.out.println("INFO: " + throwable.getLocalizedMessage());
      throwable.printStackTrace();
    }

    @Override
    public boolean isWarnEnabled() {
      return true;
    }

    @Override
    public void warn(final CharSequence charSequence) {
      System.err.println("WARN: " + charSequence);
    }

    @Override
    public void warn(final CharSequence charSequence,
                     final Throwable throwable) {
      System.err.println("WARN: " + charSequence);
      throwable.printStackTrace(System.err);
    }

    @Override
    public void warn(final Throwable throwable) {
      throwable.printStackTrace(System.err);
    }

    @Override
    public boolean isErrorEnabled() {
      return true;
    }

    @Override
    public void error(final CharSequence charSequence) {
      System.err.println("ERROR: " + charSequence);
    }

    @Override
    public void error(final CharSequence charSequence,
                      final Throwable throwable) {
      System.err.println("ERROR: " + charSequence);
      throwable.printStackTrace(System.err);
    }

    @Override
    public void error(final Throwable throwable) {
      throwable.printStackTrace(System.err);
    }
  }

  /**
   * @param args program arguments
   * @throws Exception
   */
  public static void main(final String[] args) throws Exception {
    ProcessEars pe = new ProcessEars();

    try {
      if (!pe.processArgs(new Args(args))) {
        return;
      }

      final Logger logger = new Logger();
      logger.debug = pe.debug;
      pe.setLog(logger);
      pe.execute();
    } catch (final Throwable t) {
      t.printStackTrace();
    }

    if (pe.propsPath == null) {
      usage("Must specify --props");
      return;
    }
  }

  public void execute() {
    utils = new Utils(getLog());

    try {
      loadProperties();

      pc.push(props);

      final boolean wildfly = Boolean.valueOf(pc.get("org.bedework.for.wildfly"));
      if (wildfly) {
        utils.info("Building for wildfly");
      }

      inUrl = defaultVal(inUrl,
                         "org.bedework.postdeploy.inurl");

      if (inUrl == null) {
        inDirPath = defaultVal(inDirPath,
                               "org.bedework.postdeploy.in",
                               "--in");
      } else {
        inDirPath = getRemoteFiles(inUrl);
        if (inDirPath == null) {
          return;
        }
      }

      outDirPath = defaultVal(outDirPath,
                              "org.bedework.postdeploy.out",
                              "--out");

      deployDirPath = defaultVal(deployDirPath,
                                 "org.bedework.postdeploy.deploy");

      resourcesBase = defaultVal(resourcesBase,
                                 "org.bedework.postdeploy.resources.base",
                                 "--resources");

      if (error) {
        usage(null);
        return;
      }

      utils.info("input: " + inDirPath);
      utils.info("output: " + outDirPath);
      if (deployDirPath != null) {
        utils.info("deploy: " + deployDirPath);
      }
      utils.info("resources: " + resourcesBase);

      final List<String> earNames =
              pc.listProperty("org.bedework.ear.names");

      cleanOut(outDirPath);

      final List<SplitName> earSplitNames = getInEars(inDirPath,
                                                      earNames);

      final List<SplitName> deployedEars = getEarNames(deployDirPath);

      for (final SplitName sn: earSplitNames) {
        if ((earName != null) && !earName.equals(sn.prefix)) {
          continue;
        }

        if (!noversion) {
          // See if this is a later version than the deployed file
          if (!sn.laterThan(deployedEars)) {
            utils.warn("File " + sn.name + " not later than deployed file. Skipping");
            continue;
          }
        }

        if (!earNames.contains(sn.prefix)) {
          utils.warn(sn.name + " is not in the list of supported ears. Skipped");
          continue;
        }

        if (checkonly) {
          utils.info("Ear " + sn.name + " is deployable");
          continue;
        }

        utils.info("Processing " + sn.name);

        final Path inPath = Paths.get(inDirPath, sn.name);
        final Path outPath = Paths.get(outDirPath, sn.name);

        if (delete) {
          final File outFile = outPath.toFile();

          if (outFile.exists()) {
            utils.deleteAll(outPath);
          }
        }

        utils.copy(inPath, outPath, false);

        final Ear theEar = new Ear(utils, outDirPath, sn, pc);

        ears.put(sn.name, theEar);
      }

      if (checkonly) {
        return;
      }

      for (final Ear ear: ears.values()) {
        ear.update();
      }

      if (deployDirPath == null) {
        utils.info("No deployment path specified. Terminating");
        return;
      }

      int deployed = 0;

      for (final SplitName sn: getEarNames(outDirPath)) {
        utils.info("Deploying " + sn.name);
        deployed++;

        utils.deleteMatching(deployDirPath, sn);
        final Path deployPath = Paths.get(deployDirPath, sn.name);

        if (delete) {
          final File deployFile = deployPath.toFile();

          if (deployFile.exists()) {
            utils.deleteAll(deployPath);
          }
        }

        if (wildfly) {
          // Remove any deployment directive files
          Path thePath = Paths.get(deployDirPath, sn.name + ".failed");
          File theFile = thePath.toFile();

          if (theFile.exists()) {
            theFile.delete();
          }

          thePath = Paths.get(deployDirPath, sn.name + ".deployed");
          theFile = thePath.toFile();

          if (theFile.exists()) {
            theFile.delete();
          }

          thePath = Paths.get(deployDirPath, sn.name + ".dodeploy");
          theFile = thePath.toFile();

          if (theFile.exists()) {
            theFile.delete();
          }

        }
        final Path outPath = Paths.get(outDirPath, sn.name);
        utils.copy(outPath, deployPath, false);

        if (wildfly) {
          final File doDeploy = Paths.get(deployDirPath,
                                          sn.name + ".dodeploy").toFile();
          doDeploy.createNewFile();
        }
      }

      utils.info("Deployed " + deployed + " ears");
    } catch (final Throwable t) {
      t.printStackTrace();
    }

    if (cleanup) {
      // Try to delete any temp directories
      for (final Path tempPath: tempDirs) {
        try {
          utils.deleteAll(tempPath);
        } catch (final Throwable t) {
          utils.warn("Error trying to delete " + tempPath);
        }
      }
    }
  }

  private Path getTempDirectory(final String prefix)  throws Throwable {
    final Path tempPath = Files.createTempDirectory(prefix);

    tempDirs.add(tempPath);
    return tempPath;
  }

  /**
   *
   * @param inUrl the remote ear repository
   * @return path to directory containing downloaded files or null for errors.
   * @throws Throwable
   */
  private String getRemoteFiles(final String inUrl) throws Throwable {
    final BasicHttpClient cl = new BasicHttpClient(30000);

    final Path downloadPath = getTempDirectory("bwdownload");
    final Path expandPath = getTempDirectory("bwexpand");
    final String sourceEars = expandPath.toAbsolutePath().toString();

    try {
      final DavUtil du = new DavUtil();

      final Collection<DavChild> dcs = du.getChildrenUrls(cl, inUrl, null);

      final URI inUri = new URI(inUrl);

      if (Util.isEmpty(dcs)) {
        utils.warn("No files at " + inUrl);
        return null;
      }

      for (final DavChild dc: dcs) {
        URI dcUri = new URI(dc.uri);
        if (dcUri.getHost() == null) {
          dcUri = inUri.resolve(dc.uri);
        }

        if (getLog().isDebugEnabled()) {
          utils.info("Found url " + dcUri);
        }

        final InputStream is = cl.get(dcUri.toString());

        if (is == null) {
          utils.warn("Unable to fetch " + dcUri);
          return null;
        }

        final String zipName = dc.displayName + ".zip";

        final Path zipPath = downloadPath.resolve(zipName);

        Files.copy(is, zipPath);
        unzip(zipPath.toAbsolutePath().toString(),
              sourceEars);
      }
    } finally {
      cl.release();
    }

    return sourceEars;
  }

  private void unzip(final String zipPath,
                            final String destDir) throws Throwable {
    final byte[] buffer = new byte[4096];

    final FileInputStream fis = new FileInputStream(zipPath);
    final ZipInputStream zis = new ZipInputStream(fis);
    ZipEntry ze = zis.getNextEntry();
    while(ze != null){
      final File newFile = new File(destDir + File.separator +
                                            ze.getName());

      if (ze.isDirectory()) {
        if (getLog().isDebugEnabled()) {
          utils.info("Directory entry " + newFile.getAbsolutePath());
        }

        zis.closeEntry();
        ze = zis.getNextEntry();
        continue;
      }

      if (getLog().isDebugEnabled()) {
        utils.info("Unzip " + newFile.getAbsolutePath());
      }

      /* Zip entry has relative path which may require sub directories
       */
      //noinspection ResultOfMethodCallIgnored
      new File(newFile.getParent()).mkdirs();
      final FileOutputStream fos = new FileOutputStream(newFile);
      int len;
      while ((len = zis.read(buffer)) > 0) {
        fos.write(buffer, 0, len);
      }
      fos.close();
      //close this ZipEntry
      zis.closeEntry();
      ze = zis.getNextEntry();
    }

    //close last ZipEntry
    zis.closeEntry();
    zis.close();
    fis.close();
  }

  private void cleanOut(final String outDirPath) throws Throwable {
    final Path outPath = Paths.get(outDirPath);

    if (outPath.toFile().exists()) {
      utils.deleteAll(outPath);
    }

    if (utils.makeDir(outDirPath)) {
      utils.debug("created " + outDirPath);
    }
  }

  private List<SplitName> getInEars(final String dirPath,
                                           final List<String> earNames) throws Throwable {
    final File inDir = utils.directory(dirPath);

    final String[] names = inDir.list();

    final List<SplitName> earSplitNames = new ArrayList<>();

    for (final String nm: names) {
      final SplitName sn = SplitName.testName(nm, earNames);

      if ((sn == null) || (!"ear".equals(sn.suffix))) {
        continue;
      }

      earSplitNames.add(sn);
    }

    utils.info("Found " + earSplitNames.size() + " ears");

    return earSplitNames;
  }

  private List<SplitName> getEarNames(final String dirPath) throws Throwable {
    final File outDir = utils.directory(dirPath);

    final String[] deployEarNames = outDir.list();

    final List<SplitName> earSplitNames = new ArrayList<>();

    for (final String nm: deployEarNames) {
      final SplitName sn = SplitName.testName(nm);

      if ((sn == null) || (!"ear".equals(sn.suffix))) {
        //utils.warn("Unable to process " + nm);
        continue;
      }

      earSplitNames.add(sn);
    }

    return earSplitNames;
  }

  private String defaultVal(final String val,
                                   final String pname) {
    if (val != null) {
      return val;
    }

    return props.getProperty(pname);
  }

  private String defaultVal(final String val,
                                   final String pname,
                                   final String argName) {
    final String nval = defaultVal(val, pname);
    if (nval != null) {
      return nval;
    }

    utils.error("Must specify " + argName +
                        " or provide the value in the properties with the" +
                        " '" + pname + "' property");
    error = true;

    return null;
  }
}
