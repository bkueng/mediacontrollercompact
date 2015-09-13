/***************************************************************************
 *   Copyright 2013 Sebastian Kügler <sebas@kde.org>                       *
 *   Copyright 2014 Kai Uwe Broulik <kde@privat.broulik.de>                *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU Library General Public License for more details.                  *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: expandedRepresentation
    anchors.fill: parent

    Layout.minimumWidth: 400
    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: parent.height
    Layout.fillHeight: true

    readonly property int controlSize: Math.min(height, width)
    // Basically just needed to match the right margin to the left in systray popup
    readonly property bool constrained: plasmoid.formFactor == PlasmaCore.Types.Vertical || plasmoid.formFactor == PlasmaCore.Types.Horizontal

    property int position: mpris2Source.data[mpris2Source.current].Position
    property bool disablePositionUpdate: false

    property bool isExpanded: plasmoid.expanded


    Column {
        id: titleColumn
        width: constrained ? parent.width - units.largeSpacing : parent.width
        height: parent.height
        Layout.fillHeight: true
        spacing: units.smallSpacing

        RowLayout {
            id: titleRow
            spacing: units.smallSpacing
            Layout.fillHeight: true
            width: parent.width
            height: parent.height

            Column {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                PlasmaComponents.Label {
                    id: song
                    width: parent.width
                    opacity: 0.9
                    height: parent.height / 2

                    elide: Text.ElideRight
                    text: root.track ? root.track : i18n("No media playing")
                }

                PlasmaComponents.Label {
                    id: artist
                    width: parent.width
                    opacity: 0.7
                    height: parent.height / 2

                    elide: Text.ElideRight
                    text: root.artist ? root.artist : ""
                }
            }
            /*
            Column {
                PlasmaComponents.Button {
text: i18nc("Bring the window of player %1 to the front", "Open %1", mpris2Source.data[mpris2Source.current].Identity)
          visible: !root.noPlayer && mpris2Source.data[mpris2Source.current].CanRaise
          onClicked: root.action_openplayer()
                }

            }
            */
            Column {
                id: playerControls
                Layout.fillWidth: true
                Layout.fillHeight: true
                property bool enabled: !root.noPlayer && mpris2Source.data[mpris2Source.current].CanControl
                property int controlsSize: theme.mSize(theme.defaultFont).height * 3

                //spacing: units.largeSpacing

                PlasmaComponents.ToolButton {
                    width: expandedRepresentation.controlSize
                    height: width
                    enabled: playerControls.enabled && mpris2Source.data[mpris2Source.current].CanGoPrevious
                    iconSource: "media-skip-backward"
                    onClicked: root.previous()
                }
            }
            Column {
                Layout.fillWidth: true
                Layout.fillHeight: true

                PlasmaComponents.ToolButton {
                    width: expandedRepresentation.controlSize
                    height: width
                    enabled: playerControls.enabled
                    iconSource: root.state == "playing" ? "media-playback-pause" : "media-playback-start"
                    onClicked: root.playPause()
                }
            }
            Column {
                Layout.fillWidth: true
                Layout.fillHeight: true

                PlasmaComponents.ToolButton {
                    width: expandedRepresentation.controlSize
                    height: width
                    enabled: playerControls.enabled && mpris2Source.data[mpris2Source.current].CanGoNext
                    iconSource: "media-skip-forward"
                    onClicked: root.next()
                }
            }
        }

    }

}
