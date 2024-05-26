import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import Style 1.0

import "TextTypes"

Button {
    id: root

    property string hoveredColor: UltaStyle.color.buttonBackGroundSelected
    property string defaultColor: UltaStyle.color.buttonBackGround
    property string disabledColor: AmneziaStyle.color.charcoalGray
    property string pressedColor: AmneziaStyle.color.mutedGray

    property string textColor: UltaStyle.color.buttonText
    property string textColorSelected: textColor

    property string borderColor: UltaStyle.color.border
    property string borderFocusedColor: UltaStyle.color.border
    property int borderWidth: 1
    property int borderFocusedWidth: 1

    property string leftImageSource
    property string rightImageSource
    property string leftImageColor
    property bool changeLeftImageSize: true

    property bool squareLeftSide: false

    property FlickableType parentFlickable

    property var clickedFunc

    property alias buttonTextLabel: buttonText

    implicitHeight: 56

    hoverEnabled: true
    focusPolicy: Qt.TabFocus

    onFocusChanged: {
        if (root.activeFocus) {
            if (root.parentFlickable) {
                root.parentFlickable.ensureVisible(this)
            }
        }
    }

    background: Rectangle {
        id: focusBorder

        color: defaultColor
        border.color: root.activeFocus ? root.borderFocusedColor : root.borderColor

        anchors.fill: parent

        radius: 10

        Rectangle {
            id: background

            anchors.fill: focusBorder
            anchors.margins: root.activeFocus ? 2 : 0

            radius: root.activeFocus ? 10 : 10
            color: {
                if (root.enabled) {
                    if (root.pressed) {
                        return pressedColor
                    }
                    return root.hovered ? hoveredColor : defaultColor
                } else {
                    return disabledColor
                }
            }
            border.color: borderColor
            border.width: borderWidth

            Behavior on color {
                PropertyAnimation { duration: 200 }
            }

            Rectangle {
                visible: root.squareLeftSide

                z: 1

                width: parent.radius
                height: parent.radius
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: {
                    if (root.enabled) {
                        if (root.pressed) {
                            return pressedColor
                        }
                        return root.hovered ? hoveredColor : UltaStyle.color.border
                    } else {
                        return disabledColor
                    }
                }

                Behavior on color {
                    PropertyAnimation { duration: 200 }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: focusBorder
        enabled: false
        cursorShape: Qt.PointingHandCursor
    }

    contentItem: Item {
        anchors.fill: focusBorder

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        RowLayout {
            id: content
            anchors.centerIn: parent

            Image {
                id: leftImage
                source: root.leftImageSource
                visible: root.leftImageSource === "" ? false : true

                layer {
                    enabled: leftImageColor !== "" ? true : false
                    effect: ColorOverlay {
                        color: leftImageColor
                    }
                }

                Component.onCompleted: {
                    if (root.changeLeftImageSize) {
                        leftImage.Layout.preferredHeight = 20
                        leftImage.Layout.preferredWidth = 20
                    }
                }
            }

            ButtonTextType {
                id: buttonText

                color: root.hovered ? textColorSelected : textColor
                text: root.text
                visible: root.text === "" ? false : true

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Image {
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20

                source: root.rightImageSource
                visible: root.rightImageSource === "" ? false : true

                layer {
                    enabled: true
                    effect: ColorOverlay {
                        color: textColor
                    }
                }
            }
        }
    }

    Keys.onEnterPressed: {
        if (root.clickedFunc && typeof root.clickedFunc === "function") {
            root.clickedFunc()
        }
    }

    Keys.onReturnPressed: {
        if (root.clickedFunc && typeof root.clickedFunc === "function") {
            root.clickedFunc()
        }
    }

    onClicked: {
        if (root.clickedFunc && typeof root.clickedFunc === "function") {
            root.clickedFunc()
        }
    }
}
