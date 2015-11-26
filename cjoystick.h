#ifndef CJOYSTICK_H
#define CJOYSTICK_H

#include <QObject>
#include <QTimer>
#include "xinputGamepad.h"

class cJoystick : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int xaxis READ xaxis  NOTIFY xaxisChanged)
    Q_PROPERTY(int yaxis READ yaxis  NOTIFY yaxisChanged)
    Q_PROPERTY(bool ispresent READ ispresent NOTIFY ispresentChanged)
    Q_PROPERTY(bool key_0 READ key_0 NOTIFY key_0Changed)
public:
    explicit cJoystick(QObject *parent = 0);
    int xaxis();
    int yaxis();
    bool key_0();
    bool ispresent();
signals:
    void xaxisChanged();
    void yaxisChanged();
    void key_0Changed();
    void ispresentChanged();
public slots:
    void readJoystickState();
private:
    XInput input;
    bool m_ispresent=false;
    QTimer *timer_joystick;
    int m_xaxis;
    int m_yaxis;
    bool m_key_0=false;
};

#endif // CJOYSTICK_H
