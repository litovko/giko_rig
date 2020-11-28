#ifndef RTCP_STREAM_H
#define RTCP_STREAM_H

#include <QObject>
#include <QTcpSocket>
#include <QUdpSocket>
#include <QtEndian>
#include "camera/frame_buffer.h"
#include <QFutureWatcher>
#include <QQueue>
//DONE Если поток не открывается, напрмер, если неправильно указан порт, то интерфейс зависает. Устранить зависание интерфейса.
//NOTE если установлен ___FFMPEG___, то используется библиотека FFMPEG для чтения потока RTSP
#define ___FFMPEG___

#ifdef ___FFMPEG___
extern "C"
{
    #include "libavcodec/avcodec.h"
    #include "libavformat/avformat.h"
    #include "libavfilter/avfilter.h"
    #include "libswscale/swscale.h"
    #include "libavutil/imgutils.h"
}
#endif
struct RTPFixedHeader
{
    unsigned char cc:4;
    unsigned char extension:1;
    unsigned char padding:1;
    unsigned char version:2;
    unsigned char payload:7;
    bool marker:1;
    quint16 sequence;
    quint32 timestamp;
    quint32 sources[1];
};


enum class RequestTypes
  {
     Options,
     Describe,
     Setup_metadata,
     Setup_video,
     Play,
     Pause,
     Get_parameter,
     Teardown,
     Unknown
  };


class rtsp_stream : public QObject
{
    Q_OBJECT
public:
    explicit rtsp_stream(QObject *parent = nullptr);
    explicit rtsp_stream(QObject *parent = nullptr, QString adr="", int port=0, QString media="");
    virtual ~rtsp_stream();
    void cam_connect();
    void file_connect();
    void cam_disconnect();
    void setSession(const QString &session);
    void cam_request(RequestTypes req);
    QString session() const;

signals:
    void sessionChanged();
    void streamConnecting();
    void streamStarted();
    void streamStopped();
    void frameReady(char* buf, quint32 len, int pos, AVPacket* pkt);
    void frameReady(AVPacket* pkt, int pos);
    void frameReady(QQueue<AVPacket*>* q);
    void error(QString s);

public slots:
    void slotConnected();
    void slotDisconnected();
    void slotError(QAbstractSocket::SocketError);
    void slotRead();
    void newSession();
    void udpOpen();
    void udpRead();
//    void udpSlot1();
private:
    void dump_session();
    void dump_context();
    void dump_packet();
    const QString rtsp_url(QString req_type);
#ifdef ___FFMPEG___
protected:
    bool init(const QString & url);
    void readPackets();
    AVFormatContext *m_pAVFormatContext=nullptr;
    int m_vidoeStreamIndex=0; //NOTE Предполагаем, что у нас только один стрим в потоке.
    AVPacket m_AVPacket;
    QFutureWatcher<void> m_futureWatcher;
    bool m_stop;
#endif
private:
    QString m_player_name ="User-Agent: Hyco.ru stream player\r\n";
    QTcpSocket* tcpsocket = nullptr;
    QUdpSocket* udpsocket = nullptr;
    QString m_cam_address;
    QString m_cam_media;
    int m_cam_port;
    int m_udp_cam_port = 60506; //TODO Сделать выбор/определение порта для потока
    RequestTypes m_current_request;
    int m_seq_number=1;
    quint64 m_frame_counter=0;
    int _packet_seq=0;
    QString m_session="";
    QMap<QByteArray,QByteArray> m_params;
    frame_buffer fb;
    QQueue<AVPacket*> m_packet_queue; //пул необработанных пакетов - передается в сигнале при получении каждого пакета.
public:
    int m_width=0;
    int m_height=0;
    bool m_dump=false;
};

#endif // RTCP_STREAM_H
