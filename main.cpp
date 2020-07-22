#include <QtGui/QGuiApplication>

#include <QmlVlc.h>


#include "rigmodel.h"
#include "networker.h"
#include "camera.h"
#include <QtQml>
#include "cjoystick.h"
#include <QSettings>

#define giko_name "HYCO"
#define giko_program "NPA Console"
#define LOG_PATH "log"
#define LOG_PREFFIX "/NPA_log_"

#include <stdio.h>
#include <stdlib.h>
#include <QFile>
#include <iostream>

#include "modbus\cmodbusclient.h"


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
    //QByteArray lMsg=codec->convertToUnicode(msg);
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
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps); // HiDPI pixmaps
    qputenv("QT_SCALE_FACTOR", "1");
    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache);
    //QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);
    qInstallMessageHandler(myMessageOutput);
    toggle_log(true);
    QSystemSemaphore semaphore("hyco npa", 1);  // create semaphore
    semaphore.acquire(); // Raise the semaphore, barring other instances to work with shared memory

#ifndef Q_OS_WIN32
    // in linux / unix shared memory is not freed when the application terminates abnormally,
    // so you need to get rid of the garbage
    QSharedMemory nix_fix_shared_memory("<uniq id 2>");
    if(nix_fix_shared_memory.attach()){
        nix_fix_shared_memory.detach();
    }
#endif

    QSharedMemory sharedMemory("hyco npa smem");  // Create a copy of the shared memory
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


    RegisterQmlVlc();
    QSettings settings(giko_name, giko_program);
    int cache=settings.value("network_caching",250).toInt();
    int vlc_debug=settings.value("vlc_debug",2).toInt();
    QmlVlcConfig& config = QmlVlcConfig::instance();
    config.enableAdjustFilter( false );
    config.enableMarqueeFilter( false ); //litovko
    config.enableLogoFilter( false );
    config.setTrustedEnvironment(true); // не будет воприниматься :sout иначе.
    config.setNetworkCacheTime(cache);
    config.enableNoVideoTitleShow(true);
    config.enableDebug( vlc_debug );
    qDebug()<<"Start"<<giko_name<<"  "<<giko_program<<" vlc_debug:"<<vlc_debug;


    qmlRegisterType<cRigmodel>("Gyco", 1, 0, "Board");
    qmlRegisterType<cNetworker>("Gyco", 1, 0, "Networker");
    qmlRegisterType<cCamera>("Gyco", 1, 0, "RigCamera");
    qmlRegisterType<cJoystick>("Gyco", 1, 0, "RigJoystick");
    qmlRegisterType<cModbusClient>("Gyco", 1, 0, "Modbus");
    QCoreApplication::setAttribute(Qt::AA_DisableShaderDiskCache);

    QGuiApplication app(argc, argv);
    app.setOrganizationName(giko_name);
    app.setOrganizationDomain("hyco.ru");
    app.setApplicationName(giko_program);

    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    qDebug()<<"Engine loaded"<<giko_name<<"  "<<giko_program;

    int ex=app.exec();
    settings.setValue("vlc_debug", vlc_debug);
    qDebug()<<"Good bye"<<giko_name<<"  "<<giko_program;
    //toggle_log(false);
    out.flush();
    return ex;
}

