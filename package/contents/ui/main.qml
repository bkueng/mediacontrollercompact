/***************************************************************************
 *   Copyright 2013 Sebastian Kügler <sebas@kde.org>                       *
 *   Copyright 2014 Kai Uwe Broulik <kde@privat.broulik.de>                *
 *   Copyright 2015 Beat Küng <beat-kueng@gmx.net>                         *
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
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.private.mpris as Mpris
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property var metadata: mpris2Model.currentPlayer ? mpris2Model.currentPlayer : undefined
    property string track: {
        if (metadata) return metadata.track
        return ""
    }
    property string artist: {
        if (metadata) return metadata.artist
        return ""
    }
    property string playerIcon: ""

    readonly property bool noPlayer: !mpris2Model.currentPlayer

    readonly property bool canControl: mpris2Model.currentPlayer?.canControl ?? false
    readonly property bool canGoPrevious: mpris2Model.currentPlayer?.canGoPrevious ?? false
    readonly property bool canGoNext: mpris2Model.currentPlayer?.canGoNext ?? false
    readonly property bool canPlay: mpris2Model.currentPlayer?.canPlay ?? false
    readonly property bool canPause: mpris2Model.currentPlayer?.canPause ?? false

    switchWidth: Kirigami.Units.gridUnit * 14
    switchHeight: Kirigami.Units.gridUnit * 10
    toolTipMainText: i18n("No media playing")
    Plasmoid.status: PlasmaCore.Types.ActiveStatus

    // HACK Some players like Amarok take quite a while to load the next track
    // this avoids having the plasmoid jump between popup and panel
    onStateChanged: {
        if (state != "") {
            plasmoid.status = PlasmaCore.Types.ActiveStatus
        } else {
            updatePlasmoidStatusTimer.restart()
        }
    }

    Timer {
        id: updatePlasmoidStatusTimer
        interval: 250
        onTriggered: {
            if (state !== "") {
                plasmoid.status = PlasmaCore.Types.ActiveStatus
            } else {
                plasmoid.status = PlasmaCore.Types.PassiveStatus
            }
        }
    }

    fullRepresentation: ExpandedRepresentation {}

    compactRepresentation: ExpandedRepresentation {}

    Plasma5Support.DataSource {
        id: executeSource
        engine: "executable"
        connectedSources: []

        property string lastCmd: ""

        onNewData: {
            // we get new data when the process finished, so we can remove it
            disconnectSource(lastCmd)
        }
    }
    function exec(cmd) {
        //Note: we assume that 'cmd' is executed quickly so that a previous call
        //with the same 'cmd' has already finished (otherwise no new cmd will be
        //added because it is already in the list)
        executeSource.lastCmd = cmd
        executeSource.connectSource(cmd)
    }


    Mpris.Mpris2Model {
        id: mpris2Model
        onDataChanged: {
        }
        onCurrentPlayerChanged: {
        }
    }

    function action_openplayer() {
        mpris2Model.currentPlayer.Raise()
    }
    function volumeUp() {
        exec(plasmoid.configuration.volumeUpCmd)
    }
    function volumeDown() {
        exec(plasmoid.configuration.volumeDownCmd)
    }

    function playPause() {
        mpris2Model.currentPlayer.PlayPause()
    }

    function previous() {
        mpris2Model.currentPlayer.Previous();
    }

    function next() {
        mpris2Model.currentPlayer.Next()
    }

    states: [
        State {
            name: "playing"
            when: !root.noPlayer && mpris2Model.currentPlayer.playbackStatus === Mpris.PlaybackStatus.Playing

            PropertyChanges {
                target: root
                toolTipMainText: artist + " - " + track
            }
        },
        State {
            name: "paused"
            when: !root.noPlayer && mpris2Model.currentPlayer.playbackStatus !== Mpris.PlaybackStatus.Playing

            PropertyChanges {
                target: root
                toolTipMainText: artist + " - " + track + " (paused)"
            }
        }
    ]
}
