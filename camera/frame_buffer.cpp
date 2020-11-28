#include "frame_buffer.h"
#include <qdebug.h>
//#include <H264SwDecApi.h>
frame_buffer::frame_buffer()
{
    m_frame_buffer = new unsigned char[m_frame_buffer_size];
}

frame_buffer::frame_buffer(quint32 size)
{
    m_frame_buffer = new unsigned char[size];
    m_frame_buffer_size = size;
}

void frame_buffer::reset()
{
    m_frame_pos = 0;
}

void frame_buffer::resize(quint32 newsize)
{
    if (newsize<m_frame_buffer_size) return;
    unsigned char * newbuffer = new unsigned char[newsize];
    memcpy(newbuffer, m_frame_buffer,m_frame_buffer_size);
    delete [] m_frame_buffer;
    m_frame_buffer=newbuffer;
    qDebug()<<"buffering from "<<m_frame_buffer_size<<" to "<<newsize;
    m_frame_buffer_size = newsize;

}


void frame_buffer::append(const char *from, quint32 size)
{
    append(from, 0, size);
}

void frame_buffer::append(const char *from, quint32 start, quint32 size)
{
    if ((m_frame_pos+size)<m_frame_buffer_size)
    {
        memcpy(m_frame_buffer+m_frame_pos, from+start, size);
        m_frame_pos+=size;
    }
    else
    {
        //qDebug()<<"buffer too small"<<m_frame_buffer_size<< "to add "<<size;
        resize(m_frame_pos+10*size);
        append(from, start, size);
    }
//    qDebug()<<"buffer length:"<<length();
}

void frame_buffer::append(char b)
{
    m_frame_buffer[m_frame_pos] = b;
    m_frame_pos++;
}

frame_buffer::~frame_buffer()
{
    if(m_frame_buffer!=nullptr) delete m_frame_buffer;
}

char *frame_buffer::data()
{
    return reinterpret_cast<char*>(m_frame_buffer);
}

quint32 frame_buffer::length()
{
    return m_frame_pos;
}
