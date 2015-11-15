#include "camera.h"


cCamera::cCamera(QObject *parent) : QObject(parent)
{
}
    void cCamera::setAddress(const QString  &address)
    {
        m_address = address;
        emit addressChanged();
    }

    QString cCamera::address() const
    {
        return m_address;
    }

    int cCamera::port() const
    {
        return m_port;
    }

    void cCamera::setPort(const int  &port)
    {
        m_port = port;
        emit portChanged();
    }


