package org.bedework.util.deployment;

import org.bedework.util.args.Args;

import org.apache.maven.plugin.logging.Log;

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
public class Runnable {
  static void usage(final String error_msg) {
    if (error_msg != null) {
      System.err.println(error_msg);
    }

    System.out.print("Usage: processEar [options]\n" +
                        "Options:\n" +
                        "    -h             Print this help and exit\n" +
                        "    --baseDir      Directory containing the sppserver\n" +
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

  private final Process pe = new Process();

  private boolean debug;

  /*
  private String baseDirPath;

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
  */

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
        if (pe.getInUrl() != null) {
          usage("Only one of --in or --inurl: " + args.current());
          return false;
        }

        pe.setInDirPath(args.next());
      } else if (args.ifMatch("--inurl")) {
        if (pe.getInDirPath() != null) {
          usage("Only one of --in or --inurl: " + args.current());
          return false;
        }

        pe.setInUrl(args.next());
      } else if (args.ifMatch("--baseDir")) {
        pe.setBaseDirPath(args.next());
      } else if (args.ifMatch("--out")) {
        pe.setOutDirPath(args.next());
      } else if (args.ifMatch("--props")) {
        pe.setPropsPath(args.next());
      } else if (args.ifMatch("--noclean")) {
        pe.setCleanup(false);
      } else if (args.ifMatch("--noversion")) {
        pe.setNoversion(true);
      } else if (args.ifMatch("--checkonly")) {
        pe.setCheckonly(true);
      } else if (args.ifMatch("--delete")) {
        pe.setDelete(true);
      } else if (args.ifMatch("--ear")) {
        pe.setEarName(args.next());
      } else if (args.ifMatch("--war")) {
        pe.setWarName(args.next());
      } else if (args.ifMatch("--warsonly")) {
        pe.setWarsOnly(true);
      } else if (args.ifMatch("--debug")) {
        debug = true;
      } else if (args.ifMatch("--resources")) {
        pe.setResourcesBase(args.next());
      } else if (args.ifMatch("--h")) {
        usage(null);
        return false;
      } else {
        usage("Unrecognized option: " + args.current());
        return false;
      }
    }

    if (pe.getBaseDirPath() == null) {
      usage("Must specify --baseDir");
      return false;
    }

    if (pe.getPropsPath() == null) {
      usage("Must specify --props");
      return false;
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
    final Runnable r = new Runnable();

    try {
      if (!r.processArgs(new Args(args))) {
        return;
      }

      final Logger logger = new Logger();
      logger.debug = r.debug;
      r.pe.setLog(logger);
      r.pe.execute();
    } catch (final Throwable t) {
      t.printStackTrace();
    }
  }
}
