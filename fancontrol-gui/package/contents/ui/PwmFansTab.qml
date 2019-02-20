/*
 * Copyright (C) 2015  Malte Veerman <malte.veerman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */


import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.3 as Kirigami
import Fancontrol.Qml 1.0 as Fancontrol


Kirigami.Page {
    property QtObject loader: Fancontrol.Base.loader
    property QtObject systemdCom: Fancontrol.Base.hasSystemdCommunicator() ? Fancontrol.Base.systemdCom : null
    property QtObject pwmFanModel: Fancontrol.Base.pwmFanModel
    property QtObject tempModel: Fancontrol.Base.tempModel
    property QtObject profileModel: Fancontrol.Base.profileModel
    property var pwmFans: pwmFanModel.fans
    property QtObject fan: applicationWindow().fan

    id: root

    header: Fancontrol.FanHeader {
        fan: root.fan
    }

    contextualActions: [
        Kirigami.Action {
            text: i18n("Manage profiles")
            onTriggered: profilesDialog.open()
        },
        Kirigami.Action {
            text: i18n("Service")
            visible: Fancontrol.Base.hasSystemdCommunicator
            tooltip: i18n("Control the systemd service")

            Kirigami.Action {
                text: !!systemdCom && systemdCom.serviceActive ? i18n("Stop service") : i18n("Start service")
                icon.name: !!systemdCom && systemdCom.serviceActive ? "media-playback-stop" : "media-playback-start"

                onTriggered: systemdCom.serviceActive = !systemdCom.serviceActive
            }
            Kirigami.Action {
                text: !!systemdCom && systemdCom.serviceEnabled ? i18n("Disable service") : i18n("Enable service")
                tooltip: !!systemdCom && systemdCom.serviceEnabled ? i18n("Disable service autostart at boot") : i18n("Enable service autostart at boot")

                onTriggered: systemdCom.serviceEnabled = !systemdCom.serviceEnabled
            }
        },
        Kirigami.Action {
            text: loader.sensorsDetected ? i18n("Detect fans again") : i18n("Detect fans")
            icon.name: "dialog-password"
            onTriggered: loader.detectSensors()
        },
        Kirigami.Action {
            visible: !!systemdCom && !!fan
            text: !!fan ? fan.testing ? i18n("Abort test") : i18n("Test start and stop values") : ""
            icon.name: "dialog-password"
            onTriggered: {
                if (fan.testing) {
                    fan.abortTest();
                } else {
                    fan.test();
                }
            }
        }
    ]

    mainAction: Kirigami.Action {
        text: i18n("Apply")
        enabled: Fancontrol.Base.needsApply
        icon.name: "dialog-ok-apply"
        tooltip: i18n("Apply changes")
        shortcut: StandardKey.Apply

        onTriggered: Fancontrol.Base.apply()
    }
    rightAction: Kirigami.Action {
        text: i18n("Reset")
        enabled: Fancontrol.Base.needsApply
        icon.name: "edit-undo"
        tooltip: i18n("Revert changes")

        onTriggered: Fancontrol.Base.reset()
    }

    ColumnLayout {
        anchors.fill: parent

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: !!root.fan

            sourceComponent: Fancontrol.FanItem {
                fan: root.fan
                tempModel: root.tempModel
                systemdCom: root.systemdCom
            }
        }
    }

    Label {
        anchors.centerIn: parent
        visible: pwmFans.length === 0
        text: i18n("There are no pwm capable fans in your system.")
        font.pointSize: 14
        font.bold: true
    }

    Fancontrol.ProfilesDialog {
        id: profilesDialog

        visible: false
        modal: true
        anchors.centerIn: parent
    }
}
