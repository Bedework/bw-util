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
package org.bedework.util.misc;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URI;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.MessageFormat;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.StringTokenizer;

/**
 *
 * @author   Mike Douglass
 * @version  1.0
 *
 * A number of bitty utility routines.
 */
public class Util {
  private Util() {} // Don't instantiate this

  /** Show changes for adjustCollection
   *
   * @param <T>
   */
  public static class AdjustCollectionResult<T>  {
    /** never null */
    public Collection<T> removed;
    /** never null */
    public Collection<T> added;
    /**  */
    public int numAdded;
    /**  */
    public int numRemoved;
  }

  private static final DateTimeFormatter icalUTCTimestampFormatter =
          DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss'Z'");
  
  /** Get an ical timestamp of the form "yyyyMMddTHHmmssZ"
   *
   * @return String "yyyyMMddTHHmmssZ"
   */
  public static String icalUTCTimestamp() {
    return ZonedDateTime.now(ZoneOffset.UTC).format(icalUTCTimestampFormatter);
  }

  /** Used to adjust a collection toAdjust so that it looks like the collection
   * newCol. The collection newCol will be unchanged but the result object will
   * contain a list of added and removed values.
   *
   * @param newCol make it look like this
   * @param toAdjust if non-null will be adjusted
   * @return added and removed values
   */
  public static <T> AdjustCollectionResult<T> adjustCollection(final Collection<T> newCol,
                                                            final Collection<T> toAdjust) {
    final AdjustCollectionResult<T> acr = new AdjustCollectionResult<>();

    acr.removed = new ArrayList<>();
    acr.added = new ArrayList<>();
    acr.added.addAll(newCol);

    if (toAdjust != null) {
      for (final T ent: toAdjust) {
        if (newCol.contains(ent)) {
          acr.added.remove(ent);
          continue;
        }

        acr.removed.add(ent);
      }

      for (final T ent: acr.added) {
        toAdjust.add(ent);
        acr.numAdded++;
      }

      for (final T ent: acr.removed) {
        if (toAdjust.remove(ent)) {
          acr.numRemoved++;
        }
      }
    }

    return acr;
  }

  /** Build a path out of the given elements. Any parameter may be a path element
   * or a path separator. Note this only allows "/" as the separator.
   *
   * <p>The path is constrained to either end or not end with the path separator.
   * The path will be adjusted according to the constraint
   *
   * @param endWithSep true for separator on end
   * @param val - list of elements and path separators.
   * @return completed path
   */
  public static String buildPath(final boolean endWithSep,
                                 final String... val) {
    StringBuilder path = new StringBuilder();

    for (String s: val) {
      if (s != null) {
        path.append(s);
      }
    }

    String s = path.toString().replaceAll("/+",  "/");

    if (endWithSep) {
      if (!s.endsWith("/")) {
        s += "/";
      }
    } else if (s.endsWith("/")) {
      s = s.substring(0, s.length() - 1);
    }

    return s;
  }

  /** if an href with terminating "/" the name part is that between the
   * ending "/" and the one before. 
   *
   * <p>Otherwise it's the part after the last "/"</p>
   *
   * @param href to split
   * @return name split into path and name part
   */
  public static String[] splitName(final String href) {
    if ((href == null) || (href.length() == 0)) {
      return null;
    }

    final String stripped;

    if (href.endsWith("/")) {
      stripped = href.substring(0, href.length() - 1);
    } else {
      stripped = href;
    }

    final int pos = stripped.lastIndexOf("/");

    if (pos <= 0) {
      return null;
    }

    return new String[]{stripped.substring(0, pos),
                        stripped.substring(pos + 1)};
  }

  /** get the nth element from the path - first is 0.
   *
   * @param index of element we want
   * @param path from which we extract the element
   * @return element or null
   */
  public static String pathElement(final int index,
                                   final String path) {
    final String[] paths = path.split("/");

    int idx = index;

    if ((paths[0] == null) || (paths[0].length() == 0)) {
      // skip empty first part - leading "/"
      idx++;
    }

    if (idx >= paths.length) {
      return null;
    }

    return paths[idx];
  }

