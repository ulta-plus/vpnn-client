import QtQuick
import QtQuick.Controls

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

    property string text: qsTr('ERROR')
    property string buttonText: qsTr('Close')

    property string textColor: Sotka.color.notificationText
    property string borderColor: Sotka.color.notificationBorder
    property string backgroundColor: Sotka.color.notificationBackground

    property var onClick: function() {} // function executed with close Notification

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

    VPNNaruzhuButton {
        implicitHeight: 30
        implicitWidth: (contentItem.implicitWidth > 80) ? contentItem.implicitWidth + 20 : 80

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        mainText: root.buttonText

        onClicked: {
            if (pop_up) {
                root.visible = false;
            }

            onClick();
        }
    }
}
