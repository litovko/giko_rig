#ifndef CAMERA_H
#define CAMERA_H

#include <QObject>
#include <QString>

class cCamera : public QObject
{
    Q_OBJECT
    //############ адрес и порт
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)

public:
    explicit cCamera(QObject *parent = 0);
    void setAddress(const QString  &address);
    QString address() const;

    void setPort(const int &port);
    int  port() const;
signals:
    void addressChanged();
    void portChanged();
public slots:
private:
    QString m_address="192.168.1.168";
    int m_port=8553;
    //http://192.168.1.168/vb.htm?videocodec=1&videocodeccombo=0&videocodecres=0&mirctrl=0 HTTP/1.1http://
};

#endif // CAMERA_H