  /** Read all the content into a string
   *
   * @param is input stream
   * @return a string
   */
  public static String streamToString(final InputStream is) {
    final ByteArrayOutputStream result = new ByteArrayOutputStream();
    final byte[] buffer = new byte[1024];
    int length;

    try {
      while ((length = is.read(buffer)) != -1) {
        result.write(buffer, 0, length);
      }

      return result.toString(StandardCharsets.UTF_8);
    } catch (final Throwable t) {
      throw new RuntimeException(t);
    }
  }


  /** make a locale from the standard underscore separated parts - no idea why
   * this isn't in Locale
   *
   * @param val the locale String e.g. en_US
   * @return a Locale
   * @throws RuntimeException on bad locale
   */
  public static Locale makeLocale(final String val) {
    String lang;
    String country = ""; // NOT null for Locale
    String variant = "";

    if (val == null) {
      throw new RuntimeException("Bad Locale: NULL");
    }

    if (val.length() == 2) {
      lang = val;
    } else {
      int pos = val.indexOf('_');
      if (pos != 2) {
        throw new RuntimeException("Bad Locale: " + val);
      }

      lang = val.substring(0, 2);
      pos = val.indexOf("_", 3);
      if (pos < 0) {
        if (val.length() != 5) {
          throw new RuntimeException("Bad Locale: " + val);
        }

        country = val.substring(3);
      } else {
        country = val.substring(3, 5);

        if (val.length() > 6) {
          variant = val.substring(6);
        }
      }
    }

    return new Locale(lang, country, variant);
  }

  /*
  public static void main(final String[] args) {
    System.out.println(buildPath(false, "el1", "/", "///el2///", "abc", ".ics"));
    System.out.println(buildPath(true, "el1", "/", "///el2///"));
  }*/

  /** Load a named resource as a Properties object
   *
   * @param name    String resource name
   * @return Properties populated from the resource
   * @throws Throwable
   */
  public static Properties getPropertiesFromResource(final String name) throws Throwable {
    Properties pr = new Properties();
    InputStream is = null;

    try {
      try {
        // The jboss?? way - should work for others as well.
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        is = cl.getResourceAsStream(name);
      } catch (Throwable clt) {}

      if (is == null) {
        // Try another way
        is = Util.class.getResourceAsStream(name);
      }

      if (is == null) {
        throw new Exception("Unable to load properties file" + name);
      }

      pr.load(is);

      //if (debug) {
      //  pr.list(System.out);
      //  Logger.getLogger(Util.class).debug(
      //      "file.encoding=" + System.getProperty("file.encoding"));
      //}
      return pr;
    } finally {
      if (is != null) {
        try {
          is.close();
        } catch (Throwable t1) {}
      }
    }
  }

  /** Given a class name return an object of that class.
   * The class parameter is used to check that the
   * named class is an instance of that class.
   *
   * @param className String class name
   * @param cl   Class expected
   * @return     Object checked to be an instance of that class
   * @throws Exception
   */
  public static Object getObject(final String className,
                                 final Class<?> cl) throws Exception {
    try {
      Object o = Class.forName(className).newInstance();

      if (o == null) {
        throw new Exception("Class " + className + " not found");
      }

      if (!cl.isInstance(o)) {
        throw new Exception("Class " + className +
                            " is not a subclass of " +
                            cl.getName());
      }

      return o;
    } catch (Exception e) {
      throw e;
    } catch (Throwable t) {
      throw new Exception(t);
    }
  }

  public interface PropertyFetcher {
    /** Get the value or null
     *
     * @param name name for property
     * @return value or null
     */
    String get(String name);
  }

  public static class PropertiesPropertyFetcher implements PropertyFetcher {
    private final Properties props;

    public PropertiesPropertyFetcher(final Properties props) {
      this.props = props;
    }

