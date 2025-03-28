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

    property string email: ''
    property string otpCode: ''
    property string public_request_id: ''
    property string error: ''
    property string configStatus: ''

    Connections {
        target: ImportController

        function onImportErrorOccurred(error, goToPageHome) {
            if (goToPageHome) {
                PageController.goToStartPage()
            } else {
                PageController.closePage()
            }
        }

        function onImportFinished() {
            if (!ConnectionController.isConnected) {
                ServersModel.setDefaultServerIndex(ServersModel.getServersCount() - 1)
                ServersModel.processedIndex = ServersModel.defaultIndex
            }

            PageController.goToPageHome()
        }
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        spacing: 0

        BackButtonType {
            id: backButton
            Layout.topMargin: 20
            KeyNavigation.tab: emailText
        }

        Header2TextType {
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 16
            text: qsTr('Enter your e-mail')
        }

        VPNNaruzhuTextField {
            id: emailText
            objectName: 'emailText'

            Layout.fillWidth: true
            Layout.rightMargin: 16
            Layout.leftMargin: 16

            placeholderText: 'e-mail'

            KeyNavigation.tab: continueButton
        }
    }

    VPNNaruzhuButton {
        id: continueButton
        objectName: 'connectButton'

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.leftMargin: 16
        anchors.bottomMargin: 32

        implicitHeight: 56

        mainText: qsTr('Continue')

        KeyNavigation.tab: backButton

        onClicked: {
            root.email = emailText.text

            var http = new XMLHttpRequest()
            const url = 'https://web-api.vpn-naruzhu.website'
            const check_email_api = '/api/v1/auth/request_email_verification?reason=mobile_request&email='
            http.open('GET', url + check_email_api + root.email)

            var uuid = SettingsController.getInstallationUuid(true)
            http.setRequestHeader('X-Device-Id', uuid)

            const user_agent = 'naruzhu-desktop/1.2.1.123'
            http.setRequestHeader('User-Agent', user_agent)

            http.onreadystatechange = function() {
                if(http.readyState === XMLHttpRequest.DONE) {
                    root.disableAll()
                    if (http.status == 200) {
                        inputOTPCode.visible = true
                    } else {
                        root.showHTTPError(http)
                    }
                }
            }

            http.send()
        }
    }

    function enableAll() {
        emailText.enabled = true
        backButton.enabled = true
        continueButton.enabled = true
    }

    function disableAll() {
        emailText.enabled = false
        backButton.enabled = false
        continueButton.enabled = false
    }

    function showError(error) {
        root.error = error
        errorNotification.visible = true
    }

    function showHTTPError(http) {
        error = ''
        try {
            const object = JSON.parse(http.responseText.toString())
            error = object.error.localized_message
        } catch (e) {
            error = 'UNKNOWN ERROR: ' + http.status
        }

        showError(error)
    }

    VPNNaruzhuNotification {
        id: errorNotification
        anchors.centerIn: parent
        text: root.error
        onClick: root.enableAll
    }

    function getKeyFile() {
        var http = new XMLHttpRequest()
        const url = 'https://web-api.vpn-naruzhu.website'
        const request_key_api = '/api/v1/wg_keys/download_mobile_request_key?public_request_id='
        http.open('GET', url + request_key_api + root.public_request_id)

        const uuid = SettingsController.getInstallationUuid(true)
        http.setRequestHeader('X-Device-Id', uuid)

        const user_agent = 'naruzhu-desktop/1.2.1.123'
        http.setRequestHeader('User-Agent', user_agent)

        http.onreadystatechange = function() {
            if(http.readyState === XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    if (ImportController.extractDefaultConfig(http.responseText, root.configStatus)) {
                        ImportController.importConfig()
                    } else {
                        showError(qsTr('Wrong Key File'))
                    }
                } else {
                    showHTTPError(http)
                }
            }
        }

        http.send()
    }

    VPNNaruzhuNotificationWithInput {
        id: inputOTPCode
        anchors.centerIn: parent
        text: qsTr('Enter a code from the e-mail')
        placeholderText: qsTr('code')

        withClose: function() {
            root.otpCode = inputOTPCode.getInput()
            if (root.otpCode == '') {
                inputOTPCode.visible = true
                return
            }

            var http = new XMLHttpRequest()
            const url = 'https://web-api.vpn-naruzhu.website'
            const verify_email_api = '/api/v1/mobile_request'
            http.open('POST', url + verify_email_api)

            const contentType = 'application/json'
            http.setRequestHeader('Content-Type', contentType)

            var uuid = SettingsController.getInstallationUuid(true)
            http.setRequestHeader('X-Device-Id', uuid)

            const user_agent = 'naruzhu-desktop/1.2.1.123'
            http.setRequestHeader('User-Agent', user_agent)

            http.onreadystatechange = function() {
                if(http.readyState === XMLHttpRequest.DONE) {
                    if (http.status == 200) {
                        const json_obj = JSON.parse(http.responseText.toString())
                        root.configStatus = http.responseText.toString()
                        root.public_request_id = json_obj.data.request.public_request_id
                        root.getKeyFile()
                        root.enableAll()
                    } else {
                        showHTTPError(http)
                    }
                }
            }

            const body = '{ "email": "' + root.email +'", "otp_code": "' + root.otpCode + '" }'
            http.send(body)
        }
    }
}
