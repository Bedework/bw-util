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

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.logging.Log;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
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
import java.util.Properties;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import static java.nio.file.FileVisitResult.CONTINUE;
import static java.nio.file.FileVisitResult.SKIP_SUBTREE;
import static java.nio.file.StandardCopyOption.COPY_ATTRIBUTES;
import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

/**
 */
public class Utils {
  private boolean debug;
  private final Log logger;
  private final Properties versions = new Properties();

  public Utils(final Log logger) {
    this.logger = logger;
    debug = logger.isDebugEnabled();
  }

  public void setVersionsProp(final String name,
                              final String val) {
    versions.setProperty(name, val);
  }

  public String getVersionsProp(final String name) {
    return versions.getProperty(name);
  }

  public Path createFile(final String path) throws Throwable {
    final Path pathToFile = Paths.get(path);
    Files.createDirectories(pathToFile.getParent());
    return Files.createFile(pathToFile);
  }

  public boolean empty(final String path) {
    return delete(new File(path), false);
  }

  public boolean makeDir(final String path) throws Throwable {
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

  public File directory(final String path) throws Throwable {
    final File f = new File(path);

    if (!f.exists() || !f.isDirectory()) {
      throw new MojoExecutionException(f.getAbsolutePath() +
                                               " must exist and be a directory");
    }

    return f;
  }

  public File subDirectory(final String path,
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

  public File subDirectory(final File f,
                           final String name,
                           final boolean mustExist) throws Throwable {
    final File dir = new File(f.getAbsolutePath(), name);

    if (dir.exists() && !dir.isDirectory()) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must be a directory");
    }

    if (!dir.exists() && mustExist) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must exist and be a directory");
    }

    return dir;
  }

  public File file(final File dir,
                   final String name,
                   final boolean mustExist) throws Throwable {
    final File f = new File(dir.getAbsolutePath(), name);

    if (f.exists() && !f.isFile()) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must be a file");
    }

