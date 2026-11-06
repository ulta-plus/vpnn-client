import QtQuick
import QtQuick.Controls

import Style 1.0

Window {
    id: root
    width: 300
    height: 200
    minimumWidth: 300
    minimumHeight: 200
    maximumWidth: 300
    maximumHeight: 200

    visible: false
    title: qsTr("Downloading")
    color: VPNNaruzhuStyle.color.backGround

    Connections {
        target: VPNNDownloadController

        function onFinished() {
            root.visible = false
        }

        function onErrorOccurred() {
            root.visible = true
            retryDownload.visible = true
        }
    }

    ProgressBar {
        id: progreeBar
        anchors.centerIn: parent
        width: parent.width - 40
        value: VPNNDownloadController.progress
    }

    Text {
        id: info
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        color: VPNNaruzhuStyle.color.notificationText
        font.family: VPNNaruzhuStyle.font
        text: Math.round(VPNNDownloadController.progress * 100) + "%"
    }

    VPNNaruzhuYesNoNotification {
        id: retryDownload
        visible: false

        radius: 0
        implicitHeight: 200
        implicitWidth: 300

        text: VPNNWebApi.updateError + "\n" + qsTr('Do you want to retry?')

        withYesClick: function() {
            retryDownload.visible = false
            VPNNWebApi.downloadAndInstallNewApp()
        }
        withNoClick: function() {
            root.visible = false
            retryDownload.visible = false
        }
    }

    function refresh() {
        retryDownload.visible = false
    }
}