    @Override
    public String get(final String name) {
      return props.getProperty(name);
    }
  }

  public static String propertyReplace(final String val,
                                       final PropertyFetcher props) {
    if (val == null) {
      return null;
    }

    int pos = val.indexOf("${");

    if (pos < 0) {
      return val;
    }

    final StringBuilder sb = new StringBuilder(val.length());
    int segStart = 0;

    while (true) {
      if (pos > 0) {
        sb.append(val.substring(segStart, pos));
      }

      final int end = val.indexOf("}", pos);

      if (end < 0) {
        //No matching close. Just append rest and return.
        sb.append(val.substring(pos));
        break;
      }

      final String pval = props.get(val.substring(pos + 2, end).trim());

      if (pval != null) {
        sb.append(pval);
      }

      segStart = end + 1;
      if (segStart > val.length()) {
        break;
      }

      pos = val.indexOf("${", segStart);

      if (pos < 0) {
        //Done.
        sb.append(val.substring(segStart));
        break;
      }
    }

    return sb.toString();
  }

  /**
   *
   * @param map to sort
   * @param <K> type of key
   * @param <V> type of value
   * @return sorted list of map entries
   */
  public static <K, V extends Comparable<V>> List<Map.Entry<K, V>> sortMap(Map<K, V> map) {
    // We create a list from the elements of the unsorted map
    List <Map.Entry<K, V>> list = new LinkedList<>(map.entrySet());

    // Now sort the list
    Comparator<Map.Entry<K, V>> comparator =
            Comparator.comparing(Map.Entry<K, V>::getValue);
    list.sort(comparator.reversed());

    return list;
  }

  /** Format a message consisting of a format string
   *
   * @param fmt
   * @param arg
   * @return String formatted message
   */
  public static String fmtMsg(final String fmt, final String arg) {
    Object[] o = new Object[1];
    o[0] = arg;

    return MessageFormat.format(fmt, o);
  }

  /** Format a message consisting of a format string plus two string parameters
   *
   * @param fmt
   * @param arg1
   * @param arg2
   * @return String formatted message
   */
  public static String fmtMsg(final String fmt, final String arg1, final String arg2) {
    Object[] o = new Object[2];
    o[0] = arg1;
    o[1] = arg2;

    return MessageFormat.format(fmt, o);
  }

  /** Format a message consisting of a format string plus one integer parameter
   *
   * @param fmt
   * @param arg
   * @return String formatted message
   */
  public static String fmtMsg(final String fmt, final int arg) {
    Object[] o = new Object[1];
    o[0] = new Integer(arg);

    return MessageFormat.format(fmt, o);
  }

  private static final char[] randChars = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

  /** Creates a string of given length where each character comes from a
   * set of values 0-9 followed by A-Z.
   *
   * @param length    returned string will be this long. Less than 1k + 1
   * @param maxVal    maximum ordinal value of characters.  If < than 0,
                      return null.  If > 35, 35 is used instead.
   * @return String   the random string
   */
  public static String makeRandomString(int length, int maxVal) {
    if (length < 0) {
      return null;
    }

    length = Math.min(length, 1025);

    if (maxVal < 0) {
      return null;
    }

    maxVal = Math.min(maxVal, 35);

    StringBuffer res = new StringBuffer();
    Random rand = new Random();

    for (int i = 0; i <= length; i++) {
      res.append(randChars[rand.nextInt(maxVal + 1)]);
    }

    return res.toString();
  }

