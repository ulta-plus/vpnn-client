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

    Connections {
        objectName: "pageControllerConnections"

        target: PageController

        function onRestorePageHomeState(isContainerInstalled) {
            drawer.openTriggered()
            if (isContainerInstalled) {
                containersDropDown.rootButtonClickedFunction()
            }
        }
    }

    Item {
        objectName: "homeColumnItem"

        anchors.fill: parent

        ColumnLayout {
            objectName: "homeColumnLayout"

            anchors.fill: parent
            anchors.topMargin: 12
            anchors.bottomMargin: 16

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
                objectName: "connectButton"

                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
            }

        /*
            SotkaNotification {
                pop_up: false
                visible: true

                Layout.alignment: Qt.AlignCenter

                property var defaultConfig: ServersModel.getDefaultAccount()

                text: qsTr('Subscription valid until') + ':\n' + defaultConfig.paid_until.substring(0, 10)
                buttonText: qsTr('Renew Subscription')

                onClick: function() {
                    Qt.openUrlExternally(defaultConfig.payment_link)
                }
            }
        */
        }
    }
}
