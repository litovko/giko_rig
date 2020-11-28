#include "recorder.h"
#include <QDebug>
//DONE записи не проигрываются с помощью VLC Player
//TODO запись субтитров do_subtitle_out
recorder::recorder(QObject *parent) : QObject(parent)
{

}

recorder::recorder(QObject *parent,
                   int width,
                   int height,
                   QString file_name):QObject(parent)
{
    m_filename =  file_name;
    m_height = height;
    m_width = width;
    setup_stream1();
}

recorder::~recorder()
{
    qDebug()<<"recorder destructor";
    av_write_trailer(output_fmt_context);
    avio_closep(&output_fmt_context->pb);
    avformat_free_context(output_fmt_context);
//    avcodec_free_context(&enc_ctx);
}


void recorder::slotRecord(AVPacket *avpkt)
{
    avpkt->pts=av_rescale_q(avpkt->pos,  video_st->codec->framerate, video_st->codec->time_base);
    m_dump = false;
    if (_first<0) _first = avpkt->pts; //запоминаем величину pts первого пакета записи.
    avpkt->dts=avpkt->pts-_first;  avpkt->pts=avpkt->dts;
    dump_packet(avpkt);
    av_interleaved_write_frame(output_fmt_context, avpkt);
    m_pos = output_fmt_context->pb->pos;
//    av_packet_free(&avpkt); //litovko
//

}

void recorder::dump_packet(AVPacket *avpkt)
{
    if (!m_dump) return;
    qDebug()<<"packet.pos:"<<avpkt->pos;
    qDebug()<<"avpkt.dts:"<<":"<<avpkt->dts<<"\n"
              <<"avpkt.pts:"<<":"<<avpkt->pts<<"\n"
                <<"avpkt.duration:"<<":"<<avpkt->duration<<"\n"

                    <<"avpkt.size:"<<":"<<avpkt->size<<"\n";
    qDebug()<<"pos:"<<output_fmt_context->pb->pos;
    qDebug()<<"first:"<<_first;
}

void recorder::setup_stream1()
{
    int ret = avformat_alloc_output_context2(&output_fmt_context, NULL, NULL, m_filename.toLocal8Bit().constData()); // сделали контекст выходного потока на основании расширения файла
    if (ret < 0) {
        qDebug()<<"Couldn't create output context";
        exit(1);
    }
    encoder = avcodec_find_encoder(AV_CODEC_ID_H264);
    if (!encoder) {
        qDebug()<<"Couldn't find a encoder codec!";
        exit(1);
    }
    video_st=add_video_stream(output_fmt_context,encoder->id);
    if (output_fmt_context->oformat->flags & AVFMT_GLOBALHEADER)
        enc_ctx->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
    av_dump_format(output_fmt_context, 0, m_filename.toLocal8Bit().constData(), 1);
    if (!( output_fmt_context->oformat->flags & AVFMT_NOFILE)) {
        ret = avio_open(&output_fmt_context->pb, m_filename.toLocal8Bit().constData(), AVIO_FLAG_WRITE);
        if (ret < 0) {
            qDebug()<<"Could not open output file " << m_filename;
            return;
        }
    }
    ret = avformat_write_header(output_fmt_context, NULL);
    if (ret < 0) {
        qDebug()<<"Error occurred when opening output file" << m_filename;
        return;
    }
    av_dump_format(output_fmt_context, 0, m_filename.toLocal8Bit().constData(), 1);
    emit recordStarted();
}


AVStream *recorder::add_video_stream(AVFormatContext *oc, AVCodecID codec_id)
{
    {
         AVCodecContext *c;
         AVStream *st;

         st = avformat_new_stream(oc, 0);
         if (!st) {
             fprintf(stderr, "Could not alloc stream\n");
             exit(1);
         }

         c = st->codec;
         c->codec_id = codec_id;
         c->codec_type = AVMEDIA_TYPE_VIDEO;

         /* put sample parameters */
         c->bit_rate = 90000;
         c->framerate = {1,30};
         c->time_base = {1,600};
         /* resolution must be a multiple of two */
         c->width = m_width;
         c->height = m_height;
         c->gop_size = 12; /* emit one intra frame every twelve frames at most */
         c->pix_fmt = AV_PIX_FMT_YUV420P;
         if(oc->oformat->flags & AVFMT_GLOBALHEADER)
             c->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;

         return st;
    }
}

long recorder::pos() const
{
    return m_pos;
}


