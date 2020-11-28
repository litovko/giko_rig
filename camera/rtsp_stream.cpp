#include "rtsp_stream.h"
#include <libavformat/avformat.h>
#include <libavformat/avio.h>
#include <QCoreApplication>
#include <QtConcurrent/QtConcurrent>
#include <QPointer>

rtsp_stream::rtsp_stream(QObject *parent) : QObject(parent)
{

}

rtsp_stream::rtsp_stream(QObject *parent, QString adr, int port, QString media): QObject(parent), udpsocket(nullptr), tcpsocket(nullptr)
{

    m_cam_port=port;
    m_cam_address=adr;
    m_cam_media = media;
#ifndef ___FFMPEG___
    if (tcpsocket==nullptr) {
        tcpsocket = new QTcpSocket(this);
        connect(tcpsocket, SIGNAL(connected()), SLOT(slotConnected()));
        connect(tcpsocket, SIGNAL(readyRead()), SLOT(slotRead()));
        connect(tcpsocket, SIGNAL(disconnected()), SLOT(slotDisconnected()));
        connect(tcpsocket, SIGNAL(error(QAbstractSocket::SocketError)),
                this,         SLOT(slotError(QAbstractSocket::SocketError))
                );

        connect(this, SIGNAL(sessionChanged()), SLOT(newSession()));
    }
#endif

}
#ifdef ___FFMPEG___
bool rtsp_stream::init(const QString &url)
{
    AVDictionary *options = NULL;
    av_dict_set(&options, "user-agent", "hyco.ru video stream player", 0);
    av_dict_set(&options, "buffer_size", "102400", 0);
    av_dict_set(&options, "max_delay", "0", 0);
    av_dict_set(&options, "stimeout", "20000000", 0);
    qDebug()<<"rtsp_stream: init: "<<url;
    int result = avformat_open_input(&m_pAVFormatContext,url.toLocal8Bit().data(),NULL,&options);
    if(result < 0) return false;
    m_width=m_pAVFormatContext->streams[0]->codecpar->width;
    m_height=m_pAVFormatContext->streams[0]->codecpar->height;
    return true;
}

void rtsp_stream::readPackets()
{
    while (!m_stop) {
        if (av_read_frame(m_pAVFormatContext,&m_AVPacket) <0) {
            qWarning()<<"rtsp_stream: read frame failure!";
            m_stop=true;
            emit error("Stream aborted");
            emit streamStopped();
            return;
        }
        if(m_stop) break;
        if(m_AVPacket.stream_index == m_vidoeStreamIndex) { //WARNING обрабатываем только видеопоток - самый первый стрим в потоке.
            _packet_seq++;
            m_AVPacket.pos=_packet_seq;
            AVPacket *p=av_packet_clone(&m_AVPacket);
            m_packet_queue.enqueue(p);
            av_packet_unref(&m_AVPacket);
            emit frameReady(&m_packet_queue);
        }
        QCoreApplication::processEvents();
    }
    qDebug()<<"rtsp_stream: Read packet loop exit";
    avformat_close_input(&m_pAVFormatContext);
    emit streamStopped();
}

#endif
rtsp_stream::~rtsp_stream()
{
    cam_disconnect();
    if (tcpsocket!=nullptr) delete tcpsocket;
    if (udpsocket != nullptr) {
        udpsocket->close();
        delete  udpsocket;
        udpsocket = nullptr;
    }
    while (!m_packet_queue.isEmpty()){
        AVPacket *p=m_packet_queue.dequeue();
        av_packet_free(&p);
    }
    //    m_futureWatcher.future().cancel();
    while (m_futureWatcher.future().isRunning()) {
        qDebug()<<"waiting for the future stop in destructor";
        QCoreApplication::processEvents();
    }
}

void rtsp_stream::cam_connect()
{

#ifndef ___FFMPEG___
    tcpsocket->connectToHost(m_cam_address, m_cam_port, QIODevice::ReadWrite, QAbstractSocket::IPv4Protocol);
#endif
#ifdef ___FFMPEG___
    // Открываем видеопоток в отдельном потоке.
    QFuture<bool> future = QtConcurrent::run(this,
                                             &rtsp_stream::init,
                                             "rtsp://"+m_cam_address+":"+QString::number(m_cam_port)+m_cam_media);
    emit streamConnecting();
    //    bool ret=init("rtsp://"+m_cam_address+":"+QString::number(m_cam_port)+m_cam_media);
    while (future.isRunning()) {
        QCoreApplication::processEvents();
    }
    bool ret = future.result();
    if (!ret) {
        emit error("Open stream failed");
        emit streamStopped();
        return;
    }
    m_stop = false;
    m_futureWatcher.setFuture(QtConcurrent::run(this,&rtsp_stream::readPackets));
    emit streamStarted();
#endif
}

