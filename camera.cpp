#include "camera.h"
#include <QDebug>

cCamera::cCamera(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(videopageChanged()),this, SLOT(change_videopage()));
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
    //#############
    int cCamera::videocodec() const
    {
        return m_videocodec;
    }

    void cCamera::setVideocodec(const int  &videocodec)
    {
        m_videocodec = videocodec;
        emit videocodecChanged();
    }

    int cCamera::videocodeccombo() const
    {
        return m_videocodec;
    }

    void cCamera::setVideocodeccombo(const int  &videocodeccombo)
    {
        m_videocodeccombo = videocodeccombo;
        emit videocodeccomboChanged();
    }

    int cCamera::videocodecres() const
    {
        return m_videocodecres;
    }

    void cCamera::setVideocodecres(const int  &videocodecres)
    {
        m_videocodecres = videocodecres;
        emit videocodecresChanged();
    }

    int cCamera::mirctrl() const
    {
        return m_mirctrl;
    }

    void cCamera::setMirctrl(const int  &mirctrl)
    {
        m_mirctrl = mirctrl;
        emit mirctrlChanged();
    }

    //#############

    bool cCamera::videopage() const
    {
        return m_videopage;
    }

    void cCamera::setVideopage(const bool  &videopage)
    {
        m_videopage = videopage;
        emit videopageChanged();
    }
    QString cCamera::url1() const
    {
        return m_url1;
    }
    QString cCamera::url2() const
    {
        return m_url2;
    }

    void cCamera::change_videopage()
    {
        QString s;
        s="http://"+m_address+"/vb.htm?videocodec="+::QString().number(m_videocodec,10)
                +"&videocodeccombo=" +::QString().number(m_videocodeccombo,10)
                +"&videocodecres=" +::QString().number(m_videocodecres,10)
                +"&mirctrl=" +::QString().number(m_mirctrl,10)
                +" HTTP/1.1";
        qDebug()<<"changevideo: "<<s;
        qDebug()<<"codeccombolist"<<codeccombolist();
    }

    QString cCamera::codeclist() const
    {
        QString s, c;
        int i;
        s="";
        c="";
        for (i=0; i<NUMROWS; i++) {
            if (c!=TABLE[i][0]) {
                c=TABLE[i][0];
                s=s+c+",";
            }
        }
        i=s.length();
        if (s.at(i-1)==',') s=s.left(i-1);
        qDebug()<<s;
        return s;
    }

    QString cCamera::codeccombolist() const
    {
        QString s, c;
        int i;
        s="";
        c="";
        for (i=0; i<NUMROWS; i++) {
            if ((TABLE[i][1]==::QString().number(m_videocodec,10))&&c!=TABLE[i][2]) {
                c=TABLE[i][2];
                s=s+c+",";
            }
        }
        i=s.length();
        if (s.at(i-1)==',') s=s.left(i-1);
        qDebug()<<s;
        return s;
    }

    QString cCamera::resolutionlist() const
    {
        QString s, c;
        int i;
        s="";
        c="";
        for (i=0; i<NUMROWS; i++) { //пробегаем по всему списку и выбираем возможные значения разрешений для выбранных видеопотока и кодека
            if (    (TABLE[i][1]==::QString().number(m_videocodec,10))
                 && (TABLE[i][3]==::QString().number(m_videocodeccombo,10))
                 && c!=TABLE[i][4]
                )
            {
                c=TABLE[i][4];
                s=s+c+",";
            }
        }
        i=s.length();
        if (s.at(i-1)==',') s=s.left(i-1);
        return s;
    }


