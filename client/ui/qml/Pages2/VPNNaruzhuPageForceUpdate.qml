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
    readonly property bool migrationRequired: VPNNWebApi.isMigrationRequired()
    readonly property string officialWebsiteUrl: VPNNWebApi.migrationLandingUrl

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

        Text {
            id: officialWebsiteNote

            property bool isFocusable: visible

            Layout.topMargin: 16
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.fillWidth: true

            visible: root.migrationRequired
            activeFocusOnTab: visible
            color: VPNNaruzhuStyle.color.headerText
            font.pixelSize: 14
            font.weight: Font.Medium
            font.family: VPNNaruzhuStyle.font
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            text: qsTr('If you cannot install the update, go to the <a href="%1">official VPN Naruzhu website</a>').arg(root.officialWebsiteUrl)

            onLinkActivated: function(link) {
                Qt.openUrlExternally(link)
            }

            Keys.onEnterPressed: Qt.openUrlExternally(root.officialWebsiteUrl)
            Keys.onReturnPressed: Qt.openUrlExternally(root.officialWebsiteUrl)
            Keys.onTabPressed: FocusController.nextKeyTabItem()
            Keys.onBacktabPressed: FocusController.previousKeyTabItem()
            Keys.onUpPressed: FocusController.nextKeyUpItem()
            Keys.onDownPressed: FocusController.nextKeyDownItem()
            Keys.onLeftPressed: FocusController.nextKeyLeftItem()
            Keys.onRightPressed: FocusController.nextKeyRightItem()

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            }
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
