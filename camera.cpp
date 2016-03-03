#include "camera.h"
#include <QDebug>
#include <QSettings>
#include <QTime>
#include <QDateTime>
#include <QFileInfo>


#define TIMER_CHECK 60000
cCamera::cCamera(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(indexChanged()),this, SLOT(readSettings()));
    connect(this, SIGNAL(videopageChanged()),this, SLOT(change_videopage()));
    connect(this, SIGNAL(videosettingsChanged()),this, SLOT(change_videosettings()));
    connect(this, SIGNAL(combyChanged()),this, SLOT(change_combyparametrs()));
    connect(&timer_check, SIGNAL(timeout()), this, SLOT(get_parametrs()));
    timer_check.start(TIMER_CHECK);
}
void cCamera::saveSettings()
{
    qDebug()<<"Save settings Cam"<<QString::number(m_index)<<":"<<"Cam"<<QString::number(m_index)<<":"<<"saveSettings addres:"<<m_address<<"Enabled:"<<m_cameraenabled;
    QSettings settings("HYCO", "Rig Console");
    settings.setValue("Cam"+QString::number(m_index)+"Address",m_address);
    settings.setValue("Cam"+QString::number(m_index)+"Comby",m_comby);
    settings.setValue("Cam"+QString::number(m_index)+"OverlayText",m_overlaytext);
    settings.setValue("Cam"+QString::number(m_index)+"Enabled",m_cameraenabled);
    settings.setValue("Cam"+QString::number(m_index)+"Title",m_title);
    settings.setValue("Cam"+QString::number(m_index)+"Histogram",m_histogram);
}
void cCamera::readSettings()
{
    QSettings settings("HYCO", "Rig Console");
    setAddress(settings.value("Cam"+QString::number(m_index)+"Address","192.168.1.168").toString());
    setTitle(settings.value("Cam"+QString::number(m_index)+"Title","Cam"+QString::number(m_index)).toString());
    setComby(settings.value("Cam"+QString::number(m_index)+"Comby",0).toInt());
    setCameraenabled(settings.value("Cam"+QString::number(m_index)+"Enabled",false).toBool());
    m_url1=url1(); //меняем строку запуска камеры
    setOverlaytext(settings.value("Cam"+QString::number(m_index)+"OverlayText","Cam"+QString::number(m_index)).toString());
    setHistogram(settings.value("Cam"+QString::number(m_index)+"Histogram",0).toInt());
    qDebug()<<"Read settings Cam"<<QString::number(m_index)<<":"<<"Cam"<<QString::number(m_index)<<":"<<"readSettings addres:"<<m_address;
}
void cCamera::setTitle(const QString  &title)
{
    m_title = title;
    emit titleChanged();
}

