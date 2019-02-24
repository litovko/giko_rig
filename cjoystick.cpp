#include "cjoystick.h"
#include <QDebug>
#include <QTime>
#include <QSettings>
#define J_POLL_INTERVAL 50
#define J_CHECK_INTERVAL 60000

cJoystick::cJoystick(QObject *parent) : QObject(parent)
{
    //qDebug()<<"cJoystick constructor";
    readSettings();
    timer_joystick = new QTimer(this);
    timer_checkjoystick = new QTimer(this);
    connect(this, SIGNAL(currentChanged()),this, SLOT(change_numbers()));
    connect(timer_checkjoystick,SIGNAL(timeout()),this,SLOT(checkJoystick()));
    checkJoystick();
    timer_checkjoystick->start(J_CHECK_INTERVAL);
//    readSettings();
}
cJoystick::~cJoystick(){
    timer_joystick->stop();
    timer_checkjoystick->stop();
    if (joy)delete joy; joy=0;
    if (timer_joystick) delete timer_joystick;
    if (timer_checkjoystick) delete timer_checkjoystick;
    int n=joystick.length();
    qDebug()<<"Joystick.length:"<<n << "joysavail:" << joysavail;
    saveSettings();
    for(int i=0; i<joysavail;i++) {delete joystick.at(i);}
}

