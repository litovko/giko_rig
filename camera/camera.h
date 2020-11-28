#ifndef CAMERA_H
#define CAMERA_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>

enum class ZoomType {
    zoom_in,
    zoom_out,
    zoom_stop,
    unknown
};

class camera : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString address MEMBER m_cam_address NOTIFY addressChanged)
    Q_PROPERTY(QString user MEMBER m_username NOTIFY usernameChanged)
    Q_PROPERTY(QString password MEMBER m_password NOTIFY passwordChanged)
public:
    explicit camera(QObject *parent = nullptr);
    virtual ~camera();
public slots:
    void auth(QNetworkReply* reply, QAuthenticator *authenticator);
    void finished(QNetworkReply* reply);
signals:
    void addressChanged();
    void usernameChanged();
    void passwordChanged();
public:
    Q_INVOKABLE void focus_plus();
    Q_INVOKABLE void focus_plus_stop();
    Q_INVOKABLE void focus_minus();
    Q_INVOKABLE void focus_minus_stop();
    Q_INVOKABLE void zoom_plus();
    Q_INVOKABLE void zoom_plus_stop();
    Q_INVOKABLE void zoom_minus();
    Q_INVOKABLE void zoom_minus_stop();
    Q_INVOKABLE void IR_on();
    Q_INVOKABLE void IR_off();
private:
    void request(QString code, QString attr);
private:
    QString m_cam_address="192.168.1.250";
    QNetworkAccessManager* m_networkManager;
    ZoomType m_zoom_state;
    QString m_username="Admin";
    QString m_password="hyco[123]";
};

#endif // CAMERA_H
