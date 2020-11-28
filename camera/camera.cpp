#include "camera.h"


#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QAuthenticator>
#include <QTimer>

/*
PTZ operation command word:
0x0101:  Stop decreasing iris
0x0102:   Decrease iris
0x0103:  Stop increasing iris
0x0104:  Increase iris
0x0201:  Stop focusing near
0x0202:  Focus near
0x0203:  Stop focusing far
0x0204:  Focus far
0x0301:  Stop zooming in
0x0302:  Zoom in
0x0303:  Stop zooming out
0x0304:  Zoom out
0x0402:  Turn up
0x0404:  Turn down
0x0502:  Turn right
0x0504:  Turn left
0x0702:  Turn upper left
0x0704:  Turn lower left
0x0802:  Turn upper right
0x0804:  Turn lower right
0x0901:  Stop
0x0A01:  Wiper on
0x0A02:  Wiper off
0x0B01:  Light on
0x0B02:  Light off
0x0C01:  Heater on
0x0C02:  Heater off
0x0D01:  IR on
0x0D02:  IR off
*/


camera::camera(QObject *parent) : QObject(parent), m_networkManager(nullptr)
{
    //curl  -v --digest  -X GET --data @body.json --user Admin:hyco[123] -H "content-type: application/json"  http://192.168.1.250/LAPI/V1.0/System/DeviceInfo
    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, SIGNAL(authenticationRequired(QNetworkReply *, QAuthenticator *)),
            this, SLOT(auth(QNetworkReply *, QAuthenticator *)));
    connect(m_networkManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(finished(QNetworkReply*)));
}

camera::~camera()
{
    delete m_networkManager;
}

void camera::auth(QNetworkReply *reply, QAuthenticator *authenticator)
{
    qDebug()<<"Authentification requered "<<reply->url() << " header: "<<reply->rawHeaderList();
    QString strReply = (QString)reply->readAll();
    authenticator->setUser(m_username);
    authenticator->setPassword(m_password);
    reply->deleteLater();

}

void camera::finished(QNetworkReply *reply)
{
    reply->deleteLater();
}

void camera::focus_plus()
{
    request ("514", "Focus +");
}

void camera::focus_plus_stop()
{
    request ("513", "Stop Focus +");
}

void camera::focus_minus()
{
    request ("516", "Focus -");
}

void camera::focus_minus_stop()
{
    request ("515", "Stop Focus -");
}

void camera::zoom_plus()
{
    request ("770", "Zoom +");
}

void camera::zoom_plus_stop()
{
    request ("769", "Stop Zoom +");
}

void camera::zoom_minus()
{
    request ("772", "Zoom -");
}

void camera::zoom_minus_stop()
{
    request ("771", "Stop Zoom -");
}

void camera::IR_on()
{
    request ("3329", "IR on"); //3329
}

void camera::IR_off()
{
    request ("3330", "IR off");//3330
}


void camera::request(QString code, QString attr)
{
    QUrl serviceUrl = QUrl("http://" + m_cam_address + "/LAPI/V1.0/Channels/1/PTZ/PTZCtrl");
    QNetworkRequest request(serviceUrl);
    QJsonObject json;
    json["PTZCmd"]=code;
    json["Para1"]="1";
    json["Para2"]="1";
    json["Para3"]="0";
    QJsonDocument jsonDoc(json);
    QByteArray jsonData= jsonDoc.toJson(QJsonDocument::Compact);
    request.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");
    request.setAttribute(QNetworkRequest::User,QVariant(attr));
    m_networkManager->put(request, jsonData);
}


