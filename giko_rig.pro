QT += quick network
CONFIG += c++11  console
TARGET = NPA
#CONFIG+=debug
#mingw:QMAKE_CXXFLAGS_DEBUG += "-gstabs+"
#mingw:QMAKE_CFLAGS_DEBUG += "-gstabs+"
VERSION = 5.10.0.1
#INCLUDEPATH += deps
SOURCES += main.cpp \
    networker.cpp \
    rigmodel.cpp \
    camera.cpp \
    cjoystick.cpp \
    qJoyStick.cpp

RESOURCES += qml.qrc
#mingw: QMAKE_LFLAGS +=-static-libgcc -static-libstdc++
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri)
# This line is from QmlVlcDemo.pro
#include(deps/QmlVlc/QmlVlc.pri)
include(../QmlVlc\QmlVlc.pri)

#OTHER_FILES += \
#    skin/basic_2.qml \
#    skin/pause.png \
#    skin/play.png



#
HEADERS += \
    networker.h \
    rigmodel.h \
    camera.h \
    cjoystick.h \
    qJoyStick.h

DISTFILES += \
    skin/hycoicon.ico \
    NPA_hand.qml \
    NPA_hand.qml \
    skin/npa.ico \
    skin/favicon.ico

RC_ICONS = skin/npa.ico


INCLUDEPATH += $$PWD/SDL2/include

mingw:DESTDIR = D:\dest.rig.5.11.mingw
msvc:DESTDIR = D:\dest.rig.5.11.msvc
Kit=$$[QT_INSTALL_PREFIX]
equals(Kit,"C:/Qt/5.12.1/mingw73_64"){
    message("Kit for 64 bit mingw73")
    LIBS += -L$$PWD/SDL/lib/x64 -lSDLmain
}
equals(Kit,"C:/Qt/5.11.3/mingw53_32"){
    message("Kit for 32 bit mingw53_32")
    LIBS += -L$$PWD/SDL/lib/x86 -lSDL
}
equals(Kit,"C:/Qt/5.12.1/msvc2017_64"){
    message("Kit for 64 bit MSVC")
    #LIBS += -L$$PWD/SDL/lib/x64 -lSDL
    LIBS += -L$$PWD/SDL2/lib/x64  -lSDL2 -lSDL2main
    DESTDIR = D:\dest.rig.5.12.msvc
}
message(LIBS $$LIBS)
message(KIT $$Kit)
system(d:\nc\nc.bat)



