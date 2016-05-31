/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.jolokia;

import org.apache.commons.lang.WordUtils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StreamTokenizer;
import java.io.StringReader;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * User: mike
 * Date: 5/5/15
 * Time: 4:26 PM
 */
public abstract class JolokiaCli {
  private final boolean debug;

  private final String url;

  private JolokiaClient client;

  private final BufferedReader stdin = new BufferedReader(new InputStreamReader(
          System.in));

  private SfpTokenizer tokenizer;

  private Reader inReader;

  private long startTime;

  private final Map<String, CommandInterpreter> interpreters =
          new HashMap<>();

  public JolokiaCli(final String url,
                    final boolean debug) throws Throwable {
    this.debug = debug;
    if (url == null) {
      this.url = "http://localhost:8080/hawtio/jolokia";
    } else {
      this.url = url;
    }

    register(new CmdSou());
    register(new CmdMemory());
  }

  public abstract JolokiaClient makeClient(final String uri) throws Throwable;

  public void register(final CommandInterpreter ci) {
    interpreters.put(ci.getCmdName(), ci);
  }

  public SortedSet<String> getCommands() {
    return new TreeSet<>(interpreters.keySet());
  }

  public CommandInterpreter getCmd(final String cmdName) {
    return interpreters.get(cmdName);
  }

  public void setInReader(final Reader val) {
    inReader = val;
  }

  public void processCmds() {
    while (true) {
      final String line = nextLine();
      if (line == null) {
        return;
      }

      if (line.equals("q")) {
        info("Quitting");
        return;
      }

      tokenizer = new SfpTokenizer(new StringReader(line));

      try {
        final String cmd = word("cmd");

        if (cmd == null) {
          continue;
        }

        final CommandInterpreter ci = interpreters.get(cmd);

        if (ci == null) {
          error("Unknown command: " + cmd);
          cmdHelp();
          continue;
        }

        ci.execute(this);
      } catch (final Throwable t) {
        error("Exception processing command:");
        t.printStackTrace();
      }
    }
  }

  private void cmdHelp() {
    info("Commands are:");

    final SortedSet<String> cmds = new TreeSet<>(interpreters.keySet());

    for (final String cmd: cmds) {
      final CommandInterpreter ci = interpreters.get(cmd);

      String pars = ci.getCmdPars();
      if (pars == null) {
        pars = "";
      }
      info("  " + cmd + ": " +
                   pars + "\t" +
                   WordUtils.wrap(ci.getCmdDescription(), 70, "\n\t",
                                  true));
    }
  }

  private static class CmdHelp extends CommandInterpreter {
    CmdHelp() {
      super("help", null, "This help");
    }

    public void execute(final JolokiaCli cli) {
      cli.info("Commands are:");

      final SortedSet<String> cmds = cli.getCommands();

      for (final String cmd: cmds) {
        final CommandInterpreter ci = cli.getCmd(cmd);

        String pars = ci.getCmdPars();
        if (pars == null) {
          pars = "";
        }
        cli.info("  " + cmd + ": " +
                         pars + "\t" +
                         WordUtils.wrap(ci.getCmdDescription(), 70,
                                        "\n\t",
                                        true));
      }
    }
  }

  private static class CmdSou extends CommandInterpreter {
    CmdSou() {
      super("sou", "<filename>", "Execute comands from given file");
    }

    public void execute(final JolokiaCli cli) {
      try {
        // Expect a filename or complete path

        final String fname = cli.string("filename");

        if (fname == null) {
          cli.error("Expected a filename/path");
          return;
        }

        cli.setInReader(new BufferedReader(new FileReader(fname)));
      } catch (final Throwable t) {
        t.printStackTrace();
      }
    }
  }

  private static class CmdMemory extends CommandInterpreter {
    CmdMemory() {
      super("memory", null, "Show current memory usage");
    }

    public void execute(final JolokiaCli cli) {
      try {
        cli.info(cli.getClient().getMemory());
      } catch (final Throwable t) {
        t.printStackTrace();
      }
    }
  }

  private String nextLine() {
    try {
      BufferedReader rdr;

      if (inReader != null) {
        if (inReader instanceof BufferedReader) {
          rdr = (BufferedReader)inReader;
        } else {
          rdr = new BufferedReader(inReader);
        }
      } else {
        rdr = stdin;
      }

      while (true) {
        System.out.print("cmd:");
        final String line = rdr.readLine();
        if (line == null) {
          if (inReader != null) {
            // Revert to stdin
            inReader = null;
            rdr = stdin;
            continue;
          }

          return null;
        }

        if (line.startsWith("#")) {
          continue;
        }

        final String l = line.trim();

        if (l.length() > 0) {
          return l;
        }
      }
    } catch (final Throwable t) {
      return null;
    }
  }

  public String word(final String tr) throws Throwable {
    final int tkn = nextToken(tr);

    if (tkn == StreamTokenizer.TT_EOF) {
      return null;
    }

    if (tkn == StreamTokenizer.TT_WORD) {
      return tokenizer.sval;
    }

    error("Expect a word here");
    return null;
  }

  public String string(final String tr) throws Throwable {
    final int tkn = nextToken(tr);

    if (tkn == StreamTokenizer.TT_EOF) {
      if (tr != null) {
        error("Expect a quoted string here");
      }
      return null;
    }

    if ((tkn == '"') || (tkn == '\'')) {
      return tokenizer.sval;
    }

    error("Expect a quoted string here");
    return null;
  }

  public Double number(final String tr) throws Throwable {
    final int tkn = nextToken(tr);

    if (tkn == StreamTokenizer.TT_EOF) {
      error("Expect a number here");
      return null;
    }

    if (tkn == StreamTokenizer.TT_NUMBER) {
      return tokenizer.nval;
    }

    error("Expect a number here");
    return null;
  }

  public int nextToken(final String tr) throws Throwable {
    final int tkn = tokenizer.next();

    if (!debug) {
      return tkn;
    }

    if (tkn == StreamTokenizer.TT_WORD) {
      debugMsg("nextToken(" + tr + ") = word: " + tokenizer.sval);
    } else if (tkn == '\'') {
      debugMsg("nextToken(" + tr + ") = '" + tokenizer.sval + "'");
    } else if (tkn > 0) {
      debugMsg("nextToken(" + tr + ") = " + (char)tkn);
    } else {
      debugMsg("nextToken(" + tr + ") = " + tkn);
    }

    return tkn;
  }
  
  public String nextSval() throws Throwable {
    return tokenizer.sval;
  }

  public void pushback() throws Throwable {
    tokenizer.pushBack();
  }

  public JolokiaClient getClient() throws Throwable {
    if (client == null) {
      client = makeClient(url);
    }

    return client;
  }

  public void start() {
    startTime = System.currentTimeMillis();
  }

  public void end() {
    info("Took " +
                 (System.currentTimeMillis() - startTime) +
                 " millis");
  }

  public void error(final String msg) {
    System.err.println(msg);
  }

  public void error(final Throwable t) {
    t.printStackTrace();
  }

  public void info(final String msg) {
    System.out.println(msg);
  }

  public void debugMsg(final String msg) {
    if (debug) {
      System.out.println(msg);
    }
  }
}
