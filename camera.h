#ifndef CAMERA_H
#define CAMERA_H

#include <QObject>
#include <QString>
#include <QTimer>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#define USERNAME "user"
#define USERPASS "9999"
#define TIMEOUT 10000  // 5 секунд таймаут для установки видеорежимов
#define TIMEOUT_RESET 25000 // 15 sec

class cCamera : public QObject
{
    Q_OBJECT
    //############ адрес и порт
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int index READ index WRITE setIndex NOTIFY indexChanged)
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
    Q_PROPERTY(int img2atype READ img2atype WRITE setImg2atype NOTIFY img2atypeChanged)


//====
    Q_PROPERTY(QString combylist READ combylist  NOTIFY combylistChanged) //Переменная, которая содержит список комбинированных режимов
    Q_PROPERTY(QString codeclist READ codeclist  NOTIFY codeclistChanged) //Переменная, которая содержит список количеств потоков
    Q_PROPERTY(QString codeccombolist READ codeccombolist  NOTIFY codeccombolistChanged) //Переменная, которая содержит список доступных кодеков для текущего режима потоков
    Q_PROPERTY(QString resolutionlist READ resolutionlist  NOTIFY resolutionlistChanged) //Переменная, которая содержит список доступных разрешений для текущего режима потоков
    Q_PROPERTY(QString url1 READ url1 NOTIFY url1Changed) //Корректный URL для просмотра изображения первого потока камеры.
    Q_PROPERTY(QString url2 READ url2 NOTIFY url2Changed) //Корректный URL для просмотра изображения второго потока камеры.
    Q_PROPERTY(bool videopage READ videopage WRITE setVideopage NOTIFY videopageChanged) // переменная для применения настроек комбинированных режимов к камере
    Q_PROPERTY(bool videosettings READ videosettings WRITE setVideosettings NOTIFY videosettingsChanged) // переменная для применения настроек яркости контрастности и проч камере
    Q_PROPERTY(bool videosettings READ videosettings WRITE setVideosettings NOTIFY videosettingsChanged) // переменная для применения настроек яркости контрастности и проч камере
    Q_PROPERTY(bool timeout READ timeout WRITE setTimeout NOTIFY timeoutChanged) // true - когда необходимо подождать выполнения предыдущей команды
    

public:
    explicit cCamera(QObject *parent = 0);
    virtual ~cCamera() {saveSettings();}

    void setTitle(const QString  &title);
    QString title() const;

    void setAddress(const QString  &address);
    QString address() const;

    void setIndex(const int &index);
    int  index() const;
    bool camerapresent() const;
    bool timeout() const;
    void setTimeout(const int  &timeout);
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
    void setImg2atype(const int &img2atype);
    int  img2atype() const;


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
    void titleChanged();
    void addressChanged();
    void indexChanged();
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
    void img2atypeChanged();

    void downloaded();
    void timeoutChanged();
public slots:
    void saveSettings();
    void readSettings();
    void change_videopage(); //посылаем корректный запрос камере для изменения параметров
    void change_videosettings(); //посылаем корректный запрос камере для изменения установок изображения
    void change_videopagesettings(); // параметры положения текстовых надписей.
    void commit_videosettings(); // по документации необходим вызов функции установки флага
    void commit_multicast();
    void change_combyparametrs(); //изменение параметров при выборе комби режима
    Q_INVOKABLE void setTimesettings();
    Q_INVOKABLE void setDateTimesettings();
    Q_INVOKABLE void get_parametrs(); // запросить параметры от камеры.
    Q_INVOKABLE void send_reset();
    void loadINI(QNetworkReply *pReply); //получить параметры от камеры после ответа.   
    void loadResponce(QNetworkReply *pReply);
    void stoptimeout();
private:
    //переменные для загрузки INI-файла из камеры.
    QNetworkAccessManager *m_WebCtrl;
    QByteArray m_DownloadedData;
    QStringList m_parametr; //храним все настройки, полученный из камеры в этой структуре.
    QUrl iniUrl; //URL запроса настроек камеры
private:
    QString m_address;
    QString m_title;
    int m_index=0;
    bool m_camerapresent=false;  //доступна ли камера по сети?
    bool m_videopage;
    bool m_videosettings;
    QString m_url1;//="rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4";
    QString m_url2="";
    int parse_int(QString param);
    int m_videocodec=0;
    int m_videocodeccombo=0;  //H.264
    int m_videocodecres=0;
    int m_mirctrl=0;

    int m_datestampenable=1;
    int m_timestampenable=1;
    int m_textenable=1;
    int m_textposition=0;  //0 - Top-Left; 1 - Top-Right
    QString m_overlaytext;
    int m_brightness=127;
    int m_contrast=127;
    int m_saturation=127;
    int m_sharpness=127;
    int m_dynrange=0;
    int m_colorkiller=0; //режим день/ночь
    int m_img2a=1;  // движок баланса белого
    int m_img2atype=3;
    int m_comby=0; // 0-4 комбинированные режимы согласно таблице
    QString TABLE_COMBY[4]={"Кодек H.264 HD 720",
                            "Кодек H.264 Full HD 1080",
                            "Кодек MPEG4 HD 720",
                            "Кодек MPEG4 Full HD 1080"};
    QTimer timer_check;
    QTimer timer_timeout;
    bool m_timeout=false;



};

#endif // CAMERA_H
