#ifndef CJOYSTICK_H
#define CJOYSTICK_H

#include <QObject>
#include <QTimer>
#include "qJoyStick.h"

class cJoystick : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int current READ current  WRITE setCurrent NOTIFY currentChanged)
    Q_PROPERTY(int x1axis READ x1axis  WRITE setX1axis NOTIFY x1axisChanged)
    Q_PROPERTY(int y1axis READ y1axis  WRITE setY1axis NOTIFY y1axisChanged)
    Q_PROPERTY(int x2axis READ x2axis  WRITE setX2axis NOTIFY x2axisChanged)
    Q_PROPERTY(int y2axis READ y2axis  WRITE setY2axis NOTIFY y2axisChanged)
    Q_PROPERTY(bool ispresent READ ispresent WRITE setIspresent  NOTIFY ispresentChanged)
    Q_PROPERTY(bool key_0 READ key_0 NOTIFY key_0Changed)
    Q_PROPERTY(bool key_1 READ key_1 NOTIFY key_1Changed)
public:
    explicit cJoystick(QObject *parent = 0);
    ~cJoystick();
    int x1axis();
    int y1axis();
    int x2axis();
    int y2axis();
    int current();
    bool key_0();
    bool key_1();
    bool ispresent();
    void setX1axis(const int &axis);
    void setY1axis(const int &axis);
    void setX2axis(const int &axis);
    void setY2axis(const int &axis);
    void setIspresent (const bool &pr);
    void setCurrent(const int &current);
signals:
    void x1axisChanged();
    void y1axisChanged();
    void x2axisChanged();
    void y2axisChanged();
    void key_0Changed();
    void key_1Changed();
    void ispresentChanged();
    void currentChanged();
public slots:
//    void readJoystickState();
    void checkJoystick();
    void updateData();
private:
    QJoystick *joy=0;
    bool m_ispresent=false;
    QTimer *timer_joystick;
    QTimer *timer_checkjoystick;
    int m_x1axis=0;
    int m_y1axis=0;
    int m_x2axis=0;
    int m_y2axis=0;
    int m_current=0;
    bool m_key_0=false;
    bool m_key_1=false;
    struct joydata{
        unsigned int number_axes;
        unsigned int number_btn;
        QList<int> axis;
        QList<bool> button;
    };
    // Available joystick count. Only set at initialization
    int joysavail;

    // List of joystick data
    QList<joydata*> joystick;
    void pollJoystick();
    void init_joysticks();
};

#endif // CJOYSTICK_H
