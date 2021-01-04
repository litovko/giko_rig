#include "c_onvif.h"
#include <QNetworkReply>

const static QMap<QString, QString> wsdlservices{
    {"device", "http://www.onvif.org/ver10/device/wsdl"},
    {"ptz", "http://www.onvif.org/ver20/ptz/wsdl"},
    {"media", "http://www.onvif.org/ver10/media/wsdl"},
    {"zoom","http://www.onvif.org/ver10/schema"},
    {"event","http://www.onvif.org/ver10/events/wsdl"},
    {"analiticsdevice","http://www.onvif.org/ver10/analyticsdevice/wsdl"},
    {"imaging","http://www.onvif.org/ver20/imaging/wsdl"}
};

c_onvif::c_onvif(QObject *parent) : QObject(parent)
{
    p_manager = new QNetworkAccessManager(this);
    connect(p_manager,&QNetworkAccessManager::finished,this,&c_onvif::finished);
    connect(p_manager,&QNetworkAccessManager::authenticationRequired,this,&c_onvif::authenticationRequired);
}

c_onvif::~c_onvif()
{
    if (!p_manager) {
        delete p_manager;
    }

}

void c_onvif::getProfiles()
{
    QString func = "GetProfiles";
    QString action ="\""+ wsdlservices["media"]+"/" +func +"\"" ;// "http://www.onvif.org/ver20/ptz/wsdl/AbsoluteMove";
    QDomDocument doc("");
    QDomElement rootNS = doc.createElementNS("http://www.w3.org/2003/05/soap-envelope", "s:Envelope");

    QDomElement body = doc.createElement("s:Body");
    body.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    body.setAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");

    QDomElement command = doc.createElementNS(wsdlservices["media"],func);
    body.appendChild(command);
    rootNS.appendChild(body);
    doc.appendChild(rootNS);
    QString message = doc.toString();
    //    qDebug()<<message;
    QNetworkRequest request;
    request.setUrl(QUrl("http://"+m_address+"/onvif/media")); //http://192.168.1.168/onvif/services
    request.setRawHeader("Content-Type",QString("application/soap+xml; charset=utf-8; action="+action).toLocal8Bit());
    p_manager->post(request,message.toUtf8());
}

void c_onvif::getProfile(const QString profile)
{
    QString func = "GetProfile";
    QString action ="\""+ wsdlservices["media"]+"/" +func +"\"" ;// "http://www.onvif.org/ver20/ptz/wsdl/AbsoluteMove";
    QDomDocument doc("");
    QDomElement rootNS = doc.createElementNS("http://www.w3.org/2003/05/soap-envelope", "s:Envelope");

    QDomElement body = doc.createElement("s:Body");
    body.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    body.setAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");

    QDomElement command = doc.createElementNS(wsdlservices["media"],func);
    body.appendChild(command);
    rootNS.appendChild(body);
    doc.appendChild(rootNS);
    addNode(doc,command,{{"ProfileToken",m_parameters["profile_token"]}}); //m_parameters["profile_token"]
    qDebug()<<m_parameters["profile_token"];
    QString message = doc.toString();
    //    qDebug()<<message;
    QNetworkRequest request;
    request.setUrl(QUrl("http://"+m_address+"/onvif/media")); //http://192.168.1.168/onvif/services
    request.setRawHeader("Content-Type",QString("application/soap+xml; charset=utf-8; action="+action).toLocal8Bit());
    p_manager->post(request,message.toUtf8());
}

bool c_onvif::getImagingSettings()
{
    QString func = "GetImagingSettings";
    QString action ="\""+ wsdlservices["imaging"]+"/" +func +"\"" ;// "http://www.onvif.org/ver20/ptz/wsdl/AbsoluteMove";
    QDomDocument doc("");
    QDomElement rootNS = doc.createElementNS("http://www.w3.org/2003/05/soap-envelope", "s:Envelope");

    QDomElement body = doc.createElement("s:Body");
    body.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    body.setAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");

    QDomElement command = doc.createElementNS(wsdlservices["imaging"],func);
    body.appendChild(command);
    rootNS.appendChild(body);
    doc.appendChild(rootNS);
    addNode(doc,command,{{"VideoSourceToken",m_parameters["Body->GetProfilesResponse->Profiles->VideoSourceConfiguration->SourceToken"]}});
    QString message = doc.toString();
    qDebug()<<"message:"<<message;
    QNetworkRequest request;
    request.setUrl(QUrl("http://192.168.1.168/onvif/imaging")); //http://192.168.1.168/onvif/services
    request.setRawHeader("Content-Type",QString("application/soap+xml; charset=utf-8; action="+action).toLocal8Bit());
    p_manager->post(request,message.toUtf8());
    return true;
}

