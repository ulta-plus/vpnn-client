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
            source: "qrc:/images/start_logo.png"

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 135
            Layout.leftMargin: 90
            Layout.rightMargin: 90
            Layout.preferredWidth: 196
            Layout.preferredHeight: 48
        }

        Text {
            Layout.fillWidth: true
            Layout.topMargin: 27
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            horizontalAlignment: Text.AlignHCenter
            color: Sotka.color.text
            font.family: Sotka.font
            font.pixelSize: 14
            font.weight: 500
            font.letterSpacing: -0.7
            text: qsTr("Do you already have a Telegram Key?")
        }

        SotkaButton {
            id: logInButton
            Layout.topMargin: 23
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            defaultColor: Sotka.color.yellow
            disableColor: defaultColor
            hoveredColor: defaultColor
            pressedColor: defaultColor

            mainText: qsTr("Yes, I have key")

            onClicked: {
                PageController.goToPage(PageEnum.SotkaLogIn)
            }
        }

        SotkaButton {
            id: telegramButton
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            mainText: qsTr("No, Recieve key")

            onClicked: {
                Qt.openUrlExternally("https://t.me/sotka_install_bot")
            }
        }
    }
}
