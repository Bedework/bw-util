/*
#    Copyright (c) 2007-2013 Cyrus Daboo. All rights reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
*/
package org.bedework.util.deployment;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.nio.file.CopyOption;
import java.nio.file.FileAlreadyExistsException;
import java.nio.file.FileSystemLoopException;
import java.nio.file.FileVisitOption;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.FileTime;
import java.util.EnumSet;
import java.util.Formatter;
import java.util.List;
import java.util.Properties;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import static java.nio.file.FileVisitResult.CONTINUE;
import static java.nio.file.FileVisitResult.SKIP_SUBTREE;
import static java.nio.file.StandardCopyOption.COPY_ATTRIBUTES;

class Utils {
  public static boolean debug;

  public static Path createFile(final String path) throws Throwable {
    final Path pathToFile = Paths.get(path);
    Files.createDirectories(pathToFile.getParent());
    return Files.createFile(pathToFile);
  }

  public static boolean empty(final String path) {
    return delete(new File(path), false);
  }

  public static boolean makeDir(final String path) throws Throwable {
    final File f = new File(path);

    if (!f.exists()) {
      return f.mkdir();
    }

    if (!f.isDirectory()) {
      throw new Exception(f.getAbsolutePath() +
                                  " must be a directory");
    }

    return false;
  }

  public static File directory(final String path) throws Throwable {
    final File f = new File(path);

    if (!f.exists() || !f.isDirectory()) {
      throw new Exception(f.getAbsolutePath() +
                                  " must exist and be a directory");
    }

    return f;
  }

  public static File subDirectory(final String path,
                                  final String name) throws Throwable {
    final Path p = Paths.get(path, name);
    final File f = p.toFile();

    if (!f.exists() || !f.isDirectory()) {
      throw new Exception(name + " in " +
                                  path +
                                  " must exist and be a directory");
    }

    return f;
  }

  public static File subDirectory(final File f,
                                  final String name) throws Throwable {
    final File dir = new File(f.getAbsolutePath(), name);

    if (!dir.exists() || !dir.isDirectory()) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must exist and be a directory");
    }

