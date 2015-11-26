#ifndef CAMERA_H
#define CAMERA_H

#include <QObject>
#include <QString>
#include <QTimer>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#define NUMROWS 40 //количество строк таблицы форматов видео
#define USERNAME "user"
#define USERPASS "9999"


class cCamera : public QObject
{
    Q_OBJECT
    //############ адрес и порт
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(bool camerapresent READ camerapresent NOTIFY camerapresentChanged)
    Q_PROPERTY(int videocodec READ videocodec WRITE setVideocodec NOTIFY videocodecChanged) // режим количества видеопотоков
    Q_PROPERTY(int videocodeccombo READ videocodeccombo WRITE setVideocodeccombo NOTIFY videocodeccomboChanged) // режим типов видеопотоков - MPEG, H264
    Q_PROPERTY(int videocodecres READ videocodecres WRITE setVideocodecres NOTIFY videocodecresChanged) // режим разрешения видиопотоков
    Q_PROPERTY(int mirctrl READ mirctrl WRITE setMirctrl NOTIFY mirctrlChanged) // режим зеркалирования изображения
    Q_PROPERTY(QString overlaytext READ overlaytext WRITE setOverlaytext NOTIFY overlaytextChanged)
//====
    Q_PROPERTY(int comby READ comby WRITE setComby NOTIFY combyChanged) // комбинированный режим, доступный для выбора из диалогового окна
//====
    Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
    Q_PROPERTY(int contrast READ contrast WRITE setContrast NOTIFY contrastChanged)
    Q_PROPERTY(int saturation READ saturation WRITE setSaturation NOTIFY saturationChanged)
    Q_PROPERTY(int sharpness READ sharpness WRITE setSharpness NOTIFY sharpnessChanged)
    Q_PROPERTY(int dynrange READ dynrange WRITE setDynrange NOTIFY dynrangeChanged)
    Q_PROPERTY(int colorkiller READ colorkiller WRITE setColorkiller NOTIFY colorkillerChanged)
    Q_PROPERTY(int img2a READ img2a WRITE setImg2a NOTIFY img2aChanged)


//====
    Q_PROPERTY(QString combylist READ combylist  NOTIFY combylistChanged) //Переменная, которая содержит список комбинированных режимов
    Q_PROPERTY(QString codeclist READ codeclist  NOTIFY codeclistChanged) //Переменная, которая содержит список количеств потоков
    Q_PROPERTY(QString codeccombolist READ codeccombolist  NOTIFY codeccombolistChanged) //Переменная, которая содержит список доступных кодеков для текущего режима потоков
    Q_PROPERTY(QString resolutionlist READ resolutionlist  NOTIFY resolutionlistChanged) //Переменная, которая содержит список доступных разрешений для текущего режима потоков
    Q_PROPERTY(QString url1 READ url1 NOTIFY url1Changed) //Корректный URL для просмотра изображения первого потока камеры.
    Q_PROPERTY(QString url2 READ url2 NOTIFY url2Changed) //Корректный URL для просмотра изображения второго потока камеры.
    Q_PROPERTY(bool videopage READ videopage WRITE setVideopage NOTIFY videopageChanged) // переменная для применения настроек комбинированных режимов к камере
    Q_PROPERTY(bool videosettings READ videosettings WRITE setVideosettings NOTIFY videosettingsChanged) // переменная для применения настроек яркости контрастности и проч камере
public:
    explicit cCamera(QObject *parent = 0);
    void setAddress(const QString  &address);
    QString address() const;

    void setPort(const int &port);
    int  port() const;
    bool camerapresent() const;
    //#############
    void setVideocodec(const int &videocodec);
    int  videocodec() const;

    void setVideocodeccombo(const int &videocodeccombo);
    int  videocodeccombo() const;

    void setVideocodecres(const int &videocodecres);
    int  videocodecres() const;

    void setMirctrl(const int &mirctrl);
    int  mirctrl() const;

    void setComby(const int &comby);
    int  comby() const;

    void setOverlaytext(const QString &overlaytext);
    QString  overlaytext() const;

    void setBrightness(const int &brightness);
    int  brightness() const;

    void setContrast(const int &contrast);
    int  contrast() const;

    void setSaturation(const int &saturation);
    int  saturation() const;

    void setSharpness(const int &sharpness);
    int  sharpness() const;

    void setDynrange(const int &dynrange);
    int  dynrange() const;

    void setColorkiller(const int &colorkiller);
    int  colorkiller() const;

    void setImg2a(const int &img2a);
    int  img2a() const;


