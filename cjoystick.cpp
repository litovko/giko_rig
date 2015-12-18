#include "cjoystick.h"
#include <QDebug>
#include <QTime>

#define J_POLL_INTERVAL 200
#define J_CHECK_INTERVAL 15000

cJoystick::cJoystick(QObject *parent) : QObject(parent)
{
    qDebug()<<"Joystick";
    setIspresent(joy->availableJoysticks());
    qDebug()<<"Joystick present:"<<ispresent();
    timer_joystick = new QTimer(this);
    timer_checkjoystick = new QTimer(this);
    connect(timer_checkjoystick,SIGNAL(timeout()),this,SLOT(checkJoystick()));
    timer_checkjoystick->start(J_CHECK_INTERVAL);
}
cJoystick::~cJoystick(){
    if (joy)delete joy;
}

void cJoystick::checkJoystick()
{
    bool old=ispresent();
    if (joy==0){
        joy = new QJoystick();
        qDebug()<<QTime().currentTime()<<"new QJoystick()";
    }
    setIspresent(joy->availableJoysticks());
    qDebug()<<QTime().currentTime()<<"checkJoystick availbl:"<<joy->availableJoysticks();
    if (old&&ispresent()) {
        joy->setJoystick(current()); //закрываем и открываем снова джойстик.
        return;
    }
    qDebug()<<"checkJoystick:"<<m_ispresent;
    if (ispresent()) {
        qDebug()<<"Joystick-start";
        init_joysticks();
        connect(timer_joystick,SIGNAL(timeout()),this,SLOT(updateData()));
        timer_joystick->start(0);
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
            qDebug()<<"J"<<i<<"axex:"<<joy->joystickNumAxes(i);
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
   //      joy->setJoystick(current());
}

void cJoystick::updateData()
{
    if (!m_ispresent) return;
    pollJoystick();
    setY1axis(-joystick.at(current())->axis[1]*127/32767);
    setX1axis(joystick.at(current())->axis[0]*127/32767);
    setY2axis(-joystick.at(current())->axis[3]*127/32767);
    setX2axis(joystick.at(current())->axis[2]*127/32767);
    bool b=(joystick.at(current())->button[0]);
    if (b==!m_key_0) { m_key_0=b; emit key_0Changed();
    qDebug()<<"X1:"<<m_x1axis<<" Y1:"<<m_y1axis<<"X2:"<<m_x2axis<<" Y2:"<<m_y2axis<<" B0:"<<m_key_0<<" B1:"<<m_key_1;}
    b=(joystick.at(current())->button[1]);
    if (b==!m_key_1) { m_key_1=b; emit key_1Changed();}

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
