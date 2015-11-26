#include "camera.h"
#include <QDebug>



cCamera::cCamera(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(videopageChanged()),this, SLOT(change_videopage()));
    connect(this, SIGNAL(videosettingsChanged()),this, SLOT(change_videosettings()));
    connect(this, SIGNAL(combyChanged()),this, SLOT(change_combyparametrs()));
    connect(&timer_check, SIGNAL(timeout()), this, SLOT(get_parametrs()));

    timer_check.start(60000);

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
    bool cCamera::camerapresent() const
    {
        return m_camerapresent;
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

    int cCamera::comby() const
    {
        return m_comby;
    }

    void cCamera::setComby(const int  &comby)
    {
        m_comby = comby;
        emit combyChanged();
    }

    void cCamera::setOverlaytext(const QString  &overlaytext)
    {
        m_overlaytext = overlaytext;
        emit overlaytextChanged();
    }

    QString cCamera::overlaytext() const
    {
        return m_overlaytext;
    }

    int cCamera::brightness() const
    {
        return m_brightness;
    }

    void cCamera::setBrightness(const int  &brightness)
    {
        m_brightness = brightness;
        emit brightnessChanged();
    }

    int cCamera::contrast() const
    {
        return m_contrast;
    }

    void cCamera::setContrast(const int  &contrast)
    {
        m_contrast = contrast;
        emit contrastChanged();
    }

    int cCamera::saturation() const
    {
        return m_saturation;
    }

    void cCamera::setSaturation(const int  &saturation)
    {
        m_saturation = saturation;
        emit saturationChanged();
    }


    int cCamera::sharpness() const
    {
        return m_sharpness;
    }

    void cCamera::setSharpness(const int  &sharpness)
    {
        m_sharpness = sharpness;
        emit sharpnessChanged();
    }

    int cCamera::dynrange() const
    {
        return m_dynrange;
    }

    void cCamera::setDynrange(const int  &dynrange)
    {
        m_dynrange = dynrange;
        emit dynrangeChanged();
    }

    int cCamera::colorkiller() const
    {
        return m_colorkiller;
    }

    void cCamera::setColorkiller(const int  &colorkiller)
    {
        m_colorkiller = colorkiller;
        emit colorkillerChanged();
    }

    int cCamera::img2a() const
    {
        return m_img2a;
    }

    void cCamera::setImg2a(const int  &img2a)
    {
        m_img2a = img2a;
        emit img2aChanged();
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
    bool cCamera::videosettings() const
    {
        return m_videosettings;
    }

    void cCamera::setVideosettings(const bool  &videosettings)
    {
        m_videosettings = videosettings;
        emit videosettingsChanged();
    }
    QString cCamera::url1() const
    {
        QString s;
        //"rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4";
        //"rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264"
        if(m_videocodeccombo==1) s="rtsp://"+m_address+":8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4";
        if(m_videocodeccombo==0) s="rtsp://"+m_address+":8557/PSIA/Streaming/channels/2?videoCodecType=H.264";
        qDebug()<<"url потока камеры:"<< s;
        return s;
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
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
        //emit url1Changed();  //при изменении настроке видеопотоков меняется  url для видео.
        qDebug()<<"Поменяли настройки в соответствии с комбо-режимом: "<<s;
        //change_videopagesettings();
    }
    void cCamera::change_videopagesettings()
    {
        QString s;
        s="http://" + m_address
                + "/vb.htm?framerate1=0&bitrate1=4000&ratecontrol1=1&datestampenable1="+::QString().number(m_datestampenable,10)
                + "&timestampenable1=" + ::QString().number(m_timestampenable,10)
                + "&logoenable1=0&logoposition1=0&textenable1="+::QString().number(m_textenable, 10)
                + "&title=CAM1&textposition1="+::QString().number(m_textposition,10)
                + "&encryptvideo=0&localdisplay=2&overlaytext1=" + m_overlaytext
                + "&detailinfo1=0 HTTP/1.1";

        qDebug()<<"urlchange_videopagesettings:"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
        //commit_videosettings();
        //commit_multicast();
    }
    void cCamera::change_videosettings()
    {
        QString s;
        s="http://"+m_address+"/vb.htm?brightness="+::QString().number(m_brightness,10)
                +"&contrast="+::QString().number(m_contrast,10)
                +"&saturation="+::QString().number(m_saturation,10)
                +"&sharpness="+::QString().number(m_sharpness,10)
                +"&blc=1&dynrange=0&awb=0&colorkiller="+::QString().number(m_colorkiller,10)
                +"&exposurectrl=1&maxexposuretime=0&maxgain=0&nfltctrl=0&tnfltctrl=0&vidstb1=0&lensdistortcorrection=0&binning=2"
                +"&img2a="+::QString().number(m_img2a,10)
                +"&backlight=1&histogram=0&img2atype=3&priority=0 HTTP/1.1";
        qDebug()<<"urlchange_videosettings:"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
        change_videopagesettings(); //поставил только для смены названия профиля.
    }
    void cCamera::commit_videosettings()
    {
        QString s;
        // http://192.168.1.168/vb.htm?paratest=reloadflag HTTP/1.1
        s="http://"+m_address+"/vb.htm?paratest=reloadflag HTTP/1.1";

        qDebug()<<"commit:"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
    }

    void cCamera::commit_multicast()
    {
        QString s;
     //    http://192.168.1.168/vb.htm?paratest=multicast HTTP/1.1
        s="http://"+m_address+"/vb.htm?paratest=multicast HTTP/1.1";

        qDebug()<<"commit multicast:"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
    }
    void cCamera::loadResponce(QNetworkReply *pReply)
    {
        //
        qDebug()<<"Сигнал завершения выполнения запроса установки параметров";
        qDebug()<<pReply->readAll();
        pReply->deleteLater();
    }

    void cCamera::change_combyparametrs()
    {
        qDebug()<<"comby changed:"<<m_comby;

        if (m_comby==0) {m_videocodec=0; m_videocodeccombo=1; m_videocodecres=0; }
        if (m_comby==1) {m_videocodec=0; m_videocodeccombo=1; m_videocodecres=3; }
        if (m_comby==2) {m_videocodec=0; m_videocodeccombo=0; m_videocodecres=0; }
        if (m_comby==3) {m_videocodec=0; m_videocodeccombo=0; m_videocodecres=3; }
    }

    QString cCamera::combylist() const
    {
        QString s= TABLE_COMBY[0]+","+TABLE_COMBY[1]+","+TABLE_COMBY[2]+","+TABLE_COMBY[3];
        qDebug()<<s;
        return s;
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
    void cCamera::get_parametrs()
    {

       QUrl iniUrl("http://"+m_address+"/ini.htm");  //http://192.168.1.168/ini.htm
       iniUrl.setPassword(USERPASS);
       iniUrl.setUserName(USERNAME);
       QNetworkRequest request(iniUrl);
       m_WebCtrl= new QNetworkAccessManager(this);
       connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadINI(QNetworkReply*)));
       QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
    }
    void cCamera::loadINI(QNetworkReply* pReply)
    {
        qDebug()<<"!!1";
        if (pReply->error()!=QNetworkReply::NoError ) {
            emit camerapresentChanged();
            qDebug()<<"Камера недоступна:"<<pReply->errorString();
            qDebug()<<"!!8";
            m_camerapresent=false;
            emit camerapresentChanged();
        }
        else
        {
            m_DownloadedData.clear();
            m_DownloadedData = pReply->readAll();
            qDebug()<<"!!2";
            m_parametr.clear();
            m_parametr=::QString(m_DownloadedData).split("<br>",QString::SkipEmptyParts);
            m_camerapresent=true;
            emit camerapresentChanged();
            QRegExp rx("^(title.*)");
            qDebug()<<m_parametr.count()<<"parametуrs readed from camera"<<m_parametr.indexOf(rx);
            //qDebug()<<m_parametr;
            qDebug()<<"!!3";
        }
        qDebug()<<"!!4";
        pReply->deleteLater();
//        m_WebCtrl->deleteLater();
        qDebug()<<"!!5";
    }