void rtsp_stream::file_connect()
{
    init("D:/work/build-ipcamera_test-Desktop_Qt_5_15_0_MSVC2019_64bit-Debug/output.avi");
    m_stop = false;
    m_futureWatcher.setFuture(QtConcurrent::run(this,&rtsp_stream::readPackets));
    emit streamStarted();
}

void rtsp_stream::cam_disconnect()
{
#ifndef ___FFMPEG___
    //Дать команду остановки потока
    cam_request(RequestTypes::Teardown);
#endif
#ifdef ___FFMPEG___
    m_stop = true;
#endif
}

void rtsp_stream::setSession(const QString &session)
{
    if (m_session == session) return;
    m_session = session;
    emit sessionChanged();
    m_params["Session"] = m_session.toLatin1();
}

void rtsp_stream::cam_request(RequestTypes req)
{
    m_seq_number++;
    m_current_request=req;
    QString ts;
    switch (req) {
    case RequestTypes::Options:
        qDebug()<<"url:"<<rtsp_url("/video");
        tcpsocket->write(QString("OPTIONS " + rtsp_url("/video")).toLatin1());
        tcpsocket->write(QString("CSeq: "+QString::number(m_seq_number)+"\r\n").toLatin1());
        tcpsocket->write(m_player_name.toLatin1());
        tcpsocket->write("\r\n");
        break;
    case RequestTypes::Describe:
        qDebug()<<"DESCRIBE";
        tcpsocket->write(QString("DESCRIBE " + rtsp_url("/video")).toLatin1());
        tcpsocket->write(QString("CSeq: "+QString::number(m_seq_number)+"\r\n").toLatin1());
        tcpsocket->write("\r\n");
        break;
    case RequestTypes::Setup_metadata:
        qDebug()<<"SETUP metadata";
        tcpsocket->write(QString("SETUP " + rtsp_url("/metadata")).toLatin1());
        tcpsocket->write(QString("CSeq: "+QString::number(m_seq_number)+"\r\n").toLatin1());
        tcpsocket->write(m_player_name.toLatin1());
        tcpsocket->write("Transport: RTP/AVP;unicast;client_port=60000-60001\r\n");
        tcpsocket->write(QString("Session: "+session()+"\r\n").toLatin1());
        tcpsocket->write("\r\n");
        break;
    case RequestTypes::Setup_video:
        qDebug()<<"SETUP video";
        tcpsocket->write(QString("SETUP " + rtsp_url("/video")).toLatin1());
        tcpsocket->write(QString("CSeq: "+QString::number(m_seq_number)+"\r\n").toLatin1());
        tcpsocket->write(m_player_name.toLatin1());
        tcpsocket->write(QString("Transport: RTP/AVP;unicast;client_port="+QString::number(m_udp_cam_port)+"-"+QString::number(m_udp_cam_port+1)+"\r\n").toLatin1()); //Задаем порты для приема UDP пакетов для видео.
        tcpsocket->write("\r\n");
        break;
    case RequestTypes::Play:
        qDebug()<<"PLAY";
        tcpsocket->write(QString("PLAY "+rtsp_url("/video")).toLatin1());
        tcpsocket->write(QString("CSeq: "+QString::number(m_seq_number)+"\r\n").toLatin1());
        tcpsocket->write("Range: npt=0.000-\r\n");
        tcpsocket->write(QString("Session: "+session()+"\r\n").toLatin1());
        tcpsocket->write("\r\n");
        break;
    case RequestTypes::Teardown:
        qDebug()<<"TEARDOWN";
        tcpsocket->write(QString("TEARDOWN "+rtsp_url("/video")).toLatin1());
        tcpsocket->write(QString("CSeq: "+QString::number(m_seq_number)+"\r\n").toLatin1());
        tcpsocket->write(QString("Session: "+session()+"\r\n").toLatin1());
        tcpsocket->write(m_player_name.toLatin1());
        tcpsocket->write("\r\n");
        break;
    default:
        qDebug()<<"Unknown request";
        break;
    }
}

