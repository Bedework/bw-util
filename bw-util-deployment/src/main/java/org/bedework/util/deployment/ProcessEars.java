package org.bedework.util.deployment;

import org.bedework.util.args.Args;
import org.bedework.util.deployment.Utils.SplitName;

import java.io.File;
import java.io.FileReader;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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
                        "    -h            Print this help and exit\n" +
                        "    --in          Directory for ears\n" +
                        "    --out         Directory for modified ears\n" +
                        "    --resources   Base for resource references\n" +
                        "    --delete      If specified delete target ear if it exists\n" +
                        "    --prop        Path to property file defining configuration\n" +
                        "    --ear         If specified restrict processing to named ear\n" +
                        "\n" +
                        "Description:\n" +
                        "    This utility updates an exploded ear making it ready\n" +
                        "    for deployment.\n\n" +
                        "    The ears is first copied from the specified in directory \n" +
                        "    and then modified.\n");

    if (error_msg != null) {
      throw new RuntimeException(error_msg);
    }
  }

  private static boolean error;

  private static String inDirPath;

  private static String outDirPath;

  private static boolean delete;

  private static String earName;

  private static String resourcesBase;

  private static String propsPath;

  private static Properties props;

  private final static PropertiesChain pc = new PropertiesChain();

  private final static Map<String, Ear> ears = new HashMap<>();

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
        inDirPath = args.next();
      } else if (args.ifMatch("--out")) {
        outDirPath = args.next();
      } else if (args.ifMatch("--props")) {
        propsPath = args.next();
      } else if (args.ifMatch("--delete")) {
        delete = true;
      } else if (args.ifMatch("--ear")) {
        earName = args.next();
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

      inDirPath = defaultVal(inDirPath,
                             "org.bedework.postdeploy.in",
                             "--in");

      outDirPath = defaultVal(outDirPath,
                              "org.bedework.postdeploy.out",
                              "--out");

      resourcesBase = defaultVal(resourcesBase,
                                 "org.bedework.postdeploy.resources.base",
                                 "--resources");

      if (error) {
        usage(null);
        return;
      }

      Utils.info("input: " + inDirPath);
      Utils.info("output: " + outDirPath);
      Utils.info("resources: " + resourcesBase);

      final List<String> earNames =
              pc.listProperty("org.bedework.ear.names");

      final File inDir = Utils.directory(inDirPath);

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

      for (final SplitName sn: earSplitNames) {
        if ((earName != null) && !earName.equals(sn.prefix)) {
          continue;
        }

        Utils.info("Processing " + sn.name);

        if (!earNames.contains(sn.prefix)) {
          Utils.warn(sn.name + " is not in the list of supported ears. Skipped");
          continue;
        }

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

      for (final Ear ear: ears.values()) {
        ear.update();
      }
    } catch (final Throwable t) {
      t.printStackTrace();
    }
  }

  private static String defaultVal(final String val,
                                   final String pname,
                                   final String argName) {
    String nval = val;
    if (nval == null) {
      nval = props.getProperty(pname);
    }

    if (nval == null) {
      Utils.error("Must specify " + argName +
                          " or provide the value in the properties with the" +
                          " '" + pname + "' property");
      error = true;
    }

    return nval;
  }
}
