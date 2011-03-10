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
package edu.rpi.cmt.calendar.diff;

import edu.rpi.sss.util.xml.NsContext;
import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import org.apache.log4j.Logger;

import ietf.params.xml.ns.icalendar_2.BaseComponentType;
import ietf.params.xml.ns.icalendar_2.BaseParameterType;
import ietf.params.xml.ns.icalendar_2.BasePropertyType;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import javax.xml.namespace.QName;

/** This class compares 2 components.
*
* @author Mike Douglass
*/
public class XmlIcalCompare {
  private boolean debug;

  protected transient Logger log;

  List<BaseEntityWrapper> updates;

  private NsContext nsContext;

  /**
   * @param nsContext required for path generation.
   */
  public XmlIcalCompare(final NsContext nsContext) {
    this.nsContext = nsContext;
  }

  /** Compare the parameters. Set up a diff list.
   *
   * @param val1
   * @param val2
   * @return true if val1 and val2 differ.
   */
  public boolean differ(final BaseComponentType val1,
                        final BaseComponentType val2) {
    debug = getLogger().isDebugEnabled();

    CompWrapper cw1 = new CompWrapper(null,
                                      CompWrapper.compNames.get(val1.getClass()), val1);
    CompWrapper cw2 = new CompWrapper(null,
                                      CompWrapper.compNames.get(val2.getClass()), val2);

    if (debug) {
      trace("cw1=" + cw1);
      trace("cw2=" + cw2);
    }

    updates = cw1.diff(cw2);

    boolean differs = updates.size() > 0;

    if (debug) {
      trace("Compared and differs = " + differs);
    }

    if (!differs) {
      return false;
    }

    // cw2 differs from cw1 in the props and/or the components.

    if (debug) {
      for (BaseEntityWrapper bw: updates) {
        if (debug) {
          trace(bw.toString());
        }
      }
    }

    return true;
  }

  /**
   * @author douglm
   *
   */
  public static class XpathUpdate {
    /** */
    private String xpath;

    private QName name;

    /** true to delete named element */
    public boolean delete;

    /** true to add value to named element */
    public boolean add;

    // otherwise it's update named element with value

    // Value is one of the following

    private BaseParameterType baseParameter;
    private BasePropertyType baseProperty;
    private BaseComponentType baseComponent;

    /**
     * Gets the value of the xpath.
     *
     * @return String xpath selector
     */
    public String getXpath() {
      return xpath;
    }

    /**
     * @return name of element
     */
    public QName getName() {
      return name;
    }

    /**
     * Sets the value of the baseParameter property.
     *
     * @param val
     */
    public void setBaseParameter(final BaseParameterType val) {
      baseParameter = val;
    }

    /**
     * @return baseParameter or null
     */
    public BaseParameterType getBaseParameter() {
      return baseParameter;
    }

    /**
     * Sets the value of the baseProperty property.
     *
     * @param val
     */
    public void setBaseProperty(final BasePropertyType val) {
      baseProperty = val;
    }

    /**
     * Gets the value of the baseProperty property.
     *
     * @return baseProperty or null
     */
    public BasePropertyType getBaseProperty() {
      return baseProperty;
    }

    /**
     * Sets the value of the baseComponent property.
     *
     * @param val
     */
    public void setBaseComponent(final BaseComponentType val) {
      baseComponent = val;
    }

    /**
     * Gets the value of the baseComponent property.
     *
     * @return baseComponent or null
     */
    public BaseComponentType getBaseComponent() {
      return baseComponent;
    }

    @Override
    public String toString() {
      StringBuilder sb = new StringBuilder("XpathUpdate");

      sb.append("xpath=");
      sb.append(xpath);

      if (add) {
        sb.append(", add");
      } else if (delete) {
        sb.append(", delete");
      }

      if (getBaseComponent() != null){
        sb.append(getBaseComponent());
      }

      if (getBaseProperty() != null){
        sb.append(getBaseProperty());
      }

      if (getBaseParameter() != null){
        sb.append(getBaseParameter());
      }

      return sb.toString();
    }
  }

  /**
   * @return List of updates
   */
  public List<XpathUpdate> getUpdates() {
    List<XpathUpdate> upds = new ArrayList<XpathUpdate>();

    for (BaseEntityWrapper bw: updates) {
      XpathUpdate upd = makeUpdate(bw);

      if (debug) {
        trace(upd.toString());
      }

      upds.add(upd);
    }

    return upds;
  }

  /*   We select the outer vcalendar is we wish to add a component
   *
   *   We select a component if we wish to add a property or a component to that
   *   component or if we wish to delete that component
   *
   *   We select a property to change it's parameters or it's value or delete it. The
   *   value can be a parameter to add, a new value for the property or nothing to delete
   *
   *   We select a parameter to delete it or change its value. The value is a value-type
   *  element
   */
  private XpathUpdate makeUpdate(final BaseEntityWrapper be) {
    Stack<BaseWrapper> els = new Stack<BaseWrapper>();

    BaseWrapper b = be;
    while (b != null) {
      els.push(b);
      b = b.getParent();
    }

    // Unstack and build path
    StringBuilder sb = new StringBuilder("/");
    nsContext.appendNsName(sb, XcalTags.icalendar);

    while (!els.empty()) {
      b = els.pop();

      if (b == be) {
        // This is parameter
        if (be.getAdd()) {
          //Par is the value
          break;
        }

        if (be.getDelete()) {
          sb.append("/");
          b.appendNsName(sb, nsContext);
          break;
        }
      }

      sb.append("/");
      b.appendXpathElement(sb, nsContext);
    }

    XpathUpdate upd = new XpathUpdate();

    upd.xpath = sb.toString();
    upd.add = be.getAdd();
    upd.delete = be.getDelete();

    if (!upd.delete) {
      Object newEntity;

      if (upd.add) {
        newEntity = be.getEntity();
      } else {
        newEntity = be.getDiffVal().getEntity();
      }

      if (newEntity instanceof BaseComponentType){
        upd.setBaseComponent((BaseComponentType)newEntity);
      }

      if (newEntity instanceof BasePropertyType){
        upd.setBaseProperty((BasePropertyType)newEntity);
      }

      if (newEntity instanceof BaseParameterType){
        upd.setBaseParameter((BaseParameterType)newEntity);
      }
    }

    return upd;
  }

  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void trace(final String msg) {
    getLogger().debug(msg);
  }
}
