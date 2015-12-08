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

int main(int argc, char *argv[])
{
    RegisterQmlVlc();
    QSettings settings(giko_name, giko_program);
    int cache=settings.value("network_caching",333).toInt();
    QmlVlcConfig& config = QmlVlcConfig::instance();
    config.enableAdjustFilter( true );
    config.enableMarqueeFilter( true );
    config.enableLogoFilter( true );
    config.setTrustedEnvironment(true);
    config.setNetworkCacheTime(cache);
    //config.enableRecord( true );
    //config.enableDebug( true );
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

//############### такой код генерирует QT
//    QQmlApplicationEngine engine;
//    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
//#########################################################
    return app.exec();
}

