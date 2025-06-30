import QtQuick
import QtQuick.Controls

import Style 1.0

Button {
    id: root

    property string mainText: ''
    property string disableColor: Sotka.color.buttonDisable
    property string hoveredColor: Sotka.color.buttonHovered
    property string defaultColor: Sotka.color.buttonDefault
    property string pressedColor: Sotka.color.buttonPressed
    property string borderColor: Sotka.color.buttonBorder
    property string borderFocusedColor: Sotka.color.buttonBorderFocused
    property string textColor: Sotka.color.buttonText

    property int borderWidth: 1
    property int borderFocusedWidth: 2
    property int buttonWidth: 343
    property int buttonHeight: 45
    property int buttonRaidus: 0

    implicitWidth: root.buttonWidth
    implicitHeight: root.buttonHeight

    contentItem: Text {
        text: root.mainText
        lineHeight: 24

        color: root.textColor
        font.pixelSize: 16
        font.weight: 700
        font.family: Sotka.font
        font.capitalization: Font.AllUppercase

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: root.buttonRaidus

        color: {
            if (root.enabled) {
                if (root.pressed) {
                    return root.pressedColor
                }
                return root.hovered ? root.hoveredColor : root.defaultColor
            } else {
                return root.disableColor
            }
        }

        border.color: root.hovered ? root.borderFocusedColor : root.borderColor
        border.width: root.hovered ? root.borderFocusedWidth : root.borderWidth

        Behavior on color {
            PropertyAnimation { duration: 200 }
        }
    }
}