    //#############
    QString combylist() const;
    QString codeclist() const;
    QString codeccombolist() const;
    QString resolutionlist() const;
    void setVideopage(const bool &videopage);
    bool  videopage() const;
    void setVideosettings(const bool &videosettings);
    bool  videosettings() const;
    QString url1() const;
    QString url2() const;


signals:
    void addressChanged();
    void portChanged();
    void camerapresentChanged();
    void url1Changed();
    void url2Changed();
    void videosettingsChanged();
    void videopageChanged();
    void codeccombolistChanged();
    void resolutionlistChanged();
    void codeclistChanged();
    void videocodecChanged();
    void videocodeccomboChanged();
    void videocodecresChanged();
    void mirctrlChanged();
    void combyChanged();
    void combylistChanged();
    void overlaytextChanged();

    void brightnessChanged();
    void contrastChanged();
    void saturationChanged();
    void sharpnessChanged();
    void dynrangeChanged();
    void colorkillerChanged();
    void img2aChanged();

    void downloaded();
public slots:
    void change_videopage(); //посылаем корректный запрос камере для изменения параметров
    void change_videosettings(); //посылаем корректный запрос камере для изменения установок изображения
    void change_videopagesettings(); // параметры положения текстовых надписей.
    void commit_videosettings(); // по документации необходим вызов функции установки флага
    void commit_multicast();
    void change_combyparametrs(); //изменение параметров при выборе комби режима
    void get_parametrs(); // запросить параметры от камеры.
    void loadINI(QNetworkReply *pReply); //получить параметры от камеры после ответа.   
    void loadResponce(QNetworkReply *pReply);
private:
    //переменные для загрузки INI-файла из камеры.
    QNetworkAccessManager *m_WebCtrl;
    QByteArray m_DownloadedData;
    QStringList m_parametr; //храним все настройки, полученный из камеры в этой структуре.
    QUrl iniUrl; //URL запроса настроек камеры
private:
    QString m_address="192.168.1.168";
    int m_port=8553;
    bool m_camerapresent=false;  //доступна ли камера по сети?
    bool m_videopage;
    bool m_videosettings;
    QString m_url1="rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4";
    QString m_url2="";
    //http://192.168.1.168/vb.htm?videocodec=0&videocodeccombo=0&videocodecres=0&mirctrl=0 HTTP/1.1

//    http://192.168.1.168/vb.htm?videocodec=0&videocodeccombo=0&videocodecres=0&mirctrl=0 HTTP/1.1
//    http://192.168.1.168/vb.htm?framerate1=0&bitrate1=4000&ratecontrol1=1&datestampenable1=0&timestampenable1=0&logoenable1=0&logoposition1=0&textenable1=0&title=VEC-255-IP&textposition1=1&encryptvideo=0&localdisplay=2&overlaytext1=text1&detailinfo1=0 HTTP/1.1
//    http://192.168.1.168/vb.htm?framerate1=0&bitrate1=4000&ratecontrol1=1&datestampenable1=1&timestampenable1=1&logoenable1=0&logoposition1=0&textenable1=0&title=CAM1&textposition1=0&encryptvideo=0&localdisplay=2&overlaytext1=Profile_Number_1981123123&detailinfo1=0 HTTP/1.1"
//    http://192.168.1.168/vb.htm?paratest=reloadflag HTTP/1.1
//    http://192.168.1.168/vb.htm?paratest=multicast HTTP/1.1

    int m_videocodec=0;
    int m_videocodeccombo=1;  //MPEG
    int m_videocodecres=0;
    int m_mirctrl=0;

    int m_datestampenable=1;
    int m_timestampenable=1;
    int m_textenable=1;
    int m_textposition=0;  //0 - Top-Left; 1 - Top-Right
    QString m_overlaytext="Profile_1981123123";
    int m_brightness=127;
    int m_contrast=127;
    int m_saturation=127;
    int m_sharpness=127;
    int m_dynrange=0;
    int m_colorkiller=0; //режим день/ночь
    int m_img2a=1;  // движок баланса белого

//    http://192.168.1.168/vb.htm?brightness=128&contrast=128&saturation=128&sharpness=128&blc=1&dynrange=0&awb=0&colorkiller=1&exposurectrl=1&maxexposuretime=0&maxgain=0&nfltctrl=0&tnfltctrl=0&vidstb1=0&lensdistortcorrection=0&binning=2&img2a=1&backlight=1&histogram=0&img2atype=3&priority=0 HTTP/1.1
//    http://192.168.1.168/vb.htm?paratest=reloadflag HTTP/1.1
//    http://192.168.1.168/vb.htm?paratest=multicast HTTP/1.1

