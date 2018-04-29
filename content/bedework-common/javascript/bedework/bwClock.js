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


/** A basic jQuery plug-in for building a time picker. 
 *  With a little effort this could be generalized; 
 *  at the moment, it is somewhat Bedework-centric.
 *  
 *  Styles are defined in bwClock.css
 * 
 * @author Arlen Johnson       johnsa - rpi.edu
 */

(function($){  
  $.fn.bwTimePicker = function(options) { 
    
    var defaults = {  
      hour24: false,      // are we in 24 hour clock mode?
      withPadding: false, // pad the hours with a zero if below 10
      attachToId: null,   // id of element which when clicked will launch the time picker
      hourIds: null,      // array of ids - one for each hour element to be updated
      minuteIds: null,    // array of ids - one for each minute element to be updated
      ampmIds: null,      // array of ids - one for each am/pm element to be updated
      hourLabel: "Hour",  // default text for "Hour"
      minuteLabel: "Minute", // default text for "Minute"
      amLabel: "am",      // default text for "am"
      pmLabel: "pm"      // default text for "pm"
    };  
    var options = $.extend(defaults, options);
    
    var bwTimePickerContent = "";
    bwTimePickerContent += '<div class="bwTimePicker">';
    bwTimePickerContent += '<div class="bwTimePickerCloser">x</div>';
    bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerHours"><h6>' + options.hourLabel + '</h6><div class="bwTimePickerVals">';
    if (options.hour24) {
      bwTimePickerContent += '<ul><li>0</li><li>1</li><li>2</li><li>3</li><li>4</li><li>5</li></ul>';
      bwTimePickerContent += '<ul><li>6</li><li>7</li><li>8</li><li>9</li><li>10</li><li>11</li></ul>';
      bwTimePickerContent += '<ul><li>12</li><li>13</li><li>14</li><li>15</li><li>16</li><li>17</li></ul>';
      bwTimePickerContent += '<ul><li>18</li><li>19</li><li>20</li><li>21</li><li>22</li><li>23</li></ul>';
    } else {
      bwTimePickerContent += '<ul><li>1</li><li>2</li><li>3</li><li>4</li><li>5</li><li>6</li></ul>';
      bwTimePickerContent += '<ul><li>7</li><li>8</li><li>9</li><li>10</li><li>11</li><li>12</li></ul>';
    }
    bwTimePickerContent += '</div></div>';
    bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerColon">:</div>';
    bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerMinutes"><h6>' + options.minuteLabel + '</h6><div class="bwTimePickerVals">';
    bwTimePickerContent += '<ul><li>00</li><li>10</li><li>20</li><li>30</li><li>40</li><li>50</li></ul>';
    bwTimePickerContent += '<ul><li>05</li><li>15</li><li>25</li><li>35</li><li>45</li><li>55</li></ul>';
    bwTimePickerContent += '</div></div>';
    if (!options.hour24) {
      bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerAmPm"><ul><li>' + options.amLabel + '</li><li>' + options.pmLabel + '</li></ul></div>';
    }
    bwTimePickerContent += '</div>';
    return this.each(function() {  
      var obj = $(this); 
      
      obj.addClass('bwTimePickerLink');
      $("#" + options.attachToId).css("position","relative");
      $("#" + options.attachToId).css("display","inline-block");
      
      obj.click(function() {
        $("#" + options.attachToId).append(bwTimePickerContent);
        $(".bwTimePicker .bwTimePickerCloser").click(function(){
            $("#" + options.attachToId + " .bwTimePicker").remove();
        });
        $("#" + options.attachToId + " .bwTimePicker .bwTimePickerHours li").click(function(){
          $("#" + options.attachToId + " .bwTimePicker .bwTimePickerHours li").removeClass('bwTimePickerSelected');
          $(this).addClass('bwTimePickerSelected');
          var hours = $(this).html();
          if (hours == '12' && !options.hour24) {
            hours = 0;
          }
          if (hours < 10 && options.withPadding) {
            hours = "0" + hours;
          }
          for (var i=0; i < options.hourIds.length; i++) {
            $("#" + options.hourIds[i]).val(hours);
          }
        });
        $("#" + options.attachToId + " .bwTimePicker .bwTimePickerMinutes li").click(function(){
          $("#" + options.attachToId + " .bwTimePicker .bwTimePickerMinutes li").removeClass('bwTimePickerSelected');
          $(this).addClass('bwTimePickerSelected');
          for (var i=0; i < options.minuteIds.length; i++) {
            $("#" + options.minuteIds[i]).val($(this).html());
          }
        });
        $("#" + options.attachToId + " .bwTimePicker .bwTimePickerAmPm li").click(function(){
          $("#" + options.attachToId + " .bwTimePicker .bwTimePickerAmPm li").removeClass('bwTimePickerSelected');
          $(this).addClass('bwTimePickerSelected');
          for (var i=0; i < options.ampmIds.length; i++) {
            $("#" + options.ampmIds[i]).val($(this).html());
          }
        });
      });
    });  
  };  
})(jQuery); 
