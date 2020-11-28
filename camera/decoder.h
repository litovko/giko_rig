#ifndef DECODER_H
#define DECODER_H

#include <QObject>
#include <QQueue>
extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
#include <libswscale/swscale.h>
#include <libavutil/avutil.h>

}
namespace cameradecode {



class decoder : public QObject
{
    Q_OBJECT
public:
    explicit decoder(QObject *parent = nullptr, int width = 800, int height = 600);
    virtual ~decoder();
    int decode(uint8_t* buf,int len, int pos, AVPacket* pkt);
    int decode(AVPacket* pkt, int pos);
    void setContext(int width, int height);
    AVFrame *initFrame(int width, int height, int pix_fmt);
    void fillBuffer();
    uint8_t *getBuffer() const;
    AVPacket * getPacket();

signals:
    void frameReady(const AVFrame* frame);
    void packetReady(AVPacket* avpkt);

public slots:
//    void slotDecode(char* buf, quint32 len, int pos, AVPacket* pkt);
//    void slotDecode(AVPacket *pkt, int pos);
    void slotDecode(QQueue<AVPacket*>* queue);
private:

    AVCodecContext *context;

    AVFrame *frame1;
    AVFrame *frame2;

    AVCodec *codec;
    AVPacket avpkt;

    uint8_t *buffer; //буффер для хранения RGB
    struct SwsContext* sws_context; //контекст для конвертации фреймов
};
}
#endif // DECODER_H