    int m_comby=0; // 0-4 комбинированные режимы согласно таблице
    QString TABLE_COMBY[4]={"Кодек MPEG4 HD 720",
                            "Кодек MPEG4 Full HD 1080",
                            "Кодек H.264 HD 720",
                            "Кодек H.264 Full HD 1080"};

    QTimer timer_check;


    QString TABLE [NUMROWS][6]=
    {
        {"Один поток", "0", "H.264", "0", "H264:720", "0"},
        {"Один поток", "0", "H.264", "0", "H264:D1", "1"},
        {"Один поток", "0", "H.264", "0", "H264:SXVGA", "2"},
        {"Один поток", "0", "H.264", "0", "H264:1080", "3"},
        {"Один поток", "0", "H.264", "0", "H264:720MAX60", "4"},
        {"Один поток", "0", "MPEG4", "1", "MPEG4:720", "0"},
        {"Один поток", "0", "MPEG4", "1", "MPEG4:D1", "1"},
        {"Один поток", "0", "MPEG4", "1", "MPEG4:SXVGA", "2"},
        {"Один поток", "0", "MPEG4", "1", "MPEG4:1080", "3"},
        {"Один поток", "0", "MPEG4", "1", "MPEG4:720MAX60", "4"},
        {"Один поток", "0", "MegaPixel", "2", "H264:2MP", "0"},
        {"Один поток", "0", "MegaPixel", "2", "JPG:2MP", "1"},
        {"Один поток", "0", "MegaPixel", "2", "H264:3MP", "2"},
        {"Один поток", "0", "MegaPixel", "2", "JPG:3MP", "3"},
        {"Один поток", "0", "MegaPixel", "2", "H264:5MP", "4"},
        {"Один поток", "0", "MegaPixel", "2", "JPG:5MP", "4"},
        {"Два потока", "1", "H.264 + JPEG", "0", "H264:720 + JPEG:VGA", "0"},
        {"Два потока", "1", "H.264 + JPEG", "0", "H264:720 + JPEG:D1", "1"},
        {"Два потока", "1", "H.264 + JPEG", "0", "H264:720 + JPEG:720", "2"},
        {"Два потока", "1", "H.264 + JPEG", "0", "H264:1080 + JPEG:QVGA", "3"},
        {"Два потока", "1", "H.264 + JPEG", "0", "H264:1080 + JPEG:D1", "4"},
        {"Два потока", "1", "MPEG4 + JPEG", "1", "MPEG4:720 + JPEG:VGA", "0"},
        {"Два потока", "1", "MPEG4 + JPEG", "1", "MPEG4:720 + JPEG:D1", "1"},
        {"Два потока", "1", "MPEG4 + JPEG", "1", "MPEG4:720 + JPEG:720", "2"},
        {"Два потока", "1", "MPEG4 + JPEG", "1", "MPEG4:1080 + JPEG:QVGA", "3"},
        {"Два потока", "1", "MPEG4 + JPEG", "1", "MPEG4:1080 + JPEG:D1", "4"},
        {"Два потока", "1", "Два потока H.264", "2", "H264:720 + H264:QVGA", "0"},
        {"Два потока", "1", "Два потока H.264", "2", "H264:720 + H264:D1", "1"},
        {"Два потока", "1", "Два потока H.264", "2", "H264:D1 +  H264:QVGA", "2"},
        {"Два потока", "1", "Два потока H.264", "2", "H264:1080 + H264:QVGA", "3"},
        {"Два потока", "1", "Два потока H.264", "2", "H264:1080 + H264:D1", "4"},
        {"Два потока", "1", "Два потока MPEG4", "3", "MPEG4:720 + H264:QVGA", "0"},
        {"Два потока", "1", "Два потока MPEG4", "3", "MPEG4:720 + H264:D1", "1"},
        {"Два потока", "1", "Два потока MPEG4", "3", "MPEG4:D1 +  H264:QVGA", "2"},
        {"Два потока", "1", "Два потока MPEG4", "3", "MPEG4:1080 + H264:QVGA", "3"},
        {"Два потока", "1", "Два потока MPEG4", "3", "MPEG4:1080 + H264:D1", "4"},
        {"Два потока", "1", "H.264 + MPEG4", "4", "H264:720, MPEG4:D1", "0"},
        {"Два потока", "1", "H.264 + MPEG4", "4", "H264:1080, MPEG4:D1", "1"},
        {"Три потока", "2", "Два потока H.264 + JPEG", "0", "H264:720+JPEG:VGA+H264:QVGA", "0"},
        {"Три потока", "2", "Два потока MPEG4 + JPEG", "1", "MPEG4:720+JPEG:VGA+MPEG4:QVGA", "0"}
    };
};

#endif // CAMERA_H
