# Set minimum CMake version (required for CMake 3.0 or later)
cmake_minimum_required(VERSION 2.8.12)
 
# Use Extra CMake Modules (ECM) for common functionality.
# See http://api.kde.org/ecm/manual/ecm.7.html
# and http://api.kde.org/ecm/manual/ecm-kde-modules.7.html
find_package(ECM REQUIRED NO_MODULE)
# Needed by find_package(KF5Plasma) below.
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_MODULE_PATH})
 
# Locate plasma_install_package macro.
find_package(KF5Plasma REQUIRED)
 

set(QT_MIN_VERSION "5.4.0")
find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Widgets Quick QuickWidgets Concurrent Script)

set(CMAKE_AUTOMOC ON)

set(mediacontrollercompactplugin_SRCS
    plugin/volume_control.cpp
    plugin/volume_control_plugin.cpp
    )


add_library(mediacontrollercompactplugin SHARED ${mediacontrollercompactplugin_SRCS})
target_link_libraries(mediacontrollercompactplugin Qt5::Core
                                    Qt5::Qml
                                    KF5::CoreAddons)

install(TARGETS mediacontrollercompactplugin DESTINATION
	${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/mediacontrollercompact)

install(FILES plugin/qmldir DESTINATION
	${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/mediacontrollercompact)

# Add installatation target ("make install").
plasma_install_package(package org.kde.plasma.mediacontrollercompact)
# run it:
# make install
# export QML2_IMPORT_PATH=/usr/local/lib64/qml
# plasmawindowed org.kde.plasma.mediacontrollercompact
# TODO: install to system location? (/usr/lib64/qt5/qml)

# TODO: cleanup /usr/local ...
