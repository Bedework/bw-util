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
package edu.rpi.sss.util;

import java.io.InputStream;

/** Obtain a CalEnv object.
 *
 */
public class OptionsFactory {
  private final static String envclass = "edu.rpi.sss.util.Options";

  /** Obtain and initialise an options object.
   *
   * @param globalPrefix
   * @param appPrefix
   * @param optionsFile - path to file e.g. /properties/calendar/options.xml
   * @param outerTagName - surrounding tag in options file e.g. bedework-options
   * @return CalOptionsI
  * @throws OptionsException
  */
  public static OptionsI getOptions(final String globalPrefix,
                                    final String appPrefix,
                                    final String optionsFile,
                                    final String outerTagName) throws OptionsException {
    try {
      Object o = Class.forName(envclass).newInstance();

      if (o == null) {
        throw new OptionsException("Class " + envclass + " not found");
      }

      if (!(o instanceof OptionsI)) {
        throw new OptionsException("Class " + envclass +
                                  " is not a subclass of " +
                                  OptionsI.class.getName());
      }

      OptionsI options = (OptionsI)o;

      options.init(globalPrefix, appPrefix, optionsFile, outerTagName);

      return options;
    } catch (OptionsException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new OptionsException(t);
    }
  }

  /** Return an object that uses a local set of options parsed from the input stream.
   *
   * @param globalPrefix
   * @param appPrefix
   * @param outerTagName
   * @param is
   * @return CalOptions
   * @throws OptionsException
   */
  public static Options fromStream(final String globalPrefix,
                                   final String appPrefix,
                                   final String outerTagName,
                                   final InputStream is) throws OptionsException {
    Options opts = new Options();

    opts.init(globalPrefix, appPrefix, null, outerTagName);

    opts.initFromStream(is);

    return opts;
  }
}
