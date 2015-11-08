﻿#ifndef RIGMODEL_H
#define RIGMODEL_H

#include <QObject>

#include <QTcpSocket>
#include <QString>

class cRigmodel : public QObject
{

    Q_OBJECT
    Q_PROPERTY(int pressure READ pressure WRITE setPressure NOTIFY pressureChanged)
    Q_PROPERTY(int oiltemp READ oiltemp WRITE setOiltemp NOTIFY oiltempChanged)
    //############ переменные - данные для отправки
    Q_PROPERTY(bool lamp READ lamp WRITE setLamp NOTIFY lampChanged)
    Q_PROPERTY(bool engine READ engine WRITE setEngine NOTIFY engineChanged)
    Q_PROPERTY(int joystick READ joystick WRITE setJoystick NOTIFY joystickChanged)
    //############ адрес и порт
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    //############ свойства - статусы tcp соединения

    Q_PROPERTY(bool client_connected READ client_connected NOTIFY client_connectedChanged)

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


    bool client_connected()const;


    //############ Данные для отправки
    void setLamp(const bool &lamp);
    bool lamp() const;

    void setEngine(const bool &engine);
    bool engine() const;

    void setJoystick(const int &joystick);
    int joystick() const;

signals:
    void pressureChanged();
    void oiltempChanged();
    void addressChanged();

    void lampChanged();
    void engineChanged();
    void joystickChanged();

    void portChanged();

    void client_connectedChanged();



public slots:

    void start_client();

    void clientConnected();  // слот для обработки события присоединения клиента к серверу.
    void clientDisconnected();

    void updateClientProgress(qint64 numBytes);
    void displayError(QAbstractSocket::SocketError socketError);
    void sendData(); //слот должен вызываться любым событием, которое меняет данные, предназначенные для отправки.
    void readData(); //расклаываем полученные от сервера данные по параметрам
private:
    int m_pressure=0;
    int m_oiltemp=0;
    QString m_address;
    int m_port=65000;

    bool m_client_connected = false;


    //############ Данные для отправки
    bool m_lamp=false;
    bool m_engine=false;
    int m_joystick=0;



    QTcpSocket tcpClient;


    int bytesToWrite=0;
    int bytesWritten=0;
    int bytesReceived=0;
};

#endif // RIGMODEL_H
