#include "filedownloader.h"

FileDownloader::FileDownloader(QUrl iniUrl, QObject *parent) : QObject(parent)
{
 connect(&m_WebCtrl, SIGNAL (finished(QNetworkReply*)), this, SLOT (fileDownloaded(QNetworkReply*)));

 QNetworkRequest request(iniUrl);
 reply = m_WebCtrl.get(request);
}

FileDownloader::~FileDownloader() {
    m_DownloadedData.clear();
}

void FileDownloader::fileDownloaded(QNetworkReply* pReply) {
 if(pReply->error()) qDebug()<<"===!!!===error ini file download:"<<pReply->errorString();
 m_DownloadedData.clear();
 m_DownloadedData = pReply->readAll();
 //emit a signal
 pReply->deleteLater();

 emit downloaded();
}

QString FileDownloader::downloadedData() const {
 return m_DownloadedData;
}

QNetworkReply *FileDownloader::networkReply() const {
    return reply;
}
