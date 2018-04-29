<?xml version="1.0" encoding="UTF-8"?>
<!-- 
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
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- UTILITY TEMPLATES -->

  <xsl:template name="escapeApos">
    <xsl:param name="str"/>
    <xsl:variable name="apos" select='"&apos;"'/>
    <xsl:choose>
      <xsl:when test="contains($str, $apos)">
         <xsl:value-of select="substring-before($str, $apos)" />
         <xsl:text>\'</xsl:text>
         <xsl:call-template name="escapeApos">
            <xsl:with-param name="str" select="substring-after($str, $apos)" />
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="$str" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- escape line breaks, double quotes, and tabs  -->
  <xsl:template name="escapeJson">
    <xsl:param name="string"/>
    <xsl:call-template name="replace">
      <xsl:with-param name="string">
        <xsl:call-template name="replace">
          <xsl:with-param name="string">
            <xsl:call-template name="replace">
              <xsl:with-param name="string" select="$string"/>
              <xsl:with-param name="pattern" select="'&#9;'"/>
              <xsl:with-param name="replacement" select="'\t'"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="pattern" select="'&#xA;'"/>
          <xsl:with-param name="replacement" select="'\n'"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="pattern" select="'&quot;'"/>
      <xsl:with-param name="replacement" select="'\&quot;'"/>
    </xsl:call-template>
  </xsl:template>
 
  <xsl:template name="escapeGoogle">
    <xsl:param name="string"/>
    <xsl:call-template name="replace">
      <xsl:with-param name="string" select="$string"/>
      <xsl:with-param name="pattern" select="'&#xA;'"/>
      <xsl:with-param name="replacement" select="'%0A'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="httpStatusCodes">
    <xsl:param name="code"/>
    <xsl:value-of select="$code"/><xsl:text>: </xsl:text>
    <xsl:choose>
      <xsl:when test="node() = 100">Continue</xsl:when>
      <xsl:when test="node() = 101">Switching Protocols</xsl:when>
      <xsl:when test="node() = 200">OK</xsl:when>
      <xsl:when test="node() = 201">Created</xsl:when>
      <xsl:when test="node() = 202">Accepted</xsl:when>
      <xsl:when test="node() = 203">Non-Authoritative Information</xsl:when>
      <xsl:when test="node() = 204">No Content</xsl:when>
      <xsl:when test="node() = 205">Reset Content</xsl:when>
      <xsl:when test="node() = 206">Partial Content</xsl:when>
      <xsl:when test="node() = 300">Multiple Choices</xsl:when>
      <xsl:when test="node() = 301">Moved Permanently</xsl:when>
      <xsl:when test="node() = 302">Found</xsl:when>
      <xsl:when test="node() = 303">See Other</xsl:when>
      <xsl:when test="node() = 304">Not Modified</xsl:when>
      <xsl:when test="node() = 305">Use Proxy</xsl:when>
      <xsl:when test="node() = 307">Temporary Redirect</xsl:when>
      <xsl:when test="node() = 400">Bad Request</xsl:when>
      <xsl:when test="node() = 401">Unauthorized</xsl:when>
      <xsl:when test="node() = 402">Payment Required</xsl:when>
      <xsl:when test="node() = 403">Forbidden</xsl:when>
      <xsl:when test="node() = 404">Not Found</xsl:when>
      <xsl:when test="node() = 405">Method Not Allowed</xsl:when>
      <xsl:when test="node() = 406">Not Acceptable</xsl:when>
      <xsl:when test="node() = 407">Proxy Authentication Required</xsl:when>
      <xsl:when test="node() = 408">Request Timeout</xsl:when>
      <xsl:when test="node() = 409">Conflict</xsl:when>
      <xsl:when test="node() = 410">Gone</xsl:when>
      <xsl:when test="node() = 411">Length Required</xsl:when>
      <xsl:when test="node() = 412">Precondition Failed</xsl:when>
      <xsl:when test="node() = 413">Request Entity Too Large</xsl:when>
      <xsl:when test="node() = 414">Request-URI Too Long</xsl:when>
      <xsl:when test="node() = 415">Unsupported Media Type</xsl:when>
      <xsl:when test="node() = 416">Requested Range Not Satisfiable</xsl:when>
      <xsl:when test="node() = 417">Expectation Failed</xsl:when>
      <xsl:when test="node() = 500">Internal Server Error</xsl:when>
      <xsl:when test="node() = 501">Not Implemented</xsl:when>
      <xsl:when test="node() = 502">Bad Gateway</xsl:when>
      <xsl:when test="node() = 503">Service Unavailable</xsl:when>
      <xsl:when test="node() = 504">Gateway Timeout</xsl:when>
      <xsl:when test="node() = 505">HTTP Version Not Supported</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- search and replace template taken from
       http://www.biglist.com/lists/xsl-list/archives/200211/msg00337.html -->
  <xsl:template name="replace">
    <xsl:param name="string" select="''"/>
    <xsl:param name="pattern" select="''"/>
    <xsl:param name="replacement" select="''"/>
    <xsl:choose>
      <xsl:when test="$pattern != '' and $string != '' and contains($string, $pattern)">
        <xsl:value-of select="substring-before($string, $pattern)"/>
        <xsl:copy-of select="$replacement"/>
        <xsl:call-template name="replace">
          <xsl:with-param name="string" select="substring-after($string, $pattern)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
          <xsl:with-param name="replacement" select="$replacement"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- URL-encoding template Written by Mike J. Brown, mike@skew.org.
       No license; use freely, but credit me if reproducing in print.
       http://skew.org/xml/stylesheets/url-encode/ -->
  <xsl:template name="url-encode">
    <xsl:param name="str"/>

    <!-- Characters we'll support. We could add control chars 0-31 and 127-159, but we won't. -->
    <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
    <xsl:variable name="latin1"> ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ</xsl:variable>

    <!-- Characters that usually don't need to be escaped -->
    <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>

    <xsl:variable name="hex">0123456789ABCDEF</xsl:variable>

    <xsl:if test="$str">
      <xsl:variable name="first-char" select="substring($str,1,1)"/>
      <xsl:choose>
        <xsl:when test="contains($safe,$first-char)">
          <xsl:value-of select="$first-char"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="codepoint">
            <xsl:choose>
              <xsl:when test="contains($ascii,$first-char)">
                <xsl:value-of select="string-length(substring-before($ascii,$first-char)) + 32"/>
              </xsl:when>
              <xsl:when test="contains($latin1,$first-char)">
                <xsl:value-of select="string-length(substring-before($latin1,$first-char)) + 160"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="no">Warning: string contains a character that is out of range! Substituting "?".</xsl:message>
                <xsl:text>63</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        <xsl:variable name="hex-digit1" select="substring($hex,floor($codepoint div 16) + 1,1)"/>
        <xsl:variable name="hex-digit2" select="substring($hex,$codepoint mod 16 + 1,1)"/>
        <xsl:value-of select="concat('%',$hex-digit1,$hex-digit2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($str) &gt; 1">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="substring($str,2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="substring-afterLastInstanceOf">
    <xsl:param name="string" />
    <xsl:param name="char" />
    <xsl:choose>
      <xsl:when test="contains($string, $char)">
        <xsl:call-template name="substring-afterLastInstanceOf">
          <xsl:with-param name="string" select="substring-after($string, $char)" />
          <xsl:with-param name="char" select="$char" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="changeCase">
    <xsl:param name="to">lower</xsl:param>
    <xsl:param name="string"/>
    <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ</xsl:variable>
    <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ</xsl:variable>
    <xsl:choose>
      <xsl:when test="$to='upper'"><xsl:value-of select="translate($string,$lower,$upper)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="translate($string,$upper,$lower)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

