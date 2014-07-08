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
      Utils.print(error_msg);
    }

    Utils.print("Usage: processEar [options]\n" +
                        "Options:\n" +
                        "    -h            Print this help and exit\n" +
                        "    --in          Directory for ears\n" +
                        "    --out         Directory for modified ears\n" +
                        "    --prop        Path to property file defining configuration\n" +
                        "\n" +
                        "Description:\n" +
                        "    This utility updates an exploded ear making it ready\n" +
                        "    for deployment.\n\n" +
                        "    The ear is updated in place so should be a copy if the \n" +
                        "    original needs to be preserved.\n");

    if (error_msg != null) {
      throw new RuntimeException(error_msg);
    }
  }

  private static String inDirPath;

  private static String outDirPath;

  private static String propsPath;

  private static Properties props;

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

      if ((inDirPath == null) ||
              (outDirPath == null) ||
              (propsPath == null)) {
        usage("Must specify --in, --out and --props");
        return;
      }

      loadProperties();

      final List<String> earNames =
              Utils.listProperty(props,
                                 "org.bedework.ear.names");

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
        Utils.info("Processing " + sn.name);

        if (!earNames.contains(sn.prefix)) {
          Utils.warn(sn.name + " is not in the list of supported ears. Skipped");
          continue;
        }

        final Path inPath = Paths.get(inDirPath, sn.name);
        final Path outPath = Paths.get(outDirPath, sn.name);
        Utils.copy(inPath, outPath);

        final Ear theEar = new Ear(outDirPath, sn, props);

        ears.put(sn.name, theEar);
      }

      for (final Ear ear: ears.values()) {
        ear.update();
      }
    } catch (final Throwable t) {
      t.printStackTrace();
    }
  }
}
