#ifndef CAMERA_H
#define CAMERA_H

#include <QObject>
#include <QString>

#define NUMROWS 40


class cCamera : public QObject
{
    Q_OBJECT
    //############ адрес и порт
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(int videocodec READ videocodec WRITE setVideocodec NOTIFY videocodecChanged) // режим количества видеопотоков
    Q_PROPERTY(int videocodeccombo READ videocodeccombo WRITE setVideocodeccombo NOTIFY videocodeccomboChanged) // режим типов видеопотоков - MPEG, H264
    Q_PROPERTY(int videocodecres READ videocodecres WRITE setVideocodecres NOTIFY videocodecresChanged) // режим разрешения видиопотоков
    Q_PROPERTY(int mirctrl READ mirctrl WRITE setMirctrl NOTIFY mirctrlChanged) // режим зеркалирования изображения
    Q_PROPERTY(QString codeclist READ codeclist  NOTIFY codeclistChanged) //Переменная, которая содержит список количеств потоков
    Q_PROPERTY(QString codeccombolist READ codeccombolist  NOTIFY codeccombolistChanged) //Переменная, которая содержит список доступных кодеков для текущего режима потоков
    Q_PROPERTY(QString resolutionlist READ resolutionlist  NOTIFY resolutionlistChanged) //Переменная, которая содержит список доступных разрешений для текущего режима потоков
    Q_PROPERTY(QString url1 READ url1 NOTIFY url1Changed) //Корректный URL для просмотра изображения первого потока камеры.
    Q_PROPERTY(QString url2 READ url2 NOTIFY url2Changed) //Корректный URL для просмотра изображения второго потока камеры.
    Q_PROPERTY(bool videopage READ videopage WRITE setVideopage NOTIFY videopageChanged) // переменная для применения настроек к камере
public:
    explicit cCamera(QObject *parent = 0);
    void setAddress(const QString  &address);
    QString address() const;

    void setPort(const int &port);
    int  port() const;
    //#############
    void setVideocodec(const int &videocodec);
    int  videocodec() const;

    void setVideocodeccombo(const int &videocodeccombo);
    int  videocodeccombo() const;

    void setVideocodecres(const int &videocodecres);
    int  videocodecres() const;

    void setMirctrl(const int &mirctrl);
    int  mirctrl() const;
    //#############
    QString codeclist() const;
    QString codeccombolist() const;
    QString resolutionlist() const;
    void setVideopage(const bool &videopage);
    bool  videopage() const;
    QString url1() const;
    QString url2() const;


signals:
    void addressChanged();
    void portChanged();
    void url1Changed();
    void url2Changed();
    void videopageChanged();
    void codeccombolistChanged();
    void resolutionlistChanged();
    void codeclistChanged();
    void videocodecChanged();
    void videocodeccomboChanged();
    void videocodecresChanged();
    void mirctrlChanged();
public slots:
    void change_videopage();
private:
    QString m_address="192.168.1.168";
    int m_port=8553;
    bool m_videopage;
    QString m_url1="rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4";
    QString m_url2="";
    //http://192.168.1.168/vb.htm?videocodec=0&videocodeccombo=0&videocodecres=0&mirctrl=0 HTTP/1.1

    int m_videocodec=0;
    int m_videocodeccombo=0;
    int m_videocodecres=0;
    int m_mirctrl=0;

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
