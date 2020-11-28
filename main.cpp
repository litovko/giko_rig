#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "camera/ipcamera.h"
#include <QSystemSemaphore>
//#include <QSharedMemory>
#include <QDir>
#include "rigmodel.h"
#include "networker.h"
#include <QtQml>
#include "cjoystick.h"
#include <QSettings>

#define giko_name "HYCO"
#define giko_program "MGM-7 Console"
#define LOG_PATH "log"
#define LOG_PREFFIX "/MGM7_log_"

#include <stdio.h>
#include <stdlib.h>
#include <QFile>
#include <iostream>
#include "camera/checktcp.h"
#include "camera/camera.h"
//DONE: протестировать утечку памяти
// https://kinddragon.github.io/vld/
// C:\Qt\5.15.2\msvc2019_64\bin\qmake -spec win32-msvc -tp vc
//#include <vld.h>

static QFile logfile;
static QTextStream out(&logfile);
static bool recordinglog=false;
//Включение и отключение записи логов
extern void toggle_log(bool recordlog) {
    if (!recordlog) {
        if(logfile.isOpen()) {
            logfile.write("Close\n");
            logfile.flush();
            out.flush();
            logfile.close();
        }
        recordinglog=false;
        return;
    }
    if (!logfile.isOpen()) {
        QString s=LOG_PATH;
        if (!QDir(s).exists())
            QDir().mkdir(s);

        logfile.setFileName(s+LOG_PREFFIX+QDateTime::currentDateTime().toString("dd-MM-yyyy_hh-mm-ss-zzz.log"));
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
        out<<"D:"<<QDateTime::currentDateTime().toString("dd.MM:hh:mm:ss:zzz ").toUtf8().data()<<" "<<msg<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        break;
    case QtWarningMsg:
        fprintf(stderr, "W:%s %s (%s:%u, %s)\n",QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data(), localMsg.constData(), context.file, context.line, context.function);
        out<<"W:"<<QDateTime::currentDateTime().toString("dd.MM:hh:mm:ss:zzz ").toLocal8Bit().data()<<" "<<msg<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        break;
    case QtCriticalMsg:
        fprintf(stderr, "C:%s %s (%s:%u, %s)\n",QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data(), localMsg.constData(), context.file, context.line, context.function);
        out<<"C:"<<QDateTime::currentDateTime().toString("dd.MM:hh:mm:ss:zzz ").toLocal8Bit().data()<<" "<<localMsg.constData()<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        break;
    case QtFatalMsg:
        fprintf(stderr, "F:%s %s (%s:%u, %s)\n",QTime::currentTime().toString("hh:mm:ss:zzz ").toLocal8Bit().data(), localMsg.constData(), context.file, context.line, context.function);
        out<<"FATAL:"<<QDateTime::currentDateTime().toString("dd.MM:hh:mm:ss:zzz ").toLocal8Bit().data()<<" "<<msg<<"("<<context.file<<":"<<context.line<<", "<<context.function<<")\n";
        abort();
    }
    if(logfile.isOpen()) out.flush();
}


int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling); // DPI support

//    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps); // HiDPI pixmaps
    //TODO Сделать переменную в реестре.
//    qputenv("QT_SCALE_FACTOR", "0.5"); //NOTE: Scale Factore
    
//    qputenv("QT_AUTO_SCREEN_SCALE_FACTOR", "0.5");
//    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache);
    //QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);
    qInstallMessageHandler(myMessageOutput);
    toggle_log(true);
    QSystemSemaphore semaphore("hyco mgm-7", 1);  // Создали семафор
    semaphore.acquire(); // Подняли семафор.

#ifndef Q_OS_WIN32
    // in linux / unix shared memory is not freed when the application terminates abnormally,
    // so you need to get rid of the garbage
    QSharedMemory nix_fix_shared_memory("<uniq id 2>");
    if(nix_fix_shared_memory.attach()){
        nix_fix_shared_memory.detach();
    }
#endif

    QSharedMemory sharedMemory("hyco mgm-7 smem");  // Create a copy of the shared memory
    bool is_running;
    if (sharedMemory.attach()){ //trying to attach to the existant shared memory
        is_running = true;
    }else{
        sharedMemory.create(1);
        is_running = false;
    }
    semaphore.release();
    setlocale(LC_ALL, ""); // избавляемся от кракозябров в консоли
    if(is_running){
        qWarning()<<"The program is already running!";
        qWarning()<<"Программа уже запущена!";
        std::string str;
        std::getline(std::cin, str);
        return 1;
    }

    QSettings settings(giko_name, giko_program);
    qmlRegisterType<cRigmodel>("Gyco", 1, 0, "Board");
    qmlRegisterType<cNetworker>("Gyco", 1, 0, "Networker");
    qmlRegisterType<cJoystick>("Gyco", 1, 0, "RigJoystick");
    qmlRegisterType<ipcamera>("HYCO", 1, 0, "IPCamera");
    qmlRegisterType<camera>("HYCO", 1, 0, "CamControl");
    qmlRegisterType<CheckTCP>("HYCO", 1, 0, "CheckTCP");
    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache); //NOTE понять зачем это?

    QGuiApplication app(argc, argv);
    app.setOrganizationName(giko_name);
    app.setOrganizationDomain("hyco.ru");
    app.setApplicationName(giko_program);

    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();

    qDebug()<<"Good bye"<<giko_name<<"  "<<giko_program;
    //toggle_log(false);
    out.flush();
}

