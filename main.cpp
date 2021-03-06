/*******************************************************************************
* Copyright (c) 2014, Sergey Radionov <rsatom_gmail.com>
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*   1. Redistributions of source code must retain the above copyright notice,
*      this list of conditions and the following disclaimer.
*   2. Redistributions in binary form must reproduce the above copyright notice,
*      this list of conditions and the following disclaimer in the documentation
*      and/or other materials provided with the distribution.

* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
* OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
* OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
* WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/

#include <QtGui/QGuiApplication>
#include <QQuickView>

#include <QmlVlc.h>
#include <QmlVlc/QmlVlcConfig.h>


#include "rigmodel.h"
#include "camera.h"
#include <QtQml>
#include "cjoystick.h"
#include <QSettings>

#define giko_name "HYCO"
#define giko_program "Rig Console"
#include <stdio.h>
#include <stdlib.h>
#include <QFile>
#include <QTextStream>

static QFile logfile;
static QTextStream out(&logfile);
static bool recordinglog=false;

//Включение и отключение записи логов
extern void toggle_log(bool recordlog) {
    if (!recordlog) {
        if(logfile.isOpen()) {
            logfile.write("Close\n");
            logfile.flush();
            logfile.close();
        }
        recordinglog=false;
        return;
    }
    if (!logfile.isOpen()) {
        logfile.setFileName("hyco_log_"+QDateTime::currentDateTime().toString("dd-MM-yyyy_hh-mm-ss-zzz.log"));
        logfile.open(QIODevice::WriteOnly | QIODevice::Text);
        logfile.write("Open\n");
    }
    recordinglog=true;
}

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    switch (type) {
    case QtDebugMsg:
        fprintf(stderr, "D:%s %s (%s:%u, %s)\n",QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data(), localMsg.constData(), context.file, context.line, context.function);
        out<<"Debug:"<<QTime::currentTime().toString("hh:mm:ss:zzz ").toUtf8().data()<<" "<<localMsg.constData()<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        break;
    case QtWarningMsg:
        fprintf(stderr, "W:%s %s (%s:%u, %s)\n",QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data(), localMsg.constData(), context.file, context.line, context.function);
        out<<"Warning:"<<QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data()<<" "<<localMsg.constData()<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        break;
    case QtCriticalMsg:
        fprintf(stderr, "C:%s %s (%s:%u, %s)\n",QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data(), localMsg.constData(), context.file, context.line, context.function);
        out<<"Critical:"<<QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data()<<" "<<localMsg.constData()<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        break;
    case QtFatalMsg:
        fprintf(stderr, "F:%s %s (%s:%u, %s)\n",QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data(), localMsg.constData(), context.file, context.line, context.function);
        out<<"FATAL:"<<QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data()<<" "<<localMsg.constData()<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        abort();
    }
    if(logfile.isOpen()) logfile.flush();
}


int main(int argc, char *argv[])
{
    qInstallMessageHandler(myMessageOutput);
    toggle_log(true);
    setlocale(LC_ALL, ""); // избавляемся от кракозябров в консоли
    qDebug()<<QTime::currentTime().toString("hh:mm:ss:zzz ")<<"Start"<<giko_name<<"  "<<giko_program;
    RegisterQmlVlc();
    QSettings settings(giko_name, giko_program);
    int cache=settings.value("network_caching",150).toInt();
    int vlc_debug=settings.value("vlc_debug",0).toInt();
    QmlVlcConfig& config = QmlVlcConfig::instance();
    config.enableAdjustFilter( false );
    config.enableMarqueeFilter( false );
    config.enableLogoFilter( false );
    config.setTrustedEnvironment(true);
    config.setNetworkCacheTime(cache);
    config.enableNoVideoTitleShow(true);
    //config.enableRecord( true );
    config.enableDebug( vlc_debug );
    //config.enableRecord( true);


    qmlRegisterType<cRigmodel>("Gyco", 1, 0, "RigModel");
    qmlRegisterType<cCamera>("Gyco", 1, 0, "RigCamera");
    qmlRegisterType<cJoystick>("Gyco", 1, 0, "RigJoystick");
    QGuiApplication app(argc, argv);
    app.setOrganizationName(giko_name);
    app.setOrganizationDomain("hyco.ru");
    app.setApplicationName(giko_program);

    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    qDebug()<<"Engine loaded"<<giko_name<<"  "<<giko_program;

    return app.exec();
    toggle_log(false);
    qDebug()<<"Good bye"<<giko_name<<"  "<<giko_program;
}

