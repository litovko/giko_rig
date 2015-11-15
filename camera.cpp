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
    QString cCamera::url1() const
    {
        return m_url1;
    }
    QString cCamera::url2() const
    {
        return m_url2;
    }

        void cCamera::setVideopage(const cVideopage  &videopage)
        {
            m_videopage =videopage;
            emit videopageChanged();
        }

        cVideopage cCamera::videopage() const
        {
            return m_videopage;
        }



