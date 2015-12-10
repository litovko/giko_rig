#include "cjoystick.h"
#include <QDebug>

cJoystick::cJoystick(QObject *parent) : QObject(parent)
{

    m_ispresent = input.initInput(0);
    emit ispresentChanged();
    //emit key_0Changed();
    qDebug()<<"Joystick present:"<<m_ispresent;
    if (m_ispresent) {
        timer_joystick = new QTimer(this);

        connect(timer_joystick,SIGNAL(timeout()),this,SLOT(readJoystickState()));
        timer_joystick->start(0);
    }
//    else {
//        m_xaxis=0; m_yaxis=0;
//        timer_joystick = new QTimer(this);
//        timer_checkjoystick = new QTimer(this);
//        connect(timer_checkjoystick,SIGNAL(timeout()),this,SLOT(checkJoystick()));
//        timer_checkjoystick->start(15000);
//    }
}
void cJoystick::checkJoystick()
{
    m_ispresent = input.initInput(0);
    qDebug()<<"Joystick"<<" "<<"0"<<" check:"<<m_ispresent;
    qDebug()<<"Joystick"<<" "<<"1"<<" check:"<<input.initInput(1);
    emit ispresentChanged();
    if (m_ispresent) {
    connect(timer_joystick,SIGNAL(timeout()),this,SLOT(readJoystickState()));
    timer_joystick->start(0);
    }
    else {
        timer_joystick->stop();
        disconnect(timer_joystick,SIGNAL(timeout()),this,SLOT(readJoystickState()));
    }

}

bool cJoystick::ispresent()
{
    return m_ispresent;
}

int cJoystick::xaxis()
{
    return m_xaxis;
}

int cJoystick::yaxis()
{
    return m_yaxis;
}

bool cJoystick::key_0()
{
    return m_key_0;
}

void cJoystick::readJoystickState()
{
    //qDebug()<<"is present"<<m_ispresent;
    if (!input.updateState()) return;

    // Update main axes

    m_yaxis=-input.getVertical()*127;
    emit yaxisChanged();
    m_xaxis=input.getHorizontal()*127;
    emit xaxisChanged();
    bool k=input.isKeyPressed(0);
    if (k!=m_key_0) {
        m_key_0=k;
        emit key_0Changed();
    }

}
