
TARGET  = updatesvc
CONFIG  += c++11 console utf8_source
CONFIG  -= app_bundle
CONFIG  -= qt
CONFIG  -= debug_and_release debug_and_release_target

TEMPLATE = app

CORE_ROOT_DIR = $$PWD/../../../../core

CONFIG += core_no_dst
include($$CORE_ROOT_DIR/Common/base.pri)

INCLUDEPATH += $$PWD/src
INCLUDEPATH += $$PWD/../../src/prop

HEADERS += $$PWD/src/version.h \
           $$PWD/src/classes/csocket.h \
           $$PWD/src/classes/csvcmanager.h \
           $$PWD/src/classes/translator.h

SOURCES += $$PWD/src/classes/csocket.cpp \
           $$PWD/src/classes/csvcmanager.cpp \
           $$PWD/src/classes/translator.cpp

ENV_PRODUCT_VERSION = $$(PRODUCT_VERSION)
!isEmpty(ENV_PRODUCT_VERSION) {
    FULL_PRODUCT_VERSION = $${ENV_PRODUCT_VERSION}.$$(BUILD_NUMBER)
    DEFINES += VER_PRODUCT_VERSION=$$FULL_PRODUCT_VERSION \
               VER_PRODUCT_VERSION_COMMAS=$$replace(FULL_PRODUCT_VERSION, \., ",")
}

core_windows {
    CONFIG -= embed_manifest_exe
    RC_FILE = $$PWD/res/version.rc

    contains(QMAKE_TARGET.arch, x86_64):{
        QMAKE_LFLAGS_WINDOWS = /SUBSYSTEM:WINDOWS,5.02
    } else {
        QMAKE_LFLAGS_WINDOWS = /SUBSYSTEM:WINDOWS,5.01
    }
}

core_release:DESTDIR = $$DESTDIR/build
core_debug:DESTDIR = $$DESTDIR/build/debug

!isEmpty(OO_BUILD_BRANDING) {
    DESTDIR = $$DESTDIR/$$OO_BUILD_BRANDING
}

DESTDIR = $$DESTDIR/$$CORE_BUILDS_PLATFORM_PREFIX

core_windows {
    HEADERS += $$PWD/src/platform_win/utils.h \
               $$PWD/src/platform_win/resource.h \
               $$PWD/src/platform_win/svccontrol.h \
               $$PWD/src/classes/platform_win/capplication.h \
               $$PWD/src/classes/platform_win/cunzip.h \
               $$PWD/src/classes/platform_win/cdownloader.h \
               $$PWD/src/classes/platform_win/ctimer.h

    SOURCES += $$PWD/src/platform_win/main.cpp \
               $$PWD/src/platform_win/utils.cpp \
               $$PWD/src/platform_win/svccontrol.cpp \
               $$PWD/src/classes/platform_win/capplication.cpp \
               $$PWD/src/classes/platform_win/cunzip.cpp \
               $$PWD/src/classes/platform_win/cdownloader.cpp \
               $$PWD/src/classes/platform_win/ctimer.cpp

    OTHER_FILES += $$PWD/res/version.rc \
                   $$PWD/res/manifest/updatesvc.exe.manifest

    build_xp {
        DESTDIR = $$DESTDIR/xp
        DEFINES += __OS_WIN_XP
    }

    LIBS += -lwinhttp \
            -lws2_32 \
            -lrpcrt4 \
            -lwtsapi32 \
            -lwintrust \
            -luserenv
}

core_linux {
    HEADERS += $$PWD/src/platform_linux/utils.h \
               $$PWD/src/classes/platform_linux/capplication.h \
               $$PWD/src/classes/platform_linux/cunzip.h \
               $$PWD/src/classes/platform_linux/cdownloader.h \
               $$PWD/src/classes/platform_linux/ctimer.h

    SOURCES += $$PWD/src/platform_linux/main.cpp \
               $$PWD/src/platform_linux/utils.cpp \
               $$PWD/src/classes/platform_linux/capplication.cpp \
               $$PWD/src/classes/platform_linux/cunzip.cpp \
               $$PWD/src/classes/platform_linux/cdownloader.cpp \
               $$PWD/src/classes/platform_linux/ctimer.cpp

    CONFIG += link_pkgconfig
    PKGCONFIG += gtk+-3.0
    LIBS += -lSDL2 -lcurl -luuid -larchive -lpthread
}

OBJECTS_DIR = $$DESTDIR/obj
MOC_DIR = $$DESTDIR/moc
RCC_DIR = $$DESTDIR/rcc
