import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import SortFilterProxyModel 0.2

import PageEnum 1.0
import ProtocolEnum 1.0
import ContainerProps 1.0
import ContainersModelFilters 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Controls2/TextTypes"
import "../Config"
import "../Components"

PageType {
    id: root

    property bool isUnpaid: ServersModel.isDefaultAccountUnpaid()
    property var defaultConfig: ServersModel.getDefaultAccount()

    ColumnLayout {
        objectName: "homeColumnLayout"

        anchors.fill: parent
        anchors.topMargin: 12
        anchors.leftMargin: 0
        anchors.bottomMargin: 0

        RowLayout {
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            Image {
                id: logo
                source: "qrc:/images/start_logo.png"

                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: 102
                Layout.preferredHeight: 24
            }

            SotkaButton {
                id: logOutButton
                mainText: qsTr("Log Out")
                textWeight: 500
                isUpperCase: false

                borderWidth: 0
                borderFocusedWidth: 0
                buttonWidth: 65
                buttonHeight: 24

                Layout.leftMargin: 175
                Layout.rightMargin: 16
                Layout.alignment: Qt.AlignRight

                onClicked: {
                        if (ConnectionController.isConnected || ConnectionController.isConnectionInProgress) {
                        notification.text = qsTr('Cannot sign out with an active connection')
                        notification.visible = true
                    } else {
                        var headerText = qsTr('Log out?')
                        var yesButtonText = qsTr("Continue")
                        var noButtonText = qsTr("Cancel")
                        var yesButtonFunction = function() {
                            ServersModel.removeDefaultAccount()
                            PageController.goToPageHome()
                        }
                        var noButtonFunction = function() {
                        }
                        showQuestionDrawer(headerText, '', yesButtonText, noButtonText, yesButtonFunction, noButtonFunction)
                    }
                }
            }
        }

        ConnectButton {
            id: connectButton
            objectName: 'connectButton'

            Layout.fillHeight: true
            Layout.leftMargin: 0
            Layout.rightMargin: 17
            Layout.alignment: Qt.AlignCenter
        }

        SotkaButton {
            id: personalAccountButton
            mainText: qsTr('Personal Account')

            buttonWidth: root.isUnpaid ? 343 : 169
            buttonHeight: root.isUnpaid ? 45 : 41

            Layout.leftMargin: root.isUnpaid ? 0 : 86
            Layout.rightMargin: root.isUnpaid ? 17 : 103
            Layout.bottomMargin: root.isUnpaid ? 12 : 30
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            onClicked: {
                Qt.openUrlExternally('https://t.me/sotka_install_bot')
            }
        }

    /* Currently Sotka supports only interactions in the telegram chanel
        SotkaButton {
            id: subscriptionButton
            mainText: qsTr('Renew Subscription')
            visible: root.isUnpaid

            buttonWidth: 343
            buttonHeight: 45

            defaultColor: Sotka.color.yellow
            disableColor: defaultColor
            hoveredColor: defaultColor
            pressedColor: defaultColor

            Layout.leftMargin: 0
            Layout.rightMargin: 17
            Layout.bottomMargin: root.isUnpaid ? 30 : 0
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            onClicked: {
                Qt.openUrlExternally(defaultConfig.payment_link)
            }
        }
    */
    }
}
