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

    defaultActiveFocusItem: focusItem

    ColumnLayout {
        id: content

        anchors.top: parent.top
        //anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 0

        Item {
            id: focusItem
            KeyNavigation.tab: backButton
        }

        BackButtonType {
            id: backButton
            Layout.topMargin: 20
            KeyNavigation.tab: emailText
        }

        Header2TextType {
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 16
            text: qsTr("Enter your e-mail")
        }

        TextField {
            id: emailText

            Layout.fillWidth: true
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            property int textSize: 16
            property string textColor: AmneziaStyle.color.paleGray
            property string backgroundTextColor: AmneziaStyle.color.charcoalGray
            property string backgroundColor: AmneziaStyle.color.onyxBlack
            property string borderColor: AmneziaStyle.color.slateGray
            property string borderFocusedColor: AmneziaStyle.color.paleGray

            placeholderText: "e-mail"
            placeholderTextColor: emailText.backgroundTextColor

            color: emailText.textColor
            font.pixelSize: emailText.textSize
            font.weight: 400
            font.family: "PT Root UI VF"

            background: Rectangle {
                radius: 16
                color: emailText.backgroundColor
                border.color: emailText.getBackgroundBorderColor()
                border.width: 1
                implicitHeight: 40
            }

            function getBackgroundBorderColor() {
                return emailText.focus ? emailText.borderFocusedColor : emailText.borderColor
            }

            Keys.onEnterPressed: {
                emailText.text = ""
            }

            KeyNavigation.tab: continueButton
        }
    }

    Button {
        id: continueButton

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.leftMargin: 16
        anchors.bottomMargin: 32

        implicitHeight: 56

        property string hoveredColor: AmneziaStyle.color.lightGray
        property string defaultColor: AmneziaStyle.color.paleGray
        property string pressedColor: AmneziaStyle.color.mutedGray
        property string borderColor: AmneziaStyle.color.paleGray
        property string borderFocusedColor: AmneziaStyle.color.paleGray
        property string textColor: AmneziaStyle.color.midnightBlack

        property int borderWidth: 0
        property int borderFocusedWidth: 1

        Text {
            text: "continue"
            lineHeight: 24

            color: continueButton.textColor
            font.pixelSize: 16
            font.weight: 600
            font.family: "PT Root UI VF"
        }

        background: Rectangle {
            radius: 10

            color: {
                if (continueButton.pressed) {
                    return continueButton.pressedColor
                }
                return continueButton.hovered ? continueButton.hoveredColor : continueButton.defaultColor
            }

            border.color: continueButton.activeFocus ? continueButton.borderFocusedColor : AmneziaStyle.color.transparent
            border.width: continueButton.activeFocus ? continueButton.borderFocusedWidth : 0

            Behavior on color {
                PropertyAnimation { duration: 200 }
            }
        }
    }
}
