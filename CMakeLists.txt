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

set(mymediacontrollerplugin_SRCS
    plugin/volume_control.cpp
    plugin/volume_control_plugin.cpp
    )


add_library(mymediacontrollerplugin SHARED ${mymediacontrollerplugin_SRCS})
target_link_libraries(mymediacontrollerplugin Qt5::Core
                                    Qt5::Qml
                                    KF5::CoreAddons)

install(TARGETS mymediacontrollerplugin DESTINATION
	${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/mymediacontroller)

install(FILES plugin/qmldir DESTINATION
	${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/mymediacontroller)

# Add installatation target ("make install").
plasma_install_package(package org.kde.plasma.mymediacontroller)
# run it:
# make install
# export QML2_IMPORT_PATH=/usr/local/lib64/qml
# plasmawindowed org.kde.plasma.mymediacontroller
# TODO: install to system location? (/usr/lib64/qt5/qml)

# TODO: cleanup /usr/local ...
