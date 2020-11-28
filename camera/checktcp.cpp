#include "checktcp.h"
#include <QHostAddress>
#include <QTimer>
#include <QMetaEnum>

CheckTCP::CheckTCP(QObject *parent) : QObject(parent)
{
    _socket = new QTcpSocket;
    connect(_socket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SLOT(slotState(QAbstractSocket::SocketState)));
    _timer = new QTimer;
    connect(_timer, SIGNAL(timeout()), this, SLOT(check()));
    _timer->start(_check_intreval);

}

CheckTCP::~CheckTCP()
{
    if (_socket != nullptr) {
        _socket->abort();
        delete _socket;
//        _socket->deleteLater();
    }
    if (_timer != nullptr)
        delete _timer;
//        _timer->deleteLater();
}

void CheckTCP::check(QString adr, int port)
{
//    qDebug()<<adr<<port<<_socket->state();
    if(_socket->state() != QAbstractSocket::UnconnectedState) return;
    //    _socket->connectToHost(QHostAddress(adr) , port, QAbstractSocket::ReadWrite);
    _socket->connectToHost(adr, port, QIODevice::ReadWrite, QAbstractSocket::IPv4Protocol);
    _state = StatesType::Connecting;
    QTimer::singleShot(_connect_timeout, this, SLOT (slotTimeout()));

}

void CheckTCP::slotState(QAbstractSocket::SocketState socketState)
{
//    qDebug()<<"slotStateChanged:"<<socketState;
    switch (socketState) {
    case QAbstractSocket::ConnectedState:
        if (!_ok) {
            _ok=true;
            emit okChanged();
        }
        _state=StatesType::Idle;
        _socket->abort();

        break;
    case QAbstractSocket::UnconnectedState:
        if(_state==StatesType::Connecting) {
            if (_ok) {
                _ok=false;
                emit okChanged();
            }
        }
        break;
    }
}

void CheckTCP::slotTimeout()
{
    if (_state == StatesType::Connecting) {
        _state = StatesType::Idle;
        if (_ok) {
            _ok=false;
            emit okChanged();
        }
        _socket->abort();
    }
}

void CheckTCP::check()
{
    check(_address, _port);
}

int CheckTCP::check_intreval() const
{
    return _check_intreval;
}

void CheckTCP::setCheck_intreval(int check_intreval)
{
    _check_intreval = check_intreval;
    _timer->stop();
    _timer->start(_check_intreval);
    emit intervalChanged();
}

int CheckTCP::connect_timeout() const
{
    return _connect_timeout;
}

void CheckTCP::setConnect_timeout(int connect_timeout)
{
    _connect_timeout = connect_timeout;
}
