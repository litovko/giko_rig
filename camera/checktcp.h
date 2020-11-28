#ifndef CHECKTCP_H
#define CHECKTCP_H
#include <QTcpSocket>
#include <QObject>
#include <qabstractsocket.h>
#include <QTimer>

enum class StatesType
  {
     Idle,
     Connecting,
     Disconnecting
  };


class CheckTCP : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool ok MEMBER _ok NOTIFY okChanged)
    Q_PROPERTY(QString address MEMBER _address NOTIFY addressChanged)
    Q_PROPERTY(int port MEMBER _port NOTIFY portChanged)
    Q_PROPERTY(int interval READ check_intreval  WRITE setCheck_intreval NOTIFY intervalChanged)
    Q_PROPERTY(int timeout MEMBER _connect_timeout NOTIFY timeoutChanged)
public:
    explicit CheckTCP(QObject *parent = nullptr);
    virtual ~CheckTCP();
    Q_INVOKABLE void check(QString adr, int port);

    int connect_timeout() const;
    void setConnect_timeout(int connect_timeout);

    int check_intreval() const;
    void setCheck_intreval(int check_intreval);

public slots:
    void slotState(QAbstractSocket::SocketState socketState );
    void slotTimeout();
    void check();
signals:
    void okChanged();
    void addressChanged();
    void portChanged();
    void intervalChanged();
    void timeoutChanged();
private:
    QString _address;
    int _port;
    QTcpSocket* _socket=nullptr;
    bool _ok=false;
    int _connect_timeout = 3000;
    int _check_intreval = 10000;
    StatesType _state = StatesType::Idle;
    QTimer *_timer = nullptr;
};

#endif // CHECKTCP_H
