TEMPLATE = app
# обязательно требуется мультимедия от QT иначе не регистрируется плагин.
QT += qml quick multimedia network
CONFIG += c++11 // console
# This line is from QmlVlcDemo.pro
INCLUDEPATH += deps
SOURCES += main.cpp \
    rigmodel.cpp \
    camera.cpp \
    cjoystick.cpp \
    qJoyStick.cpp

RESOURCES += qml.qrc
QMAKE_LFLAGS +=-static-libgcc -static-libstdc++
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
# This line is from QmlVlcDemo.pro
include(deps/QmlVlc/QmlVlc.pri)

#OTHER_FILES += \
#    skin/basic_2.qml \
#    skin/pause.png \
#    skin/play.png



#
HEADERS += \
    rigmodel.h \
    camera.h \
    cjoystick.h \
    qJoyStick.h

DISTFILES += \
    skin/hycoicon.ico

RC_ICONS = skin/hycoicon.ico

LIBS += -lSDL
#win32 {
#    DEFINES += SDL_WIN
#}
win32: LIBS += -L$$PWD/SDL/lib/ -lSDLmain

INCLUDEPATH += $$PWD/SDL/include
DEPENDPATH += $$PWD/SDL/include
