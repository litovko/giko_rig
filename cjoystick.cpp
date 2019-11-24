#include "cjoystick.h"
#include <QDebug>
#include <QTime>
#include <QSettings>
#include <QCoreApplication>
#define J_POLL_INTERVAL 50
#define J_CHECK_INTERVAL 20000

cJoystick::cJoystick(QObject *parent) : QObject(parent)
{
    readSettings();
    timer_joystick = new QTimer(this);
    timer_checkjoystick = new QTimer(this);
    connect(this, SIGNAL(currentChanged()),this, SLOT(change_numbers()));
    connect(timer_checkjoystick,SIGNAL(timeout()),this,SLOT(checkJoystick()));
    init_joystick();
    //checkJoystick();
    timer_checkjoystick->start(J_CHECK_INTERVAL);
    //    readSettings();
}
cJoystick::~cJoystick(){
    timer_joystick->stop();
    timer_checkjoystick->stop();
    if (joy)delete joy; joy=nullptr;
    if (timer_joystick) delete timer_joystick;
    if (timer_checkjoystick) delete timer_checkjoystick;
    //    int n=joystick.length();
    //    qDebug()<<"Joystick.length:"<<n << "joysavail:" << joysavail;
    saveSettings();
    if (_joystick_data) delete _joystick_data;
    //for(int i=0; i<joysavail;i++) {delete joystick.at(i);}
}

void cJoystick::checkJoystick()
{
    if (ispresent()) {
        if (joy->availableJoysticks()==m_joysticks_avail)
            return;
        else {
            clear_joystick();
            init_joystick();
        }
    }
    else init_joystick();

}
void cJoystick::setX1axis(const int &axis)
{
    if (axis==m_x1axis) return;
    m_x1axis=axis;
    emit x1axisChanged();
}

void cJoystick::setY1axis(const int &axis)
{
    if (axis==m_y1axis) return;
    m_y1axis=axis;
    emit y1axisChanged();

}

void cJoystick::setX2axis(const int &axis)
{
    if (axis==m_x2axis) return;
    m_x2axis=axis;
    emit x2axisChanged();
}

void cJoystick::setY2axis(const int &axis)
{
    if (axis==m_y2axis) return;
    m_y2axis=axis;
    emit y2axisChanged();

}


void cJoystick::setCurrent(const int &current)
{
    m_current=current;
    //qDebug()<<"J current"<<current;
    emit currentChanged();

}
void cJoystick::setIspresent (const bool &pr)
{
    m_key_0=!pr; //устанавливаем кнопку "Fire" в нажатое состояние для управления с помощью мышки и клавиатуры.
    emit key_0Changed();
    m_ispresent=pr;
    emit ispresentChanged();
}

bool cJoystick::ispresent()
{
    return m_ispresent;
}

int cJoystick::x1axis()
{
    return m_x1axis;
}

int cJoystick::y1axis()
{
    return m_y1axis;
}


int cJoystick::x2axis()
{
    return m_x2axis;
}

int cJoystick::y2axis()
{
    return m_y2axis;
}


int cJoystick::current()
{
    return m_current;
}

bool cJoystick::key_0()
{
    return m_key_0;
}

bool cJoystick::key_1()
{
    return m_key_1;
}

bool cJoystick::key_2()
{
    return m_key_2;
}

bool cJoystick::key_3()
{
    return m_key_3;
}

bool cJoystick::key_4()
{
    return m_key_4;
}

