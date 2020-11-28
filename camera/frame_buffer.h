#ifndef FRAME_BUFFER_H
#define FRAME_BUFFER_H
#include <QObject>


class frame_buffer
{
public:
    frame_buffer();
    frame_buffer(quint32 size);
    void reset();
    void resize(quint32 newsize);
    void append(const char *from, quint32 size);
    void append(const char *from, quint32 start, quint32 size);
    void append(char b);

    ~frame_buffer();
    unsigned char* m_frame_buffer=nullptr;
    char* data();
    quint32 m_frame_buffer_size=100000; //NOTE размер буфера должен быть чуть больше, чем реальный размер пакета, в документции по av_send_packet
    quint64 m_frame_pos=0;
    quint32 length();
};

#endif // FRAME_BUFFER_H
