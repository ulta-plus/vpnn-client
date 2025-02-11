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
            KeyNavigation.tab: emailLogInButton
        }

        Header2TextType {
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 16
            text: qsTr("Select sign up way")
        }

        CardWithIconsType {
            id: emailLogInButton

            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            headerText: qsTr("Sign up with Telegram")

            rightImageSource: "qrc:/images/controls/chevron-right.svg"
            leftImageSource: "qrc:/images/controls/telegram.svg"

            onClicked: {
                Qt.openUrlExternally("https://t.me/vpn_naruzhu_support_bot")
            }
        }

        CardWithIconsType {
            id: telegramLogInButton

            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            headerText: qsTr("Sign up with e-mail")

            rightImageSource: "qrc:/images/controls/chevron-right.svg"
            leftImageSource: "qrc:/images/controls/email.svg"   // TODO: change icon

            onClicked: {
                Qt.openUrlExternally("https://naruzhu.click/appam")
            }
        }
    }
}
