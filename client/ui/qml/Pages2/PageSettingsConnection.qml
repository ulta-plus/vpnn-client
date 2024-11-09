import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Config"

PageType {
    id: root

    defaultActiveFocusItem: focusItem

    property bool isAppSplitTinnelingEnabled: Qt.platform.os === "windows" || Qt.platform.os === "android"

    Item {
        id: focusItem
        KeyNavigation.tab: backButton
    }

    BackButtonType {
        id: backButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 20

        KeyNavigation.tab: dnsServersButton // issue_13: amneziaDnsSwitch
    }

    FlickableType {
        id: fl
        anchors.top: backButton.bottom
        anchors.bottom: parent.bottom
        contentHeight: content.height

        ColumnLayout {
            id: content

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            HeaderType {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                headerText: qsTr("Connection")
            }

            DividerType {}

            LabelWithButtonType {
                id: dnsServersButton
                Layout.fillWidth: true

                text: qsTr("DNS servers")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"

                clickedFunction: function() {
                    PageController.goToPage(PageEnum.PageSettingsDns)
                }

                Keys.onTabPressed: {
                    if (killSwitchSwitcher.visible) {
                        return killSwitchSwitcher.forceActiveFocus()
                    } else {
                        lastItemTabClicked()
                    }
                }
            }

            DividerType {}

            SwitcherType {
                id: killSwitchSwitcher
                visible: !GC.isMobile()

                Layout.fillWidth: true
                Layout.margins: 16

                text: qsTr("KillSwitch")
                descriptionText: qsTr("Disables your internet if your encrypted VPN connection drops out for any reason.")

                checked: SettingsController.isKillSwitchEnabled()
                checkable: !ConnectionController.isConnected
                onCheckedChanged: {
                    if (checked !== SettingsController.isKillSwitchEnabled()) {
                        SettingsController.toggleKillSwitch(checked)
                    }
                }
                onClicked: {
                    if (!checkable) {
                        PageController.showNotificationMessage(qsTr("Cannot change killSwitch settings during active connection"))
                    }
                }

                Keys.onTabPressed: lastItemTabClicked()
            }

            DividerType {
                visible: GC.isDesktop()
            }
        }
    }
}
