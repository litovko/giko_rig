#include "ipcamera.h"
#include <QDebug>
#include <QPainter>
#include "camera/decoder.h"
#include <QAbstractVideoBuffer>
#include <QImage>
#include <QDateTime>

using cameradecode::decoder;
ipcamera::ipcamera(QObject *parent) : QObject(parent),
    m_height(600), m_width(800),  m_signal_present(true),
    m_decoder(nullptr), m_recorder(nullptr), _surface( nullptr ), _stream(nullptr)
{
    //    startTimer(500); //таймер для отображения фрейма заставки когда нет сигнала
    connect(this, SIGNAL(timerEvent()), this, SLOT(drawFrame()));
    createDecoder();
    connect(this,SIGNAL(widthChanged()), this, SLOT(createDecoder()));
    connect(this,SIGNAL(heightChanged()), this, SLOT(createDecoder()));
    connect(&m_timer,SIGNAL(timeout()), this, SLOT(checkRecordFileSize()));
    m_timer.start(1000);
}

ipcamera::~ipcamera()
{
    if (m_decoder!=nullptr) delete m_decoder;
    if (_stream!=nullptr) delete _stream;
    m_timer.stop();
    //    qDebug()<<"Ipcamera destructor";
}
QAbstractVideoSurface *ipcamera::videoSurface() const
{
    return _surface;
}

void ipcamera::setVideoSurface(QAbstractVideoSurface *s)
{
    //    closeSurface();
    _surface = s;
}

void ipcamera::play()
{
    //    qDebug()<<"Start playing "<< m_width <<"x"<< m_height;

    setIs_playing(true);
    if (_stream==nullptr) {
        _stream = new rtsp_stream(this, m_cam_address, m_cam_port, m_cam_media);
        connect(_stream,SIGNAL(error(QString)), this, SLOT(error(QString)));
        connect(_stream,&rtsp_stream::streamStopped, [=]() {setIs_playing(false); setState("Остановлена");});
        connect(_stream,&rtsp_stream::streamStarted, [=]() {setState("Воспроизведение");});
        connect(_stream,&rtsp_stream::streamConnecting, [=]() {setState("Подключается");});
        connect(_stream,SIGNAL(frameReady(QQueue<AVPacket*>*)), m_decoder, SLOT(slotDecode(QQueue<AVPacket*>*)));
        _stream->cam_connect();
        //        connect(_stream,SIGNAL(frameReady(char* , quint32, int, AVPacket*)), m_decoder, SLOT(slotDecode(char* , quint32, int, AVPacket*)));
        //        connect(_stream,SIGNAL(frameReady(AVPacket*, int)), m_decoder, SLOT(slotDecode(AVPacket*, int)));
    }
}

void ipcamera::playfile()
{
    qDebug()<<"Start playing "<< m_width <<"x"<< m_height;
    if (_stream==nullptr) {
        _stream = new rtsp_stream(this, m_cam_address, m_cam_port, m_cam_media);

        _stream->file_connect();
        connect(_stream,SIGNAL(frameReady(char* , quint32)), m_decoder, SLOT(slotDecode(char* , quint32)));
    }
}

void ipcamera::stop()
{
    setIs_playing(false);
    if (on_record()) stop_record();
    if (_stream==nullptr) return;
    disconnect(_stream,SIGNAL(frameReady(QQueue<AVPacket*>*)), m_decoder, SLOT(slotDecode(QQueue<AVPacket*>*)));
    connect(_stream,&rtsp_stream::streamStopped,
            [=](){
        disconnect(_stream,&rtsp_stream::streamStopped, nullptr, nullptr);
        _stream->deleteLater();
        _stream = nullptr;
    });
    _stream->cam_disconnect();
    closeSurface();
}

void ipcamera::record()
{
    //    qDebug()<<"Start recording";
    if (m_recorder!=nullptr) return;
    if (_stream == nullptr) return;
    m_recorder = new recorder(this, m_width, m_height, m_file_name);
    //    connect(_stream,SIGNAL(frameReady(char* , quint32)), m_recorder, SLOT(record(char* , quint32)));
    connect(m_decoder,SIGNAL(packetReady(AVPacket*)), m_recorder, SLOT(slotRecord(AVPacket*)));
    emit on_recordChanged();
}

