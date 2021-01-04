QT +=  quick network multimedia xml
CONFIG += c++11  console
VERSION = 7.7.0.5
SOURCES += main.cpp \
    camera/c_onvif.cpp \
    camera/camera.cpp \
    camera/checktcp.cpp \
    camera/decoder.cpp \
    camera/frame_buffer.cpp \
    camera/ipcamera.cpp \
    camera/recorder.cpp \
    camera/rtsp_stream.cpp \
    networker.cpp \
    rigmodel.cpp \
    cjoystick.cpp \
    qJoyStick.cpp

RESOURCES += qml.qrc
#QML_IMPORT_PATH = C:\Qt\5.12.1\msvc2017_64\qml\QtQuick

HEADERS += networker.h \
    camera/c_onvif.h \
    camera/camera.h \
    camera/checktcp.h \
    camera/decoder.h \
    camera/frame_buffer.h \
    camera/ipcamera.h \
    camera/recorder.h \
    camera/rtsp_stream.h \
    rigmodel.h \
    cjoystick.h \
    qJoyStick.h

INCLUDEPATH += $$PWD/../FFmpeg

LIBS += -L$$PWD/../FFmpeg/lib/ -lavcodec
LIBS += -L$$PWD/../FFmpeg/lib/ -lavformat
LIBS += -L$$PWD/../FFmpeg/lib/ -lavutil
LIBS += -L$$PWD/../FFmpeg/lib/ -lswscale

#DISTFILES += \
#    NPA_hand.qml \
#    qml/MyButton.qml \
#    skin/mgm7.ico

RC_ICONS = skin/mgm7.ico

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
    DESTDIR = D:\dest.mgm7.5.12.msvc
}
equals(Kit,"C:/Qt/5.15.1/msvc2019_64"){
    message("Kit for 64 bit MSVC2019")
    LIBS += -L$$PWD/SDL2/lib/x64  -lSDL2 -lSDL2main
    DESTDIR = d:\dest.mgm7.5.15.msvc
}
equals(Kit,"C:/Qt/5.15.2/msvc2019_64"){
    message("Kit for 64 bit MSVC2019")
    LIBS += -L$$PWD/SDL2/lib/x64  -lSDL2 -lSDL2main
    DESTDIR = d:\dest.mgm7.5.15.2.msvc
}
#message(LIBS $$LIBS)
#message(KIT $$Kit)
TARGET=MGM7


#######
# C:\Qt\5.15.2\msvc2019_64\bin\qmake -spec win32-msvc -tp vc

