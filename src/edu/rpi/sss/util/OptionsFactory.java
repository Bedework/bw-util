/* **********************************************************************
    Copyright 2008 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
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
