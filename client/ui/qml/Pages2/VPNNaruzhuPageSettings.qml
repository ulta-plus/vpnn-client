import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Controls2/TextTypes"
import "../Config"

PageType {
    id: root

    ListViewType {
        id: listView

        anchors.fill: parent

        header: ColumnLayout {
            width: listView.width

            BackButtonType {
                id: backButton
                Layout.topMargin: 20
                backButtonFunction: function () {
                    PageController.goToPageHome()
                }
            }

            BaseHeaderType {
                id: header
                Layout.fillWidth: true
                Layout.topMargin: 24
                Layout.bottomMargin: 16
                Layout.rightMargin: 16
                Layout.leftMargin: 16

                headerText: qsTr("Settings")
            }
        }

        model: settingsEntries

        delegate: ColumnLayout {
            width: listView.width

            spacing: 0

            LabelWithButtonType {
                Layout.fillWidth: true

                visible: isVisible

                text: title
                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: leftImagePath

                clickedFunction: clickedHandler
            }

            DividerType {
                visible: isVisible
            }
        }
    }

    property list<QtObject> settingsEntries: [
        connection,
        application,
        about,
        supportTelegramm,
        telegrammGroup
    ]

    QtObject {
        id: connection

        property string title: qsTr("Connection")
        readonly property string leftImagePath: "qrc:/images/controls/radio.svg"
        property bool isVisible: true
        readonly property var clickedHandler: function() {
            PageController.goToPage(PageEnum.VPNNaruzhuPageSettingsConnection)
        }
    }
    QtObject {
        id: application

        property string title: qsTr("Application")
        readonly property string leftImagePath: "qrc:/images/controls/app.svg"
        property bool isVisible: true
        readonly property var clickedHandler: function() {
            PageController.goToPage(PageEnum.PageSettingsApplication)
        }
    }
    QtObject {
        id: about

        property string title: qsTr("About VPNNaruzhu")
        readonly property string leftImagePath: "qrc:/images/controls/external-link.svg"
        property bool isVisible: true
        readonly property var clickedHandler: function() {
            Qt.openUrlExternally(VPNNWebApi.getAboutLink())
        }
    }
    QtObject {
        id: supportTelegramm

        property string title: qsTr("Support via Telegram")
        readonly property string leftImagePath: "qrc:/images/controls/telegramNaruzhu.svg"
        property bool isVisible: true
        readonly property var clickedHandler: function() {
            GC.coppyUUIDToClipBoard()
            Qt.openUrlExternally(VPNNWebApi.getSupportLink())
        }
    }
    QtObject {
        id: telegrammGroup

        property string title: qsTr("Telegram Channel")
        readonly property string leftImagePath: "qrc:/images/controls/chat.svg"
        property bool isVisible: true
        readonly property var clickedHandler: function() {
            Qt.openUrlExternally("https://t.me/vpn_naruzhu")
        }
    }
}
