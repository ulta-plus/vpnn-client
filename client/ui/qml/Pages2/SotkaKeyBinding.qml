import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0

import '../Controls2'

PageType {
    id: root

    property string email: ''
    property string otpCode: ''
    property string public_request_id: ''
    property string error: ''
    property string account_status: ''

    Connections {
        target: ImportController

        function onImportFinished() {
            if (ServersModel.getServersCount() == 1) {
                // There is only new default config
                ServersModel.setDefaultServerIndex(ServersModel.getServersCount() - 1)
                ServersModel.processedIndex = ServersModel.defaultIndex
            }

            PageController.goToPageHome()
        }
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 0

        Image {
            id: image
            source: "qrc:/images/start_logo.png"

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 135
            Layout.leftMargin: 90
            Layout.rightMargin: 90
            Layout.preferredWidth: 196
            Layout.preferredHeight: 48
        }

        Text {
            Layout.fillWidth: true
            Layout.topMargin: 27
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            horizontalAlignment: Text.AlignHCenter
            color: Sotka.color.text
            font.family: Sotka.font
            font.pixelSize: 14
            font.weight: 500
            font.letterSpacing: -0.7
            text: qsTr('Key is being used with another device.\nShould it be bonded to this device?')
        }

        SotkaButton {
            id: useHereButton
            Layout.topMargin: 60
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            defaultColor: Sotka.color.yellow
            disableColor: defaultColor
            hoveredColor: defaultColor
            pressedColor: defaultColor

            mainText: qsTr('Use here')

            onClicked: {
            }
        }

        SotkaButton {
            id: buyNewButton
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            mainText: qsTr('Buy new key')

            onClicked: {
            }
        }


        SotkaButton {
            id: backButton
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            mainText: qsTr('Return back')

            onClicked: {
                PageController.closePage()
            }
        }
    }
}
