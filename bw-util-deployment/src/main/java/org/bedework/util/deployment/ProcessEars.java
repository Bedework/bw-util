package org.bedework.util.deployment;

import org.bedework.util.args.Args;
import org.bedework.util.dav.DavUtil;
import org.bedework.util.dav.DavUtil.DavChild;
import org.bedework.util.http.BasicHttpClient;
import org.bedework.util.misc.Util;

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
public class ProcessEars {
  static void usage(final String error_msg) {
    if (error_msg != null) {
      Utils.error(error_msg);
    }

    Utils.print("Usage: processEar [options]\n" +
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

  private static boolean error;

  private static String inUrl;

  private static String inDirPath;

  private static String outDirPath;

  private static String deployDirPath;

  private static boolean noversion;

  private static boolean checkonly;

  private static boolean delete;

  private static boolean cleanup = true;

  private static String earName;

  private static String resourcesBase;

  private static String propsPath;

  private static Properties props;

  private final static PropertiesChain pc = new PropertiesChain();

  private final static Map<String, Ear> ears = new HashMap<>();

  private final static List<Path> tempDirs = new ArrayList<>();

  private static void loadProperties() throws Throwable {
    final File f = Utils.file(propsPath);

    final FileReader fr = new FileReader(f);

    props = new Properties();

    props.load(fr);
  }

  static boolean processArgs(final Args args) throws Throwable {
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
        Utils.debug = true;
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

  /**
   * @param args program arguments
   * @throws Exception
   */
  public static void main(final String[] args) throws Exception {
    try {
      if (!processArgs(new Args(args))) {
        return;
      }

      if (propsPath == null) {
        usage("Must specify --props");
        return;
      }

      loadProperties();

      pc.push(props);

      final boolean wildfly = Boolean.valueOf(pc.get("org.bedework.for.wildfly"));
      if (wildfly) {
        Utils.info("Building for wildfly");
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

      Utils.info("input: " + inDirPath);
      Utils.info("output: " + outDirPath);
      if (deployDirPath != null) {
        Utils.info("deploy: " + deployDirPath);
      }
      Utils.info("resources: " + resourcesBase);

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
            Utils.warn("File " + sn.name + " not later than deployed file. Skipping");
            continue;
          }
        }

        if (!earNames.contains(sn.prefix)) {
          Utils.warn(sn.name + " is not in the list of supported ears. Skipped");
          continue;
        }

        if (checkonly) {
          Utils.info("Ear " + sn.name + " is deployable");
          continue;
        }

        Utils.info("Processing " + sn.name);

        final Path inPath = Paths.get(inDirPath, sn.name);
        final Path outPath = Paths.get(outDirPath, sn.name);

        if (delete) {
          final File outFile = outPath.toFile();

          if (outFile.exists()) {
            Utils.deleteAll(outPath);
          }
        }

        Utils.copy(inPath, outPath, false);

        final Ear theEar = new Ear(outDirPath, sn, pc);

        ears.put(sn.name, theEar);
      }

      if (checkonly) {
        return;
      }

      for (final Ear ear: ears.values()) {
        ear.update();
      }

      if (deployDirPath == null) {
        Utils.info("No deployment path specified. Terminating");
        return;
      }

      int deployed = 0;

      for (final SplitName sn: getEarNames(outDirPath)) {
        Utils.info("Deploying " + sn.name);
        deployed++;

        Utils.deleteMatching(deployDirPath, sn);
        final Path deployPath = Paths.get(deployDirPath, sn.name);

        if (delete) {
          final File deployFile = deployPath.toFile();

          if (deployFile.exists()) {
            Utils.deleteAll(deployPath);
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
        Utils.copy(outPath, deployPath, false);

        if (wildfly) {
          final File doDeploy = Paths.get(deployDirPath,
                                          sn.name + ".dodeploy").toFile();
          doDeploy.createNewFile();
        }
      }

      Utils.info("Deployed " + deployed + " ears");
    } catch (final Throwable t) {
      t.printStackTrace();
    }

    if (cleanup) {
      // Try to delete any temp directories
      for (final Path tempPath: tempDirs) {
        try {
          Utils.deleteAll(tempPath);
        } catch (final Throwable t) {
          Utils.warn("Error trying to delete " + tempPath);
        }
      }
    }
  }

  private static Path getTempDirectory(final String prefix)  throws Throwable {
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
  private static String getRemoteFiles(final String inUrl) throws Throwable {
    final BasicHttpClient cl = new BasicHttpClient(30000);

    final Path downloadPath = getTempDirectory("bwdownload");
    final Path expandPath = getTempDirectory("bwexpand");
    final String sourceEars = expandPath.toAbsolutePath().toString();

    try {
      final DavUtil du = new DavUtil();

      final Collection<DavChild> dcs = du.getChildrenUrls(cl, inUrl, null);

      final URI inUri = new URI(inUrl);

      if (Util.isEmpty(dcs)) {
        Utils.warn("No files at " + inUrl);
        return null;
      }

      for (final DavChild dc: dcs) {
        URI dcUri = new URI(dc.uri);
        if (dcUri.getHost() == null) {
          dcUri = inUri.resolve(dc.uri);
        }

        if (Utils.debug) {
          Utils.info("Found url " + dcUri);
        }

        final InputStream is = cl.get(dcUri.toString());

        if (is == null) {
          Utils.warn("Unable to fetch " + dcUri);
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

  private static void unzip(final String zipPath,
                            final String destDir) throws Throwable {
    final byte[] buffer = new byte[4096];

    final FileInputStream fis = new FileInputStream(zipPath);
    final ZipInputStream zis = new ZipInputStream(fis);
    ZipEntry ze = zis.getNextEntry();
    while(ze != null){
      final File newFile = new File(destDir + File.separator +
                                            ze.getName());

      if (ze.isDirectory()) {
        if (Utils.debug) {
          Utils.info("Directory entry " + newFile.getAbsolutePath());
        }

        zis.closeEntry();
        ze = zis.getNextEntry();
        continue;
      }

      if (Utils.debug) {
        Utils.info("Unzip " + newFile.getAbsolutePath());
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

  private static void cleanOut(final String outDirPath) throws Throwable {
    final Path outPath = Paths.get(outDirPath);

    if (outPath.toFile().exists()) {
      Utils.deleteAll(outPath);
    }

    if (Utils.makeDir(outDirPath)) {
      Utils.debug("created " + outDirPath);
    }
  }

  private static List<SplitName> getInEars(final String dirPath,
                                           final List<String> earNames) throws Throwable {
    final File inDir = Utils.directory(dirPath);

    final String[] names = inDir.list();

    final List<SplitName> earSplitNames = new ArrayList<>();

    for (final String nm: names) {
      final SplitName sn = SplitName.testName(nm, earNames);

      if ((sn == null) || (!"ear".equals(sn.suffix))) {
        continue;
      }

      earSplitNames.add(sn);
    }

    Utils.info("Found " + earSplitNames.size() + " ears");

    return earSplitNames;
  }

  private static List<SplitName> getEarNames(final String dirPath) throws Throwable {
    final File outDir = Utils.directory(dirPath);

    final String[] deployEarNames = outDir.list();

    final List<SplitName> earSplitNames = new ArrayList<>();

    for (final String nm: deployEarNames) {
      final SplitName sn = SplitName.testName(nm);

      if ((sn == null) || (!"ear".equals(sn.suffix))) {
        //Utils.warn("Unable to process " + nm);
        continue;
      }

      earSplitNames.add(sn);
    }

    return earSplitNames;
  }

  private static String defaultVal(final String val,
                                   final String pname) {
    if (val != null) {
      return val;
    }

    return props.getProperty(pname);
  }

  private static String defaultVal(final String val,
                                   final String pname,
                                   final String argName) {
    final String nval = defaultVal(val, pname);
    if (nval != null) {
      return nval;
    }

    Utils.error("Must specify " + argName +
                        " or provide the value in the properties with the" +
                        " '" + pname + "' property");
    error = true;

    return null;
  }
}
