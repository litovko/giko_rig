#include "cjoystick.h"
#include <QDebug>
#include <QTime>
#include <QSettings>
#include <QCoreApplication>
#define J_POLL_INTERVAL 50
#define J_CHECK_INTERVAL 20000

cJoystick::cJoystick(QObject *parent) : QObject(parent)
{
    readSettings();
    timer_joystick = new QTimer(this);
    timer_checkjoystick = new QTimer(this);
    connect(this, SIGNAL(currentChanged()),this, SLOT(change_numbers()));
    connect(timer_checkjoystick,SIGNAL(timeout()),this,SLOT(checkJoystick()));
    //connect(this, &cJoystick::keyChanged, this, []( int k ) { qDebug()<<"k:"<<k; });
    init_joystick();
    //checkJoystick();
    timer_checkjoystick->start(J_CHECK_INTERVAL);
    //    readSettings();
}
cJoystick::~cJoystick(){
    timer_joystick->stop();
    timer_checkjoystick->stop();
    if (joy)delete joy; joy=nullptr;
    if (timer_joystick) delete timer_joystick;
    if (timer_checkjoystick) delete timer_checkjoystick;
    //    int n=joystick.length();
    //    qDebug()<<"Joystick.length:"<<n << "joysavail:" << joysavail;
    saveSettings();
    if (_joystick_data) delete _joystick_data;
    //for(int i=0; i<joysavail;i++) {delete joystick.at(i);}
}

void cJoystick::checkJoystick()
{
    if (ispresent()) {
        if (joy->availableJoysticks()==m_joysticks_avail)
            return;
        else {
            clear_joystick();
            init_joystick();
        }
    }
    else init_joystick();

}
void cJoystick::setX1axis(const int &axis)
{
    if (axis==m_x1axis) return;
    m_x1axis=axis;
//    qDebug()<<"X1:"<<m_x1axis;
    emit x1axisChanged();
}

