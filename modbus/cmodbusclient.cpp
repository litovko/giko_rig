#include "cmodbusclient.h"
#include <QDebug>
#include <QCoreApplication>
#include <QSettings>
cModbusClient::cModbusClient(QObject *parent) : QObject(parent)
{
    m_modbusclient =  new QModbusTcpClient(parent);
    connect(m_modbusclient, SIGNAL(errorOccurred(QModbusDevice::Error)), this, SLOT(onError(QModbusDevice::Error)));
    connect(m_modbusclient, SIGNAL(stateChanged(QModbusDevice::State)), this, SLOT(onState(QModbusDevice::State)));

    m_modbusclient->setConnectionParameter(QModbusDevice::NetworkAddressParameter, address());
    m_modbusclient->setConnectionParameter(QModbusDevice::QModbusDevice::NetworkPortParameter, port());

    m_modbusclient->setNumberOfRetries(3);
    m_modbusclient->setTimeout(request_timeout());
    m_reconnect.setInterval(m_reconnect_interval);

    connect(&m_reconnect, SIGNAL(timeout()), this, SLOT(reconnect()));
    m_reconnect.start();
}

cModbusClient::~cModbusClient()
{
    if (m_modbusclient != nullptr)
    {
        m_modbusclient->disconnectDevice();
        delete m_modbusclient;
    }
    saveSettings();

}

int cModbusClient::pooling_time() const
{
    return m_pooling_time;
}



QString cModbusClient::address() const
{
    return m_address;
}

void cModbusClient::setAddress(const QString &address)
{
    m_address = address;
    emit addressChanged();
}

int cModbusClient::port() const
{
    return m_port;
}

void cModbusClient::setPort(int port)
{
    m_port = port;
    emit portChanged();
}

void cModbusClient::onError(QModbusDevice::Error error)
{
    qWarning()<<"Ошибка Modbus TCP"<<error;
}

void cModbusClient::onState(QModbusDevice::State state)
{
    qDebug()<<"Статус соединения Modbus:"<<state;
    if (state!=QModbusDevice::ConnectedState) {
        m_poolling.stop();
        disconnect(&m_poolling, nullptr, nullptr, nullptr);
        setGood_data(false);
        return;
    }
    m_poolling.setInterval(pooling_time());
    m_modbusclient->setTimeout(request_timeout());
    connect(&m_poolling, SIGNAL(timeout()), this, SLOT(send_request()));
    m_poolling.start();
}

void cModbusClient::reconnect()
{
    if (m_modbusclient->state() != QModbusDevice::UnconnectedState) {
        return;
    }
    setGood_data(false);
    m_modbusclient->connectDevice();
}

void cModbusClient::modbus_disconnect()
{
    m_poolling.stop();
    m_modbusclient->disconnectDevice();
}

void cModbusClient::read_data()
{
    //qDebug()<<"read_data";
    if (pModbusReply==nullptr)  {
        setGood_data(false);
        qWarning()<<"Warning nullptr";
        return;
    }
    //qDebug()<<"on_request"<<pModbusReply->error();

    if( pModbusReply->isFinished()&&!pModbusReply->error()) {
        setGood_data(true);
        //qDebug()<<"request_finished"<<pModbusReply->result().values();
        bool changed=false;
        for (auto i=0; i<registers(); i++) {
            if (m_values[i] != _scale(pModbusReply->result().value(i)))
            {
                changed=true;
                m_values[i] = _scale(pModbusReply->result().value(i));
//                qDebug()<<"i"<<i<<":"<<m_values[i];
            }
        }
        if (changed) emit valuesChanged();
    } else {
        qWarning()<<"Помехи в линии modbus";
        setGood_data(false);
        modbus_disconnect(); //NOTE: Похоже, что это единственный способ разобраться с помехами в линии.
    }
    pModbusReply->deleteLater();
    pModbusReply = nullptr;
}