void cJoystick::checkJoystick()
{
    bool old=ispresent();
    if (joy==0){
        joy = new QJoystick();
        qDebug()<<"new QJoystick()";
    }
    joysavail=joy->availableJoysticks();
//    qDebug()<<"Joysticks available: "<<joysavail;
    setIspresent(joysavail);
    qDebug()<<"checkJoystick availbl:"<<joy->availableJoysticks();
    if (old&&ispresent()) {
        //joy->setJoystick(current()); //закрываем и открываем снова джойстик.
        return;
    }
    qDebug()<<"checkJoystick:"<<m_ispresent;
    if (ispresent()) {
        qDebug()<<"Joystick-start";
        init_joysticks();
        connect(timer_joystick,SIGNAL(timeout()),this,SLOT(updateData()));
        timer_joystick->start(J_POLL_INTERVAL);
    }
    else {
        qDebug()<<"Joystick-stop joy:"<<joy;
        timer_joystick->stop();
        disconnect(timer_joystick,SIGNAL(timeout()),this,SLOT(updateData()));
        if (joy) {delete joy; joy=0;}
        qDebug()<<"Joystick-stop joy:"<<joy;
    }
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
    emit currentChanged();

}
void cJoystick::setIspresent (const bool &pr)
{
    //if(pr==m_ispresent) return;
//    setX1axis(0);
//    setX2axis(0);
//    setY1axis(0);
//    setY1axis(0);
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
void cJoystick::init_joysticks()
{
    // Find number of joysticks present
    joysavail=joy->availableJoysticks();
    qDebug()<<"J number:"<<joysavail;
    // Create joysticks list
    for(int i=0;i<joysavail;i++)
    {
        joydata *tempjoy;
        tempjoy = new joydata;
        joystick.append(tempjoy);
    }
    qDebug()<<"Jlist:"<<joystick.length();
    for(int i=0; i<joysavail;i++)
        {
            joy->setJoystick(i);
            // Axes
            joystick.at(i)->number_axes = joy->joystickNumAxes(i);
            joystick.at(i)->name=joy->joystickName(i);
            qDebug()<<"J:"<<i<<" name:"<<joy->joystickName(i)<<" axex:"<<joy->joystickNumAxes(i)<<"buttons:"<<joy->joystickNumButtons(i);
            for(unsigned int j=0; j<joystick.at(i)->number_axes;j++)
            {
                joystick.at(i)->axis.append(0);
            }

            // Buttons
            joystick.at(i)->number_btn  = joy->joystickNumButtons(i);
            qDebug()<<"J"<<i<<"buttons:"<<joy->joystickNumButtons(i);
            for(unsigned int j=0; j<joystick.at(i)->number_btn;j++)
            {
                joystick.at(i)->button.append(false);
            }
        }
//        m_axes_number=joystick.at(current())->number_axes;
//        m_buttons_number=joystick.at(current())->number_btn;
        change_numbers();
//        qDebug()<<"m_y1axis_ind:"<<m_y1axis_ind;
//        qDebug()<<"m_y2axis_ind:"<<m_y2axis_ind;
//        qDebug()<<"m_x1axis_ind:"<<m_x1axis_ind;
//        qDebug()<<"m_x2axis_ind:"<<m_x2axis_ind;
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
//        qDebug()<<"=========================================";
//        qDebug()<<"m_y1axis_ind:"<<m_y1axis_ind;
//        qDebug()<<"m_y2axis_ind:"<<m_y2axis_ind;
//        qDebug()<<"m_x1axis_ind:"<<m_x1axis_ind;
//        qDebug()<<"m_x2axis_ind:"<<m_x2axis_ind;
   //      joy->setJoystick(current());
}

void cJoystick::updateData()
{
    if (!m_ispresent) return;
    pollJoystick();
    if (!m_lock) {
        setY1axis((-joystick.at(current())->axis[m_y1axis_ind]*127/32767)/m_devider);
        setX1axis((joystick.at(current())->axis[m_x1axis_ind]*127/32767)/m_devider);
        setY2axis((-joystick.at(current())->axis[m_y2axis_ind]*127/32767)/m_devider);
        setX2axis((joystick.at(current())->axis[m_x2axis_ind]*127/32767)/m_devider);
    }
    bool b=(joystick.at(current())->button[m_key_0_ind]);
    if (b==!m_key_0) { m_key_0=b; emit key_0Changed();}
    //qDebug()<<"X1:"<<m_x1axis<<" Y1:"<<m_y1axis<<"X2:"<<m_x2axis<<" Y2:"<<m_y2axis<<" B0:"<<m_key_0<<" B1:"<<m_key_1;}
    b=(joystick.at(current())->button[m_key_1_ind]);
    if (b==!m_key_1) { m_key_1=b; emit key_1Changed();}
    b=(joystick.at(current())->button[m_key_2_ind]);
    if (b==!m_key_2) { m_key_2=b; emit key_2Changed();}
    b=(joystick.at(current())->button[m_key_3_ind]);
    if (b==!m_key_3) { m_key_3=b; emit key_3Changed();}
    b=(joystick.at(current())->button[m_key_4_ind]);
    if (b==!m_key_4) { m_key_4=b; emit key_4Changed();}
    b=(joystick.at(current())->button[m_key_5_ind]);
    if (b==!m_key_5) { m_key_5=b; emit key_5Changed();}

}

void cJoystick::change_numbers()
{
    if (!joysavail) return;
//    qDebug()<<"Joystick current:"+current();
    m_axes_number=joystick.at(current())->number_axes;
//    qDebug()<<"Joystick axes:"+m_axes_number;
    m_buttons_number=joystick.at(current())->number_btn;
//    qDebug()<<"Joystick buttons:"+m_buttons_number;
    emit axes_numberChanged();
    emit buttons_numberChanged();
    emit nameChanged();
}

void cJoystick::saveSettings()
{
        //qDebug()<<"Save settings Joystick"<<name();
        QSettings settings("HYCO", "Rig Console");
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
}

void cJoystick::readSettings()
{
    //qDebug()<<"Read settings Joystick";
    QSettings settings("HYCO", "Rig Console");
//    m_axes_number=settings.value("Joystick-axes",0).toInt();
//    m_buttons_number=settings.value("Joystick-buttons",0).toInt();
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
    if (joysavail) return joystick.at(m_current)->name;
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
    for(uint i=0;i<joystick.at(current())->number_axes;i++)
    {
        joystick.at(current())->axis[i]=joy->axis[i];
//        qDebug()<<"J"<<current()<<"axis"<<i<<"val:"<<joystick.at(current())->axis[i];
    }
    for(unsigned int i=0;i<joystick.at(current())->number_btn;i++)
    {
        joystick.at(current())->button[i] = joy->buttons[i];
//        qDebug()<<"J"<<current()<<"btn"<<i<<"val:"<<joystick.at(current())->button[i];
    }
}
