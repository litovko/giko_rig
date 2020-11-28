#ifndef IPCAMERA_H
#define IPCAMERA_H
#include <QHostAddress>
#include <QObject>
#include <QtMultimedia/QAbstractVideoSurface>
#include <QVideoSurfaceFormat>
#include "camera/decoder.h"
#include "camera/rtsp_stream.h"
#include "camera/recorder.h"
#include <QTimer>
//DONE Сделать статусы камеры: Остановлена, Подключение, Воспроизведение, Обрыв
//Добавить управление PTZ.
using namespace cameradecode;

class ipcamera: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString address MEMBER m_cam_address NOTIFY addressChanged)
    Q_PROPERTY(QString media MEMBER m_cam_media NOTIFY mediaChanged)
    Q_PROPERTY(int port MEMBER m_cam_port NOTIFY portChanged)
    Q_PROPERTY(QAbstractVideoSurface* videoSurface READ videoSurface WRITE setVideoSurface )
    Q_PROPERTY(int video_height MEMBER m_height NOTIFY heightChanged)
    Q_PROPERTY(int video_width MEMBER m_width NOTIFY widthChanged)
    Q_PROPERTY(QString filename MEMBER m_file_name NOTIFY file_nameChanged)
    //Размер файла для нарезки видеопотока в Мбайтах.
    Q_PROPERTY(int record_file_size MEMBER m_record_file_size NOTIFY record_file_sizeChanged)
    Q_PROPERTY(bool on_record READ on_record NOTIFY on_recordChanged)
    Q_PROPERTY(bool is_playing READ is_playing NOTIFY is_playingChanged)
    Q_PROPERTY(QString state READ state NOTIFY stateChanged)
protected:
    void timerEvent(QTimerEvent *event) override;

signals:
    void addressChanged();
    void portChanged();
    void mediaChanged();
    void timerEvent();
    void heightChanged();
    void widthChanged();
    void file_nameChanged();
    void on_recordChanged();
    void is_playingChanged();
    void record_file_sizeChanged();
    void stateChanged();
public slots:
    void drawFrame();
    void error(QString err);
public:
    explicit ipcamera(QObject *parent = nullptr);
    virtual ~ipcamera();
    QAbstractVideoSurface* videoSurface() const;
    void setVideoSurface( QAbstractVideoSurface* s );
    Q_INVOKABLE void play();
    Q_INVOKABLE void playfile();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void record();
    Q_INVOKABLE void record(QString path, QString extension);
    Q_INVOKABLE void stop_record();
    bool on_record() const;

    bool is_playing() const;

    int record_file_size() const;

    void setRecord_file_size(int record_file_size);

    QString state() const;
    void setState(const QString &state);

    void setIs_playing(bool is_playing);

private:
    void closeSurface();
    QImage blankImage();
    QVideoFrame blankVideoFrame();
    void drawImage(const QImage &image, bool signal=true);
    void drawVideoFrame(const QVideoFrame& frame);
    void drawVideoFrame2(const QVideoFrame& frame);
public slots:
    void drawAVFrame(const AVFrame *frame);
    void drawAVFrame2(const AVFrame *frame);
    void createDecoder();
    void checkRecordFileSize();
private:
    QString m_cam_address;
    int m_cam_port;
    QString m_cam_media;
    int m_height;
    int m_width;
    QString m_file_name="";
    QString m_path="";
    QString m_extension=".avi";
    bool m_signal_present=false;
    bool m_on_record;
    int m_record_file_size=800; //в мегабайтах
    QTimer m_timer;
    bool m_is_playing=false;
    decoder *m_decoder;
    recorder *m_recorder;
    QString m_state = "Остановлена";

private:
    QAbstractVideoSurface* _surface;
    QVideoSurfaceFormat _format;
    rtsp_stream* _stream;
};

#endif // IPCAMERA_H