void cModbusClient::send_request()
{

    if (pModbusReply!=nullptr) { //previous request have not completed dew some errors in line or too frequent pooling
        //qDebug()<<"sr"<<pModbusReply->type();
        qWarning()<<"Некорректные данные по modbus или слишком частый опрос";
        disconnect(pModbusReply, nullptr, nullptr, nullptr);
        //pModbusReply->deleteLater();
        delete pModbusReply;
        pModbusReply=nullptr;
        modbus_disconnect();
        return;
    }
    //qDebug()<<"send_request"<<m_modbusclient->numberOfRetries()<<" "<<m_modbusclient->timeout();
    pModbusReply = m_modbusclient->sendReadRequest(
                QModbusDataUnit( QModbusDataUnit::HoldingRegisters,
                     start_address(),
                     registers()),
                     device_address());
    //qDebug()<<pModbusReply;
    connect(pModbusReply, SIGNAL(finished()),this, SLOT(read_data()));
    connect(pModbusReply, SIGNAL(errorOccurred(QModbusDevice::Error)), this, SLOT(onError(QModbusDevice::Error)));
    //qDebug()<<pModbusReply->error();
}

void cModbusClient::saveSettings()
{
    {
        QSettings settings("HYCO", QCoreApplication::applicationName());
        settings.beginGroup("modbus");
        qDebug()<<"save modbus settings : "<<settings.organizationName()<<" "<<settings.applicationName()<<" "<<settings.group();
        settings.setValue("Address",address());
        settings.setValue("Port",port());
        settings.setValue("Pooling time", pooling_time());
        settings.setValue("Modbus device address", device_address());
        settings.setValue("Reconnect interval", reconnect_interval());
        settings.setValue("Request timeout", request_timeout());
        settings.setValue("Registers number", registers());
        settings.setValue("Registers start address", start_address());
        settings.endGroup();
    }
}

void cModbusClient::readSettings()
{
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("modbus");
    setAddress(settings.value("Address","localhost").toString());
    setPort(settings.value("Port",502).toInt());
    setPooling_time(settings.value("Pooling time",500).toInt());
    setDevice_address(settings.value("Modbus device address",1).toInt());
    setReconnect_interval(settings.value("Reconnect interval",1000).toInt());
    setRegisters(static_cast<unsigned short>(settings.value("Registers number",3).toUInt()));
    setStart_address(settings.value("Registers start address",3).toInt());
}

int cModbusClient::_scale(int v)
{
    return v>32767?v-65536:v;

}

int cModbusClient::start_address() const
{
    return m_start_address;
}

void cModbusClient::setStart_address(int start_address)
{
    m_start_address = start_address;
}

QList<int> cModbusClient::values() const
{
    return m_values;
}

unsigned short cModbusClient::registers() const
{
    return m_registers;
}

void cModbusClient::setRegisters(unsigned short registers)
{
    m_registers = registers;
}

int cModbusClient::device_address() const
{
    return m_device_address;
}

void cModbusClient::setDevice_address(int device_address)
{
    m_device_address = device_address;
}


bool cModbusClient::good_data() const
{
    return m_good_data;
}

void cModbusClient::setGood_data(bool good_data)
{
    if(m_good_data == good_data) return;
    m_good_data = good_data;
    emit good_dataChanged();

}

int cModbusClient::request_timeout() const
{
    return m_request_timeout;
}

void cModbusClient::setRequest_timeout(int request_timeout)
{
    m_request_timeout = request_timeout;
    //qDebug()<<"request_timeout chaged";
    emit request_timeoutChanged();
}

void cModbusClient::setPooling_time(int pooling_time)
{
    m_pooling_time = pooling_time;
    m_poolling.setInterval(m_pooling_time);
    emit pooling_timeChanged();
}

int cModbusClient::reconnect_interval() const
{
    return m_reconnect_interval;
}



void cModbusClient::setReconnect_interval(int reconnect_interval)
{
    m_reconnect_interval = reconnect_interval;
    m_reconnect.setInterval(m_reconnect_interval);
    emit pooling_timeChanged();
}
