#ifndef RECORDER_H
#define RECORDER_H

#include <QObject>
extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
#include <libswscale/swscale.h>
#include <libavutil/avutil.h>
}

//DONE: Разбивка видеопотока на отдельные файлы согласно заданному размеру файла
//DONE: Корректировка записи таким образом, чтобы запись шла сначала.
//TODO: Запись субтитров.
//DONE: Течет память при записи. Посмотреть освобождает ли пакеты рекордер.
//TODO: Падает прога если нет пути для записи файлов.


class recorder : public QObject
{
    Q_PROPERTY(int pos READ pos NOTIFY posChanged)
    Q_OBJECT
public:
    explicit recorder(QObject *parent = nullptr);
    explicit recorder(QObject *parent = nullptr,
                      int width = 800,
                      int height = 600,
                      QString filename="record_file.avi");
    virtual  ~recorder();
public slots:
    void slotRecord(AVPacket* avpacket);
signals:
    void recordStarted();
    void recordStopped();
    void posChanged();
private:
    void dump_packet(AVPacket* avpkt);
    void setup_stream1();
    void setup_stream2();
    AVStream * add_video_stream(AVFormatContext *oc, enum AVCodecID  codec_id);
private:
    AVOutputFormat *output_fmt;
    AVFormatContext *output_fmt_context;
    AVStream *video_st=nullptr;
    QString m_filename;
    AVPacket avpkt;
    AVCodec *encoder;
    AVCodecContext *enc_ctx;
    int m_height;
    int m_width;
    long m_pos;
    long _first = -1;
public:
    bool m_dump=false;
    long pos() const;
};

#endif // RECORDER_H
