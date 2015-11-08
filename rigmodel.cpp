#include "rigmodel.h"
#include <QDebug>


cRigmodel::cRigmodel(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(addressChanged()), this, SLOT(start_client())); // установили новый адрес - вызываем функцию start_client()
    connect(this, SIGNAL(portChanged()), this, SLOT(start_client())); // установили новый порт - вызываем функцию start_client()
    connect(&tcpClient, SIGNAL(connected()),this, SLOT(clientConnected())); // Клиент приконнектилася к указанному адресу по указанному порту.
    connect(&tcpClient, SIGNAL(bytesWritten(qint64)),this, SLOT(updateClientProgress(qint64)));
    connect(&tcpClient, SIGNAL(readyRead()),this, SLOT(readData()));
    connect(&tcpClient, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(displayError(QAbstractSocket::SocketError)));

    connect(&tcpClient, SIGNAL(connected()),this, SLOT(sendData())); //при установке исходящего соединения с аппаратом посылаем текущие данные.
    //при изменении пользователем любого параметра сразу передаем данные
    connect(this, SIGNAL(lampChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(engineChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(joystickChanged()),this, SLOT(sendData()));


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

void cRigmodel::setLamp(const bool &lamp)
{
    m_lamp = lamp;
    emit lampChanged();
    qDebug()<<"Переключили лампу";
}

bool cRigmodel::lamp() const
{
    return m_lamp;
}

void cRigmodel::setEngine(const bool &engine)
{
    m_engine = engine;
    emit engineChanged();
}

bool cRigmodel::engine() const
{
    return m_engine;
}
\
void cRigmodel::setJoystick(const int &joystick)
{
    m_joystick = joystick;
    emit joystickChanged();
}

int cRigmodel::joystick() const
{
    return m_joystick;
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


bool cRigmodel::client_connected() const
{
    return m_client_connected;
}

//################################################################



void cRigmodel::start_client()
{
    bytesWritten = 0;
    qDebug()<<"Start client >>>"+this->address()+" >> "+m_address+" >> "+QString(m_port);
    
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





void cRigmodel::updateClientProgress(qint64 numBytes)
{
    // callen when the TCP client has written some bytes
    bytesWritten += (int)numBytes;
    qDebug()<<"Update client progress >>>"+::QString().number(bytesWritten);
}

void cRigmodel::displayError(QAbstractSocket::SocketError socketError)
{
    if (socketError == QTcpSocket::RemoteHostClosedError)
        return;
    qDebug()<<"Network error >>>"+tcpClient.errorString();


    tcpClient.close();

}


//##################### функция отправки данных

void cRigmodel::sendData()
{
    char data[5]={0,32,33,34,35};

    data[0] += m_lamp*1+m_engine*2;
    qDebug()<<"Отправка данных";
// проверяем, есть ли подключение клиента. Если подключения нет, то ничего не отправляем.
if (!m_client_connected) return;

// собираем данные и упаковываем в массив байтов - по текущей документации у нас 5 байт.

bytesToWrite = (int)tcpClient.write(QByteArray(data,5).toHex());
if (bytesToWrite<0)qDebug()<<"Что то пошло не так при попытке отпраки данны >>>"+tcpClient.errorString();
if (bytesToWrite>=0)qDebug()<<"Data sent>>>"+QByteArray(data,5).toHex();
}


void cRigmodel::readData()
{
    QByteArray ba = tcpClient.readAll();
    bytesReceived +=ba.length();
    qDebug()<<"Data read>>>" << ba.toHex() << " bytesReceived:" << ::QString().number(bytesReceived);

}
