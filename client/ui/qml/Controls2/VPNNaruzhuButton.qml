import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
    property int borderFocusedWidth: 0
    property int radius: 10
    property int textSize: 16

    property var capitalization: Font.MixedCase
    property var hoveredOpacity: 1.0
    property var letterSpacing: 0.0

    property string leftIcon: ''

    contentItem: Item {
        anchors.fill: buttonBorder
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight

        RowLayout {
            id: content
            anchors.centerIn: parent

            Image {
                id: leftIcon
                source: root.leftIcon
                visible: root.leftIcon === '' ? false : true
            }

            Text {
                text: root.mainText
                lineHeight: 24

                color: root.textColor
                font.pixelSize: root.textSize
                font.weight: 600
                font.family: VPNNaruzhuStyle.font
                font.capitalization: root.capitalization
                font.letterSpacing: root.letterSpacing

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    background: Rectangle {
        id: buttonBorder
        radius: root.radius
        opacity: hovered ? root.hoveredOpacity : 1.0

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

        border.color: root.activeFocus ? root.borderFocusedColor : root.borderColor
        border.width: root.activeFocus ? root.borderFocusedWidth : root.borderWidth

        Behavior on color {
            PropertyAnimation { duration: 200 }
        }

        Behavior on opacity {
            OpacityAnimator {
                duration: 100
            }
        }
    }

    MouseArea {
        anchors.fill: buttonBorder
        enabled: false
        cursorShape: Qt.PointingHandCursor
    }
}
