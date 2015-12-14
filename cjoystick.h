#ifndef CJOYSTICK_H
#define CJOYSTICK_H

#include <QObject>
#include <QTimer>
#include "xinputGamepad.h"

class cJoystick : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int xaxis READ xaxis  WRITE setXaxis NOTIFY xaxisChanged)
    Q_PROPERTY(int yaxis READ yaxis  WRITE setYaxis NOTIFY yaxisChanged)
    Q_PROPERTY(bool ispresent READ ispresent WRITE setIspresent  NOTIFY ispresentChanged)
    Q_PROPERTY(bool key_0 READ key_0 NOTIFY key_0Changed)
    Q_PROPERTY(bool key_1 READ key_1 NOTIFY key_1Changed)
public:
    explicit cJoystick(QObject *parent = 0);
    int xaxis();
    int yaxis();
    bool key_0();
    bool key_1();
    bool ispresent();
    void setXaxis(const int &axis);
    void setYaxis(const int &axis);
    void setIspresent (const bool &pr);
signals:
    void xaxisChanged();
    void yaxisChanged();
    void key_0Changed();
    void key_1Changed();
    void ispresentChanged();
public slots:
    void readJoystickState();
    void checkJoystick();
private:
    XInput input;
    bool m_ispresent=false;
    QTimer *timer_joystick;
    QTimer *timer_checkjoystick;
    int m_xaxis;
    int m_yaxis;
    bool m_key_0=false;
    bool m_key_1=false;
};

#endif // CJOYSTICK_H
