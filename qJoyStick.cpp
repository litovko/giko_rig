#include "qjoystick.h"

#include <QDebug>

#define POLL_INTERVAL 40

QJoystick::QJoystick()
{

    SDL_Init( SDL_INIT_JOYSTICK | SDL_INIT_GAMECONTROLLER);
    //SDL_Init( SDL_INIT_JOYSTICK);
}

//int QJoystick::currentJoystick()
//{
//    return SDL_JoystickIndex(m_joystick);
//}

QString QJoystick::joystickName(int js)
{
    Q_ASSERT(js < availableJoysticks());
    Q_ASSERT(js >= 0);
    return QString(SDL_JoystickNameForIndex(js));
}

int QJoystick::joystickNumAxes(int js)
{
    Q_ASSERT(js < availableJoysticks());
    Q_ASSERT(js >= 0);
    return (SDL_JoystickNumAxes(m_joystick));
}

int QJoystick::joystickNumButtons(int js)
{
    Q_ASSERT(js < availableJoysticks());
    Q_ASSERT(js >= 0);
    return (SDL_JoystickNumButtons(m_joystick));
}


void QJoystick::setJoystick(int js)
{
    Q_ASSERT(js < availableJoysticks());
    Q_ASSERT(js >= 0);
qDebug()<<"setJoystick:"<<m_joystick;
    if (m_joystick)SDL_JoystickClose(m_joystick);
qDebug()<<"closedJoystick availbl:"<<SDL_NumJoysticks();
    m_joystick = SDL_JoystickOpen(js);

qDebug()<<"setJoystick new m_joystick:"<<m_joystick;

}

QJoystick::~QJoystick()
{
    axis.clear();
    buttons.clear();
    SDL_JoystickClose(m_joystick);
    SDL_QuitSubSystem(SDL_INIT_VIDEO | SDL_INIT_JOYSTICK);
    //this->deleteLater();
}


int QJoystick::availableJoysticks()
{
     return SDL_NumJoysticks();
}

void QJoystick::getdata()
{
    axis.clear();
    buttons.clear();


        SDL_Event event;
    SDL_PollEvent(&event);

    for(int i=0;i<SDL_JoystickNumAxes(m_joystick);i++)
    {
        axis.append(SDL_JoystickGetAxis(m_joystick,i));

    }



    for(int i=0;i<SDL_JoystickNumButtons(m_joystick);i++)
    {
        buttons.append(SDL_JoystickGetButton(m_joystick,i));

    }
}
