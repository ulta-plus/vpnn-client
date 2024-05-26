
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

    expandedContent: ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 8

        onImplicitHeightChanged: {
            root.expandedHeight = content.implicitHeight + 32
        }

        Connections {
            target: root
            enabled: !GC.isMobile()
            function onOpened() {
                focusItem.forceActiveFocus()
            }
        }

        Header2TextType {
            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            text: headerText
            color: UltaStyle.color.bottomBarText
        }

        ParagraphTextType {
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            text: descriptionText
            color: UltaStyle.color.bottomBarText
        }

        Item {
            id: focusItem
            KeyNavigation.tab: yesButton
        }

        BasicButtonType {
            id: yesButton
            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            defaultColor: UltaStyle.color.bottomBarButton
            hoveredColor: UltaStyle.color.bottomBarButtonSelected
            borderColor: UltaStyle.color.bottomBarBorder
            borderFocusedColor: UltaStyle.color.bottomBarBorder
            textColor: UltaStyle.color.bottomBarText
            textColorSelected: UltaStyle.color.bottomBarTextSelected

            text: yesButtonText

            clickedFunc: function() {
                if (yesButtonFunction && typeof yesButtonFunction === "function") {
                    yesButtonFunction()
                }
            }

            KeyNavigation.tab: noButton
        }

        BasicButtonType {
            id: noButton
            Layout.fillWidth: true
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            defaultColor: UltaStyle.color.bottomBarButton
            hoveredColor: UltaStyle.color.bottomBarButtonSelected
            borderColor: UltaStyle.color.bottomBarBorder
            borderFocusedColor: UltaStyle.color.bottomBarBorder
            textColor: UltaStyle.color.bottomBarText
            textColorSelected: UltaStyle.color.bottomBarTextSelected

            text: noButtonText

            clickedFunc: function() {
                if (noButtonFunction && typeof noButtonFunction === "function") {
                    noButtonFunction()
                }
            }

            KeyNavigation.tab: focusItem
        }
    }
}
