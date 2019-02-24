INCLUDEPATH += $$PWD/include
#
win32 {
    mingw:LIBS += $$PWD/lib/msvc/libvlc.lib
    msvc:LIBS += $$PWD/lib/msvc/libvlc.x64.lib
} else: !android {
    LIBS += -lvlc
}
