#ifndef RIGMODEL_H
#define RIGMODEL_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QString>

class cRigmodel : public QObject
{

    Q_OBJECT
    Q_PROPERTY(int pressure READ pressure WRITE setPressure NOTIFY pressureChanged)
    Q_PROPERTY(int oiltemp READ oiltemp WRITE setOiltemp NOTIFY oiltempChanged)
    //############ адрс и порт
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    //############ свойства - статусы tcp соединений
    Q_PROPERTY(bool server_ready READ server_ready NOTIFY server_readyChanged)
    Q_PROPERTY(bool client_connected READ client_connected NOTIFY client_connectedChanged)
    Q_PROPERTY(bool server_connected READ server_connected NOTIFY server_connectedChanged)
public:
    explicit cRigmodel(QObject *parent = 0);

    void setPressure(const int &pressure);
    int pressure() const;

    void setOiltemp(const int &oiltemp);
    int oiltemp() const;

    void setAddress(const QString  &address);
    QString address() const;

    void setPort(const int &port);
    int  port() const;

    bool server_ready() const;
    bool client_connected()const;
    bool server_connected()const;

signals:
    void pressureChanged();
    void oiltempChanged();
    void addressChanged();
    void portChanged();
    void server_readyChanged();
    void client_connectedChanged();
    void server_connectedChanged();


public slots:
    void start_server();
    void start_client();
    void acceptConnection();  //tcpServer new connection
    void clientConnected();
    void clientDisconnected();
    void updateServerProgress();
    void updateClientProgress(qint64 numBytes);
    void displayError(QAbstractSocket::SocketError socketError);
private:
    int m_pressure=0;
    int m_oiltemp=0;
    QString m_address;
    int m_port=65000;
    bool m_server_ready = false;
    bool m_client_connected = false;
    bool m_server_connected = false;
    QTcpServer tcpServer;
    QTcpSocket tcpClient;
    QTcpSocket *tcpServerConnection; //переменная хранит сокет открытой коннекции с клиентом

    int bytesToWrite=0;
    int bytesWritten=0;
    int bytesReceived=0;
};

#endif // RIGMODEL_H
