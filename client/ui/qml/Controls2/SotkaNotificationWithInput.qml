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
    property bool withCloseButton: false

    property string text: ''
    property string placeholderText: ''
    property string buttonYesText: qsTr('Continue')
    property string buttonNoText: qsTr('Close')

    property string textColor: Sotka.color.notificationText
    property string borderColor: Sotka.color.notificationBorder
    property string backgroundColor: Sotka.color.notificationBackground

    property var withYesButton: function() {} // function executed with close Notification
    property var withNoButton: function() {}
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

        SotkaTextField {
            id: input

            Layout.fillWidth: true
            Layout.rightMargin: 16
            Layout.leftMargin: 16
            Layout.bottomMargin: 10

            placeholderText: root.placeholderText
            backgroundColor: AmneziaStyle.color.midnightBlack
        }

        RowLayout {
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
            Layout.bottomMargin: 10

            SotkaButton {
                implicitHeight: 30
                implicitWidth: withCloseButton ? 100 : 140

                Layout.fillWidth: withCloseButton ? false : true
                Layout.leftMargin: withCloseButton ? 10 : 50
                Layout.rightMargin: withCloseButton ? 5 : 50

                mainText: root.buttonYesText

                onClicked: {
                    root.visible = false;
                    root.withYesButton();
                    input.text = '';
                }
            }

            SotkaButton {
                visible: withCloseButton
                implicitHeight: 30
                implicitWidth: withCloseButton ? 100 : 140

                Layout.leftMargin: 5
                Layout.rightMargin: 10

                mainText: root.buttonNoText

                onClicked: {
                    root.visible = false;
                    root.withNoButton();
                    input.text = '';
                }
            }
        }
    }
}
