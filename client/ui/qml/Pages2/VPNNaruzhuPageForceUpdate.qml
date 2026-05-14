import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Config"
import "../Controls2/TextTypes"
import "../Components"

PageType {
    id: root

    property string startUpdateText: qsTr('Start update')
    property string updatingText: qsTr('Updating...')

    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 0

        VPNNaruzhuHeader {
            id: header
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 24
            text: qsTr('Required update')
        }

        Text {
            Layout.leftMargin: 24
            Layout.alignment: Qt.AlignLeft

            color: VPNNaruzhuStyle.color.headerText
            font.pixelSize: 16
            font.weight: Font.Medium
            font.family: VPNNaruzhuStyle.font

            text: qsTr('Sorry for the inconvinients. Application\nshould be updated before using.')
        }

        VPNNaruzhuButton {
            id: updateButton
            objectName: 'updateButton'

            enabled: !VPNNDownloadController.inProgress

            Layout.topMargin: 10
            Layout.alignment: Qt.AlignHCenter

            implicitHeight: 41
            implicitWidth: 327
            radius: 4

            mainText: VPNNDownloadController.inProgress ? updatingText : startUpdateText
            capitalization: Font.AllUppercase

            hoveredOpacity: 0.5

            onClicked: {
                downloaderWindow.refresh()
                downloaderWindow.show()
                VPNNWebApi.downloadAndInstallNewApp()
            }
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.leftMargin: 16
        anchors.bottomMargin: 24

        Text {
            text: 'v' + VPNNWebApi.getAppVersion() + '   d: ' + VPNNWebApi.getUUIDLastSymbols()
            color: VPNNaruzhuStyle.color.footnotes
            opacity: 0.56
            font.pixelSize: 12
            font.weight: Font.Medium
            font.family: VPNNaruzhuStyle.font

            Layout.alignment: Qt.AlignVCente | Qt.AlignLeft
        }

        VPNNaruzhuButton {
            id: telegramButton

            Layout.alignment: Qt.AlignRight

            implicitHeight: 38
            implicitWidth: 144
            radius: 3

            borderWidth: 1
            borderFocusedWidth: 1

            defaultColor: 'transparent'
            pressedColor: 'transparent'
            hoveredColor: 'transparent'

            leftIcon: 'qrc:/images/controls/telegram.svg'
            leftIconColor: '#FFFFFF'

            textColor: '#FFFFFF'
            textSize: 14
            letterSpacing: textSize * (-0.05)
            mainText: qsTr('Telegram')

            onClicked: {
                Qt.openUrlExternally(VPNNWebApi.getTgChannelLink())
            }
        }
    }
}