bool cJoystick::key_5()
{
    return m_key_5;
}
// Initialize Joystick information
// Get # of joysticks available
// Populate # of axes and buttons
void cJoystick::init_joystick()
{
    if(current()<0) return;
    readSettings();
    if (joy==nullptr){
        joy = new QJoystick();
        qDebug()<<"Joystick Number:"<<current()<<"new QJoystick:"<<joy;
    }
    m_joysticks_avail=joy->availableJoysticks();
    qDebug()<<"Joysticks available:"<<m_joysticks_avail;
    setIspresent(m_joysticks_avail>current());
    if (!ispresent()) {
        qWarning()<<"Joystick "<<current()<<" not present!!!";
        clear_joystick();

        return;
    }
    // Create joysticks data
    if (_joystick_data) delete _joystick_data;
    _joystick_data = new joydata;
    int i=current();
    {
        joy->setJoystick(i);
        // Axes
        setAxes_number(_joystick_data->number_axes = joy->joystickNumAxes(i));
        _joystick_data->name=joy->joystickName(i);
        qDebug()<<"J:"<<i<<" name:"<<joy->joystickName(i)<<" axex:"<<joy->joystickNumAxes(i)<<"buttons:"<<joy->joystickNumButtons(i);
        for(auto j=0; j<_joystick_data->number_axes;j++)
        {
            _joystick_data->axis.append(0);
        }

        // Buttons
        setButtons_number( _joystick_data->number_btn  = joy->joystickNumButtons(i));
        //qDebug()<<"J"<<i<<"buttons:"<<joy->joystickNumButtons(i);
        for(auto j=0; j<_joystick_data->number_btn;j++)
        {
            _joystick_data->button.append(false);
        }
    }

    if (m_y1axis_ind>m_axes_number-1) setY1axis_ind(0);
    if (m_x1axis_ind>m_axes_number-1) setX1axis_ind(0);
    if (m_y2axis_ind>m_axes_number-1) setY2axis_ind(0);
    if (m_x2axis_ind>m_axes_number-1) setX2axis_ind(0);
    if (m_key_0_ind>m_buttons_number-1) setKey_0_ind(0);
    if (m_key_1_ind>m_buttons_number-1) setKey_1_ind(0);
    if (m_key_2_ind>m_buttons_number-1) setKey_2_ind(0);
    if (m_key_3_ind>m_buttons_number-1) setKey_3_ind(0);
    if (m_key_4_ind>m_buttons_number-1) setKey_4_ind(0);
    if (m_key_5_ind>m_buttons_number-1) setKey_5_ind(0);
    emit axes_numberChanged();
    emit buttons_numberChanged();
    emit nameChanged();
    connect(timer_joystick,SIGNAL(timeout()),this,SLOT(updateData()));
    timer_joystick->start();
}

void cJoystick::clear_joystick()
{
    if (joy) {
        timer_joystick->stop();
        disconnect(timer_joystick,SIGNAL(timeout()),this,SLOT(updateData()));
        delete joy;
        joy=nullptr;

    }
    if (_joystick_data) delete _joystick_data;
    _joystick_data=nullptr;
    setIspresent(false);
    m_joysticks_avail=0;
    m_axes_number=0;
    m_buttons_number=0;
    emit axes_numberChanged();
    emit buttons_numberChanged();
    emit nameChanged();
}

void cJoystick::updateData()
{
    if (!joy) return;
    pollJoystick();
    if (!m_lock) {
        setY1axis((-_joystick_data->axis[m_y1axis_ind]*127/32767)/m_devider);
        setX1axis((_joystick_data->axis[m_x1axis_ind]*127/32767)/m_devider);
        setY2axis((-_joystick_data->axis[m_y2axis_ind]*127/32767)/m_devider);
        setX2axis((_joystick_data->axis[m_x2axis_ind]*127/32767)/m_devider);
    }
    bool b=(_joystick_data->button[m_key_0_ind]);
    if (b==!m_key_0) { m_key_0=b; emit key_0Changed();}
    b=_joystick_data->button[m_key_1_ind];
    if (b==!m_key_1) { m_key_1=b; emit key_1Changed();}
    b=_joystick_data->button[m_key_2_ind];
    if (b==!m_key_2) { m_key_2=b; emit key_2Changed();}
    b=_joystick_data->button[m_key_3_ind];
    if (b==!m_key_3) { m_key_3=b; emit key_3Changed();}
    b=_joystick_data->button[m_key_4_ind];
    if (b==!m_key_4) { m_key_4=b; emit key_4Changed();}
    b=_joystick_data->button[m_key_5_ind];
    if (b==!m_key_5) { m_key_5=b; emit key_5Changed();}

}

void cJoystick::change_numbers()
{
    timer_joystick->stop();
    init_joystick();
    emit axes_numberChanged();
    emit buttons_numberChanged();
    emit nameChanged();
}

void cJoystick::saveSettings()
{

    if (current()<0) return;
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("joystick_"+QString::number(current()));
    settings.setValue("Joystick",name());
    settings.setValue("Joystick-axes",m_axes_number);
    settings.setValue("Joystick-buttons",m_buttons_number);
    settings.setValue("Joystick-x1",m_x1axis_ind);
    settings.setValue("Joystick-x2",m_x2axis_ind);
    settings.setValue("Joystick-y1",m_y1axis_ind);
    settings.setValue("Joystick-y2",m_y2axis_ind);
    settings.setValue("Joystick-b1",m_key_0_ind);
    settings.setValue("Joystick-b2",m_key_1_ind);
    settings.setValue("Joystick-b3",m_key_2_ind);
    settings.setValue("Joystick-b4",m_key_3_ind);
    settings.setValue("Joystick-b5",m_key_4_ind);
    settings.setValue("Joystick-b6",m_key_5_ind);
    settings.endGroup();
}

