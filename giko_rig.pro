TEMPLATE = app
# обязательно требуется мультимедия от QT иначе не регистрируется плагин.
QT += qml quick multimedia network
CONFIG += c++11
# This line is from QmlVlcDemo.pro
INCLUDEPATH += deps
SOURCES += main.cpp \
    rigmodel.cpp \
    camera.cpp \
    cjoystick.cpp \
    xinputGamepad.cpp

RESOURCES += qml.qrc

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
    xinputGamepad.h

DISTFILES += \
    skin/hycoicon.ico

RC_ICONS = skin/hycoicon.ico

win32: LIBS += -L$$PWD/SFML/lib/ -lsfml-window

INCLUDEPATH += $$PWD/SFML
DEPENDPATH += $$PWD/SFML
