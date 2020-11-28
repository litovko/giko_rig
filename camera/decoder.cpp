#include "decoder.h"
#include <QDebug>

#include "libavutil/avutil.h"

using cameradecode::decoder;

decoder::decoder(QObject *parent, int width, int height): QObject(parent),
    context(nullptr),  frame1(nullptr), frame2(nullptr),codec(nullptr),  buffer(nullptr), sws_context(nullptr)
{
    Q_UNUSED(parent)
    codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    if (!codec) {
        qWarning()<<"Codec not found\n";
        exit(1);
    }
    context = avcodec_alloc_context3(codec);
    if (!context) {
        qWarning()<<"Could not allocate video codec context\n";
        exit(1);
    }
    setContext(width, height);
    //NOTE: The AVCodecContext MUST have been opened with @ref avcodec_open2()
    //       before packets may be fed to the decoder.
    if (avcodec_open2(context, codec, NULL) < 0) {
        qWarning()<< "Could not open codec\n";
        exit(1);
    }
    frame1 = initFrame(width, height, AV_PIX_FMT_YUV420P);
    frame2 = initFrame(width, height, AV_PIX_FMT_BGRA);
    av_init_packet(&avpkt);
    //    qDebug()<<"buffer size = "<<width*height*4<< width << height;
    buffer = (uint8_t *)malloc(width*height*4);
    if(!buffer) {
        qWarning()<<"out of memory";
        exit(1);
    }
}

decoder::~decoder()
{
    //    qDebug()<<"Decoder destructor";
    avcodec_close(context);
    av_free(context);
    av_frame_free(&frame1);
    av_frame_free(&frame2);
    av_packet_free_side_data(&avpkt);
    av_packet_unref(&avpkt);

    if(buffer) {
        free(buffer);
        buffer = nullptr;
    }
}
// декодируем данные из буфера в m_frame
int decoder::decode(uint8_t *buf, int len, int pos, AVPacket* pkt)
{
    avpkt.size = len;
    avpkt.data = buf;
    avpkt.pos = pos;
    int ret=0;
    //    qDebug()<<"ref:"<< av_packet_make_refcounted(pkt);
    qDebug()<<"pos:"<<pos<<"\n"
           <<"avpkt.dts"<<":"<<avpkt.dts<<"\n"
          <<"avpkt.pts"<<":"<<avpkt.pts<<"\n"
         <<"avpkt.duration"<<":"<<avpkt.duration<<"\n"
        <<"avpkt.pos"<<":"<<avpkt.pos<<"\n"
       <<"avpkt.size"<<":"<<avpkt.size<<"\n";
    ret = avcodec_send_packet(context, &avpkt);
    if (ret < 0) {
        qWarning()<< "Error sending a packet for decoding\n";
        exit(0);
    }


    while (ret >= 0) {
        //DONE: разобраться правильный ли пакет передается в функцию.
        ret = avcodec_receive_frame(context, frame1); //uncompress recieved data
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF)
        {
            return 0;
        }
        else if (ret < 0) {
            qWarning()<<"Error during decoding\n";
            exit(1);
        }
        avpkt.pos = context->frame_number; //TOD0: Разобраться нужна ли эта строчка.

        emit packetReady(&avpkt);
//        emit frameReady(frame1); litovko

        //        av_packet_unref(pkt);

        qDebug()<<"===>>>"<<avpkt.pos;

    }
    return ret;
}

int decoder::decode(AVPacket *pkt, int pos)
{
    int ret=avcodec_send_packet(context, pkt);

    if (ret < 0) {
        qWarning()<< "Error sending a packet for decoding\n";
        exit(1);
    }

    while (ret >= 0) {
        ret = avcodec_receive_frame(context, frame1); //uncompress recieved data
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF)
        {
            return 0;
        }
        else if (ret < 0) {
            qWarning()<< "Error during decoding\n";
            exit(1);
        }
        emit packetReady(pkt);
        emit frameReady(frame1);
    }
    return ret;
}

void decoder::setContext(int width, int height)
{
    context->width = width;
    context->height = height;
    context->extradata = NULL;
    context->pix_fmt = AV_PIX_FMT_YUV420P;
    //    context->thread_count =4;
    context->flags2 |= AV_CODEC_FLAG2_CHUNKS;

}

AVFrame *decoder::initFrame(int width, int height, int pix_fmt)
{
    if (context==nullptr) return nullptr;
    int ret = 0;
    AVFrame* frm = av_frame_alloc();
    if (!frm) {
        qWarning()<< "Could not allocate video frame\n";
        exit(1);
    }

    frm->format = pix_fmt;
    frm->width  = width;
    frm->height = height;
    ret = av_image_alloc(frm->data, frm->linesize, frm->width, frm->height, (AVPixelFormat)frm->format, 32);
    if (ret < 0) {
        qWarning()<<"Could not allocate raw picture buffer\n";
        exit(1);
    }
    //    qDebug()<<"linesize:"<<frm->linesize[0];
    return frm;

}

void decoder::fillBuffer()
{
    sws_context  = sws_getCachedContext(sws_context,   //1й этап - подготовка контекста для преобразования форматов кадра
                                        frame1->width, frame1->height, AV_PIX_FMT_YUV420P,
                                        frame2->width, frame2->height, AV_PIX_FMT_BGRA,
                                        0, NULL, NULL, NULL);
    sws_scale(sws_context, //2й этап - само преобразование
              frame1->data,
              frame1->linesize,
              0,
              frame1->height,
              frame2->data,
              frame2->linesize);

//    int olen = context->width*context->height*4;
    int len = av_image_get_buffer_size(AV_PIX_FMT_BGRA,frame2->width,frame2->height,32);
//    if(len != olen) {
//        qDebug("len = %d olen = %d\n",len,olen);
//    }
    av_image_copy_to_buffer(buffer,  // Копирование картинки в буфер.
                            len, // TODO разобраться в этих параметрах.
                            frame2->data,
                            frame2->linesize,
                            AV_PIX_FMT_BGRA,
                            frame2->width,
                            frame2->height,
                            32);

}



void decoder::slotDecode(QQueue<AVPacket*> *queue)
{
    AVPacket *p=queue->dequeue();
    decode(p,queue->length()+1);
    av_packet_free(&p);
}

uint8_t *decoder::getBuffer() const
{
    return buffer;
}

AVPacket *decoder::getPacket()
{
    return &avpkt;
}
