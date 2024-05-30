/*
 * Copyright 2013 Sebastian Kügler <sebas@kde.org>
 * Copyright 2015 Beat Küng <beat-kueng@gmx.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_widgetWidth: widgetWidth.text
    property alias cfg_volumeUpCmd: volumeUpCmd.text
    property alias cfg_volumeDownCmd: volumeDownCmd.text
    property alias cfg_startPlayerCmd: startPlayerCmd.text

    TextField {
        id: widgetWidth
        Kirigami.FormData.label: i18n("Widget width:")
        placeholderText: i18n("")
        validator: IntValidator {bottom: 100; top: 2000}
    }

    TextField {
        id: volumeUpCmd
        Kirigami.FormData.label: i18n("Increase volume (mouse wheel):")
        placeholderText: i18n("")
    }
    TextField {
        id: volumeDownCmd
        Kirigami.FormData.label: i18n("Decrease volume (mouse wheel):")
        placeholderText: i18n("")
    }
    TextField {
        id: startPlayerCmd
        Kirigami.FormData.label: i18n("Start player:")
        placeholderText: i18n("")
    }
}
