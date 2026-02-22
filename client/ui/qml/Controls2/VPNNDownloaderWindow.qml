import QtQuick
import QtQuick.Controls

import Style 1.0

Window {
    id: root
    width: 300
    height: 120
    minimumWidth: 300
    minimumHeight: 120
    maximumWidth: 300
    maximumHeight: 120

    visible: false
    title: qsTr("Downloading")

    Connections {
        target: VPNNDownloader

        function onFinished() {
            visible = false
        }
    }

    ProgressBar {
        anchors.centerIn: parent
        width: parent.width - 40
        value: VPNNDownloader.progress
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        text: Math.round(VPNNDownloader.progress * 100) + "%"
    }
}
