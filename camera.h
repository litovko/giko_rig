#ifndef CAMERA_H
#define CAMERA_H

#include <QObject>
#include <QString>

class  cVideopage {
public:
    int videocodec=0;
    int videocodeccombo=0;
    int videocodecres=0;
    int mirctrl=0;
};
class cCamera : public QObject
{
    Q_OBJECT
    //############ адрес и порт
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(cVideopage videopage READ videopage WRITE setVideopage NOTIFY videopageChanged)
    Q_PROPERTY(QString url1 READ url1 NOTIFY url1Changed) //Корректный URL для просмотра изображения первого потока камеры.
    Q_PROPERTY(QString url2 READ url2 NOTIFY url2Changed) //Корректный URL для просмотра изображения второго потока камеры.
public:
    explicit cCamera(QObject *parent = 0);
    void setAddress(const QString  &address);
    QString address() const;

    void setPort(const int &port);
    int  port() const;
    QString url1() const;
    QString url2() const;
    cVideopage videopage() const;
    void setVideopage(const cVideopage &videopage);

signals:
    void addressChanged();
    void videopageChanged();
    void portChanged();
    void url1Changed();
    void url2Changed();
public slots:
private:
    QString m_address="192.168.1.168";
    int m_port=8553;
    QString m_url1="rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4";
    QString m_url2="";
    cVideopage m_videopage;
    //http://192.168.1.168/vb.htm?videocodec=0&videocodeccombo=0&videocodecres=0&mirctrl=0 HTTP/1.1

//const QString urlpref="http://";
};

#endif // CAMERA_H
