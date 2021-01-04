#ifndef C_ONVIF_H
#define C_ONVIF_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QAuthenticator>
#include <QDateTime>
#include <QVariant>
#include <QDomDocument>
#include <QUrl>

class c_onvif : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString address MEMBER m_address NOTIFY addressChanged)
    Q_PROPERTY(QString user MEMBER m_user NOTIFY userChanged)
    Q_PROPERTY(QString password MEMBER m_password  NOTIFY passwordChanged)
//    QML_ELEMENT
//    QML_NAMED_ELEMENT(ONVIF)
public:
    explicit c_onvif(QObject *parent = nullptr);
    virtual ~c_onvif();

    Q_INVOKABLE void getProfiles();
    Q_INVOKABLE void getProfile(const QString profile);
    Q_INVOKABLE bool getImagingSettings();
    Q_INVOKABLE bool getMoveOptions();
    Q_INVOKABLE bool setZoom(int z);
    Q_INVOKABLE bool startFocal(double z);
    Q_INVOKABLE bool stopFocal();

public slots:
    void finished(QNetworkReply * reply);
    void authenticationRequired(QNetworkReply * reply, QAuthenticator * authenticator);
signals:
    void addressChanged();
    void userChanged();
    void passwordChanged();
    void error(const QString &error);
    void messageReceived(QVariantMap data);
private:
    void readMessage(const QByteArray &data, const QVariant action);
    void addNode(QDomDocument &doc, QDomElement &parent, const QVariantMap &arguments);
    QVariantMap getNode(QDomNode &root);
    void parseError(QDomNode root);
    QDomNode findNode(QDomNode &parent,const QString &name);
    void process_params(const QString func, QDomNode node);
    void process_resp_profile(const QString func, QDomNode node);
private:
    QString m_address;
    QString m_user;
    QString m_password;
    QNetworkAccessManager *p_manager = nullptr;
    QMap <QString, QString> m_parameters;
    void print_params();

};

#endif // C_ONVIF_H
