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

    property var defaultConfig: ServersModel.getDefaultAccount()

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
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout {
                Layout.topMargin: 24
                Layout.rightMargin: 16
                Layout.leftMargin: 16
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignTop

                Image {
                    id: image
                    source: 'qrc:/images/welcome_logo.svg'

                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredWidth: 139
                    Layout.preferredHeight: 32
                }

                VPNNaruzhuButton {
                    id: settingsButton

                    Layout.alignment: Qt.AlignRight

                    defaultColor: 'transparent'
                    pressedColor: 'transparent'
                    hoveredColor: 'transparent'

                    implicitHeight: 24
                    implicitWidth: 24

                    leftIcon:  'qrc:/images/controls/settings.svg'
                    leftIconColor: '#FFFFFF'

                    onClicked: {
                        tabBarStackView.goToTabBarPage(PageEnum.VPNNaruzhuPageSettings)
                    }
                }
            }

            Text {
                text: 'v' + VPNNWebApi.getAppVersion()
                color: VPNNaruzhuStyle.color.footnotes
                opacity: 0.56
                font.pixelSize: 12
                font.weight: Font.Medium
                font.family: VPNNaruzhuStyle.font
                font.letterSpacing: 12 * 0.02

                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 16
            }

            Rectangle {
                Layout.topMargin: 24
                Layout.rightMargin: 16
                Layout.leftMargin: 16
                Layout.alignment: Qt.AlignTop
                implicitWidth: 343
                implicitHeight: 49

                radius: 6
                color: 'transparent'
                border.width: 1
                border.color: '#242424'

                RowLayout {
                    id: modePannel
                    anchors.centerIn: parent
                    property var activeButtonColor: '#FFFFFF'
                    property var activeTextColor: '#000000'
                    property var inactiveButtonColor: 'transparent'
                    property var inactiveTextColor: '#BDBDBD'

                    VPNNaruzhuButton {
                        id: smartMode

                        radius: 4
                        implicitWidth: 165.5
                        implicitHeight: 41

                        Layout.alignment: Qt.AlignRight
                        mainText: qsTr('Smart Mode')

                        defaultColor: modePannel.activeButtonColor
                        hoveredColor: modePannel.activeButtonColor
                        onClicked: {
                            smartMode.defaultColor = modePannel.activeButtonColor
                            smartMode.hoveredColor = smartMode.defaultColor
                            smartMode.textColor = modePannel.activeTextColor
                            directMode.defaultColor = modePannel.inactiveButtonColor
                            directMode.textColor = modePannel.inactiveTextColor
                            directMode.hoveredColor = directMode.defaultColor
                        }
                    }

                    VPNNaruzhuButton {
                        id: directMode

                        radius: 4
                        implicitWidth: 165.5
                        implicitHeight: 41

                        Layout.alignment: Qt.AlignLeft
                        mainText: qsTr('Direct Mode')

                        defaultColor: modePannel.activeButtonColor
                        hoveredColor: modePannel.activeButtonColor
                        onClicked: {
                            smartMode.defaultColor = modePannel.inactiveButtonColor
                            smartMode.hoveredColor = smartMode.defaultColor
                            smartMode.textColor = modePannel.inactiveTextColor
                            directMode.defaultColor = modePannel.activeButtonColor
                            directMode.textColor = modePannel.activeTextColor
                            directMode.hoveredColor = directMode.defaultColor
                        }
                    }
                }
            }
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            ConnectButton {
                id: connectButton
                objectName: "connectButton"

                //Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
            }
        }

        ColumnLayout {
            id: bottomBackground
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Rectangle {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                implicitWidth: parent.width
                implicitHeight: 139

                color: '#000000'
                opacity: 0.2

                gradient: Gradient {
                    GradientStop { position: 0.0; color: '#FFD600' }
                    GradientStop { position: 1.0; color: '#000000' }
                }

                border.color: '#DADADA'
                border.width: 1

                radius: 0
                topLeftRadius: 10
                topRightRadius: 10
                bottomLeftRadius: 0
                bottomRightRadius: 0
            }
        }

        Rectangle {
            id: bottomForeground
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            color: 'transparent'
            implicitWidth: parent.width
            implicitHeight: 139

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 30
                anchors.bottomMargin: 27
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                Layout.fillHeight: false

                RowLayout {
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 18

                    Text {
                        text: defaultConfig.email
                        color: '#FFFFFF'
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        font.family: VPNNaruzhuStyle.font
                        font.letterSpacing: 14 * (-0.04)

                        Layout.alignment: Qt.AlignLeft
                    }

                    VPNNaruzhuButton {
                        id: signOutButton

                        Layout.alignment: Qt.AlignRight

                        defaultColor: 'transparent'
                        pressedColor: 'transparent'
                        hoveredColor: 'transparent'

                        implicitHeight: 24
                        implicitWidth: 24

                        leftIcon:  'qrc:/images/controls/sign-out.svg'
                        leftIconColor: '#FFFFFF'

                        onClicked: {
                            if (ConnectionController.isConnected || ConnectionController.isConnectionInProgress) {
                                notification.text = qsTr('Cannot sign out with an active connection')
                                notification.visible = true
                            } else {
                                var headerText = qsTr('Sign out?')
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

                RowLayout {
                    Layout.topMargin: 20
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: parent.width
                    Layout.fillHeight: false

                    ColumnLayout {
                        Layout.alignment: Qt.AlignTop
                        Text {
                            text: qsTr('Left ') + ServersModel.getNumberOfActiveDays() + qsTr(' days')
                            color: '#FFFFFF'
                            font.pixelSize: 16
                            lineHeight: 1.2
                            font.weight: Font.Medium
                            font.family: VPNNaruzhuStyle.font

                            Layout.alignment: Qt.AlignLeft
                        }

                        Text {
                            text: qsTr('Active until ') + ServersModel.getPaidUntilDefaultAccountStr()
                            color: '#FFFFFF'
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            font.family: VPNNaruzhuStyle.font
                            font.letterSpacing: 12 * (0.02)

                            Layout.alignment: Qt.AlignLeft
                            Layout.topMargin: -5
                        }
                    }

                    VPNNaruzhuButton {
                        id: payButton

                        Layout.alignment: Qt.AlignRight

                        implicitHeight: 44
                        implicitWidth: 110
                        radius: 3

                        mainText: qsTr('Get more')
                        hoveredOpacity: 0.5

                        onClicked: {
                            Qt.openUrlExternally(defaultConfig.payment_link)
                        }
                    }
                }
            }
        }

        VPNNaruzhuNotification {
            id: notification
            objectName: "notification"
            anchors.centerIn: parent
        }
    }
}