void rtsp_stream::slotConnected()
{
    qDebug()<<"Rtsp stream connected"<<m_cam_address;
    cam_request(RequestTypes::Options);
}

void rtsp_stream::slotDisconnected()
{

}

void rtsp_stream::slotError(QAbstractSocket::SocketError)
{

}

void rtsp_stream::slotRead()
{
    int a,b;
    QByteArray buf=tcpsocket->readAll();
    QList<QByteArray> params, par;
    switch (m_current_request) {
    case RequestTypes::Options:
        cam_request(RequestTypes::Describe);
        break;
    case RequestTypes::Describe:
        params=buf.split('\r');
        foreach(auto e, params) {
            a = e.indexOf("sprop-parameter-sets=");
            if ( a > 0 ) {
                m_params["sprop-parameter-sets"] = e.mid(a+21, e.length());
                par = (m_params["sprop-parameter-sets"]).split(',');
                m_params["SPS"] =QByteArray::fromBase64(par[0]);
                m_params["PPS"] =QByteArray::fromBase64(par[1]);
            }
        }
        cam_request(RequestTypes::Setup_video);
        break;
    case RequestTypes::Setup_metadata:
        cam_request(RequestTypes::Play);
        break;
    case RequestTypes::Setup_video:
        a = buf.indexOf("Transport: ");
        b = buf.indexOf("\r",a);
        if (a>=0) m_params["Transport"] = buf.mid(a+11,b-a-11);
        a = buf.indexOf("Session: ");
        b = buf.indexOf(";",a);
        if (b == -1) b = buf.indexOf("\r",a);
        if (a>=0)  setSession(buf.mid(a+9,b-a-9));
        cam_request(RequestTypes::Setup_metadata);
        break;
    case RequestTypes::Play:
        qDebug()<<"Play reply"<<buf;
        emit streamStarted();
        qDebug()<<m_params;
        dump_session();
        //        start_time = QDateTime::currentDateTime();
        break;
    case RequestTypes::Teardown:
        qDebug()<<"Teardown reply: "<<buf;
        tcpsocket->disconnectFromHost();
        streamStopped();
        break;
    default:
        qDebug()<<"Unknown responce";
    }
}

void rtsp_stream::newSession()
{
    udpOpen();
}

void rtsp_stream::udpOpen()
{
    qDebug()<<"udpOpen";
    if (udpsocket != nullptr) {
        udpsocket->close();
        delete  udpsocket;
        udpsocket = nullptr;
    }

    udpsocket = new QUdpSocket(this);

    udpsocket->bind(QHostAddress::AnyIPv4, m_udp_cam_port);
    udpsocket->setSocketOption(QAbstractSocket::ReceiveBufferSizeSocketOption,1250000 );
    udpsocket->setSocketOption(QAbstractSocket::LowDelayOption,1 );
    connect(udpsocket, SIGNAL(readyRead()),  SLOT(udpRead()) );
}

