#ifndef RIGMODEL_H
#define RIGMODEL_H

#include <QObject>

#include <QTcpSocket>
#include <QString>
#include <QTimer>
#include <QSettings>

class cRigmodel : public QObject
{

    Q_OBJECT
    Q_PROPERTY(int pressure READ pressure WRITE setPressure NOTIFY pressureChanged)
    Q_PROPERTY(int oiltemp READ oiltemp WRITE setOiltemp NOTIFY oiltempChanged)
    Q_PROPERTY(int voltage READ voltage WRITE setVoltage NOTIFY voltageChanged)
    Q_PROPERTY(int voltage24 READ voltage24 WRITE setVoltage24 NOTIFY voltage24Changed)
    Q_PROPERTY(int ampere READ ampere WRITE setAmpere NOTIFY ampereChanged)
    Q_PROPERTY(int turns READ turns WRITE setTurns NOTIFY turnsChanged)
    Q_PROPERTY(int temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)
    Q_PROPERTY(QString rigtype READ rigtype WRITE setRigtype NOTIFY rigtypeChanged)
    Q_PROPERTY(QString gmod READ gmod WRITE setGmod NOTIFY gmodChanged)
    //############ переменные - данные для отправки
    Q_PROPERTY(bool lamp READ lamp WRITE setLamp NOTIFY lampChanged)
    Q_PROPERTY(bool engine READ engine WRITE setEngine NOTIFY engineChanged)  //включение выключение мотора
    Q_PROPERTY(bool pump READ pump WRITE setPump NOTIFY pumpChanged)  //включение выключение мотора
//    Q_PROPERTY(int joystick READ joystick WRITE setJoystick NOTIFY joystickChanged)

    Q_PROPERTY(int joystick_x1 READ joystick_x1 WRITE setJoystick_x1 NOTIFY joystick_x1Changed)
    Q_PROPERTY(int joystick_y1 READ joystick_y1 WRITE setJoystick_y1 NOTIFY joystick_y1Changed)
    Q_PROPERTY(int joystick_x2 READ joystick_x2 WRITE setJoystick_x2 NOTIFY joystick_x2Changed)
    Q_PROPERTY(int joystick_y2 READ joystick_y2 WRITE setJoystick_y2 NOTIFY joystick_y2Changed)

    Q_PROPERTY(bool camera READ camera WRITE setCamera NOTIFY cameraChanged)
    //############ адрес и порт
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(int timer_send_interval READ timer_send_interval WRITE setTimer_send_interval NOTIFY timer_send_intervalChanged)
    Q_PROPERTY(int timer_connect_interval READ timer_connect_interval WRITE setTimer_connect_interval NOTIFY timer_connect_intervalChanged)
    //############ свойства - статусы tcp соединения

    Q_PROPERTY(bool client_connected READ client_connected NOTIFY client_connectedChanged)
    Q_PROPERTY(bool good_data READ good_data  NOTIFY good_dataChanged)

public:
    explicit cRigmodel(QObject *parent = 0);
    virtual ~cRigmodel() {saveSettings();}
    //############ занчения, получаемые по сети от контроллера
    void setPressure(const int &pressure);
    int pressure() const;

    void setOiltemp(const int &oiltemp);
    int oiltemp() const;

    void setVoltage(const int &voltage);
    int voltage() const;

    void setVoltage24(const int &voltage);
    int voltage24() const;

    void setAmpere(const int &ampere);
    int ampere() const;

    void setTurns(const int &turns);
    int turns() const;

    void setTemperature(const int &temperature);
    int temperature() const;

    void setRigtype(const QString &rigtype);
    QString rigtype() const;

    void setAddress(const QString  &address);
    QString address() const;

    void setPort(const int &port);
    int  port() const;

    void setTimer_send_interval(const int &timer_send_interval);
    int  timer_send_interval() const;

    void setTimer_connect_interval(const int &timer_connect_interval);
    int  timer_connect_interval() const;

    //############ Данные для отправки
    void setLamp(const bool &lamp);
    bool lamp() const;

    void setCamera(const bool &camera);
    bool camera() const;

    void setEngine(const bool &engine);
    bool engine() const;

    void setPump(const bool &pump);
    bool pump() const;

//    void setJoystick(const int &joystick);
//    int joystick() const;

    void setJoystick_x1(const int &joystick);
    int joystick_x1() const;
    void setJoystick_y1(const int &joystick);
    int joystick_y1() const;
    void setJoystick_x2(const int &joystick);
    int joystick_x2() const;
    void setJoystick_y2(const int &joystick);
    int joystick_y2() const;

    bool client_connected()const;
    bool good_data()const;

    QString gmod() const;
    void setGmod(const QString &gmod);

signals:
    void pressureChanged();
    void oiltempChanged();
    void voltageChanged();   
    void voltage24Changed();
    void ampereChanged();
    void turnsChanged();
    void temperatureChanged();
    void rigtypeChanged();
    void gmodChanged();
    void lampChanged();
    void engineChanged();
    void pumpChanged();
    void joystickChanged();
    void joystick_x1Changed();
    void joystick_y1Changed();
    void joystick_x2Changed();
    void joystick_y2Changed();
    void cameraChanged();
    void addressChanged();
    void portChanged();
    void timer_send_intervalChanged();
    void timer_connect_intervalChanged();
    void client_connectedChanged();
    void good_dataChanged();


public slots:

    void start_client();

    void clientConnected();  // слот для обработки события присоединения клиента к серверу.
    void clientDisconnected();
    void updateSendTimer();
    void saveSettings();
    void readSettings();
    void updateClientProgress(qint64 numBytes);
    void displayError(QAbstractSocket::SocketError socketError);
    void sendData(); //слот должен вызываться любым событием, которое меняет данные, предназначенные для отправки.
    void readData(); //расклаываем полученные от сервера данные по параметрам
private:
    int m_pressure=0;
    int m_oiltemp=0;
    int m_voltage=0;
    int m_voltage24=0;
    int m_ampere=0;
    int m_turns=0;
    int m_temperature=0;
    QString m_rigtype="grab2"; //grab2,grab6,gkgbu,tk-15
    QString m_gmod="platf"; //platf,tower,bench,drill

    QString m_address="localhost";
    int m_port=1212;

    bool m_client_connected = false;


    //############ Данные для отправки
    bool m_lamp=false;
    bool m_camera=false;
    bool m_engine=false;
    bool m_pump=false;
    int m_joystick=0;
    int m_joystick_x1=0;
    int m_joystick_y1=0;
    int m_joystick_x2=0;
    int m_joystick_y2=0;
    bool m_good_data=false;




    QTcpSocket tcpClient;
    QTimer timer_connect;
    QTimer timer_send;
    int m_timer_send_interval;
    int m_timer_connect_interval;
    //QSettings m_rigsettings:m_rigsettings("HYCO", "Rig Console");



    int bytesToWrite=0;
    int bytesWritten=0;
    int bytesReceived=0;
};

#endif // RIGMODEL_H
