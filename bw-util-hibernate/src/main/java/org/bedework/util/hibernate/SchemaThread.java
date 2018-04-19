/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.hibernate;

import org.bedework.util.jmx.InfoLines;

import java.util.Properties;

/**
 * User: mike
 * Date: 1/23/17
 * Time: 23:12
 */
public abstract class SchemaThread extends Thread {
  public static final String statusDone = "Done";
  public static final String statusFailed = "Failed";
  public static final String statusRunning = "Running";
  public static final String statusStopped = "Stopped";

  public String status = statusStopped;
  
  public final InfoLines infoLines = new InfoLines();

  private final String outFile;
  private final boolean export;
  private final Properties hibConfig;
  private final String resourcepath;

  public SchemaThread(final String outFile,
                      final boolean export,
                      final Properties hibConfig) {
    this(outFile, export, hibConfig, null);
  }

  public SchemaThread(final String outFile,
                      final boolean export,
                      final Properties hibConfig,
                      final String resourcePath) {
    super("BuildSchema");
    this.outFile = outFile;
    this.export = export;
    this.hibConfig = hibConfig;
    this.resourcepath = resourcePath;
  }

  /** Called at completion
   * 
   * @param status of schema build
   */
  public abstract void completed(final String status);
  
  @Override
  public void run() {
    status = statusRunning;
    if (!Schema.execute(infoLines, outFile, export,
                        hibConfig, resourcepath)) {
      status = statusFailed;
    } else {
      status = statusDone;
    }
    
    completed(status);
  }
}
