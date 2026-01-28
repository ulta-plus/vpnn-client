import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

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
    property int textWeight: 600

    property var capitalization: Font.MixedCase
    property var hoveredOpacity: 1.0
    property var letterSpacing: 0.0
    property var leftIconColor: ''
    property var rightIconColor: ''

    property string leftIcon: ''
    property string rightIcon: ''

    contentItem: Item {
        anchors.fill: buttonBorder
        implicitWidth: buttonBorder.implicitWidth
        implicitHeight: buttonBorder.implicitHeight

        RowLayout {
            id: content
            anchors.centerIn: parent

            Image {
                id: leftIcon
                source: root.leftIcon
                visible: root.leftIcon === '' ? false : true
                layer {
                    enabled: leftIconColor !== '' ? true : false
                    effect: ColorOverlay {
                        color: leftIconColor
                    }
                }
            }

            Text {
                text: root.mainText
                lineHeight: 24

                color: root.textColor
                font.pixelSize: root.textSize
                font.weight: root.textWeight
                font.family: VPNNaruzhuStyle.font
                font.capitalization: root.capitalization
                font.letterSpacing: root.letterSpacing

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                visible: root.mainText === '' ? false : true
            }

            Image {
                id: rightIcon
                source: root.rightIcon
                visible: root.rightIcon === '' ? false : true
                layer {
                    enabled: rightIconColor !== '' ? true : false
                    effect: ColorOverlay {
                        color: rightIconColor
                    }
                }
            }
        }
    }

    background: Rectangle {
        id: buttonBorder
        radius: root.radius
        opacity: {
            if (root.enabled) {
                if (hovered) {
                    return root.hoveredOpacity
                }
            }

            return 1.0
        }

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
