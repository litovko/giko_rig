#include "cjoystick.h"
#include <QDebug>

cJoystick::cJoystick(QObject *parent) : QObject(parent)
{

    m_ispresent = input.initInput(0);
    emit ispresentChanged();
    //emit key_0Changed();
    qDebug()<<"constructor m_key_0:"<<m_key_0;
    if (m_ispresent) {
        timer_joystick = new QTimer(this);

        connect(timer_joystick,SIGNAL(timeout()),this,SLOT(readJoystickState()));
        timer_joystick->start(0);
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