void cJoystick::readSettings()
{
    if (current()<0) return;
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("joystick_"+QString::number(current()));
    setX1axis_ind(settings.value("Joystick-x1",0).toInt());
    setX2axis_ind(settings.value("Joystick-x2",1).toInt());
    setY1axis_ind(settings.value("Joystick-y1",2).toInt());
    setY2axis_ind(settings.value("Joystick-y2",3).toInt());
    setKey_0_ind(settings.value("Joystick-b1",0).toInt());
    setKey_1_ind(settings.value("Joystick-b2",1).toInt());
    setKey_2_ind(settings.value("Joystick-b3",2).toInt());
    setKey_3_ind(settings.value("Joystick-b4",3).toInt());
    setKey_4_ind(settings.value("Joystick-b5",4).toInt());
    setKey_5_ind(settings.value("Joystick-b6",5).toInt());
}

void cJoystick::setButtons_number(int buttons_number)
{
    m_buttons_number = buttons_number;
    emit buttons_numberChanged();
}

void cJoystick::setAxes_number(int axes_number)
{
    m_axes_number = axes_number;
    emit axes_numberChanged();
}

int cJoystick::devider() const
{
    return m_devider;
}

void cJoystick::setDevider(int devider)
{
    m_devider = devider;
    emit deviderChanged();
}

bool cJoystick::lock() const
{
    return m_lock;
}

void cJoystick::setLock(bool lock)
{
    if (m_lock==lock) return;
    m_lock = lock;
    qDebug()<<"Joystick Lock";
    emit lockChanged();
}


int cJoystick::buttons_number() const
{
    return m_buttons_number;
}

QString cJoystick::name() const
{
    if (_joystick_data) return _joystick_data->name;
    else return "Джойстик не найден";
}

int cJoystick::axes_number() const
{
    return m_axes_number;
}

int cJoystick::key_1_ind() const
{
    return m_key_1_ind;
}

void cJoystick::setKey_1_ind(int key_1_ind)
{
    m_key_1_ind = key_1_ind;
    emit key_1_indChanged();
}

int cJoystick::key_2_ind() const
{
    return m_key_2_ind;
}

void cJoystick::setKey_2_ind(int key_2_ind)
{
    m_key_2_ind = key_2_ind;
    emit key_2_indChanged();
}

int cJoystick::key_3_ind() const
{
    return m_key_3_ind;
}

void cJoystick::setKey_3_ind(int key_3_ind)
{
    m_key_3_ind = key_3_ind;
    emit key_3_indChanged();
}

int cJoystick::key_4_ind() const
{
    return m_key_4_ind;
}

void cJoystick::setKey_4_ind(int key_4_ind)
{
    m_key_4_ind = key_4_ind;
    emit key_4_indChanged();
}

int cJoystick::key_5_ind() const
{
    return m_key_5_ind;
}

void cJoystick::setKey_5_ind(int key_5_ind)
{
    m_key_5_ind = key_5_ind;
    emit key_5_indChanged();
}

int cJoystick::key_0_ind() const
{
    return m_key_0_ind;
}

void cJoystick::setKey_0_ind(int key_0_ind)
{
    m_key_0_ind = key_0_ind;
    emit key_0_indChanged();
}

int cJoystick::y2axis_ind() const
{
    return m_y2axis_ind;
}

void cJoystick::setY2axis_ind(int y2axis_ind)
{
    m_y2axis_ind = y2axis_ind;
    emit y2axis_indChanged();
}

int cJoystick::x2axis_ind() const
{
    return m_x2axis_ind;
}

void cJoystick::setX2axis_ind(int x2axis_ind)
{
    m_x2axis_ind = x2axis_ind;
    emit x2axis_indChanged();
}

int cJoystick::y1axis_ind() const
{
    return m_y1axis_ind;
}

void cJoystick::setY1axis_ind(int y1axis_ind)
{
    m_y1axis_ind = y1axis_ind;
    emit y1axis_indChanged();
}

int cJoystick::x1axis_ind() const
{
    return m_x1axis_ind;
}

void cJoystick::setX1axis_ind(int x1axis_ind)
{
    m_x1axis_ind = x1axis_ind;
    emit x1axis_indChanged();
}

// Extracts data from QJoystick class
void cJoystick::pollJoystick()
{

    joy->getdata();
    for(auto i=0;i<_joystick_data->number_axes;i++)
    {
        _joystick_data->axis[i]=joy->axis[i];
    }
    for(auto i=0;i<_joystick_data->number_btn;i++)
    {
        _joystick_data->button[i] = joy->buttons[i];
    }
}