  /** Add a string to a string array of a given maximum length. Truncates
   * the string array if required.
   *
   * New entries go at the end. old get dropped off the front.
   *
   * @param  sarray     String[] to be updated
   * @param  val        new entry
   * @param  maxEntries Number of entries we keep.
   * @return String[]   Modified sarray
   */
  public static String[] appendTextToArray(String[] sarray, final String val,
                                    final int maxEntries) {
    if (sarray == null) {
      if (maxEntries > 0) {
        sarray = new String[1];
        sarray[0] = val;
      }
      return sarray;
    }

    if (sarray.length > maxEntries) {
      String[] neb = new String[maxEntries];
      System.arraycopy(sarray, sarray.length - maxEntries,
                       neb, 0, maxEntries);
      sarray = neb;
      sarray[sarray.length - 1] = val;
      neb = null;
      return sarray;
    }

    if (sarray.length < maxEntries) {
      int newLen = sarray.length + 1;
      String[] neb = new String[newLen];
      System.arraycopy(sarray, 0,
                       neb, 0, sarray.length);
      sarray = neb;
      sarray[sarray.length - 1] = val;
      neb = null;

      return sarray;
    }

    if (maxEntries > 1) {
      System.arraycopy(sarray, 1,
                       sarray, 0, sarray.length - 1);
    }

    sarray[sarray.length - 1] = val;
    return sarray;
  }

