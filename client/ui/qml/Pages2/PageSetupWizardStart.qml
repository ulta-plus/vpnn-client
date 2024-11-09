import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Config"
import "../Controls2/TextTypes"
import "../Components"

PageType {
    id: root

    defaultActiveFocusItem: focusItem

    ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        Image {
            id: image
            source: "qrc:/images/naruzhu_logo.png"

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 32
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.preferredWidth: 344
            Layout.preferredHeight: 279
        }

        ParagraphTextType {
            Layout.fillWidth: true
            Layout.topMargin: 18
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            horizontalAlignment: Text.AlignHCenter
            color: "#F1F0EF"
            text: qsTr("Open foreign and Russian websites.")
        }

        Item {
            id: focusItem
            KeyNavigation.tab: startButton
        }

        BasicButtonType {
            id: startButton
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            text: qsTr("I have the data to connect")
            defaultColor: "transparent"
            hoveredColor: "#FFDD51"
            pressedColor: "#FFDD51"
            disabledColor: "#878B91"
            textColor: "#000000" // Set default text color to black

            // Button styling
            background: Rectangle {
                color: parent.hovered ? "#FFDD51" : "transparent"
                border.color: parent.hovered ? "#191919" : "#FFDD51" // Set border color to corner color when hovered
                radius: 10
            }

            // Button text color
            contentItem: Text {
                text: parent.text
                color: parent.hovered ? "#000000" : "#FFDD51" // Change text color when hovered
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
            }
            clickedFunc: function() {
                PageController.goToPage(PageEnum.PageSetupWizardConfigSource)
            }

            KeyNavigation.tab: startButton2
        }

        BasicButtonType {
            id: startButton2
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            // Button appearance properties
            defaultColor: "transparent"
            hoveredColor: "#FFDD51"
            pressedColor: "#FFDD51"
            disabledColor: "#878B91"
            textColor: "#000000" // Set default text color to black

            text: qsTr("I have nothing")
            // Button styling
            background: Rectangle {
                color: parent.hovered ? "#FFDD51" : "transparent"
                border.color: parent.hovered ? "#191919" : "#FFDD51" // Set border color to corner color when hovered
                radius: 10
            }

            // Button text color
            contentItem: Text {
                text: parent.text
                color: parent.hovered ? "#000000" : "#FFDD51" // Change text color when hovered
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 16
            }

            // Click functionality
            onClicked: {
                Qt.openUrlExternally(qsTr("https://naruzhu.click/appam"))
            }
        }
    }

}
