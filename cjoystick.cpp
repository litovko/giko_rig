#include "cjoystick.h"
#include <QDebug>
#include <QTime>
#include <QSettings>
#define J_POLL_INTERVAL 50
#define J_CHECK_INTERVAL 15000

cJoystick::cJoystick(QObject *parent) : QObject(parent)
{
    timer_joystick = new QTimer(this);
    timer_checkjoystick = new QTimer(this);
    connect(this, SIGNAL(currentChanged()),this, SLOT(change_numbers()));
    connect(timer_checkjoystick,SIGNAL(timeout()),this,SLOT(checkJoystick()));
    timer_checkjoystick->start(J_CHECK_INTERVAL);
    readSettings();
}
cJoystick::~cJoystick(){
    timer_joystick->stop();
    timer_checkjoystick->stop();
    if (joy)delete joy; joy=0;
    if (timer_joystick) delete timer_joystick;
    if (timer_checkjoystick) delete timer_checkjoystick;
    int n=joystick.length();
    qDebug()<<"Joystick.length:"<<n << "joysavail:" << joysavail;
    for(int i=0; i<joysavail;i++) {delete joystick.at(i);}
    saveSettings();
}

void cJoystick::checkJoystick()
{
    bool old=ispresent();
    if (joy==0){
        joy = new QJoystick();
        qDebug()<<QTime().currentTime()<<"new QJoystick()";
    }
    joysavail=joy->availableJoysticks();
    setIspresent(joysavail);
    qDebug()<<QTime().currentTime()<<"checkJoystick availbl:"<<joy->availableJoysticks();
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
        change_numbers();
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
    if(pr==m_ispresent) return;
    setX1axis(0);
    setX2axis(0);
    setY1axis(0);
    setY1axis(0);
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
            //qDebug()<<"J"<<i<<"buttons:"<<joy->joystickNumButtons(i);
            for(unsigned int j=0; j<joystick.at(i)->number_btn;j++)
            {
                joystick.at(i)->button.append(false);
            }
        }
   //      joy->setJoystick(current());
}

void cJoystick::updateData()
{
    if (!m_ispresent) return;
    pollJoystick();
    setY1axis(-joystick.at(current())->axis[m_y1axis_ind]*127/32767);
    setX1axis(joystick.at(current())->axis[m_x1axis_ind]*127/32767);
    setY2axis(-joystick.at(current())->axis[m_y2axis_ind]*127/32767);
    setX2axis(joystick.at(current())->axis[m_x2axis_ind]*127/32767);
    bool b=(joystick.at(current())->button[m_key_0_ind]);
    if (b==!m_key_0) { m_key_0=b; emit key_0Changed();
    qDebug()<<"X1:"<<m_x1axis<<" Y1:"<<m_y1axis<<"X2:"<<m_x2axis<<" Y2:"<<m_y2axis<<" B0:"<<m_key_0<<" B1:"<<m_key_1;}
    b=(joystick.at(current())->button[m_key_1_ind]);
    if (b==!m_key_1) { m_key_1=b; emit key_1Changed();}
}

void cJoystick::change_numbers()
{
    qDebug()<<"Joy:"<<"1";
    if (!joysavail) return;
    m_axes_number=joystick.at(current())->number_axes;
    m_buttons_number=joystick.at(current())->number_btn;
    emit axes_numberChanged();
    emit buttons_numberChanged();
    emit nameChanged();
    qDebug()<<"Joy:"<<"2";
}

void cJoystick::saveSettings()
{
        qDebug()<<"Save settings Joystick"<<name();
        QSettings settings("HYCO", "Rig Console");
        settings.setValue("Joystick",name());
        settings.setValue("Joystick-x1",m_x1axis_ind);
        settings.setValue("Joystick-x2",m_x2axis_ind);
        settings.setValue("Joystick-y1",m_y1axis_ind);
        settings.setValue("Joystick-y2",m_y2axis_ind);
        settings.setValue("Joystick-b1",m_key_0_ind);
        settings.setValue("Joystick-b2",m_key_1_ind);
}

void cJoystick::readSettings()
{
    QSettings settings("HYCO", "Rig Console");
    setX1axis_ind(settings.value("Joystick-x1",0).toInt());
    setX2axis_ind(settings.value("Joystick-x2",1).toInt());
    setY1axis_ind(settings.value("Joystick-y1",2).toInt());
    setY2axis_ind(settings.value("Joystick-y2",3).toInt());
    setKey_0_ind(settings.value("Joystick-b1",0).toInt());
    setKey_1_ind(settings.value("Joystick-b2",1).toInt());
    qDebug()<<"Read settings Joystick";
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
    for(unsigned int i=0;i<joystick.at(current())->number_axes;i++)
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
