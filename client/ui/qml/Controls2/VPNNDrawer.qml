pragma ComponentBehavior: Bound

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
    property string button0Text
    property string button1Text
    property string button2Text

    property var button0Function
    property var button1Function
    property var button2Function

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
            Layout.rightMargin: 15
            Layout.leftMargin: 15

            text: root.headerText
            font.pixelSize: 26
            color: VPNNaruzhuStyle.color.headerText
        }

        TextEdit {
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.rightMargin: 15
            Layout.leftMargin: 15

            text: root.descriptionText

            readOnly: true
            selectByMouse: true
            color: VPNNaruzhuStyle.color.drawerDescription
            font.pixelSize: 16
            font.weight: 400
            font.family: VPNNaruzhuStyle.font

            wrapMode: Text.WordWrap
        }

        VPNNaruzhuButton {
            id: button0
            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 15
            Layout.leftMargin: 15

            implicitHeight: 50

            visible: root.button0Text !== ""

            mainText: root.button0Text

            onClicked: function() {
                if (root.button0Function && typeof root.button0Function === "function") {
                    root.button0Function()
                }
            }
        }

        BasicButtonType {
            id: button1
            Layout.fillWidth: true
            Layout.topMargin: (root.button0Text == "") ? 16 : 0
            Layout.rightMargin: 15
            Layout.leftMargin: 15

            implicitHeight: 50

            defaultColor: AmneziaStyle.color.transparent
            hoveredColor: AmneziaStyle.color.translucentWhite
            pressedColor: AmneziaStyle.color.sheerWhite
            disabledColor: AmneziaStyle.color.mutedGray
            textColor: AmneziaStyle.color.paleGray
            borderWidth: 1

            visible: root.button1Text !== ""

            text: root.button1Text

            clickedFunc: function() {
                if (root.button1Function && typeof root.button1Function === "function") {
                    root.button1Function()
                }
            }
        }

        BasicButtonType {
            id: button2
            Layout.fillWidth: true
            Layout.rightMargin: 15
            Layout.leftMargin: 15

            implicitHeight: 50

            defaultColor: AmneziaStyle.color.transparent
            hoveredColor: AmneziaStyle.color.translucentWhite
            pressedColor: AmneziaStyle.color.sheerWhite
            disabledColor: AmneziaStyle.color.mutedGray
            textColor: AmneziaStyle.color.paleGray
            borderWidth: 1

            visible: root.button2Text !== ""

            text: root.button2Text

            clickedFunc: function() {
                if (root.button2Function && typeof root.button2Function === "function") {
                    root.button2Function()
                }
            }
        }
    }
}
