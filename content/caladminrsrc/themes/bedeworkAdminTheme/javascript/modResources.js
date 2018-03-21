/*
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

// Specialty output for featured events resources
function writeFeaturedEventsXml() {
  var feXml = "<featuredEvents>\n";
  feXml += "  <featuresOn>" + $("#featuredEventsForm input:radio[name='enabled']:checked").val() + "</featuresOn> <!-- true to use features, false to use generic placeholders -->\n";
  feXml += "  <singleMode>" + $("#featuredEventsForm input:radio[name='singleMode']:checked").val() + "</singleMode> <!-- true for a single pane (single), false for a triptych (group) -->\n";
  feXml += "  <features>\n";
  feXml += "    <group>\n";
  for(i=1; i < 4; i++) {  
    feXml += "      <image>\n";
    feXml += "        <name>" + $("#featuredEventsForm #image" + i + "-name").val() + "</name>\n";
    feXml += "        <link>" + $("#featuredEventsForm #image" + i + "-link").val() + "</link>\n";
    feXml += "        <toolTip>" + $("#featuredEventsForm #image" + i + "-toolTip").val() + "</toolTip>\n";
    feXml += "      </image>\n";
  }
  feXml += "    </group>\n";
  feXml += "    <single>\n";
  feXml += "      <image>\n";
  feXml += "        <name>" + $("#featuredEventsForm #singleImage-name").val() + "</name>\n";
  feXml += "        <link>" + $("#featuredEventsForm #singleImage-link").val() + "</link>\n";
  feXml += "        <toolTip>" + $("#featuredEventsForm #singleImage-toolTip").val() + "</toolTip>\n";
  feXml += "      </image>\n";
  feXml += "    </single>\n";
  feXml += "  </features>\n";
  feXml += "  <generics>\n";
  feXml += "    <group>\n";
  for(i=1; i < 4; i++) {  
    feXml += "      <image>\n";
    feXml += "        <name>" + $("#featuredEventsForm #genImage" + i + "-name").val() + "</name>\n";
    feXml += "        <link>" + $("#featuredEventsForm #genImage" + i + "-link").val() + "</link>\n";
    feXml += "        <toolTip>" + $("#featuredEventsForm #genImage" + i + "-toolTip").val() + "</toolTip>\n";
    feXml += "      </image>\n";
  }
  feXml += "    </group>\n";
  feXml += "  </generics>\n";
  feXml += "</featuredEvents>\n";
  
  $("#resourceContent").val(feXml);
  return true;
}
