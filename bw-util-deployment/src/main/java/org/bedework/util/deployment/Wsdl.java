package org.bedework.util.deployment;

import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.io.File;

import javax.xml.namespace.QName;

/** Represent a web.xml file.
 *
 * @author douglm
 */
public class Wsdl extends XmlFile {
  private final PropertiesChain props;

  public Wsdl(final Utils utils,
              final File war,
              final String wsdlName,
              final PropertiesChain props) throws Throwable {
    super(utils, war, wsdlName, false);
    this.props = props;
  }

  public void update() throws Throwable {
    utils.info("Update " + theXml.getAbsolutePath());

    replaceSoapAddressLocation();
  }

  final static String wsdlNs = "http://schemas.xmlsoap.org/wsdl/";
  final static QName qnameService = new QName(wsdlNs,
                                              "service");

  /**
   * Replace the location attribute in the following segment:
   * <pre>
   *
       <wsdl:service name="SynchRemoteService">
         <wsdl:port name="SynchRSPort" binding="tns:SynchRemoteServiceBinding">
           <soap:address location="http://10.0.11.32:8080/synchws/"></soap:address>
         </wsdl:port>
         </wsdl:service>
       </wsdl:definitions>

   * </pre>
   * @throws Throwable on xml parse error
   */
  public void replaceSoapAddressLocation() throws Throwable {
    final Element service =
            (Element)XmlUtil.getOneTaggedNode(root, "wsdl:service");

    if (service == null) {
      utils.error("Badly formed wssvc - no service element: " +
                          theXml.getAbsolutePath());
      return;
    }

    final Node port = XmlUtil.getOneTaggedNode(service, "wsdl:port");

    if (port == null) {
      utils.error("Badly formed wssvc - no port element: " +
                          theXml.getAbsolutePath());
      return;
    }

    final Node addr = XmlUtil.getOneTaggedNode(port, "soap:address");

    if (addr == null) {
      utils.error("Badly formed wssvc - no address element: " +
                          theXml.getAbsolutePath());
      return;
    }

    propsReplaceAttr((Element)addr, "location", props);
  }
}
