#ifndef CJOYSTICK_H
#define CJOYSTICK_H

#include <QObject>
#include <QTimer>
#include <QVariant>
#include "qJoyStick.h"

class cJoystick : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int current READ current  WRITE setCurrent NOTIFY currentChanged)
    Q_PROPERTY(int x1axis READ x1axis  WRITE setX1axis NOTIFY x1axisChanged)
    Q_PROPERTY(int y1axis READ y1axis  WRITE setY1axis NOTIFY y1axisChanged)
    Q_PROPERTY(int x2axis READ x2axis  WRITE setX2axis NOTIFY x2axisChanged)
    Q_PROPERTY(int y2axis READ y2axis  WRITE setY2axis NOTIFY y2axisChanged)

    Q_PROPERTY(int x1axis_ind READ x1axis_ind  WRITE setX1axis_ind NOTIFY x1axis_indChanged)
    Q_PROPERTY(int y1axis_ind READ y1axis_ind  WRITE setY1axis_ind NOTIFY y1axis_indChanged)
    Q_PROPERTY(int x2axis_ind READ x2axis_ind  WRITE setX2axis_ind NOTIFY x2axis_indChanged)
    Q_PROPERTY(int y2axis_ind READ y2axis_ind  WRITE setY2axis_ind NOTIFY y2axis_indChanged)
    Q_PROPERTY(bool ispresent READ ispresent WRITE setIspresent  NOTIFY ispresentChanged)
    Q_PROPERTY(bool lock READ lock WRITE setLock  NOTIFY lockChanged)
    Q_PROPERTY(int devider READ devider WRITE setDevider NOTIFY deviderChanged) //делитель выходных значений джойстика

    Q_PROPERTY(int axes_number READ axes_number NOTIFY axes_numberChanged)
    Q_PROPERTY(int buttons_number READ buttons_number NOTIFY buttons_numberChanged)
    Q_PROPERTY(int hats_number READ buttons_number NOTIFY buttons_numberChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QList<bool> keys READ keys NOTIFY keysChanged) // KEYS
    Q_PROPERTY(QList<QString> names READ names NOTIFY namesChanged) // KEY NAMES
    Q_PROPERTY(QList<int> hats READ hats NOTIFY hatsChanged)
    Q_PROPERTY(QList<bool> invert READ invert WRITE setInvert NOTIFY invertChanged )

public:
    explicit cJoystick(QObject *parent = nullptr);
    ~cJoystick();
    int x1axis();
    int y1axis();
    int x2axis();
    int y2axis();
    int current();

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

    void setAxes_number(int axes_number);

    void setButtons_number(int buttons_number);
    QList<bool> keys();
    QList<QString> names();
    QList<int> hats();
    int hats_number() const;
    void setHats_number(int hats_number);

    QList<bool> invert() const;
    void setInvert(const QList<bool> &invert);

signals:
    void x1axisChanged();
    void y1axisChanged();
    void x2axisChanged();
    void y2axisChanged();

    void x1axis_indChanged();
    void y1axis_indChanged();
    void x2axis_indChanged();
    void y2axis_indChanged();

    void axes_numberChanged();
    void buttons_numberChanged();
    void hats_numberChanged();
    void ispresentChanged();
    void lockChanged();
    void deviderChanged();
    void currentChanged();
    void nameChanged();
    void keysChanged();
    void namesChanged();
    void keyChanged(int key);
    void hatsChanged();
    void invertChanged();
public slots:
//    void readJoystickState();
    void checkJoystick();
    void updateData();
    void change_numbers();
    void saveSettings();
    void readSettings();
    Q_INVOKABLE int map(int ind);
    Q_INVOKABLE void setmap(int ind, int id);
    Q_INVOKABLE void set_button_name(int ind, QString name);
private:
    QJoystick *joy=nullptr;
    bool m_ispresent=false;
    bool m_lock=false;
    int  m_devider=1;
    QTimer *timer_joystick=nullptr;
    QTimer *timer_checkjoystick=nullptr;
    int m_x1axis=0;
    int m_y1axis=0;    
    int m_x2axis=0;
    int m_y2axis=0;
    int m_current=-1;
    int m_x1axis_ind=0;
    int m_y1axis_ind=1;
    int m_x2axis_ind=2;
    int m_y2axis_ind=3;

    QMap<int,int> key_map={  // первая позиция - номер кнопки в программе IND , вторая позиция - ID физической кнопки
        {0,0}, {1,1}, {2,2}, {3,3}, {4,4},
        {5,5}, {6,6}, {7,7}, {8,8}, {9,9},
        {10,10}, {11,11}, {12,12}, {13,13}, {14,14},
        {15,15}, {16,16}, {17,17}, {18,18}, {19,19},
        {20,20}, {21,21}, {22,22}, {23,23}, {24,24},

    };
    QMap<int, QString>key_name_map={
        {0,"Курок"},
//        {1,"Имя 2"}, {2,"Имя 3"}, {3,"Имя 4"}, {4,"Имя 5"},
//        {5,"Имя 6"}, {6,"Имя 7"}, {7,"Имя 8"}, {8,"Имя 9"}, {9,"Имя 10"},
//        {10,"Имя 11"}, {11,"Имя 12"}, {12,"Имя 13"}, {13,"Имя 14"}, {14,"Имя 15"},
//        {15,"Имя 16"}, {16,"Имя 17"}, {17,"Имя 18"}, {18,"Имя 19"}, {19,"Имя 20"},
//        {20,"Имя 21"}, {21,"Имя 22"}, {22,"Имя 23"}, {23,"Имя 24"}, {24,"Имя 25"},
    };
    int m_axes_number=0;
    int m_buttons_number=0;
    int m_hats_number=0;
    struct joydata{
        int number_axes;
        int number_btn;
        int number_hats;
        QList<int> axis;
        QList<bool> button;
        QList<int> hat;
        QString name;
    };
    // Available number of joysticks.
    int m_joysticks_avail=0;
    joydata* _joystick_data=nullptr;
    void pollJoystick();
    void init_joystick();
    void clear_joystick();
    //QMap<int,QString> joy_map;
    QList<bool> _buttons;
    QList<int> _hats;
    QList<bool> m_invert={false, false, false, false};
};

#endif // CJOYSTICK_H
