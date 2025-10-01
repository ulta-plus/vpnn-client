import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Style 1.0

import '../Controls2'

Rectangle {
    id: root

    implicitHeight: 100
    implicitWidth: 240

    radius: 10
    visible: false

    property int textSize: 16
    property bool pop_up: true

    property string text: ''
    property string buttonYesText: qsTr('Yes')
    property string buttonNoText: qsTr('No')

    property string textColor: Sotka.color.notificationText
    property string borderColor: Sotka.color.notificationBorder
    property string backgroundColor: Sotka.color.notificationBackground

    property var withYesClick: function() {}
    property var withNoClick: function() {}

    color: root.backgroundColor
    border.width: 1
    border.color: root.borderColor

    Text {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        text: root.text
        color: root.textColor

        font.pixelSize: root.textSize
        font.weight: 400
        font.family: 'PT Root UI VF'
    }

    RowLayout {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        SotkaButton {
            id: yesButton

            implicitHeight: 30
            implicitWidth: 80

            mainText: root.buttonYesText

            onClicked: {
                if (pop_up) {
                    root.visible = false;
                }

                withYesClick();
            }
        }

        SotkaButton {
            id: noButton

            implicitHeight: 30
            implicitWidth: 80

            anchors.leftMargin: 10

            mainText: root.buttonNoText

            onClicked: {
                if (pop_up) {
                    root.visible = false;
                }

                withNoClick();
            }
        }
    }
}
