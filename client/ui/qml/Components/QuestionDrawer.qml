import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Style 1.0

import "../Controls2"
import "../Controls2/TextTypes"

import "../Config"

DrawerType2 {
    id: root

    property string headerText
    property string descriptionText
    property string yesButtonText
    property string noButtonText

    property var yesButtonFunction
    property var noButtonFunction

    expandedStateContent: ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 8

        onImplicitHeightChanged: {
            root.expandedHeight = content.implicitHeight + 32
        }

        Header2TextType {
            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            text: headerText
        }

        ParagraphTextType {
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            text: descriptionText
        }

        SotkaButton {
            id: yesButton
            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            defaultColor: Sotka.color.yellow
            hoveredColor: Sotka.color.yellow
            pressedColor: Sotka.color.yellow

            mainText: yesButtonText

            onClicked: {
                if (yesButtonFunction && typeof yesButtonFunction === "function") {
                    yesButtonFunction()
                }
            }
        }

        SotkaButton {
            id: noButton
            Layout.fillWidth: true
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            mainText: noButtonText

            onClicked: {
                if (noButtonFunction && typeof noButtonFunction === "function") {
                    noButtonFunction()
                }
            }
        }
    }
}
