#ifndef RIGMODEL_H
#define RIGMODEL_H

#include <QObject>

#include <QTcpSocket>
#include <QString>
#include <QTimer>
#include <QSettings>
#include <QtGlobal>
class cRigmodel : public QObject
{

    Q_OBJECT
    Q_PROPERTY(unsigned int position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(int leak READ leak WRITE setLeak NOTIFY leakChanged)
    Q_PROPERTY(int leak_voltage READ leak_voltage WRITE setLeak_voltage NOTIFY leak_voltageChanged)
    Q_PROPERTY(int pressure READ pressure WRITE setPressure NOTIFY pressureChanged)
    Q_PROPERTY(int pressure2 READ pressure2 WRITE setPressure2 NOTIFY pressure2Changed)
    Q_PROPERTY(int temperature2 READ temperature2 WRITE setTemperature2 NOTIFY temperature2Changed)
    Q_PROPERTY(int voltage READ voltage WRITE setVoltage NOTIFY voltageChanged)
    Q_PROPERTY(int voltage2 READ voltage2 WRITE setVoltage2 NOTIFY voltage2Changed)
    Q_PROPERTY(int voltage3 READ voltage3 WRITE setVoltage3 NOTIFY voltage3Changed)
    Q_PROPERTY(int voltage24 READ voltage24 WRITE setVoltage24 NOTIFY voltage24Changed)
    Q_PROPERTY(int voltage24_2 READ voltage24_2 WRITE setVoltage24_2 NOTIFY voltage24_2Changed)
    Q_PROPERTY(int ampere READ ampere WRITE setAmpere NOTIFY ampereChanged)
    Q_PROPERTY(int ampere2 READ ampere2 WRITE setAmpere2 NOTIFY ampere2Changed)
    Q_PROPERTY(int ampere3 READ ampere3 WRITE setAmpere3 NOTIFY ampere3Changed)
    Q_PROPERTY(int altitude READ altitude WRITE setAltitude NOTIFY altitudeChanged)
    Q_PROPERTY(int tangag READ tangag WRITE setTangag NOTIFY tangagChanged)
    Q_PROPERTY(int kren READ kren WRITE setKren NOTIFY krenChanged)
    Q_PROPERTY(int turns READ turns WRITE setTurns NOTIFY turnsChanged)
    Q_PROPERTY(int temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)
    Q_PROPERTY(QString rigtype READ rigtype WRITE setRigtype NOTIFY rigtypeChanged)
    Q_PROPERTY(QString gmod READ gmod WRITE setGmod NOTIFY gmodChanged)
    //############ переменные - данные для отправки
    Q_PROPERTY(bool lamp READ lamp WRITE setLamp NOTIFY lampChanged)
    Q_PROPERTY(bool engine READ engine WRITE setEngine NOTIFY engineChanged)  //включение выключение мотора 1
    Q_PROPERTY(bool engine2 READ engine2 WRITE setEngine2 NOTIFY engine2Changed)  //включение выключение мотора 2
    Q_PROPERTY(bool pump READ pump WRITE setPump NOTIFY pumpChanged)  //включение выключение мотора промывки
//    Q_PROPERTY(int joystick READ joystick WRITE setJoystick NOTIFY joystickChanged)

    Q_PROPERTY(int joystick_x1 READ joystick_x1 WRITE setJoystick_x1 NOTIFY joystick_x1Changed)
    Q_PROPERTY(int joystick_y1 READ joystick_y1 WRITE setJoystick_y1 NOTIFY joystick_y1Changed)
    Q_PROPERTY(int joystick_x2 READ joystick_x2 WRITE setJoystick_x2 NOTIFY joystick_x2Changed)
    Q_PROPERTY(int joystick_y2 READ joystick_y2 WRITE setJoystick_y2 NOTIFY joystick_y2Changed)

    Q_PROPERTY(bool camera READ camera WRITE setCamera NOTIFY cameraChanged)
    Q_PROPERTY(bool camera1 READ camera1 WRITE setCamera1 NOTIFY camera1Changed)
    Q_PROPERTY(bool camera2 READ camera2 WRITE setCamera2 NOTIFY camera2Changed)
    Q_PROPERTY(bool camera3 READ camera3 WRITE setCamera3 NOTIFY camera3Changed)
    Q_PROPERTY(bool camera4 READ camera4 WRITE setCamera4 NOTIFY camera4Changed)

    Q_PROPERTY(int light1 READ light1 WRITE setLight1 NOTIFY light1Changed) //яркость - 16 градаций
    Q_PROPERTY(int light2 READ light2 WRITE setLight2 NOTIFY light2Changed)
    Q_PROPERTY(int light3 READ light3 WRITE setLight3 NOTIFY light3Changed)
    Q_PROPERTY(int light4 READ light4 WRITE setLight4 NOTIFY light4Changed)
    //############ адрес и порт и другие параметры
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(int timer_send_interval READ timer_send_interval WRITE setTimer_send_interval NOTIFY timer_send_intervalChanged)
    Q_PROPERTY(int timer_connect_interval READ timer_connect_interval WRITE setTimer_connect_interval NOTIFY timer_connect_intervalChanged)
    Q_PROPERTY(int freerun READ freerun WRITE setFreerun NOTIFY freerunChanged) // Valve free run  - свободный ход клапанов в процентах
    Q_PROPERTY(int check_type READ check_type WRITE setCheck_type NOTIFY check_typeChanged) // Есть возможность отключить определение типа устройства если контроллер установлен не в то устройство
    //############ свойства - статусы tcp соединения

    Q_PROPERTY(bool client_connected READ client_connected NOTIFY client_connectedChanged)
    Q_PROPERTY(bool good_data READ good_data  NOTIFY good_dataChanged)

public:
        explicit cRigmodel(QObject *parent = nullptr);
    virtual ~cRigmodel() {saveSettings();}
    //############ занчения, получаемые по сети от контроллера
    void setPressure(const int &pressure);
    int pressure() const;

    void setTemperature2(const int &temperature2);
    int temperature2() const;

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
    void setRigtypeInt(const int &rigtype);

    void setAddress(const QString  &address);
    QString address() const;

    void setPort(const quint16 &port);
    quint16  port() const;

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

    int freerun() const;
    void setFreerun(int freerun);

    bool check_type() const;
    void setCheck_type(bool check_type);

    int voltage2() const;
    void setVoltage2(int voltage2);

    int voltage3() const;
    void setVoltage3(int voltage3);

    int ampere2() const;
    void setAmpere2(int ampere2);

    int ampere3() const;
    void setAmpere3(int ampere3);

    int altitude() const;
    void setAltitude(int altitude);

    int voltage24_2() const;
    void setVoltage24_2(int voltage24_2);

    int light1() const;
    void setLight1(int light1);

    int light2() const;
    void setLight2(int light2);

    int light3() const;
    void setLight3(int light3);

    int light4() const;
    void setLight4(int light4);

    int pressure2() const;
    void setPressure2(int pressure2);

    unsigned int position() const;
    void setPosition(unsigned int position);

    void setGood_data(bool good_data);

    void setClient_connected(bool client_connected);

    int tangag() const;
    void setTangag(int tangag);

    int kren() const;
    void setKren(int kren);

    int leak() const;
    void setLeak(int leak);

    bool engine2() const;
    void setEngine2(bool engine2);

    bool camera1() const;
    void setCamera1(bool camera1);

    bool camera2() const;
    void setCamera2(bool camera2);

    bool camera3() const;
    void setCamera3(bool camera3);

    bool camera4() const;
    void setCamera4(bool camera4);

    int leak_voltage() const;
    void setLeak_voltage(int leak_voltage);

signals:
    void positionChanged();
    void pressureChanged();
    void pressure2Changed();
    void temperature2Changed();
    void voltageChanged();
    void voltage2Changed();
    void voltage3Changed();
    void voltage24Changed();
    void voltage24_2Changed();
    void ampereChanged();
    void ampere2Changed();
    void ampere3Changed();
    void leakChanged();
    void leak_voltageChanged();
    void altitudeChanged();
    void tangagChanged();
    void krenChanged();
    void turnsChanged();
    void temperatureChanged();
    void rigtypeChanged();
    void gmodChanged();
    void lampChanged();
    void engineChanged();
    void engine2Changed();
    void pumpChanged();
    void joystickChanged();
    void joystick_x1Changed();
    void joystick_y1Changed();
    void joystick_x2Changed();
    void joystick_y2Changed();
    void light1Changed();
    void light2Changed();
    void light3Changed();
    void light4Changed();
    void cameraChanged();
    void camera1Changed();
    void camera2Changed();
    void camera3Changed();
    void camera4Changed();
    void addressChanged();
    void portChanged();
    void timer_send_intervalChanged();
    void timer_connect_intervalChanged();
    void freerunChanged();
    void client_connectedChanged();
    void good_dataChanged();
    void check_typeChanged();


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
    void sendKoeff();
    void reset();
    Q_INVOKABLE void reconnect();
private:
    int scaling(const int &value);
    int m_pressure=50;
    int m_pressure2=60;
    int m_temperature=10;
    int m_temperature2=20;
    int m_voltage=251;
    int m_voltage2=260;
    int m_voltage3=241;
    int m_voltage24=25;
    int m_voltage24_2=25;
    int m_ampere=21;
    int m_ampere2=25;
    int m_ampere3=23;
    int m_leak=20;
    int m_leak_voltage=20;
    int m_altitude=10;
    int m_tangag=10;
    int m_kren=10;
    int m_turns=0;
    QString gmod_decode(QString gmod) const;
    unsigned int m_position=60842;
    QString m_rigtype="mgbu"; //grab2,grab6,gkgbu,mgbu


    QString m_address="localhost";
    quint16 m_port=1212;
    int m_freerun;
    bool m_client_connected = false;

    std::map<std::string, std::function<void(int)>> _fmap;
    bool handle_tag(const QString &tag,  const QString &val);
    //############ Данные для отправки
    bool m_lamp=false;
    bool m_camera=false;
    bool m_camera1=false;
    bool m_camera2=false;
    bool m_camera3=false;
    bool m_camera4=false;
    bool m_engine=false;
    bool m_engine2=false;
    bool m_pump=false;
    int m_joystick=0;
    int m_joystick_x1=0;
    int m_joystick_y1=0;
    int m_joystick_x2=0;
    int m_joystick_y2=0;
    int m_light1=0;
    int m_light2=0;
    int m_light3=0;
    int m_light4=0;
            //коэффициенты и пороги
    int m_knpa=1; //коэффициент тока
    int m_knpv=1; //коэффициент наприяжения
    int m_knpi=1; //коэффициент давлени масла
    int m_lima=100000; //порог по току
    int m_limv=100000; //порог по напряжению
    int m_limz=100000; //порог по току утечки
    QString m_gmod="platf"; //platf,tower,bench,drill

    bool m_good_data=false;
    bool m_check_type=false;




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

//voltage24_2
//light - 4 m_light1
//temperature2
//pressure2
//position - unsigned int
