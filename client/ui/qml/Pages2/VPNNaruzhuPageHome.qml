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
    property var defaultEmail: defaultConfig.email

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

    Connections {
        target: VPNNWebApi

        function onDefaultAccountStatusUpdated() {
            refreshAccountStatusDisplay()
        }
    }

    function getNumberOfActiveDaysText() {
        var numberOfActiveDays = ServersModel.getNumberOfActiveDays()
        if (!ServersModel.isDefaultAccountActive()) {
            numberOfActiveDays = 0
        }
        return qsTr('Left ') + numberOfActiveDays + qsTr(' days')
    }

    function getSubscriptionStatusText() {
        if (ServersModel.isDefaultAccountActive()) {
            return qsTr('Active until ') + ServersModel.getPaidUntilDefaultAccountStr()
        } else {
            return qsTr('Subscription ended')
        }
    }

    function refreshAccountStatusDisplay() {
        numberOfActiveDaysText.text = getNumberOfActiveDaysText()
        subscriptionStatusText.text = getSubscriptionStatusText()
    }

    function showNotification(msg) {
        notification.text = msg
        notification.visible = true
        notification.onClick = function() {
            notification.implicitHeight = 100
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
            anchors.bottom: parent.bottom

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
                text: 'v' + VPNNWebApi.getAppVersion() + '   d: ' + VPNNWebApi.getUUIDLastSymbols()
                color: VPNNaruzhuStyle.color.footnotes
                opacity: 0.56
                font.pixelSize: 12
                font.weight: Font.Medium
                font.family: VPNNaruzhuStyle.font
                font.letterSpacing: 12 * 0.02

                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 16
            }

            VPNNaruzhuConnectionModeSwitcher {
                id: connectionModeSwitcher

                Layout.topMargin: 23
                Layout.rightMargin: 16
                Layout.leftMargin: 16
                Layout.alignment: Qt.AlignTop

                enabled: !(ConnectionController.isConnectionInProgress || ConnectionController.isConnected)
            }

            VPNNaruzhuCountryList {
                id: countryList

                Layout.topMargin: 22
                Layout.preferredHeight: 41
                Layout.preferredWidth: 216
                Layout.alignment: Qt.AlignHCenter

                height: 41
                width: 216

                enabled: !(ConnectionController.isConnectionInProgress || ConnectionController.isConnected)
            }

            ConnectButton {
                id: connectButton
                objectName: "connectButton"

                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 17

                enabled: !notification.visible
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 14

                VPNNaruzhuButton {
                    id: helpButton

                    Layout.alignment: Qt.AlignRight

                    defaultColor: 'transparent'
                    pressedColor: 'transparent'
                    hoveredColor: 'transparent'

                    mainText: qsTr('Need help')
                    textColor: '#FFFFFF'
                    textSize: 14
                    letterSpacing: 14 * (-0.04)
                    textWeight: Font.DemiBold

                    implicitHeight: 20
                    implicitWidth: 200

                    rightIcon: 'qrc:/images/controls/question.svg'
                    rightIconColor: '#FFFFFF'

                    onClicked: {
                        var headerText = qsTr('Do you need help?')
                        var isPossibleToChangeServer = VPNNWebApi.isChangeServerPossible()
                        var descriptionText = ''
                        var button0Text = ''
                        if (isPossibleToChangeServer) {
                            descriptionText = qsTr("Most issues can be resolved by switching servers. You can switch servers once a day. We will disconnect the VPN before doing so.\n\nIf switching servers doesn't help, please contact support: help@vpn-naruzhu.com.")
                            button0Text = qsTr('Switch server')
                        } else {
                            descriptionText = qsTr('Contact with support via help@vpn-naruzhu.com or telegram.')
                        }

                        var button1Text = qsTr('E-mail')
                        var button2Text = qsTr('Telegram')
                        var button0Function = function() {
                            waitingBox.visible = true
                            var success = VPNNWebApi.changeServer()
                            var msg = ''
                            if (success) {
                                msg = qsTr('Server successfully changed')
                            } else {
                                notification.implicitHeight = 120
                                msg = qsTr('Server change failed, please contact support')
                            }

                            waitingBox.visible = false
                            root.showNotification(msg)
                        }
                        var button1Function = function() {
                            GC.coppyUUIDToClipBoard()
                            Qt.openUrlExternally("mailto:help@vpn-naruzhu.com")
                        }
                        var button2Function = function() {
                            GC.coppyUUIDToClipBoard()
                            Qt.openUrlExternally(VPNNWebApi.getSupportLink())
                        }
                        showVpnnDrawer(headerText, descriptionText, button0Text, button1Text, button2Text, button0Function, button1Function, button2Function)
                    }
                }
            }

            Rectangle {
                id: bottomBackground
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                Layout.topMargin: 17
                implicitWidth: parent.width
                implicitHeight: 139

                //color: '#000000'
                //opacity: 1.0

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(255,214,0, 0.075) } //'#FFD600'
                    GradientStop { position: 1.0; color: Qt.rgba(0,0,0, 1) } //'#000000'
                }

                border.color: '#DADADA'
                border.width: 1

                radius: 10
                // radius for the different ange supported from Qt6.7
                //topLeftRadius: 10
                //topRightRadius: 10
                //bottomLeftRadius: 0
                //bottomRightRadius: 0
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
                        text: {
                            if (defaultEmail.length > 45) {
                                return defaultEmail.slice(0, 41) + ' ...'
                            } else {
                                defaultEmail
                            }
                        }

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
                                var msg = qsTr('Cannot sign out with an active connection')
                                root.showNotification(msg)
                            } else {
                                var headerText = qsTr('Sign out?')
                                var yesButtonText = qsTr("Continue")
                                var noButtonText = qsTr("Cancel")
                                var yesButtonFunction = function() {
                                    ServersModel.removeDefaultAccount()
                                    SettingsController.clearSettings()
                                    VPNNCountriesModel.setCurrentIndex(0);
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
                            id: numberOfActiveDaysText
                            text: getNumberOfActiveDaysText()
                            color: '#FFFFFF'
                            font.pixelSize: 16
                            lineHeight: 1.2
                            font.weight: Font.Medium
                            font.family: VPNNaruzhuStyle.font

                            Layout.alignment: Qt.AlignLeft
                        }

                        Text {
                            id: subscriptionStatusText
                            text: getSubscriptionStatusText()
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

        BusyIndicator {
            id: waitingBox
            anchors.centerIn: parent
            visible: false
        }
    }
}
