#ifndef NETWORKER_H
#define NETWORKER_H

#include <QObject>
#include <QList>
#include <rigmodel.h>

class cNetworker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(int timer_send_interval READ timer_send_interval WRITE setTimer_send_interval NOTIFY timer_send_intervalChanged)
    Q_PROPERTY(int timer_connect_interval READ timer_connect_interval WRITE setTimer_connect_interval NOTIFY timer_connect_intervalChanged)
    Q_PROPERTY(bool client_connected READ client_connected NOTIFY client_connectedChanged)
    Q_PROPERTY(bool good_data READ good_data  NOTIFY good_dataChanged)
public:
    explicit cNetworker(QObject *parent = nullptr);
    virtual ~cNetworker() {saveSettings();}

    QString address() const;
    void setAddress(const QString &address);

    quint16 port() const;
    void setPort(const quint16 &port);

    bool client_connected() const;
    void setClient_connected(bool client_connected);

    int timer_send_interval() const;
    void setTimer_send_interval(int timer_send_interval);

    int timer_connect_interval() const;
    void setTimer_connect_interval(int timer_connect_interval);

    bool good_data() const;
    void setGood_data(bool good_data);

signals:
    void addressChanged();
    void portChanged();
    void timer_send_intervalChanged();
    void timer_connect_intervalChanged();
    void client_connectedChanged();
    void good_dataChanged();

public slots:
    Q_INVOKABLE void reg(cRigmodel *rig);
    void start_client();
    void updateSendTimer();
    void deviceConnected();
    void deviceDisconnected();
    void saveSettings();
    void readSettings();
    void displayError(QAbstractSocket::SocketError socketError);
    void sendData();
    void readData();
    Q_INVOKABLE void reconnect();
private:
    QList<cRigmodel*> m_boards;
    QString m_address="localhost";
    quint16 m_port=1212;
    bool m_client_connected = false;
    bool m_good_data=false;
    QTcpSocket tcpClient;
    QTimer timer_connect;
    QTimer timer_send;
    int m_timer_send_interval;
    int m_timer_connect_interval;
};

#endif // NETWORKER_H