bool c_onvif::getMoveOptions()
{
    QString func = "GetMoveOptions";
    QString action ="\""+ wsdlservices["imaging"]+"/" +func +"\"" ;// "http://www.onvif.org/ver20/ptz/wsdl/AbsoluteMove";
    QDomDocument doc("");
    QDomElement rootNS = doc.createElementNS("http://www.w3.org/2003/05/soap-envelope", "s:Envelope");

    QDomElement body = doc.createElement("s:Body");
    body.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    body.setAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");

    QDomElement command = doc.createElementNS(wsdlservices["imaging"],func);
    body.appendChild(command);
    rootNS.appendChild(body);
    doc.appendChild(rootNS);
    addNode(doc,command,{{"VideoSourceToken",m_parameters["Body->GetProfilesResponse->Profiles->VideoSourceConfiguration->SourceToken"]}});

    QString message = doc.toString();
    qDebug()<<"message:"<<message;
    QNetworkRequest request;
    request.setUrl(QUrl("http://192.168.1.168/onvif/imaging")); //http://192.168.1.168/onvif/services
    request.setRawHeader("Content-Type",QString("application/soap+xml; charset=utf-8; action="+action).toLocal8Bit());
    p_manager->post(request,message.toUtf8());
    return true;
}

bool c_onvif::setZoom(int z)
{
    QString func = "AbsoluteMove";
    QString action ="\""+ wsdlservices["ptz"]+"/" +func +"\"" ;// "http://www.onvif.org/ver20/ptz/wsdl/AbsoluteMove";
    QDomDocument doc("");
    QDomElement rootNS = doc.createElementNS("http://www.w3.org/2003/05/soap-envelope", "s:Envelope");

    QDomElement body = doc.createElement("s:Body");
    body.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    body.setAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");

    QDomElement command = doc.createElementNS(wsdlservices["ptz"],func);
    body.appendChild(command);
    rootNS.appendChild(body);
    doc.appendChild(rootNS);
    addNode(doc,command,{{"ProfileToken",m_parameters["profile_token"]}});
    QDomElement pos = doc.createElement("Position");
    QDomElement zoom = doc.createElement("Zoom");
    zoom.setAttribute( "xmlns", wsdlservices["zoom"] );
    zoom.setAttribute( "x", (z/1000.0));
    //       qDebug()<<"--------------"<<z/100.0;
    pos.appendChild(zoom);
    command.appendChild(pos);

    QString message = doc.toString();
    //    qDebug()<<message;
    QNetworkRequest request;
    request.setUrl(QUrl("http://"+m_address+"/onvif/ptz")); //http://192.168.1.168/onvif/services
    request.setRawHeader("Content-Type",QString("application/soap+xml; charset=utf-8; action="+action).toLocal8Bit());
    p_manager->post(request,message.toUtf8());
    return true;
}

bool c_onvif::startFocal(double z)
{
    QString func = "Move";
    QString action ="\""+ wsdlservices["imaging"]+"/" +func +"\"" ;// "http://www.onvif.org/ver20/ptz/wsdl/AbsoluteMove";
    QDomDocument doc("");
    QDomElement rootNS = doc.createElementNS("http://www.w3.org/2003/05/soap-envelope", "s:Envelope");

    QDomElement body = doc.createElement("s:Body");
    body.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    body.setAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");

    QDomElement command = doc.createElementNS(wsdlservices["imaging"],func);
    body.appendChild(command);
    rootNS.appendChild(body);
    doc.appendChild(rootNS);
    addNode(doc,command,{{"VideoSourceToken",m_parameters["Body->GetProfilesResponse->Profiles->VideoSourceConfiguration->SourceToken"]}});
    QDomElement op = doc.createElement("Focus");
    QDomElement movetype = doc.createElement("Continuous"); //NOTE Только непрерывная фокусировка
    movetype.setAttribute( "xmlns", wsdlservices["zoom"] );
    QDomElement pos = doc.createElement("Speed");
    pos.appendChild(doc.createTextNode(QString::number(z)));
    op.appendChild(movetype);
    movetype.appendChild(pos);
    command.appendChild(op);
    QString message = doc.toString();
//    qDebug()<<message;
    QNetworkRequest request;
    request.setUrl(QUrl("http://"+m_address+"/onvif/imaging"));
    request.setRawHeader("Content-Type",QString("application/soap+xml; charset=utf-8; action="+action).toLocal8Bit());
    p_manager->post(request,message.toUtf8());
    return true;
}

