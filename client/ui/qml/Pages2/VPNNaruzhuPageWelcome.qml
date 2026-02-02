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

    ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        Image {
            id: image
            source: 'qrc:/images/welcome_logo.svg'

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 73
            Layout.preferredWidth: 222
            Layout.preferredHeight: 52
        }

        VPNNaruzhuHeader {
            Layout.fillWidth: true
            Layout.topMargin: 60
            Layout.leftMargin: 25
            Layout.rightMargin: 25
            font.letterSpacing: -1.2
            horizontalAlignment: Text.AlignHCenter
            text: qsTr('Smart VPN opens everything')
        }

        Text {
            Layout.topMargin: 24
            Layout.leftMargin: 26
            Layout.rightMargin: 26
            lineHeight: 1.5

            color: VPNNaruzhuStyle.color.headerText
            font.pixelSize: 16
            font.weight: Font.Medium
            font.family: VPNNaruzhuStyle.font

            text: qsTr('  •  Hish Speed up to 300 Mb/s
  •  Up to 10 devices simultaneously
  •  36 countries to choose
  •  Guaranteed results
  •  Responsive support
  •  Private and secure traffic
  •  Unlimited')
        }

        VPNNaruzhuButton {
            id: continueButton

            Layout.topMargin: 28
            Layout.alignment: Qt.AlignHCenter

            implicitHeight: 41
            implicitWidth: 327
            radius: 4

            mainText: qsTr('Continue')
            capitalization: Font.AllUppercase

            hoveredOpacity: 0.5

            onClicked: {
                PageController.goToPage(PageEnum.VPNNaruzhuPageEmailLogIn)
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
                Qt.openUrlExternally("https://t.me/vpn_naruzhu")
            }
        }
    }
}
