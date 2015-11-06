#include "rigmodel.h"
#include <QDebug>


cRigmodel::cRigmodel(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(addressChanged()), this, SLOT(start_client())); // установили новый адрес - вызываем функцию start()
    connect(&tcpServer, SIGNAL(newConnection()),this, SLOT(acceptConnection())); // новый коннект к серверу
}

void cRigmodel::setPressure(const int &pressure)
{
    m_pressure = pressure;
    emit pressureChanged();
}

int cRigmodel::pressure() const
{
    return m_pressure;
}

void cRigmodel::setOiltemp(const int &oiltemp)
{
    m_oiltemp = oiltemp;
    emit oiltempChanged();
}

int cRigmodel::oiltemp() const
{
    return m_oiltemp;
}


void cRigmodel::setAddress(const QString  &address)
{
    m_address = address;
    emit addressChanged();
}

QString cRigmodel::address() const
{
    return m_address;
}

bool cRigmodel::server_ready() const
{
    return m_server_ready;
}

bool cRigmodel::client_connected() const
{
    return m_client_connected;
}
bool cRigmodel::server_connected() const
{
    return m_server_connected;
}
//################################################################
// Функция работает по сигналу узменения адреса сервера.
void cRigmodel::start_server()
{

    bytesReceived = 0;
    QString st=tcpServer.isListening()?"yes":"no";
    qDebug()<<"Start "+this->address()+ " is listening==" + st ;
    while (!tcpServer.isListening() && !tcpServer.listen()) {
        qDebug()<<"не включается листенер";
            return;
    }
    st=tcpServer.isListening()?"yes":"no";
    qDebug()<<"Start "+this->address()+ " is listening==" + st ;
    m_server_ready = true;

}

void cRigmodel::start_client()
{
    bytesWritten = 0;
    qDebug()<<"Start client >>>"+this->address();
    tcpClient.connectToHost(address(), tcpServer.serverPort());
}
//Функция работает по сигналу прихода нового клиента к серверу.
void cRigmodel::acceptConnection()
{
    tcpServerConnection = tcpServer.nextPendingConnection();
//    connect(tcpServerConnection, SIGNAL(readyRead()),
//            this, SLOT(updateServerProgress()));
//    connect(tcpServerConnection, SIGNAL(error(QAbstractSocket::SocketError)),
//            this, SLOT(displayError(QAbstractSocket::SocketError)));

    //serverStatusLabel->setText(tr("Accepted connection"));
    m_server_connected = true;
    tcpServer.close(); //выключаем листенер - одной коннеции достаточно.
    m_server_ready=false;
}