bool c_onvif::stopFocal()
{
    QString func = "FocusStop";
    QString action ="\""+ wsdlservices["imaging"]+"/" +func +"\"" ;// "http://www.onvif.org/ver20/ptz/wsdl/AbsoluteMove";
    QDomDocument doc("");
    QDomElement rootNS = doc.createElementNS("http://www.w3.org/2003/05/soap-envelope", "s:Envelope");

    QDomElement body = doc.createElement("s:Body");
    body.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
    body.setAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");

    QDomElement command = doc.createElementNS(wsdlservices["imaging"],"Stop");
    body.appendChild(command);
    rootNS.appendChild(body);
    doc.appendChild(rootNS);
    addNode(doc,command,{{"VideoSourceToken",m_parameters["Body->GetProfilesResponse->Profiles->VideoSourceConfiguration->SourceToken"]}});

    QString message = doc.toString();
//    qDebug()<<message;
    QNetworkRequest request;
    request.setUrl(QUrl("http://"+m_address+"/onvif/imaging"));
    request.setRawHeader("Content-Type",QString("application/soap+xml; charset=utf-8; action="+action).toLocal8Bit());
    p_manager->post(request,message.toUtf8());
    return true;
}

void c_onvif::finished(QNetworkReply *reply)
{
    if(reply->error() == QNetworkReply::NoError || reply->error() == QNetworkReply::InternalServerError)
    { readMessage(reply->readAll(), reply->request().header(QNetworkRequest::ContentTypeHeader));
        //        qDebug()<<"reply header:"<<reply->request().header(QNetworkRequest::ContentTypeHeader);
//        print_params();
    }
    else {
        //        qDebug()<<"reply header:"<<reply->request().header(QNetworkRequest::ContentTypeHeader);
        emit error(reply->errorString());
    }
    reply->deleteLater();
}

void c_onvif::authenticationRequired(QNetworkReply *reply, QAuthenticator *authenticator)
{
    Q_UNUSED(reply)
    //    qDebug()<<"auth required";
    authenticator->setUser(m_user);
    authenticator->setPassword(m_password);
}

void c_onvif::readMessage(const QByteArray &data, const QVariant action)
{
//        qDebug()<<"readMessage";
//        qDebug()<<data;
    //    qDebug()<<action;
    QDomDocument doc("");
    QString errorString;
    int errorLine;
    int errorCol;
    QString header;
    if (action.isNull())
        header="";
    else {
        header= action.toString();
    }
    if(!doc.setContent(data,true,&errorString,&errorLine,&errorCol)) {
        emit error(QString("XMP parse error: %1 at line %2 column %3")
                   .arg(errorString)
                   .arg(errorLine)
                   .arg(errorCol));
        qDebug()<<(QString("XMP parse error: %1 at line %2 column %3")
                           .arg(errorString)
                           .arg(errorLine)
                           .arg(errorCol));
        return;
    }
    QDomElement root = doc.documentElement();
    if(root.localName() == "Envelope") {
        for(QDomNode node = root.firstChild(); !node.isNull(); node = node.nextSibling()) {
            if(node.localName() == "Body") {
                if(node.firstChild().localName() == "Fault")
                    parseError(node.firstChild());
                else
                {
                    emit messageReceived(getNode(node));
                    process_params("", node);
                    process_resp_profile(header, node);
                }
            }
        }
    }

}

void c_onvif::addNode(QDomDocument &doc, QDomElement &parent, const QVariantMap &arguments)
{
    QMapIterator<QString, QVariant> i(arguments);
    while (i.hasNext()) {
        i.next();
        QDomElement node = doc.createElement(i.key());
        if(i.value().type() == QVariant::Map)
            addNode(doc,node,i.value().toMap());
        else {
            QDomText text = doc.createTextNode(i.value().toString());
            node.appendChild(text);
        }
        parent.appendChild(node);
    }
}

