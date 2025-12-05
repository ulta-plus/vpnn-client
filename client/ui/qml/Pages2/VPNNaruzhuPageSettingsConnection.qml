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

    property bool isAppSplitTinnelingEnabled: Qt.platform.os === "windows" || Qt.platform.os === "android"

    BackButtonType {
        id: backButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 20

        onActiveFocusChanged: {
            if(backButton.enabled && backButton.activeFocus) {
                listView.positionViewAtBeginning()
            }
        }
    }

    ListViewType {
        id: listView

        anchors.top: backButton.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        header: ColumnLayout {

            width: listView.width

            BaseHeaderType {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                headerText: qsTr("Connection")
            }
        }

        model: 1 // fake model to force the ListView to be created without a model

        delegate: ColumnLayout { // TODO(CyAn84): add DelegateChooser when have migrated to 6.9

            width: listView.width

            DividerType {}

            LabelWithButtonType {
                id: connectionParameters

                Layout.fillWidth: true

                text: qsTr("Parameters")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"

                clickedFunction: function() {
                    PageController.goToPage(PageEnum.VPNNaruzhuPageSettingsServerProtocols)
                }
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
            }

            DividerType {}

            LabelWithButtonType {
                id: killSwitchButton
                visible: !GC.isMobile()

                Layout.fillWidth: true

                text: qsTr("KillSwitch")
                descriptionText: qsTr("Blocks network connections without VPN")
                rightImageSource: "qrc:/images/controls/chevron-right.svg"

                clickedFunction: function() {
                    PageController.goToPage(PageEnum.PageSettingsKillSwitch)
                }
            }

            DividerType {
                visible: GC.isDesktop()
            }
        }
    }
}
