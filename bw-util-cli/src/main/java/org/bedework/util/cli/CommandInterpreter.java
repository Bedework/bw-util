/* ********************************************************************
    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.
*/
package org.bedework.util.cli;

/**
 * User: mike Date: 12/9/15 Time: 10:08
 */
public abstract class CommandInterpreter {
  private final String cmdName;
  private final String cmdPars;
  private final String cmdDescription;

  public CommandInterpreter(final String cmdName,
                            final String cmdPars,
                            final String cmdDescription) {
    this.cmdName = cmdName;
    this.cmdPars = cmdPars;
    this.cmdDescription = cmdDescription;
  }

  public String getCmdName() {
    return cmdName;
  }

  public String getCmdPars() {
    return cmdPars;
  }

  public String getCmdDescription() {
    return cmdDescription;
  }

  public abstract void execute(final Cli cli);
}
