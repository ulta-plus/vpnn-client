import QtQuick
import QtQuick.Controls

import Style 1.0

Button {
    id: root

    property string mainText: ''
    property string disableColor: VPNNaruzhuStyle.color.buttonDisable
    property string hoveredColor: VPNNaruzhuStyle.color.buttonHovered
    property string defaultColor: VPNNaruzhuStyle.color.buttonDefault
    property string pressedColor: VPNNaruzhuStyle.color.buttonPressed
    property string borderColor: VPNNaruzhuStyle.color.buttonBorder
    property string borderFocusedColor: VPNNaruzhuStyle.color.buttonBorderFocused
    property string textColor: VPNNaruzhuStyle.color.buttonText

    property int borderWidth: 0
    property int borderFocusedWidth: 1

    contentItem: Text {
        text: root.mainText
        lineHeight: 24

        color: root.textColor
        font.pixelSize: 16
        font.weight: 600
        font.family: 'PT Root UI VF'

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: 10

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

        border.color: root.activeFocus ? root.borderFocusedColor : AmneziaStyle.color.transparent
        border.width: root.activeFocus ? root.borderFocusedWidth : root.borderWidth

        Behavior on color {
            PropertyAnimation { duration: 200 }
        }
    }
}