    return dir;
  }

  public static File file(final File dir,
                          final String name) throws Throwable {
    final File f = new File(dir.getAbsolutePath(), name);

    if (!f.exists() || !f.isFile()) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must exist and be a file");
    }

    return f;
  }

  public static File fileOrDir(final File dir,
                               final String name) throws Throwable {
    final File f = new File(dir.getAbsolutePath(), name);

    if (!f.exists()) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must exist");
    }

    return dir;
  }

  public static File file(final String path) throws Throwable {
    final File f = new File(path);

    if (!f.exists() || !f.isFile()) {
      throw new Exception(path +
                                  " must exist and be a file");
    }

    return f;
  }

  /** Parse a reader and return the DOM representation.
   *
   * @param rdr        Reader
   * @param nameSpaced true if this document has namespaces
   * @return Document  Parsed body or null for no body
   * @exception Throwable Some error occurred.
   */
  public static Document parseXml(final Reader rdr,
                                  final boolean nameSpaced) throws Throwable {
    if (rdr == null) {
      // No content?
      return null;
    }

    final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setNamespaceAware(nameSpaced);

    final DocumentBuilder builder = factory.newDocumentBuilder();

    return builder.parse(new InputSource(rdr));
  }

  /** If it's a file - delete it.
   * If it's a directory delete the contents and if deleteThis is true
   * delete the directory as well.
   *
   * @param file file/dir
   * @param deleteThis true to delete directory
   * @return true if something deleted
   */
  public static boolean delete(final File file,
                               final boolean deleteThis) {
    final File[] flist;

    if(file == null){
      return false;
    }

    if (file.isFile()) {
      return file.delete();
    }

    if (!file.isDirectory()) {
      return false;
    }

    flist = file.listFiles();
    if (flist != null && flist.length > 0) {
      for (final File f : flist) {
        if (!delete(f, true)) {
          return false;
        }
      }
    }

    if (!deleteThis) {
      return true;
    }
    return file.delete();
  }

  private final static CopyOption[] copyOptionAttributes =
          new CopyOption[] { COPY_ATTRIBUTES };

  /**
   * A {@code FileVisitor} that copies a file-tree ("cp -r")
   */
  private static class DirCopier implements FileVisitor<Path> {
    private final Path in;
    private final Path out;
    private final boolean outExists;

    DirCopier(final Path in,
              final Path out,
              final boolean outExists) {
      this.in = in;
      this.out = out;
      this.outExists = outExists;
    }

    @Override
    public FileVisitResult preVisitDirectory(final Path dir,
                                             final BasicFileAttributes attrs) {
      // before visiting entries in a directory we copy the directory
      final Path newdir = out.resolve(in.relativize(dir));

      try {
        if ((newdir.compareTo(out) == 0) && outExists) {
          return CONTINUE;
        }

        Files.copy(dir, newdir, copyOptionAttributes);
      } catch (final FileAlreadyExistsException faee) {
        error("File already exists" + faee.getFile());
      } catch (final Throwable t) {
        error("Unable to create: " + newdir + ": " + t);
        return SKIP_SUBTREE;
      }
      return CONTINUE;
    }

    @Override
    public FileVisitResult visitFile(final Path file,
                                     final BasicFileAttributes attrs) {
      copyFile(file, out.resolve(in.relativize(file)));
      return CONTINUE;
    }

    @Override
    public FileVisitResult postVisitDirectory(final Path dir,
                                              final IOException exc) {
      // fix up modification time of directory when done
      if (exc == null) {
        final Path newdir = out.resolve(in.relativize(dir));
        try {
          final FileTime time = Files.getLastModifiedTime(dir);
          Files.setLastModifiedTime(newdir, time);
        } catch (final Throwable t) {
          error("Unable to copy all attributes to: " + newdir +
                        ": " + t);
        }
      }
      return CONTINUE;
    }

    @Override
    public FileVisitResult visitFileFailed(final Path file,
                                           final IOException exc) {
      if (exc instanceof FileSystemLoopException) {
        error("cycle detected: " + file);
      } else {
        error("Unable to copy: " + file + "; " + exc);
      }
      return CONTINUE;
    }
  }

  public static void copy(final Path inPath,
                          final Path outPath,
                          final boolean outExists) throws Throwable {
    final EnumSet<FileVisitOption> opts = EnumSet.of(
            FileVisitOption.FOLLOW_LINKS);
    final DirCopier tc = new DirCopier(inPath, outPath, outExists);
    Files.walkFileTree(inPath, opts, Integer.MAX_VALUE, tc);
  }

  static void copyFile(final Path in,
                       final Path out) {
    if (Files.notExists(out)) {
      try {
        Files.copy(in, out, copyOptionAttributes);
      } catch (final Throwable t) {
        error("Unable to copy: " + in + " to " + out +
                      ": " + t);
      }
    }
  }

  public static class DeletingFileVisitor extends SimpleFileVisitor<Path> {
    @Override
    public FileVisitResult visitFile(final Path file,
                                     final BasicFileAttributes attributes)
            throws IOException {
      if(attributes.isRegularFile()){
        Files.delete(file);
      }
      return FileVisitResult.CONTINUE;
    }

    @Override
    public FileVisitResult postVisitDirectory(final Path directory,
                                              final IOException ioe)
            throws IOException {
      Files.delete(directory);
      return FileVisitResult.CONTINUE;
    }

    @Override
    public FileVisitResult visitFileFailed(final Path file,
                                           final IOException ioe)
            throws IOException {
      error("Unable to delete: " + file +
                    ": " + ioe);
      return FileVisitResult.CONTINUE;
    }
  }

  public static void deleteAll(final Path dir) throws Throwable {
    final DeletingFileVisitor delFileVisitor = new DeletingFileVisitor();
    Files.walkFileTree(dir, delFileVisitor);
  }

  /** Return a Proeprties object containing all those properties that
   * match the given prefix. The property name will have the prefix
   * replaced by the new prefix.
   *
   * @param props source properties
   * @param prefix to match
   * @param newPrefix replacement
   * @return never null
   */
  public static Properties filter(final Properties props,
                                  final String prefix,
                                  final String newPrefix) {
    final Properties res = new Properties();

    for (final String pname: props.stringPropertyNames()) {
      if (pname.startsWith(prefix)) {
        res.setProperty(newPrefix + pname.substring(prefix.length()),
                        props.getProperty(pname));
      }
    }
    return res;
  }

  public static String propReplace(final Properties props, final String s) {
    if (s == null) {
      return null;
    }

    final int start = s.indexOf("${");

    if (start < 0) {
      return s;
    }

    final int end = s.indexOf("}", start);

    if (end < 0) {
      return s;
    }

    final String pval = props.getProperty(s.substring(start + 2, end));

    if (pval == null) {
      return s;
    }

    return s.substring(0, start) + pval + s.substring(end + 1);
  }

  /** Result of splitting a name into its component parts, e.g.
   *
   * anapp-3.10.5.war
   *
   * has prefix = "anapp"
   * version = "3.10.5"
   * suffix = "."
   *
   * <p>Note the prefix must be longer than 3 characters - to avoid the
   * "bw-" part of the name</p>
   *
   */
  static class SplitName {
    String name;

    String prefix;
    String version;
    String suffix;

    SplitName(final String name,
              final String prefix) {
      this.name = name;
      this.prefix = prefix;

      final int dashPos = prefix.length();
      if (name.charAt(prefix.length()) != '-') {
        throw new RuntimeException("Bad name/prefix");
      }

      final int dotPos = name.lastIndexOf(".");

      version = name.substring(dashPos + 1, dotPos);
      suffix = name.substring(dotPos + 1);
    }

    static SplitName testName(final String name) {
      /* Try to figure out the prefix */
      final int dashPos = name.indexOf("-", 3);

      if (dashPos < 0) {
        return null;
      }

      final int dotPos = name.lastIndexOf(".");

      if (dotPos > dashPos) {
        return new SplitName(name, name.substring(0, dashPos));
      }

      return null;
    }

    static SplitName testName(final String name,
                              final List<String> prefixes) {
      for (final String prefix: prefixes) {
        if (name.startsWith(prefix) &&
          // Next char must be "-"
                     (name.charAt(prefix.length()) == '-')) {
          final int dotPos = name.lastIndexOf(".");

          if (dotPos > prefix.length()) {
            return new SplitName(name, prefix);
          }
        }
      }

      return null;
    }
  }

  static void deleteMatching(final String dirPath,
                             final SplitName sn) throws Throwable {
    if ((sn.prefix.length() < 3) || (sn.suffix.length() < 3)) {
      throw new Exception("Suspect name " + sn);
    }

    final File dir = directory(dirPath);

    final String[] names = dir.list();

    for (final String nm: names) {
      if (nm.startsWith(sn.prefix) && nm.endsWith(sn.suffix)) {
        final Path p = Paths.get(dirPath, nm);
        deleteAll(p);
      }
    }
  }

  static void print(final String fmt,
                    final Object... params) {
    final Formatter f = new Formatter();

    info(f.format(fmt, params).toString());
  }

  static void info(final String msg) {
    System.out.println("INFO: " + msg);
  }

  static void error(final String msg) {
    System.err.println("ERROR: " + msg);
  }

  static void debug(final String msg) {
    if (debug) {
      System.out.println("DEBUG: " + msg);
    }
  }

  static void warn(final String msg) {
    System.err.println("WARN: " + msg);
  }

  static void assertion(final boolean test,
                        final String fmt,
                        final Object... params) {
    if (test) {
      return;
    }

    final Formatter f = new Formatter();

    throw new RuntimeException(f.format(fmt, params).toString());
  }

  static int getInt(final String val) {
    try {
      return Integer.valueOf(val);
    } catch (final Throwable ignored) {
      throw new RuntimeException("Failed to parse as Integer " + val);
    }
  }
}