void rtsp_stream::udpRead()
{
    QByteArray datagram;
    QByteArray type7, type8;
    QHostAddress address;
    RTPFixedHeader *rtph;
    const char* c="\0\0\0\1";
    while (udpsocket->hasPendingDatagrams())
    {
        datagram.resize(udpsocket->pendingDatagramSize());
        udpsocket->readDatagram(datagram.data(), datagram.size());
        rtph = (RTPFixedHeader*) datagram.data();
        auto seq=qFromBigEndian<quint16>(rtph->sequence);

        if (seq-_packet_seq>1) qWarning()<<"!!!LOST!!!"<<seq-_packet_seq;
        _packet_seq=seq;

        //qDebug()<<"vers:"<<rtph->version<<" payl:"<<rtph->payload<< " tmst:"<<qFromBigEndian<quint32>(rtph->timestamp);
        int nal_ref_idc = (datagram[12] & 0x60); //3 NAL UNIT BITS
        int fragment_type = datagram[12] & 0x1F; //5 FRAGMENT TYPE BITS
        int start_bit = (datagram[13] & 0x80)>>7; // START BIT
        int end_bit = (datagram[13] & 0x40)>>6;   //  END BIT
        int nal_unit_bits = datagram[13] & 0x1F;  //5 NAL UNIT BITS
        //        qDebug()<<"seq:"<<seq<<"bytes available:"<<socket->size()<<"nal_ref_idc:"<<nal_ref_idc<<" fragment_type:"<<fragment_type<<" start_bit:"<<start_bit<<" end_bit:"<<end_bit<<" nal_unit_bits:"<<nal_unit_bits;

        if (fragment_type==7){
            //            qDebug()<<"Fragment TYPE7";
            type7.append(datagram.data()+12,datagram.size()-12);
            m_params["SPS"]=QByteArray(datagram.data()+12,datagram.size()-12);
        }
        if (fragment_type==8){
            //            qDebug()<<"Fragment TYPE8";
            type8.append(datagram.data()+12,datagram.size()-12);
            m_params["PPS"]=QByteArray(datagram.data()+12,datagram.size()-12);
        }
        if (fragment_type==28){ //VIDEO DATA
            if (start_bit) {
                datagram[13]=(nal_ref_idc|nal_unit_bits);
                fb.reset();
                fb.append(c,4);
                fb.append(m_params["SPS"].data(), m_params["SPS"].length());
                fb.append(c,4);
                fb.append(m_params["PPS"].data(), m_params["PPS"].length());
                fb.append(c,4);
                fb.append(datagram.data()+13,datagram.size()-13);
            }
            if (end_bit) {
                m_frame_counter++;
                //                qDebug()<<"FRAME:"<<m_frame_counter;
                fb.append(datagram.data(), 14, datagram.size()-14);
                emit frameReady(fb.data(), fb.length(), _packet_seq, &m_AVPacket); //TODO set postiton
            }
            if (!(start_bit||end_bit)){
                fb.append(datagram.data(), 14, datagram.size()-14);
            }
        }
    }
}


void rtsp_stream::dump_session()
{
    for(auto a: m_params.toStdMap()) qDebug()<<a.first<<"==="<<a.second;

}

void rtsp_stream::dump_context()
{
    qDebug()<<"======== dump stream context ===========";
    avformat_find_stream_info(m_pAVFormatContext, NULL);
    av_dump_format(m_pAVFormatContext, 0, "", 0);
    qDebug()<<"starttime:" <<m_pAVFormatContext->start_time;
    qDebug()<<"AV_TIME_BASE"<<AV_TIME_BASE;
    qDebug()<<"starttime realtime:" <<m_pAVFormatContext->start_time_realtime;
    qDebug()<<"framerate stream0 :" <<m_pAVFormatContext->streams[0]->avg_frame_rate.num<<":"<<m_pAVFormatContext->streams[0]->avg_frame_rate.den;
    qDebug()<<"bitrate info:" <<m_pAVFormatContext->streams[0]->codecpar->bit_rate;
    qDebug()<<"format info:" <<(AVPixelFormat)m_pAVFormatContext->streams[0]->codecpar->format; //12 = AV_PIX_FMT_YUVJ420P
    qDebug()<<"height info:" <<m_pAVFormatContext->streams[0]->codecpar->height;
    qDebug()<<"width info:" <<m_pAVFormatContext->streams[0]->codecpar->width;
    qDebug()<<"samplerate info:" <<m_pAVFormatContext->streams[0]->codecpar->sample_rate;
    qDebug()<<"timebase stream0 :" <<m_pAVFormatContext->streams[0]->time_base.num<<":"<<m_pAVFormatContext->streams[0]->time_base.den;
    qDebug()<<"codecinfo stream0 :" <<m_pAVFormatContext->streams[0]->codec_info_nb_frames;
    qDebug()<<"============== dump end ================";
}

void rtsp_stream::dump_packet()
{
    if (!m_dump) return;
    qDebug()<<"Packet pos:"<<m_AVPacket.pos;
    qDebug()<<"Packet pts:"<<m_AVPacket.pts;
    qDebug()<<"Packet dts:"<<m_AVPacket.dts;
    qDebug()<<"Packet siz:"<<m_AVPacket.size;
    qDebug()<<"Packet dur:"<<m_AVPacket.duration;
    qDebug()<<"Packet ptr:"<<&m_AVPacket;
}

const QString rtsp_stream::rtsp_url(QString req_type)
{
    return "rtsp://"+m_cam_address+":"+QString::number(m_cam_port)+m_cam_media+ req_type+" RTSP/1.0\r\n";
}



QString rtsp_stream::session() const
{
    return m_session;
}
