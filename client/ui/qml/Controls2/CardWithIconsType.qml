import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Style 1.0

import "TextTypes"

Button {
    id: root

    property string headerText
    property string bodyText
    property string footerText

    property string hoveredColor: UltaStyle.color.buttonBackGroundSelected
    property string defaultColor: UltaStyle.color.buttonBackGround

    property string rightImageSource
    property string rightImageColor: UltaStyle.color.icon
    property string rightImageBackgroundColor: UltaStyle.color.buttonBackGround

    property string leftImageSource
    property string leftImageColor: UltaStyle.color.icon

    property string textColor: UltaStyle.color.mainText

    property real textOpacity: 1.0

    hoverEnabled: true

    background: Rectangle {
        id: backgroundRect
        anchors.fill: parent
        radius: 16

        color: UltaStyle.color.buttonBackGround
        border.color: UltaStyle.color.border
    }

    contentItem: Item {
        anchors.left: parent.left
        anchors.right: parent.right

        implicitHeight: content.implicitHeight
        RowLayout {
            id: content
            anchors.fill: parent

            IconImage {
                id: leftImage
                source: leftImageSource
                color: leftImageColor

                visible: leftImageSource !== ""

                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.topMargin: 24
                Layout.bottomMargin: 24
                Layout.leftMargin: 24
            }

            ColumnLayout {
                ListItemTitleType {
                    text: root.headerText
                    visible: text !== ""

                    color: textColor

                    Layout.fillWidth: true
                    Layout.rightMargin: 16
                    Layout.leftMargin: 16
                    Layout.topMargin: 16
                    Layout.bottomMargin: root.bodyText !== "" ? 0 : 16

                    opacity: root.textOpacity
                }

                CaptionTextType {
                    text: root.bodyText
                    visible: text !== ""

                    color: AmneziaStyle.color.mutedGray
                    textFormat: Text.RichText

                    Layout.fillWidth: true
                    Layout.rightMargin: 16
                    Layout.leftMargin: 16
                    Layout.bottomMargin: root.footerText !== "" ? 0 : 16

                    opacity: root.textOpacity
                }

                ButtonTextType {
                    text: root.footerText
                    visible: text !== ""

                    color: AmneziaStyle.color.mutedGray

                    Layout.fillWidth: true
                    Layout.rightMargin: 16
                    Layout.leftMargin: 16
                    Layout.topMargin: 16
                    Layout.bottomMargin: 16

                    opacity: root.textOpacity
                }
            }

            ImageButtonType {
                id: rightImage

                implicitWidth: 40
                implicitHeight: 40

                hoverEnabled: false
                image: rightImageSource
                imageColor: rightImageColor
                visible: rightImageSource != "" ? true : false

                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                Layout.topMargin: 16
                Layout.bottomMargin: 16
                Layout.rightMargin: 16

                Rectangle {
                    id: rightImageBackground
                    anchors.fill: parent
                    radius: 12
                    color: UltaStyle.color.buttonBackGround
                    border.color: UltaStyle.color.border
                }

                onClicked: {
                    if (clickedFunction && typeof clickedFunction === "function") {
                        clickedFunction()
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: {
            backgroundRect.color = root.hoveredColor
            backgroundRect.border.color = UltaStyle.color.borderSelected

            root.rightImageColor = UltaStyle.color.iconSelected
            rightImageBackground.color = UltaStyle.color.buttonBackGroundSelected
            rightImageBackground.border.color = UltaStyle.color.borderSelected

            root.leftImageColor = UltaStyle.color.iconSelected
            root.textColor = UltaStyle.color.mainTextSelected
            root.textOpacity = 0.8
        }

        onExited: {
            backgroundRect.color = root.defaultColor
            backgroundRect.border.color = UltaStyle.color.border

            root.rightImageColor = UltaStyle.color.icon
            rightImageBackground.color = rightImage.defaultColor
            rightImageBackground.border.color = UltaStyle.color.border

            root.leftImageColor = UltaStyle.color.icon
            root.textColor = UltaStyle.color.mainText
            root.textOpacity = 1
        }

        onClicked: {
            root.clicked()
        }
    }
}
