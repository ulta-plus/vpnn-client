import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0
import WebAPI 1.0

import './'
import '../Controls2'
import '../Controls2/TextTypes'

PageType {
    id: root

    property string email: ''
    property string otpCode: ''
    property string public_request_id: ''
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
            root.disableAll()
            root.email = emailText.text.trim()

            if (root.email == '') {
                showError(qsTr('Please, provide an email'))
                return
            }

            // Email verification RegExp
            let re = new RegExp("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
            if (!re.test(root.email)) {
                showError(qsTr('Invalid e-mail'))
                return
            }

            var http = VPNNaruzhuAPI.getEmailVerificationHTTPRequest(root.email)

            http.onreadystatechange = function() {
                if(http.readyState === XMLHttpRequest.DONE) {
                    waitingBox.visible = false
                    if (http.status == 200) {
                        inputOTPCode.visible = true
                    } else {
                        root.showHTTPError(http)
                    }
                }
            }

            waitingBox.visible = true
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
            print(http.responseText)

            if (http.status == 0) {
                error = qsTr('Cannot connect to Sever')
            } else {
                error = qsTr('UNKNOWN ERROR: ') + http.status
            }
        }

        showError(error)
    }

    VPNNaruzhuNotification {
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

    function getKeyFile() {
        var http = VPNNaruzhuAPI.getRequestKeyHTTP(root.public_request_id)

        http.onreadystatechange = function() {
            if(http.readyState === XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    if (ImportController.extractDefaultAccountConfig(root.email, http.responseText, root.account_status)) {
                        ImportController.importConfig()
                    } else {
                        showError(qsTr('Wrong Key File'))
                    }
                } else {
                    print('Cannot download file')
                    print(http.responseText.toString())
                    showHTTPError(http)
                }
            }
        }

        http.send()
    }

    VPNNaruzhuNotificationWithInput {
        id: inputOTPCode
        withCloseButton: true
        anchors.centerIn: parent
        text: qsTr('Enter a code from the e-mail')
        buttonYesText: qsTr('Send')
        placeholderText: qsTr('code')

        withYesButton: function() {
            root.otpCode = inputOTPCode.getInput().trim()
            if (root.otpCode == '') {
                inputOTPCode.visible = true
                return
            }

            var http = VPNNaruzhuAPI.getOTPVerificationHTTPRequest()

            http.onreadystatechange = function() {
                if(http.readyState === XMLHttpRequest.DONE) {
                    waitingBox.visible = false
                    if (http.status == 200) {
                        const json_obj = JSON.parse(http.responseText.toString())
                        root.account_status = http.responseText.toString()
                        root.public_request_id = json_obj.data.request.public_request_id

                        var status = json_obj.data.request.simplified_status
                        if (status == 'paid' || status == 'trial') {
                            root.getKeyFile()
                        } else {
                            // 'blocked', 'new', 'else'
                            if (ImportController.extractDefaultAccountDummyConfig(root.email, root.account_status)) {
                                ImportController.importConfig()
                            } else {
                                showError(qsTr('Wrong Dummy Key File'))
                            }
                        }
                        root.enableAll()
                    } else {
                        showHTTPError(http)
                    }
                }
            }

            const body = '{ "email": "' + root.email +'", "otp_code": "' + root.otpCode + '" }'
            waitingBox.visible = true
            http.send(body)
        }

        withNoButton: function() {
            root.enableAll()
        }
    }
}
