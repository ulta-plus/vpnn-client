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

    property string text: ''
    property string buttonYesText: qsTr('Yes')
    property string buttonNoText: qsTr('No')

    property string textColor: VPNNaruzhuStyle.color.notificationText
    property string borderColor: VPNNaruzhuStyle.color.notificationBorder
    property string backgroundColor: VPNNaruzhuStyle.color.notificationBackground

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

        VPNNaruzhuButton {
            id: yesButton

            implicitHeight: 30
            implicitWidth: 80

            mainText: root.buttonYesText

            onClicked: {
                root.visible = false;
                withYesClick();
            }
        }

        VPNNaruzhuButton {
            id: noButton

            implicitHeight: 30
            implicitWidth: 80

            anchors.leftMargin: 10

            mainText: root.buttonNoText

            onClicked: {
                root.visible = false;
                withNoClick();
            }
        }
    }
}
