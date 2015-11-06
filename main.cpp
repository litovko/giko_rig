#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "rigmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<cRigmodel>("Gyco", 1, 0, "RigModel");
    //cRigmodel  rig;
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

