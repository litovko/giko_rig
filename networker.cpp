#include "networker.h"
#include <QDebug>
#include <QCoreApplication>
#include <QJsonArray>
#include <QJsonDocument>
cNetworker::cNetworker(QObject *parent) : QObject(parent)
{
    qDebug()<<"init networker";
    readSettings();

    connect(this, SIGNAL(addressChanged()), this, SLOT(saveSettings()));
    connect(this, SIGNAL(timer_send_intervalChanged()), this, SLOT(updateSendTimer()));

    connect(&tcpClient, SIGNAL(connected()),this, SLOT(deviceConnected())); // Клиент приконнектилася к указанному адресу по указанному порту.
    connect(&tcpClient, SIGNAL(disconnected()),this, SLOT(deviceDisconnected())); // Клиент отвалился
    connect(&tcpClient, SIGNAL(readyRead()),this, SLOT(readData()));
    connect(&tcpClient, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(displayError(QAbstractSocket::SocketError)));

    connect(&timer_connect, SIGNAL(timeout()), this, SLOT(start_client()));
    QTimer::singleShot(1000, this, SLOT(start_client())); //конектимся через 1 секунду после запуска программы
    timer_connect.start(m_timer_connect_interval);

    connect(&timer_send, SIGNAL(timeout()), this, SLOT(sendData()));
    timer_send.start(m_timer_send_interval);
}

void cNetworker::reg(cRigmodel *rig)
{
    m_boards.append(rig);
    qDebug()<<"Registered rig board: "<<rig->board();
    connect(rig, SIGNAL(dataChanged()),this, SLOT(sendData()));
}

void cNetworker::start_client()
{
    if (m_client_connected) return;
    if (tcpClient.state()) {
        qDebug()<<"tcpstate:"<<tcpClient.state();
        return;
    }
    qDebug()<<"Rig trying to connect to >>>"<<address()<<"poprt"<<::QString().number( port() );

    tcpClient.connectToHost(address(), m_port);
}

void cNetworker::updateSendTimer()
{
    timer_send.start(m_timer_send_interval);
}

void cNetworker::deviceConnected()
{
    qDebug()<<"Rig Client connected to >>>"+this->address()+" port:"+ ::QString().number(port());
    setClient_connected(true);
}

void cNetworker::deviceDisconnected()
{
    qDebug()<<"Rig Client disconnected form >>>"+this->address()+" port:"+ QString::number(port());
    setClient_connected(false);
}

void cNetworker::saveSettings()
{
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("network");
    qDebug()<<"save network settings : "<<settings.organizationName()<<" "<<settings.applicationName()<<" "<<settings.group();
    settings.setValue("RigAddress",address());
    settings.setValue("RigPort",port());
    settings.setValue("RigSendInterval",timer_send_interval());
    settings.setValue("RigConnectInterval",timer_connect_interval());
    settings.endGroup();
}

void cNetworker::readSettings()
{
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("network");
    setAddress(settings.value("RigAddress","localhost").toString());
    setPort(static_cast<quint16>(settings.value("RigPort","1212").toUInt()));
    setTimer_send_interval(settings.value("RigSendInterval","2000").toInt());
    if (timer_send_interval()<50) setTimer_send_interval(50);
    setTimer_connect_interval(settings.value("RigConnectInterval","30000").toInt());
}

void cNetworker::displayError(QAbstractSocket::SocketError socketError)
{

}

void cNetworker::sendData()
{
    if (!m_client_connected) return;
    QJsonArray arr;
    foreach (auto e, m_boards)
        arr.append(e->getData());
    QJsonDocument doc;
    doc.setArray(arr);
    int bytesToWrite = static_cast<int>(tcpClient.write(doc.toJson(QJsonDocument::Indented)));
    if (bytesToWrite<0)qWarning()<<"Rig: Something wrong on sending data >>>"+tcpClient.errorString();
    if (bytesToWrite>=0)qDebug()<<"sent:"<<doc.toJson(QJsonDocument::Compact)<<" len:"<<::QString().number(bytesToWrite);
}

void cNetworker::readData()
{
    QByteArray jdata=tcpClient.readAll();
    //jdata ="[{%_dev%:0,%type%:%npa__%,%dc1v%:114,%dc2v%:0,%toil%:70,%toi2%:0,%temp%:0,%humi%:0,%poil%:33,%poi2%:44,%pwrv%:0,%pwv2%:0,%pwv3%:0,%vchs%:0,%pwra%:100,%pwa2%:0,%pwa3%:0,%leak%:0,%tang%:3,%kren%:1,%azmt%:-5,%spxy%:65487,%drpm%:0}]";
    //[{"_dev":0,"type":"npa__","dc1v":114,"dc2v":0,"toil":-100,"toi2":0,"temp":0,"humi":0,"poil":0,"poi2":0,"pwrv":0,"pwv2":0,"pwv3":0,"vchs":0,"pwra":0,"pwa2":0,"pwa3":0,"leak":0,"tang":3,"kren":1,"azmt":0,"spxy":65487,"drpm":0}]
    //jdata=jdata.replace("%","\"");
    //qDebug()<<"json:"<<jdata;
    QJsonDocument doc=QJsonDocument::fromJson(jdata);
    QJsonArray arr = doc.array();
    if (!doc.isArray()) {
        qWarning()<<"Wrong data from controller";
        setGood_data(false);
        return;
    }
    foreach(const QJsonValue & el, arr) {
        //qDebug()<<"dev"<<el["_dev"].toInt();
        int _device=el["_dev"].toInt(-1);
        foreach(auto *rm, m_boards)
          if ( rm->board()==_device) rm->readData(el);
    }
}

void cNetworker::reconnect()
{
    qDebug()<<"reconnect";
    tcpClient.disconnectFromHost();
    tcpClient.close();
    tcpClient.abort();
    setClient_connected(false);
    QTimer::singleShot(2000, this, SLOT(start_client())); //конектимся через 2 секунды после выполнения конструктора
}

bool cNetworker::good_data() const
{
    return m_good_data;
}

void cNetworker::setGood_data(bool good_data)
{
    m_good_data = good_data;
    emit good_dataChanged();
}

int cNetworker::timer_connect_interval() const
{
    return m_timer_connect_interval;
}

void cNetworker::setTimer_connect_interval(int timer_connect_interval)
{
    m_timer_connect_interval = timer_connect_interval;
}

int cNetworker::timer_send_interval() const
{
    return m_timer_send_interval;
}

void cNetworker::setTimer_send_interval(int timer_send_interval)
{
    m_timer_send_interval = timer_send_interval;
}

bool cNetworker::client_connected() const
{
    return m_client_connected;
}

void cNetworker::setClient_connected(bool client_connected)
{
    m_client_connected = client_connected;
    emit client_connectedChanged();
}

quint16 cNetworker::port() const
{
    return m_port;
}

void cNetworker::setPort(const quint16 &port)
{
    m_port = port;
    emit portChanged();
}

QString cNetworker::address() const
{
    return m_address;
}

void cNetworker::setAddress(const QString &address)
{
    m_address = address;
    emit addressChanged();
}


