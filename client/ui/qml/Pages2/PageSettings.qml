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

    defaultActiveFocusItem: header

    FlickableType {
        id: fl
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        contentHeight: content.height

        ColumnLayout {
            id: content

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 0

            HeaderType {
                id: header
                Layout.fillWidth: true
                Layout.topMargin: 24
                Layout.rightMargin: 16
                Layout.leftMargin: 16

                headerText: qsTr("Settings")

                KeyNavigation.tab: account.rightButton
            }

            LabelWithButtonType {
                id: account
                Layout.fillWidth: true
                Layout.topMargin: 16

                text: qsTr("Servers")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: "qrc:/images/controls/server.svg"

                clickedFunction: function() {
                    PageController.goToPage(PageEnum.PageSettingsServersList)
                }

                KeyNavigation.tab: connection.rightButton
            }

            DividerType {}

            LabelWithButtonType {
                id: connection
                Layout.fillWidth: true

                text: qsTr("Connection")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: "qrc:/images/controls/radio.svg"

                clickedFunction: function() {
                    PageController.goToPage(PageEnum.PageSettingsConnection)
                }

                KeyNavigation.tab: application.rightButton
            }

            DividerType {}

            LabelWithButtonType {
                id: application
                Layout.fillWidth: true

                text: qsTr("Application")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: "qrc:/images/controls/app.svg"

                clickedFunction: function() {
                    PageController.goToPage(PageEnum.PageSettingsApplication)
                }

                KeyNavigation.tab: supportTelegramm.rightButton
            }

            DividerType {}

            LabelWithButtonType {
                id: supportTelegramm
                Layout.fillWidth: true

                text: qsTr("Support via Telegram")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: "qrc:/images/controls/telegramNaruzhu.svg"

                clickedFunction: function() {
                     Qt.openUrlExternally("https://t.me/ultadiscord_bot")
                }
                KeyNavigation.tab: supportTelegramm.rightButton
            }

            DividerType {}

            LabelWithButtonType {
                id: telegrammGroup
                Layout.fillWidth: true

                text: qsTr("Telegram Group")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: "qrc:/images/controls/chat.svg"

                clickedFunction: function() {
                     Qt.openUrlExternally("https://t.me/ultarussia")
                }
                KeyNavigation.tab: account.rightButton
            }

            DividerType {}
        }
    }
}
