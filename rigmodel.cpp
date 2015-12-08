#include "rigmodel.h"
#include <QDebug>
#include <QTime>


cRigmodel::cRigmodel(QObject *parent) : QObject(parent)
{
    readSettings();
    connect(this, SIGNAL(addressChanged()), this, SLOT(saveSettings()));
    //connect(this, SIGNAL(portChanged()), this, SLOT(saveSettings()));
    connect(&tcpClient, SIGNAL(connected()),this, SLOT(clientConnected())); // Клиент приконнектилася к указанному адресу по указанному порту.
    connect(&tcpClient, SIGNAL(disconnected()),this, SLOT(clientDisconnected())); // Клиент отвалился
    connect(&tcpClient, SIGNAL(bytesWritten(qint64)),this, SLOT(updateClientProgress(qint64)));
    connect(&tcpClient, SIGNAL(readyRead()),this, SLOT(readData()));
    connect(&tcpClient, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(displayError(QAbstractSocket::SocketError)));

    connect(&tcpClient, SIGNAL(connected()),this, SLOT(sendData())); //при установке исходящего соединения с аппаратом посылаем текущие данные.
    //при изменении пользователем любого параметра сразу передаем данные
    connect(this, SIGNAL(lampChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(engineChanged()),this, SLOT(sendData()));
    //connect(this, SIGNAL(joystickChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(cameraChanged()),this, SLOT(sendData()));

    connect(&timer_connect, SIGNAL(timeout()), this, SLOT(start_client()));
    timer_connect.start(m_timer_connect_interval);
    connect(&timer_send, SIGNAL(timeout()), this, SLOT(sendData()));
    timer_send.start(m_timer_send_interval);
}
void cRigmodel::saveSettings()
{
    qDebug()<<"saveSettings addres:"<<m_address<<"port:"<<m_port;
    QSettings settings("HYCO", "Rig Console");
    settings.setValue("RigAddress",m_address);
    settings.setValue("RigPort",m_port);
    settings.setValue("RigSendInterval",m_timer_send_interval);
    settings.setValue("RigConnectInterval",m_timer_connect_interval);

}

void cRigmodel::readSettings()
{

    QSettings settings("HYCO", "Rig Console");
    m_address=settings.value("RigAddress","localhost").toString();
    m_port=settings.value("RigPort","1212").toInt();
    m_timer_send_interval=settings.value("RigSendInterval","2000").toInt();
    m_timer_connect_interval=settings.value("RigConnectInterval","30000").toInt();
//    qDebug()<<"readSettings addres:"<<m_address<<"port:"<<m_port;
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


void cRigmodel::setVoltage(const int &voltage)
{
    m_voltage = voltage;
    emit voltageChanged();
}

int cRigmodel::voltage() const
{
    return m_voltage;
}

void cRigmodel::setAmpere(const int &ampere)
{
    m_ampere = ampere;
    emit ampereChanged();
}

int cRigmodel::ampere() const
{
    return m_ampere;
}

void cRigmodel::setTurns(const int &turns)
{
    m_turns = turns;
    emit turnsChanged();
}

int cRigmodel::turns() const
{
    return m_turns;
}

void cRigmodel::setTemperature(const int &temperature)
{
    m_temperature = temperature;
    emit temperatureChanged();
}

int cRigmodel::temperature() const
{
    return m_temperature;
}

void cRigmodel::setRigtype(const QString &rigtype)
{
    m_rigtype = rigtype;
    emit rigtypeChanged();
}

QString cRigmodel::rigtype() const
{
    return m_rigtype;
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

void cRigmodel::setCamera(const bool &camera)
{
    m_camera = camera;
    emit cameraChanged();
    qDebug()<<"Переключили питание камер";
}

bool cRigmodel::camera() const
{
    return m_camera;
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

int cRigmodel::timer_send_interval() const
{
    return m_timer_send_interval;
}

void cRigmodel::setTimer_send_interval(const int  &timer_send_interval)
{
    m_timer_send_interval = timer_send_interval;
    emit timer_send_intervalChanged();
}

int cRigmodel::timer_connect_interval() const
{
    return m_timer_connect_interval;
}

void cRigmodel::setTimer_connect_interval(const int  &timer_connect_interval)
{
    m_timer_connect_interval = timer_connect_interval;
    emit timer_connect_intervalChanged();
}

bool cRigmodel::client_connected() const
{
    return m_client_connected;
}

bool cRigmodel::good_data() const
{
    return m_good_data;
}


//################################################################



void cRigmodel::start_client()
{
    QTime t;
    if (m_client_connected) return;
    bytesWritten = 0;
    qDebug()<<"Start client >>>"<<m_address<<"poprt"<<::QString().number(m_port)<<t.currentTime();;
    
    tcpClient.connectToHost(m_address, m_port);

}
void cRigmodel::clientConnected()
{
    qDebug()<<"Client connected to address >>>"+this->address()+" port:"+ ::QString().number(m_port);
    m_client_connected=true;
    emit client_connectedChanged();
}
void cRigmodel::clientDisconnected()
{
    qDebug()<<"Client disconnected form address >>>"+this->address()+" port:"+ this->port();
    m_client_connected=false;
    m_good_data=false;
    m_pressure=0;
    m_oiltemp=0;
    m_voltage=0;
    m_ampere=0;
    m_turns=0;
    m_temperature=0;
    emit pressureChanged();
    emit oiltempChanged();
    emit voltageChanged();
    emit ampereChanged();
    emit turnsChanged();
    emit temperatureChanged();
    emit client_connectedChanged();
    emit good_dataChanged();
}





void cRigmodel::updateClientProgress(qint64 numBytes)
{
    // callen when the TCP client has written some bytes
    bytesWritten += (int)numBytes;
    //qDebug()<<"Update client progress >>>"+::QString().number(bytesWritten);
}

void cRigmodel::displayError(QAbstractSocket::SocketError socketError)
{
    if (socketError == QTcpSocket::RemoteHostClosedError)   //litovko надо уточнить зачем эта проверка
        return;
    qDebug()<<"Network error >>>"+tcpClient.errorString();


    tcpClient.close();

}


//##################### функция отправки данных

void cRigmodel::sendData()
{
    char data[5]={0,32,33,34,35};
    data[0] = m_lamp*4+m_engine*1+m_camera*8;
    QString Data; // Строка отправки данных.

// проверяем, есть ли подключение клиента. Если подключения нет, то ничего не отправляем.
    if (!m_client_connected) return;
    Data="{ana1:"+::QString().number(int(m_joystick*127/100),10)+";dig1:"+::QString().number(data[0],10)+"}FEDCA987";
    qDebug()<<"Отправка данных"<<Data;
    //qDebug()<<"Joystik:"<<::QString().number(m_joystick,10);
    bytesToWrite = (int)tcpClient.write(::QByteArray(Data.toLatin1()).data());
    if (bytesToWrite<0)qDebug()<<"Что то пошло не так при попытке отпраки данны >>>"+tcpClient.errorString();
    if (bytesToWrite>=0)qDebug()<<"Data sent>>>"<<Data<<":"<<::QString().number(bytesToWrite);
}


void cRigmodel::readData()
{

    QByteArray Data="";
    QString CRC ="";
    QList<QByteArray> split;
    int m;
    Data = tcpClient.readAll();
    qDebug()<<"read :"<<Data;

    // надо распрасить строчку
    // {toil=29;poil=70;drpm=15;pwrv=33;pwra=3}FAFBFCFD
    // проверяем на наличие {}
    m_good_data = false; emit good_dataChanged();
    if (Data.startsWith("{")&&(m=Data.indexOf("}"))>0) {
        m_good_data = true; emit good_dataChanged();
        CRC=Data.mid(m+1);
        qDebug()<<"CRC:"<<CRC; //CRC пока не проверяем - это отдельная тема.
        Data=Data.mid(1,m-1);
        qDebug()<<"truncated :"<<Data;
        split=Data.split(';');
        qDebug()<<"split:"<<split;
        QListIterator<QByteArray> i(split);
        QByteArray s, val;
        bool ok=false;
        while (i.hasNext()){
             s=i.next();
             m=s.indexOf(":");
             val=s.mid(m+1); //данные после ":"
             s=s.left(m); // названия тэга
            qDebug()<<"tag:"<<s<<"value:"<<val;
            if (s=="toil") {
                m_temperature=val.toInt(&ok,10); emit temperatureChanged();
                if(!ok) {m_good_data = false; emit good_dataChanged();}
            }
            if (s=="poil"){
                m_pressure=val.toInt(&ok,10); emit pressureChanged();
                if(!ok) {m_good_data = false; emit good_dataChanged();}
            }
            if (s=="drpm"){
                m_turns=val.toInt(&ok,10); emit turnsChanged();
                if(!ok) {m_good_data = false; emit good_dataChanged();}
            }
            if (s=="pwrv"){
                m_voltage=val.toInt(&ok,10); emit voltageChanged();
                if(!ok) {m_good_data = false; emit good_dataChanged();}
            }
            if (s=="pwra"){
                m_ampere=val.toInt(&ok,10); emit ampereChanged();
                if(!ok) {m_good_data = false; emit good_dataChanged();}
            }
            if (s=="type"){
                m_rigtype=val; emit rigtypeChanged();
                if (m_rigtype=="grab2"||m_rigtype=="grab6"||m_rigtype=="gkgbu"||m_rigtype=="tk-15") ok=true;
                if(!ok) {m_good_data = false; emit good_dataChanged();}
            }
         }
    }
    else {
        m_good_data=false; good_dataChanged();
    }
}