void ipcamera::record(QString path, QString extension)
{
    //    qDebug()<<"Start recording";
    emit on_recordChanged();
    if (m_recorder!=nullptr) return;
    if (_stream == nullptr) return;

    m_path = path;
    m_extension = extension;
    m_file_name=path+QDateTime::currentDateTime().toString("ddMMyyyy_hh-mm-ss")+extension;
    m_recorder = new recorder(this, m_width, m_height, m_file_name);
    connect(m_decoder,SIGNAL(packetReady(AVPacket*)), m_recorder, SLOT(slotRecord(AVPacket*)));
    emit on_recordChanged();
    //        qDebug()<<"end record()";
}

void ipcamera::stop_record()
{
    //    qDebug()<<"Stop recording";
    delete m_recorder;
    m_recorder = nullptr;
    emit on_recordChanged();
}

void ipcamera::closeSurface()
{
    if( _surface && _surface->isActive() )
        _surface->stop();
}

QImage ipcamera::blankImage()
{
    QImage image(QSize(m_width, m_height), QImage::Format_RGB32);
    image.fill("blue");
    QPainter p(&image);
    //    qDebug()<<"image size:"<<image.size();
    p.setPen(QPen(Qt::yellow));
    p.setFont(QFont("Times", 30, QFont::Bold));
    p.drawText(image.rect(), Qt::AlignCenter, "НЕТ СИГНАЛА");
    image.save("d:\\fn.jpg","JPG");
    return image;
}

QVideoFrame ipcamera::blankVideoFrame()
{
    // Генерируем простой фрейм
    QVideoFrame vframe(m_height*m_width*4,QSize(m_width, m_height),m_width, QVideoFrame::Format_YUV420P);
    vframe.setMetaData("key","value");
    vframe.map(QAbstractVideoBuffer::MapMode::ReadWrite);
    qDebug()<<vframe.mapMode()<<" b:"<<vframe.mappedBytes()<<" l:"<<vframe.bytesPerLine()<<" planes:"<<vframe.planeCount()<<"s:"<<m_width<<"x"<<m_height;
    uchar* b=vframe.bits(0);
    uchar* b1=vframe.bits(1);
    uchar* b2=vframe.bits(2);
    //        for (int i=0; i<m_height*m_width; i++ ) {
    //            int p=i;
    //            b[p]=127;

    //        }
    for (int i=0; i<m_width/2; i++ ) {
        int p=i+m_height/2*m_width*1.5;
        //        b1[p]=12;
        b2[p]=15;

    }
    vframe.unmap();
    return vframe;
}

void ipcamera::drawImage(const QImage &image, bool signal)
{

    if (!_surface->isActive()) {
        //        QVideoFrame::PixelFormat pixelFormat =  QVideoFrame::pixelFormatFromImageFormat( QImage::Format_RGB32 );
        QVideoFrame::PixelFormat pixelFormat = QVideoFrame::Format_YUV420P;
        _format = QVideoSurfaceFormat( QSize(m_width, m_height),                                        pixelFormat );
        _surface->start(_format);
    }
    else {
        _surface->present(image);
    }
    m_signal_present = signal;

}

void ipcamera::drawVideoFrame(const QVideoFrame &frame)
{
    qDebug()<<"drawVideoFrame";
    if (!_surface->isActive()) {
        //        QVideoFrame::PixelFormat pixelFormat =  QVideoFrame::pixelFormatFromImageFormat( QImage::Format_RGB32 );
        QVideoFrame::PixelFormat pixelFormat = QVideoFrame::Format_YUV420P;
        _format = QVideoSurfaceFormat( QSize(m_width, m_height),                                        pixelFormat );
        _surface->start(_format);
    }
    else {
        _surface->present(frame);
    }
}

