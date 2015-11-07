#include "rigmodel.h"
#include <QDebug>


cRigmodel::cRigmodel(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(addressChanged()), this, SLOT(start_client())); // установили новый адрес - вызываем функцию start_clietn()
    connect(this, SIGNAL(portChanged()), this, SLOT(start_client())); // установили новый порт - вызываем функцию start_clietn()
    connect(&tcpServer, SIGNAL(newConnection()),this, SLOT(acceptConnection())); // получен новый коннект к серверу (пришел клиент)
    connect(&tcpClient, SIGNAL(connected()),this, SLOT(clientConnected())); // Клиент приконнектилася к указанному адресу по указанному порту.
    connect(&tcpClient, SIGNAL(bytesWritten(qint64)),this, SLOT(updateClientProgress(qint64)));
    connect(&tcpClient, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(displayError(QAbstractSocket::SocketError)));

    tcpServer.listen(QHostAddress(m_address),m_port);
    m_server_ready = true;
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

int cRigmodel::port() const
{
    return m_port;
}

void cRigmodel::setPort(const int  &port)
{
    m_port = port;
    emit portChanged();
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
    qDebug()<<"Start client >>>"+this->address()+" >> "+m_address+" >> "+m_port;
    
    tcpClient.connectToHost(m_address, m_port);
}
void cRigmodel::clientConnected()
{
    qDebug()<<"Client connect to address >>>"+this->address()+" port:"+ this->port();
    m_client_connected=true;
}
void cRigmodel::clientDisconnected()
{
    qDebug()<<"Client disconnected form address >>>"+this->address()+" port:"+ this->port();
    m_client_connected=false;
}

//Функция работает по сигналу прихода нового клиента к серверу.
void cRigmodel::acceptConnection()
{
    tcpServerConnection = tcpServer.nextPendingConnection();

    connect(tcpServerConnection, SIGNAL(readyRead()),
            this, SLOT(updateServerProgress()));
    connect(tcpServerConnection, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(displayError(QAbstractSocket::SocketError)));

    qDebug()<<"Accepted connection >>>"+tcpServerConnection->peerAddress().toString();
    //serverStatusLabel->setText(tr("Accepted connection"));
    m_server_connected = true;
    tcpServer.close(); //выключаем листенер - одной коннеции достаточно.
    m_server_ready=false;
}



void cRigmodel::updateClientProgress(qint64 numBytes)
{
    // callen when the TCP client has written some bytes
    bytesWritten += (int)numBytes;
    qDebug()<<"Update client progress >>>"+numBytes;
    // only write more if not finished and when the Qt write buffer is below a certain size.
    if (bytesToWrite > 0 && tcpClient.bytesToWrite() <= 100)
        bytesToWrite -= (int)tcpClient.write(QByteArray(qMin(bytesToWrite, 100), '@'));

}
void cRigmodel::updateServerProgress()
{
    bytesReceived += (int)tcpServerConnection->bytesAvailable();
    tcpServerConnection->readAll();
     qDebug()<<"Server progress bytes received >>>"+bytesReceived;


}
void cRigmodel::displayError(QAbstractSocket::SocketError socketError)
{
    if (socketError == QTcpSocket::RemoteHostClosedError)
        return;
    qDebug()<<"Network error >>>"+tcpClient.errorString();


    tcpClient.close();
    tcpServer.close();
}
