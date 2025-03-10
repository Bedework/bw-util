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

import org.bedework.base.ToString;

import org.apache.commons.text.StringEscapeUtils;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URI;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
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

  public record Caller(String className,
                       String methodName,
                       String fileName,
                       int lineNumber) {
    public String toString() {
      return new ToString(this)
              .append("className", className)
              .append("methodName", methodName)
              .append("fileName", fileName)
              .append("lineNumber", lineNumber)
              .toString();
    }
  }

  public static List<Caller> getCallers(final int levels) {
    final var res = new ArrayList<Caller>();
    final StackTraceElement[] stackTraceElements =
            Thread.currentThread().getStackTrace();

    var skipped = 0; // first 2 are this method and the caller.
    for (var i = 1; i < stackTraceElements.length; i++) {
      if (skipped < 2) {
        skipped++;
        continue;
      }
      final StackTraceElement ste =
              stackTraceElements[i];
      res.add(new Caller(ste.getClassName(),
                         ste.getMethodName(),
                         ste.getFileName(),
                         ste.getLineNumber()));
      if (res.size() >= levels) {
        break;
      }
    }

    return res;
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
    final StringBuilder path = new StringBuilder();

    for (final String s: val) {
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
    if ((href == null) || (href.isEmpty())) {
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

    if ((paths[0] == null) || (paths[0].isEmpty())) {
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
    final String lang;
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
   * @throws RuntimeException on fatal error
   */
  public static Properties getPropertiesFromResource(final String name) {
    final Properties pr = new Properties();
    InputStream is = null;

      // The jboss?? way - should work for others as well.
      final ClassLoader cl = Thread.currentThread().getContextClassLoader();
    try {
      is = cl.getResourceAsStream(name);

      if (is == null) {
        // Try another way
        is = Util.class.getResourceAsStream(name);
      }

      if (is == null) {
        throw new RuntimeException(
                "Unable to load properties file" + name);
      }

      pr.load(is);

      //if (debug) {
      //  pr.list(System.out);
      //  Logger.getLogger(Util.class).debug(
      //      "file.encoding=" + System.getProperty("file.encoding"));
      //}
      return pr;
    } catch (final Throwable t) {
      if (t instanceof RuntimeException) {
        throw (RuntimeException)t;
      }

      throw new RuntimeException(t);
    } finally {
      if (is != null) {
        try {
          is.close();
        } catch (final Throwable ignored) {}
      }
    }
  }

  /** Given a class name return an object of that class.
   * The class parameter is used to check that the
   * named class is an instance of that class.
   *
   * @param loader class loader to use
   * @param className String class name
   * @param cl   Class expected
   * @return     Object checked to be an instance of that class
   * @throws RuntimeException on fatal error
   */
  public static Object getObject(final ClassLoader loader,
                                 final String className,
                                 final Class<?> cl) {
    try {
      final Class<?> clazz = loader.loadClass(className);

      if (clazz == null) {
        throw new RuntimeException("Class " + className + " not found");
      }

      final Object o = clazz.getDeclaredConstructor().newInstance();

      if (!cl.isInstance(o)) {
        throw new RuntimeException(
                "Class " + clazz +
                        " is not a subclass of " +
                        cl.getName());
      }

      return o;
    } catch (final RuntimeException re) {
      throw re;
    } catch (final Throwable t) {
      throw new RuntimeException(t);
    }
  }

  /** Given a class name return an object of that class.
   * The class parameter is used to check that the
   * named class is an instance of that class.
   *
   * @param className String class name
   * @param cl   Class expected
   * @return     Object checked to be an instance of that class
   * @throws RuntimeException on fatal error
   */
  public static Object getObject(final String className,
                                 final Class<?> cl) {
    return getObject(Thread.currentThread().getContextClassLoader(),
                     className,
                     cl);
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
        sb.append(val, segStart, pos);
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

    return propertyReplace(sb.toString(), props);
  }

  /**
   *
   * @param map to sort
   * @param <K> type of key
   * @param <V> type of value
   * @return sorted list of map entries
   */
  public static <K, V extends Comparable<V>> List<Map.Entry<K, V>> sortMap(
          final Map<K, V> map) {
    // We create a list from the elements of the unsorted map
    final List <Map.Entry<K, V>> list = new LinkedList<>(map.entrySet());

    // Now sort the list
    final Comparator<Map.Entry<K, V>> comparator =
            Comparator.comparing(Map.Entry<K, V>::getValue);
    list.sort(comparator.reversed());

    return list;
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

    final StringBuilder res = new StringBuilder();
    final Random rand = new Random();

    for (int i = 0; i <= length; i++) {
      res.append(randChars[rand.nextInt(maxVal + 1)]);
    }

    return res.toString();
  }

  public static String makeDataUri(final String val,
                                   final String contentType) {
    return "data:" + contentType + ";base64," +
            Base64.getEncoder().
                    encodeToString(val.getBytes());
  }

  public static boolean causeIs(final Throwable t,
                                final Class<?> possibleCause) {
    Objects.requireNonNull(t);
    Throwable rootCause = t;
    if (possibleCause.isAssignableFrom(rootCause.getClass())) {
      return true;
    }
    while ((rootCause.getCause() != null) &&
            (rootCause.getCause() != rootCause)) {
      rootCause = rootCause.getCause();
      if (possibleCause.isAssignableFrom(rootCause.getClass())) {
        return true;
      }
    }

    return false;
  }

  public static String fromBase64(final String val) {
    final var bytes = Base64.getDecoder().decode(val);
    return new String(bytes, StandardCharsets.US_ASCII);
  }

  public static String escapeJava(final String val) {
    return StringEscapeUtils.escapeJava(val);
  }

  /** Add a string to a string array of a given maximum length. Truncates
   * the string array if required.
   * <p>
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
      final String[] neb = new String[maxEntries];
      System.arraycopy(sarray, sarray.length - maxEntries,
                       neb, 0, maxEntries);
      sarray = neb;
      sarray[sarray.length - 1] = val;
      return sarray;
    }

    if (sarray.length < maxEntries) {
      final int newLen = sarray.length + 1;
      final String[] neb = new String[newLen];
      System.arraycopy(sarray, 0,
                       neb, 0, sarray.length);
      sarray = neb;
      sarray[sarray.length - 1] = val;

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

    final int len = val.length;

    if (len == 0) {
      return "";
    }

    final StringBuilder sb = new StringBuilder();

    for (int i = 0; i < len; i++) {
      if (i > 0) {
        sb.append(" ");
      }

      final String s = val[i];

      try {
        if (s == null) {
          sb.append("\t");
        } else {
          sb.append(URLEncoder.encode(s, StandardCharsets.UTF_8));
        }
      } catch (final Throwable t) {
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

    final int len = val.length();

    if (len == 0) {
      return new String[0];
    }

    final ArrayList<String> al = new ArrayList<>();
    int i = 0;

    while (i < len) {
      final int end = val.indexOf(" ", i);

      final String s;
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
          al.add(URLDecoder.decode(s, StandardCharsets.UTF_8));
        }
      } catch (final Throwable t) {
        throw new RuntimeException(t);
      }
    }

    return al.toArray(new String[0]);
  }

  /** Return true if Strings are equal including possible null
   *
   * @param thisStr compare this
   * @param thatStr with that
   * @return boolean true for equal
   */
  public static boolean equalsString(final String thisStr,
                                     final String thatStr) {
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
    if (val.isEmpty()) {
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
    final List<String> l = new LinkedList<>();

    if ((val == null) || (val.isEmpty())) {
      return l;
    }

    final StringTokenizer st = new StringTokenizer(val, ",", false);
    while (st.hasMoreTokens()) {
      final String token = st.nextToken().trim();

      if (token.isEmpty()) {
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
   * @param thisone compare this
   * @param thatone with that
   * @return int -1, 0, 1,
   */
  public static int cmpObjval(final Comparable thisone,
                              final Comparable thatone) {
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
   * @param thisone compare this
   * @param thatone with that
   * @return int -1, 0, 1,
   */
  public static int cmpObjval(
          final Collection<? extends Comparable<?>> thisone,
          final Collection<? extends Comparable<?>> thatone) {
    if (thisone == null) {
      if (thatone == null) {
        return 0;
      }

      return -1;
    }

    if (thatone == null) {
      return 1;
    }

    final int thisLen = thisone.size();
    final int thatLen = thatone.size();

    int res = cmpIntval(thisLen, thatLen);
    if (res != 0) {
      return res;
    }

    final Iterator<? extends Comparable<?>> thatIt =
            thatone.iterator();
    for (final Comparable<?> c: thisone) {
      res = cmpObjval(c, thatIt.next());

      if (res != 0) {
        return res;
      }
    }

    return 0;
  }

  /** Compare two boolean objects
   *
   * @param thisone compare this
   * @param thatone with that
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
   * @param thisone compare this
   * @param thatone with that
   * @return int -1, 0, 1,
   */
  public static int cmpIntval(final int thisone, final int thatone) {
    return Integer.compare(thisone, thatone);

  }

  /** Compare two char arrays
   *
   * @param thisone compare this
   * @param thatone with that
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
      final char thisc = thisone[i];
      final char thatc = thatone[i];

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
   * @param val collection or null
   * @return boolean
   */
  public static boolean isEmpty(final Collection<?> val) {
    if (val == null) {
      return true;
    }

    return val.isEmpty();
  }

  /** Test for a valid URI and return the URI object.
   *
   * @param val possible uri
   * @return null for invalid or a URI object
   */
  public static URI validURI(final String val) {
    try {
      return new URI(val);
    } catch (final Throwable t) {
      return null;
    }
  }

  /** Return a path, broken into its elements, after "." and ".." are removed.
   * If the parameter path attempts to go above the root we return null.
   *
   * Other than the backslash thing why not use URI?
   *
   * @param path      String path to be fixed
   * @return String[]   fixed path broken into elements
   * @throws RuntimeException on bad uri
   */
  public static List<String> fixPath(final String path) {
    if (path == null) {
      return null;
    }

    String decoded;
    try {
      decoded = URLDecoder.decode(path,
                                  StandardCharsets.UTF_8);
    } catch (final Throwable t) {
      throw new RuntimeException("Undecodable path: " + path);
    }

    if (decoded == null) {
      return null;
    }

    /* Make any backslashes into forward slashes.
     */
    if (decoded.indexOf('\\') >= 0) {
      decoded = decoded.replace('\\', '/');
    }

    /* Ensure a leading '/'
     */
    if (!decoded.startsWith("/")) {
      decoded = "/" + decoded;
    }

    /* Remove all instances of '//'.
     */
    while (decoded.contains("//")) {
      decoded = decoded.replaceAll("//", "/");
    }

    /* Somewhere we may have /./ or /../
     */

    final StringTokenizer st = new StringTokenizer(decoded, "/");

    final ArrayList<String> al = new ArrayList<>();
    while (st.hasMoreTokens()) {
      final String s = st.nextToken();

      if (s.equals(".")) {
        continue;
      }

      if (s.equals("..")) {
        // Back up 1
        if (al.isEmpty()) {
          // back too far
          throw new RuntimeException("Path attempting to back up past root: " + path);
        }

        al.remove(al.size() - 1);
      } else {
        al.add(s);
      }
    }

    return al;
  }
}
