#ifndef CMODBUSCLIENT_H
#define CMODBUSCLIENT_H

#include <QObject>
#include <QTimer>
#include<QtSerialBus/QModbusTcpClient>

class cModbusClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int pooling_time MEMBER m_pooling_time NOTIFY pooling_timeChanged)
    Q_PROPERTY(QString address MEMBER m_address NOTIFY addressChanged)
    Q_PROPERTY(int port MEMBER m_port NOTIFY portChanged)
    Q_PROPERTY(int device_address MEMBER m_device_address NOTIFY device_addressChanged)
    Q_PROPERTY(int registers MEMBER m_registers NOTIFY registersChanged)
    Q_PROPERTY(int reconnect_interval READ reconnect_interval WRITE setReconnect_interval NOTIFY reconnect_intervalChanged)
    Q_PROPERTY(int request_timeout MEMBER m_request_timeout NOTIFY request_timeoutChanged)
    Q_PROPERTY(bool good_data MEMBER m_good_data NOTIFY good_dataChanged)
    Q_PROPERTY(QList<int> values READ values NOTIFY valuesChanged)
    Q_PROPERTY(int start_address MEMBER m_start_address NOTIFY start_addressChanged)
public:
    explicit cModbusClient(QObject *parent = nullptr);
    virtual ~cModbusClient();

    int pooling_time() const;
    void setReconnect_interval(int reconnect_interval);


    QString address() const;
    void setAddress(const QString &address);

    int port() const;
    void setPort(int port);

    int reconnect_interval() const;

    void setPooling_time(int pooling_time);

    int request_timeout() const;
    void setRequest_timeout(int request_timeout);

    bool good_data() const;
    void setGood_data(bool good_data);

    int device_address() const;
    void setDevice_address(int device_address);

    unsigned short registers() const;
    void setRegisters(unsigned short registers);

    QList<int> values() const;

    int start_address() const;
    void setStart_address(int start_address);

signals:
    void pooling_timeChanged();
    void addressChanged();
    void portChanged();
    void reconnect_intervalChanged();
    void request_timeoutChanged();
    void good_dataChanged();
    void device_addressChanged();
    void registersChanged();
    void valuesChanged();
    void start_addressChanged();

public slots:
    void onError(QModbusDevice::Error error);
    void onState(QModbusDevice::State state);
    void reconnect();
    Q_INVOKABLE void modbus_disconnect();
    void read_data();
    void send_request();

private:
    void saveSettings();
    void readSettings();
    int _scale(int v);
    int m_device_address=0;
    int m_start_address=30001;
    int m_pooling_time =1000;
    unsigned short m_registers = 3;
    QString m_address = "localhost";
    int m_port = 502;
    QModbusTcpClient *m_modbusclient = nullptr;
    int m_reconnect_interval=1000;
    bool m_good_data=false;
    QTimer m_reconnect;
    QTimer m_poolling;
    int m_request_timeout=200;
    QModbusReply *pModbusReply=nullptr;
    QList<int> m_values = {0,0,0};


};

#endif // CMODBUSCLIENT_H