void cJoystick::setY1axis(const int &axis)
{
    if (axis==m_y1axis) return;
    m_y1axis=axis;
//    qDebug()<<"Y1:"<<m_y1axis;
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
    //qDebug()<<"J current"<<current;
    emit currentChanged();

}
void cJoystick::setIspresent (const bool &pr)
{
//    m_key_0=!pr; //устанавливаем кнопку "Fire" в нажатое состояние для управления с помощью мышки и клавиатуры.
//    emit key_0Changed();
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

//bool cJoystick::key_0()
//{
//    return m_key_0;
//}

//bool cJoystick::key_1()
//{
//    return m_key_1;
//}

//bool cJoystick::key_2()
//{
//    return m_key_2;
//}

//bool cJoystick::key_3()
//{
//    return m_key_3;
//}

//bool cJoystick::key_4()
//{
//    return m_key_4;
//}

//bool cJoystick::key_5()
//{
//    return m_key_5;
//}
// Initialize Joystick information
// Get # of joysticks available
// Populate # of axes and buttons
void cJoystick::init_joystick()
{
    if(current()<0) return;
    readSettings();
    if (joy==nullptr){
        joy = new QJoystick();
        qDebug()<<"Joystick Number:"<<current()<<"new QJoystick:"<<joy;
        //setIspresent(true);
    }
    m_joysticks_avail=joy->availableJoysticks();
    qDebug()<<"Joysticks available:"<<m_joysticks_avail;
    if (current()==0 && m_joysticks_avail>0)
        setIspresent(true);
    else if (current()==1 && m_joysticks_avail>1)
                setIspresent(true);
            else
                setIspresent(false);
    if (!ispresent()) {
        qWarning()<<"Joystick "<<current()<<" not present!!!";
        clear_joystick();

        return;
    }
    // Create joysticks data
    if (_joystick_data) delete _joystick_data;
    _joystick_data = new joydata;
    int i=current();
    {
        joy->setJoystick(i);
        // Axes
        setAxes_number(_joystick_data->number_axes = joy->joystickNumAxes(i));
        _joystick_data->name=joy->joystickName(i);
        qDebug()<<"J:"<<i<<" name:"<<joy->joystickName(i)<<" axex:"<<joy->joystickNumAxes(i)<<"buttons:"<<joy->joystickNumButtons(i)<<"hats:"<<joy->joystickNumHats(i);
        for(auto j=0; j<_joystick_data->number_axes;j++)
        {
            _joystick_data->axis.append(0);
        }
        // Buttons
        setButtons_number( _joystick_data->number_btn  = joy->joystickNumButtons(i));
        //qDebug()<<"J"<<i<<"buttons:"<<joy->joystickNumButtons(i);
        for(auto j=0; j<_joystick_data->number_btn;j++)
        {
            _joystick_data->button.append(false);
        }
        // Hats
        setHats_number(_joystick_data->number_hats = joy->joystickNumHats(i));
        //qDebug()<<"J"<<i<<"hats:"<<joy->joystickNumHats(i);
        for(auto j=0; j<_joystick_data->number_hats;j++)
        {
            _joystick_data->hat.append(0);
        }
        if (_joystick_data->number_hats==0) _joystick_data->hat.append(0); //NOTE: сделано чтобы не передавать пустой список в QML для борьбы с адресацией к пустому списку.
        //WARNING: Некоторый трюк для избавления от первой HAT у джойстика LOGITECH - преобразуем первую кепку HAT в простые кнопки - 4 кнопоки на каждую кепку HAT.
        if (_joystick_data->number_hats) {
            setButtons_number(buttons_number()+4);
            for (auto j=0; j<4; j++) _joystick_data->button.append(false);
        }
    }

    if (m_y1axis_ind>m_axes_number-1) setY1axis_ind(0);
    if (m_x1axis_ind>m_axes_number-1) setX1axis_ind(0);
    if (m_y2axis_ind>m_axes_number-1) setY2axis_ind(0);
    if (m_x2axis_ind>m_axes_number-1) setX2axis_ind(0);
//    if (m_key_0_ind>m_buttons_number-1) setKey_0_ind(0);
//    if (m_key_1_ind>m_buttons_number-1) setKey_1_ind(0);
//    if (m_key_2_ind>m_buttons_number-1) setKey_2_ind(0);
//    if (m_key_3_ind>m_buttons_number-1) setKey_3_ind(0);
//    if (m_key_4_ind>m_buttons_number-1) setKey_4_ind(0);
//    if (m_key_5_ind>m_buttons_number-1) setKey_5_ind(0);
    emit axes_numberChanged();
    emit buttons_numberChanged();
    emit nameChanged();
    connect(timer_joystick,SIGNAL(timeout()),this,SLOT(updateData()));
    timer_joystick->start();
}

void cJoystick::clear_joystick()
{
    if (joy) {
        timer_joystick->stop();
        disconnect(timer_joystick,SIGNAL(timeout()),this,SLOT(updateData()));
        delete joy;
        joy=nullptr;

    }
    if (_joystick_data) delete _joystick_data;
    _joystick_data=nullptr;
    setIspresent(false);
    m_joysticks_avail=0;
    m_axes_number=0;
    m_buttons_number=0;
    emit axes_numberChanged();
    emit buttons_numberChanged();
    emit nameChanged();
}

QList<bool> cJoystick::invert() const
{
//    qDebug()<<"m_invert_read:"<<m_invert;
    return m_invert;
}

void cJoystick::setInvert(const QList<bool> &invert)
{
    m_invert = invert;
//    qDebug()<<"m_invert_write:"<<m_invert;
    emit invertChanged();
}

void cJoystick::updateData()
{
    if (!joy) return;
    pollJoystick();
    if (!m_lock) {
        setY1axis(((m_invert[m_y1axis_ind]?-1:1) * _joystick_data->axis[m_y1axis_ind]*127/32767)/m_devider);
        setX1axis(((m_invert[m_x1axis_ind]?-1:1) * _joystick_data->axis[m_x1axis_ind]*127/32767)/m_devider);
        setY2axis(((m_invert[m_y2axis_ind]?-1:1) * _joystick_data->axis[m_y2axis_ind]*127/32767)/m_devider);
        setX2axis(((m_invert[m_x2axis_ind]?-1:1) * _joystick_data->axis[m_x2axis_ind]*127/32767)/m_devider);
    }

    bool keyschanged =false;
    for (auto i=0; i<buttons_number(); i++ ){
        if (_buttons.length()==0) {_buttons = _joystick_data->button; break;} //TODO: надо  перенести в инициализацию джойстика
        if (_buttons[i]!=_joystick_data->button[i]){
            emit keyChanged(key_map[i]);
            _buttons[i] = _joystick_data->button[i];
            keyschanged=true;
        }
    }
    if (keyschanged) emit keysChanged();
    for (auto i=0; i<_joystick_data->number_hats; i++ ) {
        //qDebug()<<"H"<<_hats<<"HH"<<_joystick_data->hat;
        //qDebug()<<"H"<<_hats[0]<<"HH"<<_joystick_data->hat[0];
        if (_hats.length()==0) {_hats=_joystick_data->hat; break;}
        if (_hats[i]!=_joystick_data->hat[i])
        {
            emit hatsChanged();
            //qDebug()<<"H"<<_hats[0]<<"HH"<<_joystick_data->hat[0];
            _hats = _joystick_data->hat;
            break;
        }
    }

}

void cJoystick::change_numbers()
{
    timer_joystick->stop();
    init_joystick();
//    emit axes_numberChanged();
//    emit buttons_numberChanged();
//    emit nameChanged();
}

void cJoystick::saveSettings()
{

    if (current()<0) return;
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("joystick_"+QString::number(current()));
    settings.setValue("Joystick",name());
    settings.setValue("Joystick-axes",m_axes_number);
    settings.setValue("Joystick-buttons",m_buttons_number);
    settings.setValue("Joystick-hats",m_hats_number);
    settings.setValue("Joystick-x1",m_x1axis_ind);
    settings.setValue("Joystick-x2",m_x2axis_ind);
    settings.setValue("Joystick-y1",m_y1axis_ind);
    settings.setValue("Joystick-y2",m_y2axis_ind);


    for (auto i=0; i<key_map.size(); i++)
        settings.setValue("Joystick-bn"+QString::number(i),key_map[i]);
    for (auto i=0; i<m_invert.length(); i++)
        settings.setValue("Joystick-axes-ivert"+QString::number(i),m_invert[i]);
    settings.endGroup();
}

void cJoystick::readSettings()
{
    if (current()<0) return;
    QSettings settings("HYCO", QCoreApplication::applicationName());
    settings.beginGroup("joystick_"+QString::number(current()));
    setX1axis_ind(settings.value("Joystick-x1",0).toInt());
    setX2axis_ind(settings.value("Joystick-x2",1).toInt());
    setY1axis_ind(settings.value("Joystick-y1",2).toInt());
    setY2axis_ind(settings.value("Joystick-y2",3).toInt());

    for (auto i=0; i<key_map.size(); i++)
        key_map[i]=settings.value("Joystick-bn"+QString::number(i)).toInt();
    for (auto i=0; i<m_invert.length(); i++)
        m_invert[i]=settings.value("Joystick-axes-ivert"+QString::number(i)).toBool();
    settings.endGroup();
//    qDebug()<<key_map;
}

int cJoystick::map(int ind)
{
    return key_map[ind];
}

void cJoystick::setmap(int ind, int id)
{
    key_map[ind]=id;
}

int cJoystick::hats_number() const
{
    return m_hats_number;
}

void cJoystick::setHats_number(int hats_number)
{
    m_hats_number = hats_number;
    emit hats_numberChanged();
}

void cJoystick::setButtons_number(int buttons_number)
{
    m_buttons_number = buttons_number;
    emit buttons_numberChanged();
}

QList<bool> cJoystick::keys()
{
    QList<bool> _buttons;
    for (auto i=0;i<buttons_number(); i++)
        _buttons.append(_joystick_data->button[key_map[i]]);
//    qDebug()<<"IB>"<<_joystick_data->button;
//    qDebug()<<"CB>"<<_buttons;
    return _buttons;
}

QList<int> cJoystick::hats()
{
    if (!_joystick_data) qDebug()<<"JOYSTICK_DATA _NULL_PTR!!!" ;
    return  _joystick_data->hat;
}

void cJoystick::setAxes_number(int axes_number)
{
    m_axes_number = axes_number;
    emit axes_numberChanged();
}

int cJoystick::devider() const
{
    return m_devider;
}

void cJoystick::setDevider(int devider)
{
    m_devider = devider;
    emit deviderChanged();
}

bool cJoystick::lock() const
{
    return m_lock;
}

void cJoystick::setLock(bool lock)
{
    if (m_lock==lock) return;
    m_lock = lock;
    qDebug()<<"Joystick Lock";
    emit lockChanged();
}


int cJoystick::buttons_number() const
{
    return m_buttons_number;
}

QString cJoystick::name() const
{
    if (_joystick_data) return _joystick_data->name;
    else return "Джойстик не найден";
}

int cJoystick::axes_number() const
{
    return m_axes_number;
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
    for(auto i=0;i<_joystick_data->number_axes;i++)
    {
        _joystick_data->axis[i]=joy->axis[i];
    }
    for(auto i=0;i<_joystick_data->number_btn;i++)
    {
        _joystick_data->button[i] = joy->buttons[i];
    }
    for(auto i=0;i<_joystick_data->number_hats;i++)
    {
        _joystick_data->hat[i] = joy->hats[i];
    }
    if (_joystick_data->number_hats) { //WARNING: преобразование первой кепки кепок в 4 кнопки - проставляем значения.
        for (auto j=0; j<4; j++) {
            _joystick_data->button[_joystick_data->number_btn+j]=(_joystick_data->hat[0]) & (1 << j);
        }
    }
}