QVariantMap c_onvif::getNode(QDomNode &root)
{
    QVariantMap map;
    for(QDomNode node = root.firstChild(); !node.isNull(); node = node.nextSibling()) {
        QString name = node.localName();
        if(node.firstChild().isText()) {
            map.insert(name,node.toElement().text());
        } else {
            map.insert(name, getNode(node));
        }
    }
    return map;
}

void c_onvif::parseError(QDomNode root)
{
    QString errorCode;
    QString errorSubCode;
    QString errorReason;

    for(QDomNode node = root.firstChild(); !node.isNull(); node = node.nextSibling()) {
        if(node.localName() == "Code") {
            QDomNode value = findNode(node,"Value");
            if(!value.isNull())
                errorCode = value.toElement().text();
            value = findNode(node,"Subcode");
            if(!value.isNull()) {
                value = findNode(value,"value");
                if(!value.isNull())
                    errorSubCode = value.toElement().text();
            }
        } else if(node.localName() == "Reason") {
            QDomNode value = findNode(node,"Text");
            if(!value.isNull()) {
                errorReason = value.toElement().text();
            }
        }
    }
    emit error("Soap error (code: " + errorCode + (errorSubCode.isEmpty() ? "" : ",subcode: " + errorSubCode) + ",reason: " + errorReason + ")");
}

QDomNode c_onvif::findNode(QDomNode &parent, const QString &name)
{
    for(QDomNode node = parent.firstChild(); !node.isNull(); node = node.nextSibling()) {
        if(node.localName() == name)
            return node;
    }
    return QDomNode();
}

void c_onvif::process_params(const QString func, QDomNode node)
{
    //    qDebug()<<"==process==";
    int i=1;
    while (!node.isNull()) {
        //        qDebug()<< func << i;
        i++;
        if (node.isElement()) {
            QDomElement e = node.toElement();
//            qDebug()<< func << "Element name: "<< e.tagName()<<"v:"<<e.text()<<"type:"<<e.nodeType()<< "hasChild:"<<e.hasChildNodes();

            //            qDebug()<< func<<node.localName()<<"hasAttributes="<<node.hasAttributes();
            if (node.hasAttributes()) {
                QDomNamedNodeMap map=node.attributes();
                for(auto i=0; i<map.count(); i++) {
                    QDomNode ni = map.item(i);
                    QDomAttr el = ni.toAttr();
                    //                    qDebug()<< func << "attr:"<<el.name()<<"="<<el.value();
                    m_parameters[func+"->attr_"+el.name()] =  el.value();
                }

            }
            if (node.hasChildNodes()) {
                QDomNode node1=node.firstChild();
                if (node1.isText()){
                    //                    qDebug()<<func<<"Name:"<<e.tagName()<<":"<<node1.toText().data();
                    m_parameters[(func==""?"":(func+"->"))+e.tagName()] =  node1.toText().data();
                }
                else
                    process_params((func==""?"":(func+"->"))+e.tagName(), node1);
            }
        }
        //        else
        //           if (node.isText())
        //            qDebug()<< func <<"type:"<<node.nodeType()<<"nodeText:"<< node.toText().data();
        //        qDebug()<<func<<"Siblings";
        node = node.nextSibling();
    }


}

void c_onvif::process_resp_profile(const QString func, QDomNode node)
{
    //    qDebug()<<"==resp==";
    //    qDebug()<<"func:"<<func;
    //    qDebug()<<"Node:"<< node.nodeName();
    QDomElement e=node.firstChildElement("GetProfilesResponse");
    //    qDebug()<<"Node name:"<<e.nodeName()<<"  "<<e.tagName();
    e=e.firstChildElement("Profiles");
    //    qDebug()<<"Node name:"<<e.nodeName()<<"  "<<e.tagName();
    QDomNamedNodeMap m=e.attributes();
    for (int i=0; i<m.count();i++){
        //        qDebug()<<i<<":"<<m.item(i).nodeName()<<"="<<m.item(i).toAttr().value();
        m_parameters["profile_"+m.item(i).toAttr().name()] =  m.item(i).toAttr().value();
    }
}

void c_onvif::print_params()
{
    qDebug()<<"==All=params==";
    foreach(QString el, m_parameters.keys()) qDebug() <<"==>> "<<el<<":"<< m_parameters[el];
}
