/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.jolokia;

import org.bedework.util.cli.Cli;
import org.bedework.util.cli.CommandInterpreter;

import java.util.Objects;

/**
 * User: mike
 * Date: 5/5/15
 * Time: 4:26 PM
 */
public abstract class JolokiaCli extends Cli {
  private final String url;

  private JolokiaClient client;

  public JolokiaCli(final String url,
                    final boolean debug) throws Throwable {
    super(debug);

    this.url = Objects.requireNonNullElse(url,
                                          "http://localhost:8080/hawtio/jolokia");

    register(new CmdMemory());
  }

  public abstract JolokiaClient makeClient(final String uri);

  public JolokiaClient getClient() {
    if (client == null) {
      client = makeClient(url);
    }

    return client;
  }

  private static class CmdMemory extends CommandInterpreter {
    CmdMemory() {
      super("memory", null, "Show current memory usage");
    }

    public void execute(final Cli cli) {
      try {
        cli.info(((JolokiaCli)cli).getClient().getMemory());
      } catch (final Throwable t) {
        t.printStackTrace();
      }
    }
  }
}
