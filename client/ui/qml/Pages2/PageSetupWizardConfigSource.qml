import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Controls2/TextTypes"
import "../Config"

PageType {
    id: root

    Connections {
        target: ImportController

        function onQrDecodingFinished() {
            if (Qt.platform.os === "ios") {
                PageController.closePage()
            }
            PageController.goToPage(PageEnum.PageSetupWizardViewConfig)
        }
    }

    FlickableType {
        id: fl
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        contentHeight: content.height

        ColumnLayout {
            id: content

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 0

            Item {
                id: focusItem
                KeyNavigation.tab: backButton
            }

            BackButtonType {
                id: backButton
                Layout.topMargin: 20
            }

            HeaderType {
                property bool isVisible: SettingsController.getInstallationUuid() !== "" || PageController.isStartPageVisible()

                Layout.fillWidth: true
                Layout.topMargin: 24
                Layout.rightMargin: 16
                Layout.leftMargin: 16

                headerText: qsTr("Server connection")
            }

            Header2TextType {
                Layout.fillWidth: true
                Layout.topMargin: 48
                Layout.rightMargin: 16
                Layout.leftMargin: 16

                text: qsTr("What do you have?")
            }

            CardWithIconsType {
                id: openFile

                Layout.fillWidth: true
                Layout.topMargin: 16
                Layout.rightMargin: 16
                Layout.leftMargin: 16
                Layout.bottomMargin: 16

                headerText: qsTr("Key as file")

                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: "qrc:/images/controls/folder-search-2.svg"

                onClicked: {
                    var nameFilter = "Config files (*.vpn *.ovpn *.conf *.json)"
                    var fileName = SystemController.getFileName(qsTr("Open key file"), nameFilter)
                    if (fileName !== "") {
                        if (ImportController.extractConfigFromFile(fileName)) {
                            PageController.goToPage(PageEnum.PageSetupWizardViewConfig)
                        }
                    }
                }
            }

            CardWithIconsType {
                id: openAsText

                Layout.fillWidth: true
                Layout.rightMargin: 16
                Layout.leftMargin: 16
                Layout.bottomMargin: 16

                headerText: qsTr("Key as Text")

                rightImageSource: "qrc:/images/controls/chevron-right.svg"
                leftImageSource: "qrc:/images/controls/text-cursor.svg"

                onClicked: {
                    PageController.goToPage(PageEnum.PageSetupWizardTextKey)
                }
            }
        }
    }
}