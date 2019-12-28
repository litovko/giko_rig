#include "rigmodel.h"
#include <QDebug>
#include <QString>
#include <functional>
#include <cmath>
#include <QCoreApplication>
#include <QJsonObject>
cRigmodel::cRigmodel(QObject *parent) : QObject(parent)
{
    readSettings();
    using namespace std::placeholders;
    _fmap["spxy"]  = std::bind(&cRigmodel::setPosition, this, _1);
    _fmap["toil"]  = std::bind(&cRigmodel::setTemperature, this, _1);
    _fmap["toi2"]  = std::bind(&cRigmodel::setTemperature2, this, _1);
    _fmap["poil"]  = std::bind(&cRigmodel::setPressure, this, _1);
    _fmap["poi2"]  = std::bind(&cRigmodel::setPressure2, this, _1);
    _fmap["pwrv"]  = std::bind(&cRigmodel::setVoltage, this, _1);
    _fmap["pwv2"]  = std::bind(&cRigmodel::setVoltage2, this, _1);
    _fmap["pwv3"]  = std::bind(&cRigmodel::setVoltage3, this, _1);
    _fmap["pwra"]  = std::bind(&cRigmodel::setAmpere, this, _1);
    _fmap["pwa2"]  = std::bind(&cRigmodel::setAmpere2, this, _1);
    _fmap["pwa3"]  = std::bind(&cRigmodel::setAmpere3, this, _1);
    _fmap["altm"]  = std::bind(&cRigmodel::setAltitude, this, _1);
    _fmap["drpm"]  = std::bind(&cRigmodel::setTurns, this, _1);
    _fmap["dc1v"]  = std::bind(&cRigmodel::setVoltage24, this, _1);
    _fmap["dc2v"]  = std::bind(&cRigmodel::setVoltage24_2, this, _1);
    _fmap["tang"]  = std::bind(&cRigmodel::setTangag, this, _1);
    _fmap["kren"]  = std::bind(&cRigmodel::setKren, this, _1);
    _fmap["leak"]  = std::bind(&cRigmodel::setLeak, this, _1);
    _fmap["vchs"]  = std::bind(&cRigmodel::setLeak_voltage, this, _1);
    _fmap["type"]  = std::bind(&cRigmodel::setRigtypeInt, this, _1);
    reset();

    connect(this, SIGNAL(lampChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(light1Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(light2Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(light3Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(light4Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(engineChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(engine2Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(free_engine1Changed(bool)),this, SLOT(sendData()));
    connect(this, SIGNAL(free_engine2Changed(bool)),this, SLOT(sendData()));
    connect(this, SIGNAL(pumpChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(cameraChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(camera1Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(camera2Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(camera3Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(camera4Changed()),this, SLOT(sendData()));
    connect(this, SIGNAL(gmodChanged()),this, SLOT(sendData()));
    connect(this, SIGNAL(joystick_x1Changed()), this, SLOT(setana()));
    connect(this, SIGNAL(joystick_x2Changed()), this, SLOT(setana()));
    connect(this, SIGNAL(joystick_y1Changed()), this, SLOT(setana()));
    connect(this, SIGNAL(joystick_y2Changed()), this, SLOT(setana()));

}
void cRigmodel::reset()
{
    for (auto const& f : _fmap) f.second(0);
}

void cRigmodel::setana()
{
    if (m_rigtype!="NPA") return;
    int ana1=0, ana2=0, ana3=0, ana4=0;
    if (gmod()=="move") {
        ana4=-m_joystick_x1; // поменяно из-за пробитого транзистора
        ana2=m_joystick_y2; // исп
        ana3=m_joystick_y1; // исп
        //ana2=m_joystick_y1-m_joystick_x1;
        //ana3=m_joystick_y1+m_joystick_x1;
    }
    if (gmod()=="move1") {
        ana1=0;
        ana2=0;
        ana3=-m_joystick_y1; //исп инвертировал
        ana4=-m_joystick_y2; //исп инвертировал
    }
    if (gmod()=="hand"){
        ana1=m_joystick_x1;
        ana2=m_joystick_y1;
        ana3=m_joystick_y1;
        ana4=m_joystick_y2;
    }
    if (gmod()=="hand1"){
        ana1=m_joystick_x2;
        ana2=m_joystick_x1;
        ana3=0;
        ana4=0;
    }
    if (gmod()=="hand2"){
        ana1=m_joystick_y2;
        ana2=m_joystick_y1;
        ana3=0;
        ana4=0;
    }
    if (gmod()=="group"){
        ana1=m_joystick_y2;
        ana2=m_joystick_y1;
        ana3=m_joystick_x2;
        ana4=m_joystick_x1;
    }
    //    m_ana1=scaling(m_ana1);
    //    m_ana2=scaling(m_ana2);
    //    m_ana3=scaling(m_ana3);
    //    m_ana4=scaling(m_ana4);
    //qDebug()<<"setana y1:"<<m_joystick_y1<<" x2:"<<m_joystick_x2<<" ana1:"<<m_ana1<<" ana2:"<<m_ana2<<" ana3:"<<m_ana3;
    if (m_ana1!=ana1) {m_ana1=ana1; emit ana1Changed();}
    if (m_ana2!=ana2) {m_ana2=ana2; emit ana2Changed();}
    if (m_ana3!=ana3) {m_ana3=ana3; emit ana3Changed();}
    if (m_ana4!=ana4) {m_ana4=ana4; emit ana4Changed();}
}

void cRigmodel::saveSettings()
{
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("board_"+QString::number(m_board,10));
    qDebug()<<"save settings : "<<settings.organizationName()<<" "<<settings.applicationName()<<" "<<settings.group();
    //settings.setValue("RigAddress",m_address);
    //settings.setValue("RigPort",m_port);
    settings.setValue("RigFreerun",m_freerun);
    settings.setValue("RigSendInterval",m_timer_send_interval);
    settings.setValue("RigConnectInterval",m_timer_connect_interval);
    settings.setValue("RigCheckType",m_check_type);
    settings.setValue("Rig_KNPA",m_knpa);
    settings.setValue("Rig_KNPV",m_knpv);
    settings.setValue("Rig_KNPI",m_knpi);
    settings.setValue("Rig_LIMA",m_lima);
    settings.setValue("Rig_LIMV",m_limv);
    settings.setValue("Rig_LIMZ",m_limz);
    settings.setValue("Rig_ENG_DT1",m_timer_delay_engine1);
    settings.setValue("Rig_ENG_DT2",m_timer_delay_engine2);
    settings.endGroup();


}

void cRigmodel::readSettings()
{

    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("board_"+QString::number(m_board,10));
//    m_address=settings.value("RigAddress","localhost").toString();
//    m_port=static_cast<quint16>(settings.value("RigPort","1212").toUInt());
    setFreerun(settings.value("RigFreerun","0").toInt());
    m_timer_send_interval=settings.value("RigSendInterval","2000").toInt();
    if (m_timer_send_interval<50)m_timer_send_interval=50;
    m_timer_connect_interval=settings.value("RigConnectInterval","30000").toInt();
    m_check_type=settings.value("RigCheckType","false").toBool();

    m_knpa=settings.value("Rig_KNPA","false").toInt();
    m_knpv=settings.value("Rig_KNPV","false").toInt();
    m_knpi=settings.value("Rig_KNPI","false").toInt();

    m_lima=settings.value("Rig_LIMA","false").toInt();
    m_limv=settings.value("Rig_LIMV","false").toInt();
    m_limz=settings.value("Rig_LIMZ","false").toInt();
    setTimer_delay_engine1(settings.value("Rig_ENG_DT1","2000").toInt());
    setTimer_delay_engine2(settings.value("Rig_ENG_DT2","2000").toInt());
}

//void cRigmodel::updateSendTimer()
//{
//    timer_send.stop();
//    timer_send.start(m_timer_send_interval);
//}

void cRigmodel::setPressure(const int &pressure)
{
    if (m_pressure == pressure) return;
    m_pressure = pressure;
    emit pressureChanged();
}

int cRigmodel::pressure() const
{
    return m_pressure;
}

void cRigmodel::setTemperature2(const int &temperature2)
{
    if (m_temperature2 == temperature2) return;
    m_temperature2 = temperature2;
    emit temperature2Changed();
}

int cRigmodel::temperature2() const
{
    return m_temperature2;
}


void cRigmodel::setVoltage(const int &voltage)
{
    if (m_voltage == voltage) return;
    m_voltage = voltage;
    emit voltageChanged();
}

int cRigmodel::voltage() const
{
    return m_voltage;
}

void cRigmodel::setVoltage24(const int &voltage)
{
    if (m_voltage24 == voltage) return;
    m_voltage24 = voltage;
    emit voltage24Changed();
}

int cRigmodel::voltage24() const
{
    return m_voltage24;
}

void cRigmodel::setAmpere(const int &ampere)
{
    if (m_ampere == ampere) return;
    m_ampere = ampere;
    emit ampereChanged();
}

int cRigmodel::ampere() const
{
    return m_ampere;
}

void cRigmodel::setTurns(const int &turns)
{
    if (m_turns == turns) return;
    m_turns = turns;
    emit turnsChanged();
}

int cRigmodel::turns() const
{
    return m_turns;
}

void cRigmodel::setTemperature(const int &temperature)
{
    if (m_temperature == temperature) return;
    m_temperature = temperature;
    emit temperatureChanged();
}

int cRigmodel::temperature() const
{
    return m_temperature;
}

void cRigmodel::setRigtype(const QString &rigtype)
{
    if (m_rigtype == rigtype) return;
    m_rigtype = rigtype;
    emit rigtypeChanged();
    //qDebug()<<"Rig: rigtype:"<<m_rigtype;
}

QString cRigmodel::rigtype() const
{
    return m_rigtype;
}

void cRigmodel::setRigtypeInt(const int &rigtype)
{

}

void cRigmodel::setLamp(const bool &lamp)
{
    m_lamp = lamp;
    emit lampChanged();
}

bool cRigmodel::lamp() const
{
    return m_lamp;
}

void cRigmodel::setCamera(const bool &camera)
{
    m_camera = camera;
    emit cameraChanged();
    //qDebug()<<"Rig Camera power switched";
}

bool cRigmodel::camera() const
{
    return m_camera;
}

void cRigmodel::setEngine(const bool &engine)
{
    if (m_engine == engine ) return;
    if (m_free_engine2 && engine) return;
    m_engine = engine;
    setfree_engine1(engine&&rigtype()=="mgbu");
    if (m_engine)
        QTimer::singleShot(m_timer_delay_engine1, [this](){setfree_engine1(false);});

    emit engineChanged();
}

void cRigmodel::setEngine2(bool engine2)
{
    if (m_engine2 == engine2) return;
    if (m_free_engine1 && engine2) return;

    m_engine2 = engine2;
    setfree_engine2(engine2&&rigtype()=="mgbu");
    if (m_engine2)
        QTimer::singleShot(m_timer_delay_engine2, [this](){setfree_engine2(false);});
    emit engine2Changed();
}

bool cRigmodel::engine() const
{
    return m_engine;
}

void cRigmodel::setPump(const bool &pump)
{
    if (m_pump == pump) return;
    m_pump = pump;
    emit pumpChanged();
}

bool cRigmodel::pump() const
{
    return m_pump;
}

void cRigmodel::setJoystick_x1(const int &joystick)
{
    if (m_joystick_x1 == joystick) return;
    m_joystick_x1 = joystick;
    emit joystick_x1Changed();
}

int cRigmodel::joystick_x1() const
{
    return m_joystick_x1;
}
//-------------------------------
void cRigmodel::setJoystick_y1(const int &joystick)
{
    if (m_joystick_y1 == joystick) return;
    m_joystick_y1 = joystick;
    emit joystick_y1Changed();
}

int cRigmodel::joystick_y1() const
{
    return m_joystick_y1;
}
//----------------------------------
void cRigmodel::setJoystick_x2(const int &joystick)
{
    if (m_joystick_x2 == joystick) return;
    m_joystick_x2 = joystick;
    emit joystick_x2Changed();
}

int cRigmodel::joystick_x2() const
{
    return m_joystick_x2;
}
void cRigmodel::setJoystick_y2(const int &joystick)
{
    if (m_joystick_y2 == joystick) return;
    m_joystick_y2 = joystick;
    emit joystick_y2Changed();
}

int cRigmodel::joystick_y2() const
{
    return m_joystick_y2;
}

int cRigmodel::timer_send_interval() const
{
    return m_timer_send_interval;
}

void cRigmodel::setTimer_send_interval(const int  &timer_send_interval)
{
    m_timer_send_interval = timer_send_interval;
    if (m_timer_send_interval<50)m_timer_send_interval=50;
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

QJsonObject cRigmodel::getData()
{
    QJsonObject json;
    json["dev1"]=board();
    json["ana1"]=ana1();
    json["ana2"]=ana2();
    json["ana3"]=ana3();
    json["svet"]=(m_light1+(m_light2*16)+(m_light3*16*16)+(m_light4*16*16*16));
    json["dig1"]= m_engine*1
            +   !m_pump*4  //замок манипулятора открывание
            +   m_pump*2 //замок манипулятора закрывание
            +   m_lamp*64
            //+ m_camera*8
            + m_engine2*8
            + m_camera1*16*m_camera
            + m_camera2*32*m_camera
            //+ m_camera3*64*m_camera
            + m_camera4*128*m_camera
            ;
    //qDebug()<<sizeof (json);
    return json;
}


//##################### функция отправки данных

void cRigmodel::sendData()
{
    emit dataChanged();
    //qDebug()<<"data changed";
}

//QString cRigmodel::NPA_data()
//{
//    int dig= m_engine*1
//            +   !m_pump*4  //замок манипулятора открывание
//            +   m_pump*2 //замок манипулятора закрывание
//            +   m_lamp*64
//            //+ m_camera*8
//            + m_engine2*8
//            + m_camera1*16*m_camera
//            + m_camera2*32*m_camera
//            //+ m_camera3*64*m_camera
//            + m_camera4*128*m_camera
//            ;
//    QString Data="{ana1:"+::QString().number(ana1(),10)\
//            +";ana2:"+::QString().number(ana2(),10)\
//            +";ana3:"+::QString().number(ana3(),10)\
//            +";ana4:"+::QString().number(ana4(),10);
//    Data=Data+";gmod:"+gmod_decode(m_gmod)\
//            //+";svet:"+::QString().number((m_light1+(m_light2*16)+(m_light3*16*16)+(m_light4*16*16*16)))
//            +";dig1:"+::QString().number(dig,10)+"}CONSDATA";
//    return Data;
//}
bool cRigmodel::handle_tag(const QString &tag, const QString &val)
{
    bool ok=false;
    auto it = _fmap.find(tag.toUtf8().constData());
    if(it != _fmap.end()) {
        if (val=="type") {
            setRigtype(val);
            if (rigtype()=="mgbu_") setRigtype("mgbu")
                    ;
            if(!(ok=(m_rigtype=="grab2"||m_rigtype=="grab6"||m_rigtype=="gkgbu"||m_rigtype=="mgbu")))
                qWarning()<<"Data! Wrong rig type <"<<val<<">";

        }
        else {
            auto v=val.toInt(&ok,10);
            if (ok) it->second(v);
        }
    }
    else  qWarning()<<"Data! For tag <"<<tag<<"> handle not found!";

    return ok;
}

int cRigmodel::ana2() const
{
    return m_ana2;
}

int cRigmodel::ana3() const
{
    return m_ana3;
}

int cRigmodel::ana4() const
{
    return m_ana4;
}

int cRigmodel::ana1() const
{
    return m_ana1;
}

void cRigmodel::setfree_engine2(bool free_engine2)
{
    if (m_free_engine2 == free_engine2) return;
    m_free_engine2 = free_engine2;
    emit free_engine2Changed(m_free_engine2);
}

void cRigmodel::setfree_engine1(bool free_engine1)
{
    if (m_free_engine1 == free_engine1) return;
    m_free_engine1 = free_engine1;
    emit free_engine1Changed(m_free_engine1);
    //qDebug()<<"free_engine:"<<m_free_engine1;
}

bool cRigmodel::camera4() const
{
    return m_camera4;
}

void cRigmodel::setCamera4(bool camera4)
{
    m_camera4 = camera4;
    emit camera4Changed();
}

bool cRigmodel::camera3() const
{
    return m_camera3;
}

void cRigmodel::setCamera3(bool camera3)
{
    m_camera3 = camera3;
    emit camera3Changed();
}

bool cRigmodel::camera2() const
{
    return m_camera2;
}

void cRigmodel::setCamera2(bool camera2)
{
    m_camera2 = camera2;
    emit camera2Changed();
}

bool cRigmodel::camera1() const
{
    return m_camera1;
}

void cRigmodel::setCamera1(bool camera1)
{
    m_camera1 = camera1;
    emit camera1Changed();
}

bool cRigmodel::engine2() const
{
    return m_engine2;
}



//void cRigmodel::readData()
//{

//    QByteArray Data="";
//    QString CRC ="";
//    QList<QByteArray> split;
//    int m;
//    _no_resp=false;
//    //Data = tcpClient.readAll();
//    qDebug()<<"read:"<<Data;
//    // {toil=29;poil=70;drpm=15;pwrv=33;pwra=3}FAFBFCFD

//    if (Data.startsWith("{")&&(m=Data.indexOf("}"))>0) {
//        setGood_data(true);
//        CRC=Data.mid(m+1);
//        //qDebug()<<"CRC:"<<CRC; //CRC пока не проверяем - это отдельная тема.
//        Data=Data.mid(1,m-1);
//        //qDebug()<<"truncated :"<<Data;
//        split=Data.split(';');
//        //qDebug()<<"split:"<<split;
//        QListIterator<QByteArray> i(split);
//        QByteArray s, val;
//        while (i.hasNext()){
//            s=i.next();
//            m=s.indexOf(":");
//            val=s.mid(m+1); //данные после ":"
//            s=s.left(m); // название тэга
//            setGood_data( handle_tag(s,val) );
//        }
//    }
//    else {
//        setGood_data(false);
//        qWarning()<<"Rig: wrong data receved";
//    }
//}

void cRigmodel::sendKoeff()
{
    if(m_rigtype!="mgbu") return;
    QString Data; // Строка отправки данных.
    // проверяем, есть ли подключение клиента. Если подключения нет, то ничего не отправляем.
    //if (!m_client_connected) return;

    Data="{knpa:"+::QString().number(m_knpa,10);
    Data=Data+";knpv:"+::QString().number(m_knpv,10);
    Data=Data+";knpi:"+::QString().number(m_knpi,10);
    Data=Data+";lima:"+::QString().number(m_lima,10);
    Data=Data+";limv:"+::QString().number(m_limv,10);
    Data=Data+";limz:"+::QString().number(m_limz,10);
    Data=Data+"}CONSDATA";
    //qDebug()<<"Rig - send data: "<<Data;


//    if (bytesToWrite<0)qWarning()<<"Rig: Something wrong due to send data >>>"+tcpClient.errorString();
//    if (bytesToWrite>=0)qDebug()<<"Rig:sent>>>"<<Data<<":"<<::QString().number(bytesToWrite);
}


int cRigmodel::scaling(const int &value)
{
    if (value==0) return 0;
    double df=127.0*m_freerun/100.0;
    //qDebug()<<"Rig - scale df: "<<df<<"f:"<<(ceil(df + value*(100-m_freerun)/100.0)) <<" v:"<<value;
    if  (value>0)
        return static_cast<int>(ceil(df + value*(100-m_freerun)/100.0));
    else
        return static_cast<int>(-ceil(df - value*(100-m_freerun)/100.0));

}

int cRigmodel::board() const
{
    return m_board;
}

void cRigmodel::setBoard(int board)
{
    m_board = board;
}



int cRigmodel::leak_voltage() const
{
    return m_leak_voltage;
}

void cRigmodel::setLeak_voltage(int leak_voltage)
{
    if (m_leak_voltage == leak_voltage) return;
    m_leak_voltage = leak_voltage;
    emit leak_voltageChanged();
}

QString cRigmodel::gmod_decode(QString gmod) const
{
    if (rigtype()=="NPA") {
        if (gmod=="move")  return "grup1";
        if (gmod=="move1") return "grup3";
        if (gmod=="hand")  return "grup2";
        if (gmod=="hand1") return "grup3";
        if (gmod=="hand2") return "grup2";
        if (gmod=="group") return "grup4";
    }
    if (rigtype()!="mgbu") return gmod;
    if (gmod=="drill") return "grup1";
    if (gmod=="bench") return "grup2";
    if (gmod=="tower") return "grup3";
    if (gmod=="platf") return "grup4";
    return gmod;
}



int cRigmodel::leak() const
{
    return m_leak;
}

void cRigmodel::setLeak(int leak)
{
    if (m_leak == leak)return;
    m_leak = leak;
    emit leakChanged();
}

int cRigmodel::kren() const
{
    return m_kren;
}

void cRigmodel::setKren(int kren)
{
    if(m_kren == kren) return;
    m_kren = kren;
    emit krenChanged();
}

int cRigmodel::tangag() const
{
    return m_tangag;
}

void cRigmodel::setTangag(int tangag)
{
    if (m_tangag == tangag) return;
    m_tangag = tangag;
    emit tangagChanged();
}




unsigned int cRigmodel::position() const
{
    return m_position;
}

void cRigmodel::setPosition(unsigned int position)
{
    if (m_position == position) return;
    m_position = position;
    emit positionChanged();
}

int cRigmodel::pressure2() const
{
    return m_pressure2;
}

void cRigmodel::setPressure2(int pressure2)
{
    if (m_pressure2 == pressure2) return;
    m_pressure2 = pressure2;
    emit pressure2Changed();
}

int cRigmodel::light4() const
{
    return m_light4;
}

void cRigmodel::setLight4(int light4)
{
    if(m_light4 == light4) return;
    m_light4 = light4;
    emit light4Changed();
}

int cRigmodel::light3() const
{
    return m_light3;
}

void cRigmodel::setLight3(int light3)
{
    if(m_light3 == light3) return;
    m_light3 = light3;
    emit light3Changed();
}

int cRigmodel::light2() const
{
    return m_light2;
}

void cRigmodel::setLight2(int light2)
{
    if(m_light2 == light2) return;
    m_light2 = light2;
    emit light2Changed();
}

int cRigmodel::light1() const
{
    return m_light1;
}

void cRigmodel::setLight1(int light1)
{
    if(m_light1 == light1) return;
    m_light1 = light1;
    emit light1Changed();
}

int cRigmodel::voltage24_2() const
{
    return m_voltage24_2;
}

void cRigmodel::setVoltage24_2(int voltage24_1)
{
    if(m_voltage24_2 == voltage24_1)return;
    m_voltage24_2 = voltage24_1;
    emit voltage24_2Changed();
}

int cRigmodel::altitude() const
{
    return m_altitude;
}

void cRigmodel::setAltitude(int altitude)
{
    if( m_altitude == altitude)return;
    m_altitude = altitude;
    emit altitudeChanged();
}

int cRigmodel::ampere3() const
{
    return m_ampere3;
}

void cRigmodel::setAmpere3(int ampere3)
{
    if (m_ampere3 == ampere3) return;
    m_ampere3 = ampere3;
    emit ampere3Changed();
}

int cRigmodel::ampere2() const
{
    return m_ampere2;
}

void cRigmodel::setAmpere2(int ampere2)
{
    if (m_ampere2 == ampere2) return;
    m_ampere2 = ampere2;
    emit ampere2Changed();
}

int cRigmodel::voltage3() const
{
    return m_voltage3;
}

void cRigmodel::setVoltage3(int voltage3)
{
    if (m_voltage3 == voltage3) return;
    m_voltage3 = voltage3;
    emit voltage3Changed();
}

int cRigmodel::voltage2() const
{
    return m_voltage2;
}

void cRigmodel::setVoltage2(int voltage2)
{
    if (m_voltage2 == voltage2) return;
    m_voltage2 = voltage2;
    emit voltage2Changed();
}

bool cRigmodel::check_type() const
{
    return m_check_type;
}

void cRigmodel::setCheck_type(bool check_type)
{
    m_check_type = check_type;
    emit check_typeChanged();
}

int cRigmodel::freerun() const
{
    return m_freerun;
}

void cRigmodel::setFreerun(int freerun)
{
    if (m_freerun==freerun)  return;
    if (freerun<0) m_freerun=0;
    if (freerun>100) m_freerun=100;
    m_freerun = freerun;
    emit freerunChanged();
}

QString cRigmodel::gmod() const
{
    return m_gmod;
}

void cRigmodel::setGmod(const QString &gmod)
{
    if (m_gmod == gmod) return;
    m_gmod = gmod;
    //qDebug()<<"gmod:"+m_gmod;
    emit gmodChanged();
}

void cRigmodel::setTimer_delay_engine2(int timer_delay_engine2)
{
    if (m_timer_delay_engine2 == timer_delay_engine2)
        return;

    m_timer_delay_engine2 = timer_delay_engine2;
    emit timer_delay_engine2Changed(m_timer_delay_engine2);
}

void cRigmodel::setTimer_delay_engine1(int timer_delay_engine1)
{
    if (m_timer_delay_engine1 == timer_delay_engine1)
        return;

    m_timer_delay_engine1 = timer_delay_engine1;
    emit timer_delay_engine1Changed(m_timer_delay_engine1);
}
