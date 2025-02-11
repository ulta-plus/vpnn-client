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

    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 0

        BackButtonType {
            id: backButton
            Layout.topMargin: 20
            KeyNavigation.tab: telegramLogInButton
        }

        Header2TextType {
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 16
            text: qsTr("Select login method")
        }

        CardWithIconsType {
            id: telegramLogInButton

            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            headerText: qsTr("Login with Telegram")

            rightImageSource: "qrc:/images/controls/chevron-right.svg"
            leftImageSource: "qrc:/images/controls/telegram.svg"

            onClicked: {
                PageController.goToPage(PageEnum.PageSetupWizardTextKey)
            }
        }

        CardWithIconsType {
            id: emailLogInButton

            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            headerText: qsTr("Login with an e-mail")

            rightImageSource: "qrc:/images/controls/chevron-right.svg"
            leftImageSource: "qrc:/images/controls/email.svg"   // TODO: change icon

            onClicked: {
                PageController.goToPage(PageEnum.VPNNaruzhuPageEmailLogIn)
            }
        }

        CardWithIconsType {
            id: fileLogInButton

            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            headerText: qsTr("Login with a key file")

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
    }
}
