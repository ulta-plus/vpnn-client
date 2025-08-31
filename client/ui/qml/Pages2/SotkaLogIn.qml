import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0

import './'
import '../Controls2'
import '../Controls2/TextTypes'

PageType {
    id: root

    property string email: 'default@sotka.com'
    property string public_request_id: ''
    property string telegram_key: ''
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

            if (ServersModel.getDefaultAccount().simplified_status == 'Key limit exceeded') {
                PageController.goToPage(PageEnum.SotkaKeyBinding)
            } else {
                PageController.goToPageHome()
            }
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
            text: qsTr('Please, enter Telegram key')
        }

        SotkaTextField {
            id: telegramKey
            objectName: 'telegramKey'

            Layout.fillWidth: true
            Layout.topMargin: 23
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            placeholderText: qsTr('Telegram key')

            KeyNavigation.tab: continueButton
        }

        SotkaButton {
            id: continueButton
            Layout.topMargin: 12
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            defaultColor: Sotka.color.yellow
            disableColor: defaultColor
            hoveredColor: defaultColor
            pressedColor: defaultColor

            mainText: qsTr('Continue')

            onClicked: {
                try {
                    root.disableAll()
                    waitingBox.visible = true

                    if (ServersModel.isThereDefaultAccount()) {
                        ServersModel.removeDefaultAccount()
                    }

                    root.telegram_key = telegramKey.text.trim()
                    print('input:', root.telegram_key)
                    if (root.telegram_key == '') {
                        waitingBox.visible = false
                        showError(qsTr('Please, enter your telegram key'))
                        return
                    } else if (!root.telegram_key.includes('vpn://')) {
                        print('not vpn://')
                        waitingBox.visible = false
                        showError(qsTr('Key should contain "vpn://"'))
                        return
                    } else if (root.telegram_key.includes(' ')) {
                        waitingBox.visible = false
                        showError(qsTr('Key shouldn\'t contain spaces'))
                        return
                    }
                    print('input check passed')

                    root.public_request_id = ImportController.getPublicIdFromTelegramKey(root.telegram_key)
                    if (root.public_request_id == '') {
                        waitingBox.visible = false
                        showError(qsTr('Wrong Telegram Key'))
                        return
                    }
                    root.account_status = VPNNWebApi.getAccountStatusStr(root.public_request_id)
                    const cur_status = JSON.parse(root.account_status)

                    var simplified_status = ''
                    try {
                        simplified_status = cur_status.data.request.simplified_status
                    } catch (e) {
                        root.account_status = '{
        "data": {
            "request": {
                "public_request_id": "' + root.public_request_id + '",
                "simplified_status": "Key limit exceeded",
                "paid_until": "",
                "payment_link": ""
            }
        }
    }'
                        root.error = cur_status.error.localized_message
                    }

                    waitingBox.visible = false

                    if (root.error == '' || root.error == 'Key limit exceeded') {
                        if (ImportController.extractDefaultAccountDummyConfig(root.email, root.account_status)) {
                            enableAll()
                            ImportController.importConfig()
                        } else {
                            showError(qsTr('Wrong Dummy Key File'))
                        }
                    } else {
                        // Other errors
                        showError(root.error)
                    }
                } catch (e) {
                    waitingBox.visible = false
                    enableAll()
                }
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

    function enableAll() {
        telegramKey.enabled = true
        backButton.enabled = true
        continueButton.enabled = true
    }

    function disableAll() {
        telegramKey.enabled = false
        backButton.enabled = false
        continueButton.enabled = false
    }

    function showError(error) {
        root.error = error
        errorNotification.visible = true
    }

    SotkaNotification {
        id: errorNotification
        anchors.centerIn: parent
        text: root.error
        onClick: root.enableAll
    }

    BusyIndicator {
        id: waitingBox
        anchors.centerIn: parent
        visible: false
    }
}
