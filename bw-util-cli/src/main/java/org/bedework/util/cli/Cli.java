/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.cli;

import org.bedework.util.misc.Util;

import org.apache.commons.lang.WordUtils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StreamTokenizer;
import java.io.StringReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * User: mike
 * Date: 5/5/15
 * Time: 4:26 PM
 */
@SuppressWarnings("unused")
public abstract class Cli {
  private final boolean debug;

  private int exitStatus;
  
  private final BufferedReader stdin = new BufferedReader(new InputStreamReader(
          System.in));

  private String singleCmd;

  private String curline;

  private SfpTokenizer tokenizer;

  private Reader inReader;

  private long startTime;

  private final Map<String, CommandInterpreter> interpreters =
          new HashMap<>();

  public Cli(final boolean debug) throws Throwable {
    this.debug = debug;

    register(new CmdHelp());
    register(new CmdSou());
  }

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

  public void setExitStatus(final int val) {
    exitStatus = val;
  }

  public int getExitStatus() {
    return exitStatus;
  }

  public void setSingleCmd(final String val) {
    singleCmd = val;
  }

  public String getSingleCmd() {
    return singleCmd;
  }

  public void processCmds() {
    while (true) {
      if (getSingleCmd() != null) {
        curline = getSingleCmd();
      } else {
        curline = nextLine();
      }

      if (curline == null) {
        return;
      }

      if (curline.equals("q")) {
        info("Quitting");
        return;
      }

      tokenizer = new SfpTokenizer(new StringReader(curline));

      try {
        final String cmd = getDottedWords(false);

        if (cmd == null) {
          continue;
        }

        CommandInterpreter ci = interpreters.get(cmd);

        if (ci == null) {
          error("Unknown command: " + cmd);
          ci = interpreters.get("help");
          if (ci == null) {
            ci = new CmdHelp();
          }
        }

        ci.execute(this);
      } catch (final Throwable t) {
        error("Exception processing command:");
        t.printStackTrace();
      }

      if (getSingleCmd() != null) {
        break;
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

    public void execute(final Cli cli) {
      String cmdName = null;

      try {
        cmdName = cli.word(null);
      } catch (Throwable t) {
        cli.error(t.getLocalizedMessage());
      }

      if (cmdName != null) {
        final CommandInterpreter ci = cli.getCmd(cmdName);

        if (ci != null) {
          cmdInfo(cli, ci);
          final List<String> help = ci.getHelp();
          if (!Util.isEmpty(help)) {
            for (final String helpLine : help) {
              cli.info(WordUtils.wrap(helpLine, 70,
                                      "\n\t",
                                      true));
            }
          }

          return;
        }
        cli.error("Unknown commmand " + cmdName);
      }

      cli.info("Commands are:");

      final SortedSet<String> cmds = cli.getCommands();

      for (final String cmd : cmds) {
        cmdInfo(cli, cli.getCmd(cmd));
      }
    }

    private void cmdInfo(final Cli cli,
                         final CommandInterpreter ci) {

      String pars = ci.getCmdPars();
      if (pars == null) {
        pars = "";
      }
      cli.info(ci.getCmdName() + ": " +
                       pars + "\n\tDescription: " +
                       WordUtils.wrap(ci.getCmdDescription(), 70,
                                      "\n\t\t",
                                      true));
    }
  }

  private static class CmdSou extends CommandInterpreter {
    CmdSou() {
      super("sou", "<filename>", "Execute comands from given file");
    }

    public void execute(final Cli cli) {
      try {
        // Expect a filename or complete path

        final String fname = cli.string("filename");

        if (fname == null) {
          cli.error("Expected a filename/path");
          return;
        }

        cli.setInReader(new BufferedReader(new FileReader(fname)));
        cli.setSingleCmd(null); // In case we had a single command
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
  
  public String getCurline() {
    return curline;
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

  public String getDottedWords(final boolean required) throws Throwable {
      int tkn = nextToken("getDottedWords");
      String dws = "";

      for (; ; ) {
        if (tkn != StreamTokenizer.TT_WORD) {
          if (required) {
            error("Expecting a word");
          }
          return null;
        }

        dws += nextSval();

        tkn = nextToken("getDottedWords");

        if (tkn != '.') {
          pushback();
          return dws;
        }

        dws += ".";

        tkn = nextToken("getDottedWords: word");
      }
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
