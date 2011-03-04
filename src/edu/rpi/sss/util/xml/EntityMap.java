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
package edu.rpi.sss.util.xml;

import java.io.Serializable;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.HashMap;

/**
 * Utility routines to handle entities
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public final class EntityMap implements Serializable {
  /**
   */
  public static class Entity {
    int codeVal;
    String name;
    String description;

    /**
     * @param codeVal
     * @param name
     * @param description
     */
    public Entity(int codeVal, String name, String description) {
      this.codeVal = codeVal;
      this.name = name;
      this.description = description;
    }
  }

  /** These always become named */
  private static final int codeAmp = 38;
  private static final int codeLt = 60;
  private static final int codeGt = 62;
  private static final int codeNbsp = 160;

  /* This is a list of valid entities.
     Not sure where this came from - possibly culled from various sources.
   */
  private static final Entity[] entities = {
     /* C0 controls and Basic Latin - Range 00-7F (0-127) */
     new Entity(34, "quot", "quotation mark (APL quote)"),
     new Entity(38, "amp", "ampersand"),
     new Entity(60, "lt", "less-than sign"),
     new Entity(62, "gt", "greater-than sign"),

     /* C1 Controls and Latin-1 Supplement - Range 80-FF (128-255) */
     new Entity(160, "nbsp",   "o-break space (non-breaking space)"),
     new Entity(161, "iexcl",  "inverted exclamation mark"),
     new Entity(162, "cent",   "cent sign"),
     new Entity(163, "pound",  "pound sign"),
     new Entity(164, "curren", "currency sign"),
     new Entity(165, "yen",    "yen sign (yuan sign)"),
     new Entity(166, "brvbar", "broken bar (broken vertical bar)"),
     new Entity(167, "sect",   "section sign"),
     new Entity(168, "uml",    "diaeresis (spacing diaeresis)"),
     new Entity(169, "copy",   "copyright sign"),
     new Entity(170, "ordf",   "feminine ordinal indicator"),
     new Entity(171, "laquo",  "left-pointing double angle quotation mark (left pointing guillemet)"),
     new Entity(172, "not",    "not sign"),
     new Entity(173, "shy",    "soft hyphen (discretionary hyphen)"),
     new Entity(174, "reg", "registered sign (registered trade mark sign)"),
     new Entity(175, "macr", "macron (spacing macron, overline APL overbar)"),
     new Entity(176, "deg", "degree sign"),
     new Entity(177, "plusmn", "plus-minus sign (plus-or-minus sign)"),
     new Entity(178, "sup2", "superscript two (superscript digit two, squared)"),
     new Entity(179, "sup3", "superscript three (superscript digit three, cubed)"),
     new Entity(180, "acute", "acute accent (spacing acute)"),
     new Entity(181, "micro", "micro sign"),
     new Entity(182, "para", "pilcrow sign (paragraph sign)"),
     new Entity(183, "middot", "middle dot (Georgian comma, Greek middle dot)"),
     new Entity(184, "cedil", "cedilla (spacing cedilla)"),
     new Entity(185, "sup1", "superscript one (superscript digit one)"),
     new Entity(186, "ordm", "masculine ordinal indicator"),
     new Entity(187, "raquo", "right-pointing double angle quotation mark (right pointing guillemet)"),
     new Entity(188, "frac14", "vulgar fraction one quarter (fraction one quarter)"),
     new Entity(189, "frac12", "vulgar fraction one half (fraction one half)"),
     new Entity(190, "frac34", "vulgar fraction three quarters (fraction three quarters)"),
     new Entity(191, "iquest", "inverted question mark (turned question mark)"),
     new Entity(192, "Agrave", "Latin capital letter A with grave (Latin capital letter A grave)"),
     new Entity(193, "Aacute", "Latin capital letter A with acute"),
     new Entity(194, "Acirc", "Latin capital letter A with circumflex"),
     new Entity(195, "Atilde", "Latin capital letter A with tilde"),
     new Entity(196, "Auml", "Latin capital letter A with diaeresis"),
     new Entity(197, "Aring", "Latin capital letter A with ring above (Latin capital letter A ring)"),
     new Entity(198, "AElig", "Latin capital letter AE (Latin capital ligature AE)"),
     new Entity(199, "Ccedil", "Latin capital letter C with cedilla"),
     new Entity(200, "Egrave", "Latin capital letter E with grave"),
     new Entity(201, "Eacute", "Latin capital letter E with acute"),
     new Entity(202, "Ecirc", "Latin capital letter E with circumflex"),
     new Entity(203, "Euml", "Latin capital letter E with diaeresis"),
     new Entity(204, "Igrave", "Latin capital letter I with grave"),
     new Entity(205, "Iacute", "Latin capital letter I with acute"),
     new Entity(206, "Icirc", "Latin capital letter I with circumflex"),
     new Entity(207, "Iuml", "Latin capital letter I with diaeresis"),
     new Entity(208, "ETH", "Latin capital letter ETH"),
     new Entity(209, "Ntilde", "Latin capital letter N with tilde"),
     new Entity(210, "Ograve", "Latin capital letter O with grave"),
     new Entity(211, "Oacute", "Latin capital letter O with acute"),
     new Entity(212, "Ocirc", "Latin capital letter O with circumflex"),
     new Entity(213, "Otilde", "Latin capital letter O with tilde"),
     new Entity(214, "Ouml", "Latin capital letter O with diaeresis"),
     new Entity(215, "times", "multiplication sign"),
     new Entity(216, "Oslash", "Latin capital letter O with stroke (Latin capital letter O slash)"),
     new Entity(217, "Ugrave", "Latin capital letter U with grave"),
     new Entity(218, "Uacute", "Latin capital letter U with acute"),
     new Entity(219, "Ucirc", "Latin capital letter U with circumflex"),
     new Entity(220, "Uuml", "Latin capital letter U with diaeresis"),
     new Entity(221, "Yacute", "Latin capital letter Y with acute"),
     new Entity(222, "THORN", "Latin capital letter THORN"),
     new Entity(223, "szlig", "Latin small letter sharp s (ess-zed)"),
     new Entity(224, "agrave", "Latin small letter a with grave (Latin small letter a grave)"),
     new Entity(225, "aacute", "Latin small letter a with acute"),
     new Entity(226, "acirc", "Latin small letter a with circumflex"),
     new Entity(227, "atilde", "Latin small letter a with tilde"),
     new Entity(228, "auml", "Latin small letter a with diaeresis"),
     new Entity(229, "aring", "Latin small letter a with ring above (Latin small letter a ring)"),
     new Entity(230, "aelig", "Latin small letter ae (Latin small ligature ae)"),
     new Entity(231, "ccedil", "Latin small letter c with cedilla"),
     new Entity(232, "egrave", "Latin small letter e with grave"),
     new Entity(233, "eacute", "Latin small letter e with acute"),
     new Entity(234, "ecirc", "Latin small letter e with circumflex"),
     new Entity(235, "euml", "Latin small letter e with diaeresis"),
     new Entity(236, "igrave", "Latin small letter i with grave"),
     new Entity(237, "iacute", "Latin small letter i with acute"),
     new Entity(238, "icirc", "Latin small letter i with circumflex"),
     new Entity(239, "iuml", "Latin small letter i with diaeresis"),
     new Entity(240, "eth", "Latin small letter eth"),
     new Entity(241, "ntilde", "Latin small letter n with tilde"),
     new Entity(242, "ograve", "Latin small letter o with grave"),
     new Entity(243, "oacute", "Latin small letter o with acute"),
     new Entity(244, "ocirc", "Latin small letter o with circumflex"),
     new Entity(245, "otilde", "Latin small letter o with tilde"),
     new Entity(246, "ouml", "Latin small letter o with diaeresis"),
     new Entity(247, "divide", "division sign"),
     new Entity(248, "oslash", "Latin small letter o with stroke (Latin small letter o slash)"),
     new Entity(249, "ugrave", "Latin small letter u with grave"),
     new Entity(250, "uacute", "Latin small letter u with acute"),
     new Entity(251, "ucirc", "Latin small letter u with circumflex"),
     new Entity(252, "uuml", "Latin small letter u with diaeresis"),
     new Entity(253, "yacute", "Latin small letter y with acute"),
     new Entity(254, "thorn", "Latin small letter thorn with"),
     new Entity(255, "yuml", "Latin small letter y with diaeresis"),

     /* Latin Extended-A - Range 100-17F (256-383) */
     new Entity(338, "OElig", "Latin capital ligature OE"),
     new Entity(339, "oelig", "Latin small ligature oe"),
     new Entity(352, "Scaron", "Latin capital letter S with caron"),
     new Entity(353, "scaron", "Latin small letter s with caron"),
     new Entity(376, "Yuml", "Latin capital letter Y with diaeresis"),

     /* Latin Extended-B - Range 180-24F (256-383) */
     new Entity(402, "fnof", "Latin small f with hook (function, florin)"),

     /* Spacing Modifier Letters - Range 02B0-02FF (688-767) */
     new Entity(710, "circ", "modifier letter circumflex accent"),
     new Entity(732, "tilde", "small tilde"),

     /* Greek and Coptic - Range 370-3FF (880-1023) */
     new Entity(913, "Alpha", "Greek capital letter alpha"),
     new Entity(914, "Beta", "Greek capital letter beta"),
     new Entity(915, "Gamma", "Greek capital letter gamma"),
     new Entity(916, "Delta", "Greek capital letter delta"),
     new Entity(917, "Epsilon", "Greek capital letter epsilon"),
     new Entity(918, "Zeta", "Greek capital letter zeta"),
     new Entity(919, "Eta", "Greek capital letter eta"),
     new Entity(920, "Theta", "Greek capital letter theta"),
     new Entity(921, "Iota", "Greek capital letter iota"),
     new Entity(922, "Kappa", "Greek capital letter kappa"),
     new Entity(923, "Lambda", "Greek capital letter lambda"),
     new Entity(924, "Mu", "Greek capital letter mu"),
     new Entity(925, "Nu", "Greek capital letter nu"),
     new Entity(926, "Xi", "Greek capital letter xi"),
     new Entity(927, "Omicron", "Greek capital letter omicron"),
     new Entity(928, "Pi", "Greek capital letter pi"),
     new Entity(929, "Rho", "Greek capital letter rho"),
     new Entity(931, "Sigma", "Greek capital letter sigma"),
     new Entity(932, "Tau", "Greek capital letter tau"),
     new Entity(933, "Upsilon", "Greek capital letter upsilon"),
     new Entity(934, "Phi", "Greek capital letter phi"),
     new Entity(935, "Chi", "Greek capital letter chi"),
     new Entity(936, "Psi", "Greek capital letter psi"),
     new Entity(937, "Omega", "Greek capital letter omega"),
     new Entity(945, "alpha", "Greek small letter alpha"),
     new Entity(946, "beta", "Greek small letter beta"),
     new Entity(947, "gamma", "Greek small letter gamma"),
     new Entity(948, "delta", "Greek small letter delta"),
     new Entity(949, "epsilon", "Greek small letter epsilon"),
     new Entity(950, "zeta", "Greek small letter zeta"),
     new Entity(951, "eta", "Greek small letter eta"),
     new Entity(952, "theta", "Greek small letter theta"),
     new Entity(953, "iota", "Greek small letter iota"),
     new Entity(954, "kappa", "Greek small letter kappa"),
     new Entity(955, "lambda", "Greek small letter lambda"),
     new Entity(956, "mu", "Greek small letter mu"),
     new Entity(957, "nu", "Greek small letter nu"),
     new Entity(958, "xi", "Greek small letter xi"),
     new Entity(959, "omicron", "Greek small letter omicron"),
     new Entity(960, "pi", "Greek small letter pi"),
     new Entity(961, "rho", "Greek small letter rho"),
     new Entity(962, "sigmaf", "Greek small letter final sigma"),
     new Entity(963, "sigma", "Greek small letter sigma"),
     new Entity(964, "tau", "Greek small letter tau"),
     new Entity(965, "upsilon", "Greek small letter upsilon"),
     new Entity(966, "phi", "Greek small letter phi"),
     new Entity(967, "chi", "Greek small letter chi"),
     new Entity(968, "psi", "Greek small letter psi"),
     new Entity(969, "omega", "Greek small letter omega"),
     new Entity(977, "thetasym", "Greek small letter theta symbol"),
     new Entity(978, "upsih", "Greek upsilon with hook symbol"),
     new Entity(982, "piv", "Greek pi symbol"),

     /* General Punctuation - Range 2000-206F (8192-8303) */
     new Entity(8194, "ensp", "n space"),
     new Entity(8195, "emsp", "m space"),
     new Entity(8201, "thinsp", "hin space"),
     new Entity(8204, "zwnj", "zero width non-joiner"),
     new Entity(8205, "zwj", "zero width joiner"),
     new Entity(8206, "lrm", "left-to-right mark"),
     new Entity(8207, "rlm", "right-to-left mark"),
     new Entity(8211, "ndash", "en dash"),
     new Entity(8212, "mdash", "em dash"),
     new Entity(8216, "lsquo", "left single quotation mark"),
     new Entity(8217, "rsquo", "right single quotation mark"),
     new Entity(8218, "sbquo", "single low-9 quotation mark"),
     new Entity(8220, "ldquo", "left double quotation mark"),
     new Entity(8221, "rdquo", "right double quotation mark"),
     new Entity(8222, "bdquo", "double low-9 quotation mark"),
     new Entity(8224, "dagger", "dagger"),
     new Entity(8225, "Dagger", "double dagger"),
     new Entity(8226, "bull", "bullet (black small circle)"),
     new Entity(8230, "hellip", "horizontal ellipsis (three dot leader)"),
     new Entity(8240, "permil", "per mille sign"),
     new Entity(8242, "prime", "prime (minutes, feet)"),
     new Entity(8243, "Prime", "double prime (seconds, inches)"),
     new Entity(8249, "lsaquo", "single left-pointing angle quotation mark"),
     new Entity(8250, "rsaquo", "single right-pointing angle quotation mark"),
     new Entity(8254, "oline", "overline (spacing overscore)"),
     new Entity(8260, "frasl", "fraction slash"),
     new Entity(8364, "euro", "euro sign"),

     /* Letterlike Symbols - Range 2100-214F (8448-8527) */
     new Entity(8465, "image", "blackletter capital I (imaginary part)"),
     new Entity(8472, "weierp", "script capital P (power set, Weierstrass p)"),
     new Entity(8476, "real", "blackletter capital R (real part symbol)"),
     new Entity(8482, "trade", "trade mark sign"),
     new Entity(8501, "alefsym", "alef symbol (first transfinite cardinal)"),

     /* Arrows - Range 2190-21FF (8592-8703) */
     new Entity(8592, "larr", "leftwards arrow"),
     new Entity(8593, "uarr", "upwards arrow"),
     new Entity(8594, "rarr", "rightwards arrow"),
     new Entity(8595, "darr", "downwards arrow"),
     new Entity(8596, "harr", "left right arrow"),
     new Entity(8629, "crarr", "downwards arrow with corner leftwards (carriage return)"),
     new Entity(8656, "lArr", "leftwards double arrow"),
     new Entity(8657, "uArr", "upwards double arrow"),
     new Entity(8658, "rArr", "rightwards double arrow"),
     new Entity(8659, "dArr", "downwards double arrow"),
     new Entity(8660, "hArr", "left right double arrow"),

     /* Mathematical Operators - Range 2200-22FF (8704-8959) */
     new Entity(8704, "forall", "for all"),
     new Entity(8706, "part", "partial differential"),
     new Entity(8707, "exist", "there exists"),
     new Entity(8709, "empty", "empty set (null set, diameter)"),
     new Entity(8711, "nabla", "nabla (backward difference)"),
     new Entity(8712, "isin", "element of"),
     new Entity(8713, "notin", "not an element of"),
     new Entity(8715, "ni", "contains as member"),
     new Entity(8719, "prod", "n-ary product (product sign)"),
     new Entity(8721, "sum", "n-ary summation"),
     new Entity(8722, "minus", "minus sign"),
     new Entity(8727, "lowast", "asterisk operator"),
     new Entity(8730, "radic", "square root (radical sign)"),
     new Entity(8733, "prop", "proportional to"),
     new Entity(8734, "infin", "infinity"),
     new Entity(8736, "ang", "angle"),
     new Entity(8743, "and", "logical and (wedge)"),
     new Entity(8744, "or", "logical or (vee)"),
     new Entity(8745, "cap", "intersection (cap)"),
     new Entity(8746, "cup", "union (cup)"),
     new Entity(8747, "int", "integral"),
     new Entity(8756, "there4", "therefore"),
     new Entity(8764, "sim", "tilde operator (varies with, similar to)"),
     new Entity(8773, "cong", "approximately equal to"),
     new Entity(8776, "asymp", "almost equal to (asymptotic to)"),
     new Entity(8800, "ne", "not equal to"),
     new Entity(8801, "equiv", "identical to"),
     new Entity(8804, "le", "less-than or equal to"),
     new Entity(8805, "ge", "greater-than or equal to"),
     new Entity(8834, "sub", "subset of"),
     new Entity(8835, "sup", "superset of"),
     new Entity(8836, "nsub", "not a subset of"),
     new Entity(8838, "sube", "subset of or equal to"),
     new Entity(8839, "supe", "superset of or equal to"),
     new Entity(8853, "oplus", "circled plus (direct sum)"),
     new Entity(8855, "otimes", "circled times (vector product)"),
     new Entity(8869, "perp", "up tack (orthogonal to, perpendicular)"),
     new Entity(8901, "sdot", "dot operator"),

     /* Miscellaneous Technical - Range 2300-23FF (8960-9215) */
     new Entity(8968, "lceil", "left ceiling (APL upstile)"),
     new Entity(8969, "rceil", "right ceiling"),
     new Entity(8970, "lfloor", "left floor (APL downstile)"),
     new Entity(8971, "rfloor", "right floor"),
     new Entity(9001, "lang", "left-pointing angle bracket (bra)"),
     new Entity(9002, "rang", "right-pointing angle bracket (ket)"),

     /* Geometric Shapes - Range 25A0-25FF (9632-9727) */
     new Entity(9674, "loz", "lozenge"),

     /* Miscellaneous Symbols - Range 2600-26FF (9728-9983) */
     new Entity(9824, "spades", "black spade suit"),
     new Entity(9827, "clubs", "black club suit (shamrock)"),
     new Entity(9829, "hearts", "black heart suit (valentine)"),
     new Entity(9830, "diams", "black diamond suit"),
  };

  /** The following map values between 128 and 159 onto a unicode value.
   * For example 147, a double quote is correctly represented by the unicode
   * value 8220.
   */
  private static final int[] codeFix = {
      8364,    /* 128   */
      129,     /* 129   */
      8218,    /* 130   */
      402,     /* 131   */
      8222,    /* 132   */
      8230,    /* 133   */
      8224,    /* 134   */
      8225,    /* 135   */
      710,     /* 136   */
      8240,    /* 137   */
      352,     /* 138   */
      8249,    /* 139   */
      338,     /* 140   */
      141,     /* 141   */
      381,     /* 142   */
      143,     /* 143   */
      144,     /* 144   */
      8216,    /* 145   */
      8217,    /* 146   */
      8220,    /* 147   */
      8221,    /* 148   */
      8226,    /* 149   */
      8211,    /* 150   */
      8212,    /* 151   */
      732,     /* 152   */
      8482,    /* 153   */
      353,     /* 154   */
      8250,    /* 155   */
      339,     /* 156   */
      157,     /* 157   */
      382,     /* 158   */
      376,     /* 159   */
  };

  /* Indexed by code */
  private static final HashMap<Integer, Entity> emap = new HashMap<Integer, Entity>();

  /* Indexed by name */
  private static final HashMap<String, Entity> enamemap = new HashMap<String, Entity>();

  static {
    for (int i = 0; i < entities.length; i++) {
      Entity e = entities[i];

      emap.put(new Integer(e.codeVal), e);

      enamemap.put(e.name, e);
    }
  }

  private static final int maxEntityLen = 20;

  /** Convert all entities and unicode values above 127 to numeric entities.
   * If fix is true, will convert all values between 128 and 159 to valid
   * unicode values
   *
   * @param val
   * @param fix
   * @return String after conversion
   * @throws Throwable
   */
  public static String makeNumeric(String val, boolean fix) throws Throwable {
    if (val == null) {
      return null;
    }

    char[] entityBuff = new char[maxEntityLen];
    int entityI = 0;
    boolean inEntity = false;

    /** Watch for characters over 127
     */
    StringReader sr = new StringReader(val);
    int ct = 0;
    int len = val.length();
    StringWriter sw = new StringWriter(len);

    while (sr.ready()) {
      int ch = sr.read();

      if (ch < 0) {
        if (inEntity) {
          throw new Exception("Bad entity (" +
                              new String(entityBuff, 0, entityI) +
                              ") at about pos " + ct + " in " +
                              subVal(val, ct));
        }
        break;
      }

      if ((!inEntity) && (ch == '&')) {
        inEntity = true;
        entityI = 0;
      } else if (inEntity) {
        //System.out.println("ch=" + (char)ch);
        if (ch > 127) {
          throw new Exception("Bad entity character at " + ct +
                              subVal(val, ct));
        }

        if ((entityI == 0) && (ch == '#')) {
          inEntity = false;
          sw.write("&#");
        } else if (ch == ';') {
          String ename = new String(entityBuff, 0, entityI);

          Entity e = enamemap.get(ename);

          sw.write("&");
          if (e == null) {
            /** For the moment just pass it through - we may be using
             * entities for other purposes
             */
            sw.write(ename);
          } else if ((e.codeVal == codeAmp) ||
                     (e.codeVal == codeLt) ||
                     (e.codeVal == codeGt) ||
                     (e.codeVal == codeNbsp)) {
            sw.write(String.valueOf(e.name));
          } else {
            sw.write("#");
            sw.write(String.valueOf(e.codeVal));
          }
          sw.write(";");
          inEntity = false;
        } else if (entityI < maxEntityLen) {
          entityBuff[entityI] = (char)ch;
          entityI++;
        } else {
          throw new Exception("Bad entity (" +
                              new String(entityBuff, 0, entityI) +
                              ") at about pos " + ct + " in " +
                              subVal(val, ct));
        }
      } else if (ch > 127) {
        if (fix && (ch < 160)) {
          ch = codeFix[ch - 128];
        }

        sw.write("&#");
        sw.write(String.valueOf(ch));
        sw.write(";");
      } else {
        sw.write(ch);
      }

      ct++;
    }

    return sw.toString();
  }

  private static String subVal(String val, int pos) {
    int len = val.length();
    int end = Math.min(len, pos + 50);

    return val.substring(Math.max(0, pos - 30), end);
  }

  /** Test it
   * @param args
   */
  public static void main(String[] args) {
    try {
      System.out.println(EntityMap.makeNumeric("A string &copy; another", true));
    } catch (Throwable t) {
      System.out.println(t.getMessage());
      t.printStackTrace();
    }
  }
}