    if (!f.exists() && mustExist) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must exist and be a file");
    }

    return f;
  }

  public File fileOrDir(final File dir,
                        final String name) throws Throwable {
    final File f = new File(dir.getAbsolutePath(), name);

    if (!f.exists()) {
      throw new Exception(name + " in " +
                                  f.getAbsolutePath() +
                                  " must exist");
    }

    return dir;
  }

  public File file(final String path) throws Throwable {
    final File f = new File(path);

    if (!f.exists() || !f.isFile()) {
      throw new Exception(path + " must exist and be a file");
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
  public Document parseXml(final Reader rdr,
                           final boolean nameSpaced) throws Throwable {
    return parseXml(rdr, nameSpaced, false);
  }

  /** Parse a reader and return the DOM representation.
   *
   * @param rdr        Reader
   * @param nameSpaced true if this document has namespaces
   * @param offline true if in offline mode
   * @return Document  Parsed body or null for no body
   * @exception Throwable Some error occurred.
   */
  public Document parseXml(final Reader rdr,
                           final boolean nameSpaced,
                           final boolean offline) throws Throwable {
    if (rdr == null) {
      // No content?
      return null;
    }

    final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setNamespaceAware(nameSpaced);

    if (offline) {
      factory.setValidating(false);
      factory.setFeature(
              "http://apache.org/xml/features/nonvalidating/load-external-dtd",
              false);
    }

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
  public boolean delete(final File file,
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
          new CopyOption[] { REPLACE_EXISTING, COPY_ATTRIBUTES };

  /**
   * A {@code FileVisitor} that copies a file-tree ("cp -r")
   */
  private class DirCopier implements FileVisitor<Path> {
    private final Path in;
    private final Path out;
    private final boolean outExists;
    private final PropertiesChain props;

    DirCopier(final Path in,
              final Path out,
              final boolean outExists,
              final PropertiesChain props) {
      this.in = in;
      this.out = out;
      this.outExists = outExists;
      this.props = props;
    }

    @Override
    public FileVisitResult preVisitDirectory(final Path dir,
                                             final BasicFileAttributes attrs) {
      // before visiting entries in a directory we copy the directory
      final Path newdir = out.resolve(in.relativize(dir));

      try {
//        if ((newdir.compareTo(out) == 0) && outExists) {
  //        return CONTINUE;
    //    }

        //Utils.debug("**** Visit dir " + dir);
        final File nd = newdir.toFile();
        if (nd.exists()) {
          if (nd.isDirectory()) {
            return CONTINUE;
          }

          error(dir.toString() + " already exists and is not a directory");
          return SKIP_SUBTREE;
        }
        //Utils.debug("**** Copy dir " + dir);
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
      //Utils.debug("**** Copy file " + file);
      copyFile(file, out.resolve(in.relativize(file)), props);
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

  public void copy(final Path inPath,
                   final Path outPath,
                   final boolean outExists,
                   final PropertiesChain props) throws Throwable {
    final EnumSet<FileVisitOption> opts = EnumSet.of(
            FileVisitOption.FOLLOW_LINKS);
    final DirCopier tc = new DirCopier(inPath, outPath,
                                       outExists, props);
    Files.walkFileTree(inPath, opts, Integer.MAX_VALUE, tc);
  }

  class TokenResolver implements ITokenResolver {
    protected final PropertiesChain props;

    public TokenResolver(final PropertiesChain props) {
      this.props = props;
    }

    public String resolveToken(final String tokenName) {
      return props.get(tokenName);
    }

  }

  private void copyFile(final Path in,
                        final Path out,
                        final PropertiesChain props) {
    final boolean noReplacement;

    if (props == null) {
      noReplacement = true;
    } else {
      final String name = in.getFileName().toString();

      if (name.endsWith(".jar") || name.endsWith(".zip")) {
        warn("Can't process this " + in);
        noReplacement = true;
      } else {
        noReplacement = false;
      }
    }

    if (noReplacement) {
      try {
        Files.copy(in, out, copyOptionAttributes);
      } catch (final Throwable t) {
        error("Unable to copy: " + in + " to " + out +
                      ": " + t);
      }

      return;
    }
//    if (Files.notExists(out)) {
    Reader rdr = null;
    Writer wtr = null;
    try {
      rdr = new TokenReplacingReader(new FileReader(in.toFile()),
                                    new TokenResolver(props));
      wtr = new FileWriter(out.toFile());
      int length;

      int data = rdr.read();
      while(data != -1){
        wtr.write(data);
        data = rdr.read();
      }
    } catch (final Throwable t) {
      error(t);
      error("Unable to copy: " + in + " to " + out +
                    ": " + t);
    } finally {
      try {
        rdr.close();
      } catch (final Throwable t) {
        error("Exception closing " + in + " " + t.getMessage());
      }
      try {
        wtr.close();
      } catch (final Throwable t) {
        error("Exception closing " + out + " " + t.getMessage());
      }
    }
    //  }
  }


  public class DeletingFileVisitor extends SimpleFileVisitor<Path> {
    @Override
    public FileVisitResult visitFile(final Path file,
                                     final BasicFileAttributes attributes)
            throws IOException {
      if(attributes.isRegularFile()) {
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

  public void deleteAll(final Path dir) throws Throwable {
    final DeletingFileVisitor delFileVisitor = new DeletingFileVisitor();
    Files.walkFileTree(dir, delFileVisitor);
  }

  /** Return a Properties object containing all those properties that
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

  /** Delete any files on the given path that have a name part that
   * matches the split name. Allows us to remove old versions.
   *
   * @param dirPath the directory
   * @param sn the split name
   * @throws Throwable
   */
  void deleteMatching(final String dirPath,
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

  void print(final String fmt,
                    final Object... params) {
    final Formatter f = new Formatter();

    info(f.format(fmt, params).toString());
  }

  void info(final String msg) {
    logger.info(msg);
  }

  void error(final String msg) {
    logger.error(msg);
  }

  void error(final Throwable t) {
    logger.error(t);
  }

  void setDebug(final boolean val) {
    debug = val;
  }

  boolean debug() {
    return debug;
  }

  void debug(final String msg) {
    if (debug) {
      logger.debug(msg);
    }
  }

  void warn(final String msg) {
    logger.warn(msg);
  }

  void assertion(final boolean test,
                 final String fmt,
                 final Object... params) {
    if (test) {
      return;
    }

    final Formatter f = new Formatter();

    throw new RuntimeException(f.format(fmt, params).toString());
  }

  int getInt(final String val) {
    try {
      return Integer.valueOf(val);
    } catch (final Throwable ignored) {
      throw new RuntimeException("Failed to parse as Integer " + val);
    }
  }
}

