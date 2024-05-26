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

    defaultActiveFocusItem: focusItem

    ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        Image {
            id: image
            source: "qrc:/images/ulta_logo.png"

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 160
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.preferredWidth: 220
            Layout.preferredHeight: 56
        }

        ParagraphTextType {
            Layout.fillWidth: true
            Layout.topMargin: 18
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Discord without any blocks")
        }

        SmallTextType {
            Layout.fillWidth: true
            Layout.topMargin: 70
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            color: UltaStyle.color.mainText
            text: qsTr("Do you already have a key from the Telegram bot?")
        }

        Item {
            id: focusItem
            KeyNavigation.tab: startButton
        }

        BasicButtonType {
            id: startButton
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            text: qsTr("Yes, I've a key")

            // Button styling
            background: Rectangle {
                color: parent.hovered ? UltaStyle.color.buttonBackGroundSelected : UltaStyle.color.buttonBackGround
                border.color: UltaStyle.color.border
                radius: 10
            }

            // Button text color
            contentItem: Text {
                text: parent.text
                color: parent.hovered ? UltaStyle.color.mainTextSelected : UltaStyle.color.mainText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                font.family: "Montserrat Medium"
            }

            clickedFunc: function() {
                PageController.goToPage(PageEnum.PageSetupWizardConfigSource)
            }

            KeyNavigation.tab: startButton2
        }

        BasicButtonType {
            id: startButton2
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            text: qsTr("No, receive a key")

            // Button styling
            background: Rectangle {
                color: parent.hovered ? UltaStyle.color.buttonBackGroundSelected : UltaStyle.color.buttonBackGround
                border.color: UltaStyle.color.border
                radius: 10
            }

            // Button text color
            contentItem: Text {
                text: parent.text
                color: parent.hovered ? UltaStyle.color.mainTextSelected : UltaStyle.color.mainText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                font.family: "Montserrat Medium"
            }

            // Click functionality
            onClicked: {
                Qt.openUrlExternally(qsTr("https://t.me/ultadiscord_bot"))
            }
        }
    }

}