QString cCamera::title() const
{
    return m_title;
}

    void cCamera::setAddress(const QString  &address)
    {
        m_address = address;
        m_url1=url1();
        m_camerapresent=false;
        emit url1Changed();
        emit addressChanged();
        emit camerapresentChanged();
    }

    QString cCamera::address() const
    {
        return m_address;
    }

    int cCamera::index() const
    {
        return m_index;
    }
    bool cCamera::camerapresent() const
    {
        return m_camerapresent;
    }
    bool cCamera::cameraenabled() const
    {
        return m_cameraenabled;
    }
    void cCamera::setCameraenabled(const bool &enable) {
        m_cameraenabled=enable;
        emit cameraenabledChanged();
    }

    void cCamera::setIndex(const int  &index)
    {
        m_index = index;
        get_parametrs();
        emit indexChanged();
        //emit addressChanged();
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
        m_url1=url1();
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

    int cCamera::img2atype() const
    {
        return m_img2atype;
    }

    void cCamera::setImg2atype(const int  &img2atype)
    {
        m_img2atype = img2atype;
        emit img2atypeChanged();
    }

    bool cCamera::timeout() const
    {
        return m_timeout;
    }

    void cCamera::setTimeout(const int  &timeout)
    {
        m_timeout = true;
        emit timeoutChanged();
        timer_timeout.singleShot(timeout,this, SLOT(stoptimeout()));
    }

    void cCamera::stoptimeout()
    {
        m_timeout=false;
        emit timeoutChanged();
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
        if(m_videocodeccombo==1) s="rtsp://"+m_address+":8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4";
        if(m_videocodeccombo==0) s="rtsp://"+m_address+":8557/PSIA/Streaming/channels/2?videoCodecType=H.264";
        //qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"Cam"<<QString::number(m_index)<<":"<<"url1(): url потока камеры:"<< s;
        return s;
    }
    QString cCamera::url2() const
    {
        return m_url2;
    }

    void cCamera::change_videopage()
    {
        if (m_index==0||timeout()||!m_cameraenabled) return;
        setTimeout(TIMEOUT);
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
        m_url1=url1();
        emit url1Changed();  //при изменении настроке видеопотоков меняется  url для видео.
        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"Cam"<<QString::number(m_index)<<":"<<"Поменяли настройки в соответствии с комбо-режимом: "<<s;
        //change_videopagesettings();
    }
    void cCamera::change_videopagesettings()
    {
        if (m_index==0||timeout()||!m_cameraenabled) return;
        QString s;
        s="http://" + m_address
                + "/vb.htm?framerate1=0&bitrate1=4000&ratecontrol1=1&datestampenable1="+::QString().number(m_datestampenable,10)
                + "&timestampenable1=" + ::QString().number(m_timestampenable,10)
                + "&logoenable1=0&logoposition1=0&textenable1="+::QString().number(m_textenable, 10)
                + "&title=" + m_title
                + "&textposition1="+::QString().number(m_textposition,10)
                + "&encryptvideo=0&localdisplay=2&overlaytext1=" + m_overlaytext
                + "&detailinfo1=0 HTTP/1.1";

        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"urlchange_videopagesettings:"<<s;
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
    void cCamera::setTimesettings()
    {
        if (m_index==0||timeout()||!m_cameraenabled) return;
        setTimeout(TIMEOUT);
        QString s;
        s="http://" + m_address
                + "/vb.htm?timefrequency=-1&daylight=0&timezone=15&dateformat=2&tstampformat=1&dateposition=0&timeposition=0 HTTP/1.1";
        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"setTimesettings():"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
    }
    //http://192.168.1.168/vb.htm?newdate=2012/12/09&newtime=13:18:33&dateformat=2&tstampformat=1&dateposition=0&timeposition=0
    void cCamera::setDateTimesettings()
    {
        if (timeout()) return; else setTimeout(TIMEOUT);
        if (m_index==0||!m_cameraenabled) return;
        QString s;
        QDateTime t;
        s="http://" + m_address
                + "/vb.htm?newdate=" +t.currentDateTime().toString("yyyy/MM/dd")
                + "&newtime="+t.currentDateTime().toString("HH:mm:ss")
                + "&dateformat=2&tstampformat=1&dateposition=0&timeposition=0"
                + " HTTP/1.1";
        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"setDateTimesettings():"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
    }

    void cCamera::change_videosettings()
    {
        if (m_index==0||timeout()||!m_cameraenabled) return;
        QString s;
        s="http://"+m_address+"/vb.htm?brightness="+::QString().number(m_brightness,10)
                +"&contrast="+::QString().number(m_contrast,10)
                +"&saturation="+::QString().number(m_saturation,10)
                +"&sharpness="+::QString().number(m_sharpness,10)
                +"&blc=1&dynrange=0&awb=0&colorkiller="+::QString().number(m_colorkiller,10)
                +"&exposurectrl=1&maxexposuretime=0&maxgain=0&nfltctrl=0&tnfltctrl=0&vidstb1=0&lensdistortcorrection=0&binning=2"
                +"&img2a="+::QString().number(m_img2a,10)
                +"&backlight=1"
                +"&histogram=0"
                +"&img2atype="+::QString().number(m_img2atype,10)
                +"&priority=0 HTTP/1.1";
        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"urlchange_videosettings:"<<s;
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

        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"commit:"<<s;
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

        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"commit multicast:"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
    }
    void cCamera::send_reset()
    {
        if (timeout()) return; else setTimeout(TIMEOUT_RESET);
        QString s;
        s="http://"+m_address+"/vb.htm?ipcamrestartcmd";

        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"restart:"<<s;
        QUrl iniUrl(s);
        iniUrl.setPassword(USERPASS);
        iniUrl.setUserName(USERNAME);
        QNetworkRequest request(iniUrl);
        m_WebCtrl= new QNetworkAccessManager(this); //litovko достаточно ли одной переменной???
        connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadResponce(QNetworkReply*)));
        QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
    }

    int cCamera::get_filesize()
    {
        QFileInfo info(m_recordfile);
        return info.size();
    }
    void cCamera::loadResponce(QNetworkReply *pReply)
    {
        qDebug()<<"Cam"<<QString::number(m_index)<<" responce:"<<pReply->readAll();
        pReply->deleteLater();
    }

    void cCamera::change_combyparametrs()
    {
        //qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"comby changed:"<<m_comby;

        if (m_comby==2) {m_videocodec=0; m_videocodeccombo=1; m_videocodecres=0; }
        if (m_comby==3) {m_videocodec=0; m_videocodeccombo=1; m_videocodecres=3; }
        if (m_comby==0) {m_videocodec=0; m_videocodeccombo=0; m_videocodecres=0; }
        if (m_comby==1) {m_videocodec=0; m_videocodeccombo=0; m_videocodecres=3; }
    }

    QString cCamera::combylist() const
    {
        QString s= TABLE_COMBY[0]+","+TABLE_COMBY[1]+","+TABLE_COMBY[2]+","+TABLE_COMBY[3];
        //qDebug()<<"Cam"<<QString::number(m_index)<<"combylist():"<<s;
        return s;
    }


    QString cCamera::codeclist() const
    {
        QString s="нет данных";
        return s;
    }

    QString cCamera::codeccombolist() const
    {
        QString s="нет данных";
        return s;
    }

    QString cCamera::resolutionlist() const
    {
        QString s="нет данных";
        return s;
    }

    void cCamera::get_parametrs()
    {

       if (m_index==0||timeout()||!m_cameraenabled) return;
       QUrl iniUrl("http://"+m_address+"/ini.htm");  //http://192.168.1.168/ini.htm
       qDebug()<<"Cam"<<QString::number(m_index)<<" get_parametrs by URL:" << iniUrl<<QTime().currentTime();
       iniUrl.setPassword(USERPASS);
       iniUrl.setUserName(USERNAME);
       QNetworkRequest request(iniUrl);
       m_WebCtrl= new QNetworkAccessManager(this);
       qDebug()<<m_WebCtrl;
       connect(m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (loadINI(QNetworkReply*)));
       qDebug()<<request.url();
       QNetworkReply *p= m_WebCtrl->get(request);  // в этом месте создается объект QNetworkReply!!!
       qDebug()<<"get_parametrs()- end"<<m_index;
    }
    int cCamera::parse_int(QString param){
        QRegExp rx("^("+param+"=.*)");
        QString s=m_parametr.at(m_parametr.indexOf(rx)); //qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"loadINI videocodeccombo:"<<s;
        QStringList sl=s.split("=");
        s=sl.at(1);
        bool ok; int c,r;
        c=s.toInt(&ok,10);
        if (ok) return c;
        return 0;
    }
    QString cCamera::parse_string(QString param){
        QRegExp rx("^("+param+"=.*)");
        QString s=m_parametr.at(m_parametr.indexOf(rx)); //qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"loadINI videocodeccombo:"<<s;
        QStringList sl=s.split("=");
        return sl.at(1);
    }
    
    QString cCamera::recordfile() const
    {
        return m_recordfile;
    }
    
    void cCamera::setRecordfile(const QString &recordfile)
    {
        m_recordfile = recordfile;
        emit recordfileChanged();
    }
    
    void cCamera::setHistogram(int histogram)
    {
        m_histogram = histogram;
        histogramChanged();
    }


    
    int cCamera::histogram() const
    {
        return m_histogram;
    }


    void cCamera::loadINI(QNetworkReply* pReply)
    {
        qDebug()<<"loadINI: Cam"<<QString::number(m_index)<<":"<<"!!1";
        if (pReply->error()!=QNetworkReply::NoError ) {
            qWarning()<<"Cam"<<QString::number(m_index)<<":"<<"Camera unavailable:"<<pReply->errorString();
//            qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"!!8";
            m_camerapresent=false;
            emit camerapresentChanged();
        }
        else
        {
            m_DownloadedData.clear();
            m_DownloadedData = pReply->readAll();
            m_parametr.clear(); m_parametr=::QString(m_DownloadedData).split("<br>",QString::SkipEmptyParts);
            m_camerapresent=true;  emit camerapresentChanged();
            int c,r;
            c=parse_int("videocodeccombo"); setVideocodeccombo(c);
            r=parse_int("videocodecres"); setVideocodecres(r);
            if (c==0&&r==0) m_comby=0;
            if (c==0&&r==3) m_comby=1;
            if (c==1&&r==0) m_comby=2;
            if (c==1&&r==3) m_comby=3;
            emit combyChanged();
            setBrightness(parse_int("brightness"));
            setContrast(parse_int("contrast"));
            setSaturation(parse_int("saturation"));
            setSharpness(parse_int("sharpness"));
            setColorkiller(parse_int("colorkiller"));
            setImg2a(parse_int("img2a"));
            setImg2atype(parse_int("img2atype"));
            setOverlaytext(parse_string("overlaytext1"));//overlaytext1
//            qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"!!3";
        }
//        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"!!4";
        pReply->deleteLater();
//        m_WebCtrl->deleteLater();
//        qDebug()<<"Cam"<<QString::number(m_index)<<":"<<"!!5";
}

