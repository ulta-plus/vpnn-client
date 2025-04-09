import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Style 1.0

import '../Controls2'

Rectangle {
    id: root

    implicitHeight: 180
    implicitWidth: 240

    radius: 10
    visible: false

    property int textSize: 20

    property string text: ''
    property string placeholderText: ''
    property string buttonText: qsTr('Continue')
    property string textColor: VPNNaruzhuStyle.color.notificationText
    property string borderColor: VPNNaruzhuStyle.color.notificationBorder
    property string backgroundColor: VPNNaruzhuStyle.color.notificationBackground

    property var withClose: function() {} // function executed with close Notification
    property var getInput: function() {
        return input.text;
    }

    color: root.backgroundColor
    border.width: 1
    border.color: root.borderColor

    ColumnLayout {
        anchors.fill: parent

        Text {
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.bottomMargin: 10

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter

            text: root.text
            color: root.textColor

            font.pixelSize: root.textSize
            font.weight: 700
            font.family: 'PT Root UI VF'
        }

        VPNNaruzhuTextField {
            id: input

            Layout.fillWidth: true
            Layout.rightMargin: 16
            Layout.leftMargin: 16
            Layout.bottomMargin: 10

            placeholderText: root.placeholderText
            backgroundColor: AmneziaStyle.color.midnightBlack
        }

        VPNNaruzhuButton {
            implicitHeight: 30

            Layout.fillWidth: true
            Layout.rightMargin: 50
            Layout.leftMargin: 50
            Layout.bottomMargin: 10

            mainText: root.buttonText

            onClicked: {
                root.visible = false;
                root.withClose();
                input.text = '';
            }
        }
    }
}