  /** Return a String representing the given String array, achieved by
   * URLEncoding the individual String elements then concatenating with
   *intervening blanks.
   *
   * @param  val    String[] value to encode
   * @return String encoded value
   */
  public static String encodeArray(final String[] val){
    if (val == null) {
      return null;
    }

    int len = val.length;

    if (len == 0) {
      return "";
    }

    StringBuffer sb = new StringBuffer();

    for (int i = 0; i < len; i++) {
      if (i > 0) {
        sb.append(" ");
      }

      String s = val[i];

      try {
        if (s == null) {
          sb.append("\t");
        } else {
          sb.append(URLEncoder.encode(s, "UTF-8"));
        }
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }

    return sb.toString();
  }

  /** Return a StringArray resulting from decoding the given String which
   * should have been encoded by encodeArray
   *
   * @param  val      String value encoded by encodeArray
   * @return String[] decoded value
   */
  public static String[] decodeArray(final String val){
    if (val == null) {
      return null;
    }

    int len = val.length();

    if (len == 0) {
      return new String[0];
    }

    ArrayList<String> al = new ArrayList<String>();
    int i = 0;

    while (i < len) {
      int end = val.indexOf(" ", i);

      String s;
      if (end < 0) {
        s = val.substring(i);
        i = len;
      } else {
        s = val.substring(i, end);
        i = end + 1;
      }

      try {
        if (s.equals("\t")) {
          al.add(null);
        } else {
          al.add(URLDecoder.decode(s, "UTF-8"));
        }
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }

    return al.toArray(new String[al.size()]);
  }

  /** Return true if Strings are equal including possible null
   *
   * @param thisStr
   * @param thatStr
   * @return boolean true for equal
   */
  public static boolean equalsString(final String thisStr, final String thatStr) {
    if ((thisStr == null) && (thatStr == null)) {
      return true;
    }

    if (thisStr == null) {
      return false;
    }

    return thisStr.equals(thatStr);
  }

  /** Compare two strings. null is less than any non-null string.
   *
   * @param s1       first string.
   * @param s2       second string.
   * @return int     0 if the s1 is equal to s2;
   *                 <0 if s1 is lexicographically less than s2;
   *                 >0 if s1 is lexicographically greater than s2.
   */
  public static int compareStrings(final String s1, final String s2) {
    if (s1 == null) {
      if (s2 != null) {
        return -1;
      }

      return 0;
    }

    if (s2 == null) {
      return 1;
    }

    return s1.compareTo(s2);
  }

  /** We get a lot of zero length (or all white space) strings in the web world.
   * This will return null for a zero length.
   *
   * @param  val    String request parameter value
   * @return String null for null or zero lengt val, val otherwise.
   */
  public static String checkNull(String val) {
    if (val == null) {
      return null;
    }

    val = val.trim();
    if (val.length() == 0) {
      return null;
    }

    return val;
  }

  /** We get a lot of zero length strings in the web world. This will return
   * false for null or zero-length.
   *
   * @param  val    String request parameter value
   * @return boolean true for length > 0
   */
  public static boolean present(final String val) {
    return checkNull(val) != null;
  }

  /** Turn a comma separated list into a List.
   * Throws exception for invalid list.
   *
   * @param val     String comma separated list
   * @param emptyOk Empty elements are OK
   * @return List of elements, never null
   * @throws Throwable for invalid list
   */
  public static List<String> getList(final String val, final boolean emptyOk) throws Throwable {
    List<String> l = new LinkedList<String>();

    if ((val == null) || (val.length() == 0)) {
      return l;
    }

    StringTokenizer st = new StringTokenizer(val, ",", false);
    while (st.hasMoreTokens()) {
      String token = st.nextToken().trim();

      if ((token == null) || (token.length() == 0)) {
        if (!emptyOk) {
          // No empty strings

          throw new Exception("List has an empty element.");
        }
        l.add("");
      } else {
        // Got non-empty element
        l.add(token);
      }
    }

    return l;
  }

  /** Compare two possibly null objects
   *
   * @param thisone
   * @param thatone
   * @return int -1, 0, 1,
   */
  @SuppressWarnings("unchecked")
  public static int cmpObjval(final Comparable thisone, final Comparable thatone) {
    if (thisone == null) {
      if (thatone == null) {
        return 0;
      }

      return -1;
    }

    if (thatone == null) {
      return 1;
    }

    return thisone.compareTo(thatone);
  }

  /** Compare two possibly null objects
   *
   * @param thisone
   * @param thatone
   * @return int -1, 0, 1,
   */
  public static int cmpObjval(final Collection<? extends Comparable> thisone,
                              final Collection<? extends Comparable> thatone) {
    if (thisone == null) {
      if (thatone == null) {
        return 0;
      }

      return -1;
    }

    if (thatone == null) {
      return 1;
    }

    int thisLen = thisone.size();
    int thatLen = thatone.size();

    int res = cmpIntval(thisLen, thatLen);
    if (res != 0) {
      return res;
    }

    Iterator<? extends Comparable> thatIt = thatone.iterator();
    for (Comparable c: thisone) {
      res = cmpObjval(c, thatIt.next());

      if (res != 0) {
        return res;
      }
    }

    return 0;
  }

  /** Compare two boolean objects
   *
   * @param thisone
   * @param thatone
   * @return int -1, 0, 1,
   */
  public static int cmpBoolval(final boolean thisone, final boolean thatone) {
    if (thisone == thatone) {
      return 0;
    }

    if (!thisone) {
      return -1;
    }

    return 1;
  }

  /** Compare two int objects
   *
   * @param thisone
   * @param thatone
   * @return int -1, 0, 1,
   */
  public static int cmpIntval(final int thisone, final int thatone) {
    if (thisone == thatone) {
      return 0;
    }

    if (thisone < thatone) {
      return -1;
    }

    return 1;
  }

  /** Compare two char arrays
   *
   * @param thisone
   * @param thatone
   * @return int -1, 0, 1,
   */
  public static int compare(final char[] thisone, final char[] thatone) {
    if (thisone == thatone) {
      return 0;
    }

    if (thisone == null) {
      return -1;
    }

    if (thatone == null) {
      return 1;
    }

    if (thisone.length < thatone.length) {
      return -1;
    }

    if (thisone.length > thatone.length) {
      return -1;
    }

    for (int i = 0; i < thisone.length; i++) {
      char thisc = thisone[i];
      char thatc = thatone[i];

      if (thisc < thatc) {
        return -1;
      }

      if (thisc > thatc) {
        return 1;
      }
    }

    return 0;
  }

  /** Return true for null or empty
   *
   * @param val
   * @return boolean
   */
  public static boolean isEmpty(final Collection val) {
    if (val == null) {
      return true;
    }

    return val.isEmpty();
  }

  /** Test for a valid URI and return the URI object.
   *
   * @param val
   * @return null for invalid or a URI object
   */
  public static URI validURI(final String val) {
    try {
      return new URI(val);
    } catch (Throwable t) {
      return null;
    }
  }
}