void ipcamera::drawAVFrame2(const AVFrame *frame) //NOTE вывод декодированного ферйма на экран.
{
    m_decoder->fillBuffer();
    QImage image(m_decoder->getBuffer(), m_width, m_height,  QImage::Format_RGB32);
    if (!_surface->isActive()) {
        QVideoFrame::PixelFormat pixelFormat =
                QVideoFrame::pixelFormatFromImageFormat( image.format() );
        _format =
                QVideoSurfaceFormat( image.size(),
                                     pixelFormat );
        //        qDebug()<<"==pixelFormat:"<<pixelFormat;
        //        qDebug()<<"==videosurfaceFormat:"<<_format;
        //        qDebug()<<"==imageSize  :"<<image.size();
        _surface->start(_format);
    }
    bool _pres =  _surface->present(QVideoFrame(image));
    //    qDebug()<<"present:"<<_pres<<" state:"<<_surface->isActive()<<" err:"<<_surface->error();
    m_signal_present = true;
}

void ipcamera::createDecoder()
{
    //    qDebug()<<"createDecoder:";
    if (m_decoder!=nullptr)
        delete m_decoder;
    m_decoder = new decoder(this, m_width, m_height);
    connect(m_decoder, SIGNAL(frameReady(const AVFrame*)),
            this, SLOT(drawAVFrame2(const AVFrame*)) );
}

void ipcamera::checkRecordFileSize()
{
    if (m_recorder==nullptr) return;
    //    qDebug()<<m_recorder->pos()<<"====="<<m_record_file_size*1024*1024;
    if (m_recorder->pos()>=m_record_file_size*1024*1024) {
        stop_record();
        record(m_path, m_extension);
    }
}

void ipcamera::setIs_playing(bool is_playing)
{
    m_is_playing = is_playing;
    emit is_playingChanged();
}

QString ipcamera::state() const
{
    return m_state;
}

void ipcamera::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}

void ipcamera::setRecord_file_size(int record_file_size)
{
    m_record_file_size = record_file_size;
}

int ipcamera::record_file_size() const
{
    return m_record_file_size;
}

bool ipcamera::is_playing() const
{
    return m_is_playing;
}

bool ipcamera::on_record() const
{
    return m_recorder!=nullptr;
}

void ipcamera::drawAVFrame(const AVFrame *frame)
{
    //TODO: преобразовать фрейм ffmpeg в QVideoFrame и уже отрисовать функцией drawVideoFrame
    qDebug()<<frame->coded_picture_number<<" "<<"drawAVFrame frame, linesizes "<<frame->linesize[0]<<"u"<<frame->linesize[1]<<"v"<<frame->linesize[2];
    QVideoFrame vframe(m_height*m_width*4,QSize(frame->width, frame->height),frame->width, QVideoFrame::Format_YUV420P);
    vframe.map(QAbstractVideoBuffer::MapMode::ReadOnly);
    qDebug()<<"field type:"<<vframe.fieldType();
    vframe.setFieldType(QVideoFrame::FieldType::TopField);
    //char* buf=frame->buf[0]->data;
    int picture_size =av_image_get_buffer_size(AV_PIX_FMT_YUV420P, m_width, m_height,1);
    qDebug()<<"picture_buffer_size="<<picture_size;
    for (int plane=0; plane<3; plane++){
        uchar* b=vframe.bits(plane);
        AVBufferRef* s=frame->buf[plane];
        qDebug()<<"avplane:"<<plane<<"linesize:"<<frame->linesize[plane]<<"bufsize:"<<s->size;
        memcpy(b, s->data, s->size);
        //        qDebug()<<"copied";
    }
    vframe.unmap();
    drawVideoFrame(vframe);
}


void ipcamera::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event)
    emit timerEvent();
}

void ipcamera::drawFrame()
{
    drawImage(blankImage(), false);
    drawVideoFrame(blankVideoFrame());
    m_signal_present=false;
}

void ipcamera::error(QString err)
{
    qWarning()<<"ipcamera::error:"<<err<<_stream;
    stop();
    if (err == "Stream aborted")
        setState("Обрыв связи");
    else
        setState("Нет связи");
    emit on_recordChanged(); //надо ли?
}
