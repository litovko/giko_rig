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
    Q_PROPERTY(bool key_0 READ key_0 NOTIFY key_0Changed)
    Q_PROPERTY(bool key_1 READ key_1 NOTIFY key_1Changed)
    Q_PROPERTY(bool key_2 READ key_2 NOTIFY key_2Changed)
    Q_PROPERTY(bool key_3 READ key_3 NOTIFY key_3Changed)
    Q_PROPERTY(bool key_4 READ key_4 NOTIFY key_4Changed)
    Q_PROPERTY(bool key_5 READ key_5 NOTIFY key_5Changed)
    Q_PROPERTY(int x1axis_ind READ x1axis_ind  WRITE setX1axis_ind NOTIFY x1axis_indChanged)
    Q_PROPERTY(int y1axis_ind READ y1axis_ind  WRITE setY1axis_ind NOTIFY y1axis_indChanged)
    Q_PROPERTY(int x2axis_ind READ x2axis_ind  WRITE setX2axis_ind NOTIFY x2axis_indChanged)
    Q_PROPERTY(int y2axis_ind READ y2axis_ind  WRITE setY2axis_ind NOTIFY y2axis_indChanged)
    Q_PROPERTY(bool ispresent READ ispresent WRITE setIspresent  NOTIFY ispresentChanged)
    Q_PROPERTY(bool lock READ lock WRITE setLock  NOTIFY lockChanged)
    Q_PROPERTY(int devider READ devider WRITE setDevider NOTIFY deviderChanged) //делитель выходных значений джойстика
    Q_PROPERTY(int key_0_ind READ key_0_ind WRITE setKey_0_ind NOTIFY key_0_indChanged)
    Q_PROPERTY(int key_1_ind READ key_1_ind WRITE setKey_1_ind NOTIFY key_1_indChanged)
    Q_PROPERTY(int key_2_ind READ key_2_ind WRITE setKey_2_ind NOTIFY key_2_indChanged)
    Q_PROPERTY(int key_3_ind READ key_3_ind WRITE setKey_3_ind NOTIFY key_3_indChanged)
    Q_PROPERTY(int key_4_ind READ key_4_ind WRITE setKey_4_ind NOTIFY key_4_indChanged)
    Q_PROPERTY(int key_5_ind READ key_5_ind WRITE setKey_5_ind NOTIFY key_5_indChanged)
    Q_PROPERTY(int axes_number READ axes_number NOTIFY axes_numberChanged)
    Q_PROPERTY(int buttons_number READ buttons_number NOTIFY buttons_numberChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
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
    bool key_2();
    bool key_3();
    bool key_4();
    bool key_5();
    bool ispresent();
    void setX1axis(const int &axis);
    void setY1axis(const int &axis);
    void setX2axis(const int &axis);
    void setY2axis(const int &axis);
    void setIspresent (const bool &pr);
    void setCurrent(const int &current);
    int x1axis_ind() const;
    void setX1axis_ind(int x1axis_ind);

    int y1axis_ind() const;
    void setY1axis_ind(int y1axis_ind);

    int x2axis_ind() const;
    void setX2axis_ind(int x2axis_ind);

    int y2axis_ind() const;
    void setY2axis_ind(int y2axis_ind);

    int key_0_ind() const;
    void setKey_0_ind(int key_0_ind);

    int key_1_ind() const;
    void setKey_1_ind(int key_1_ind);

    int key_2_ind() const;
    void setKey_2_ind(int key_2_ind);

    int key_3_ind() const;
    void setKey_3_ind(int key_3_ind);

    int key_4_ind() const;
    void setKey_4_ind(int key_4_ind);

    int key_5_ind() const;
    void setKey_5_ind(int key_5_ind);

    int axes_number() const;

    int buttons_number() const;
    QString name() const;

    bool lock() const;
    void setLock(bool lock);

    int devider() const;
    void setDevider(int devider);

signals:
    void x1axisChanged();
    void y1axisChanged();
    void x2axisChanged();
    void y2axisChanged();
    void key_0Changed();
    void key_1Changed();
    void key_2Changed();
    void key_3Changed();
    void key_4Changed();
    void key_5Changed();
    void x1axis_indChanged();
    void y1axis_indChanged();
    void x2axis_indChanged();
    void y2axis_indChanged();
    void key_0_indChanged();
    void key_1_indChanged();
    void key_2_indChanged();
    void key_3_indChanged();
    void key_4_indChanged();
    void key_5_indChanged();
    void axes_numberChanged();
    void buttons_numberChanged();
    void ispresentChanged();
    void lockChanged();
    void deviderChanged();
    void currentChanged();
    void nameChanged();
public slots:
//    void readJoystickState();
    void checkJoystick();
    void updateData();
    void change_numbers();
    void saveSettings();
    void readSettings();
private:
    QJoystick *joy=0;
    bool m_ispresent=false;
    bool m_lock=false;
    int  m_devider=1;
    QTimer *timer_joystick=0;
    QTimer *timer_checkjoystick=0;
    int m_x1axis=0;
    int m_y1axis=0;    
    int m_x2axis=0;
    int m_y2axis=0;
    int m_current=0;
    bool m_key_0=false;
    bool m_key_1=false;
    bool m_key_2=false;
    bool m_key_3=false;
    bool m_key_4=false;
    bool m_key_5=false;
    int m_x1axis_ind=0;
    int m_y1axis_ind=1;
    int m_x2axis_ind=2;
    int m_y2axis_ind=3;
    int m_key_0_ind=0;
    int m_key_1_ind=1;
    int m_key_2_ind=2;
    int m_key_3_ind=3;
    int m_key_4_ind=4;
    int m_key_5_ind=5;
    int m_axes_number=0;
    int m_buttons_number=0;
    struct joydata{
        unsigned int number_axes;
        unsigned int number_btn;
        QList<int> axis;
        QList<bool> button;
        QString name;
    };
    // Available joystick count. Only set at initialization
    int joysavail=0;

    // List of joystick data
    QList<joydata*> joystick;
    void pollJoystick();
    void init_joysticks();
};

#endif // CJOYSTICK_H
