#! /usr/bin/bash

if kpackagetool6 -t Plasma/Applet --list | grep -q "^org.kde.plasma.mediacontrollercompact$"; then
  kpackagetool6 -t Plasma/Applet --upgrade package
else
  kpackagetool6 -t Plasma/Applet --install package
fi
