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
    property string pleaseInputEmail: qsTr('Enter your e-mail')
    property string pleaseInputOtp: qsTr('Enter a code from the e-mail')
    property string placeholderEmail: 'e-mail'
    property string placeholderOtpCode: 'otp code'

    enum PageStatus { InputEmail = 0, InputOTP = 1 }
    property var pageStatus: VPNNaruzhuPageEmailLogIn.PageStatus.InputEmail

    Connections {
        target: ImportController

        function onImportFinished() {
            if (ServersModel.getServersCount() == 1) {
                // There is only new default config
                ServersModel.setDefaultServerIndex(ServersModel.getServersCount() - 1)
                ServersModel.processedIndex = ServersModel.defaultIndex
            }

            waitingBox.visible = false
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
            KeyNavigation.tab: input
            backButtonFunction: function () {
                if (root.pageStatus == VPNNaruzhuPageEmailLogIn.PageStatus.InputOTP) {
                    switchPageStatusToInputEmail()
                } else {
                    PageController.closePage()
                }
            }
        }

        VPNNaruzhuHeader {
            id: header
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 24
            text: root.pleaseInputEmail
        }

        VPNNaruzhuTextField {
            id: input
            objectName: 'input'

            Layout.alignment: Qt.AlignHCenter

            implicitHeight: 41
            implicitWidth: 327
            radius: 4

            placeholderText: root.placeholderEmail

            KeyNavigation.tab: continueButton
        }

        VPNNaruzhuButton {
            id: continueButton
            objectName: 'connectButton'

            Layout.topMargin: 10
            Layout.alignment: Qt.AlignHCenter

            implicitHeight: 41
            implicitWidth: 327
            radius: 4

            mainText: qsTr('Continue')
            capitalization: Font.AllUppercase

            hoveredOpacity: 0.5

            KeyNavigation.tab: backButton

            onClicked: {
                root.disableAll()

                if (root.pageStatus == VPNNaruzhuPageEmailLogIn.PageStatus.InputEmail) {
                    root.email = input.text.trim()

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
                                switchPageStatusToInputOtp()
                            } else {
                                root.showHTTPError(http)
                            }
                        }
                    }

                    waitingBox.visible = true
                    http.send()
                } else {
                    root.otpCode = input.text.trim()
                    if (root.otpCode == '') {
                        showError(qsTr('Please, provide OTP code'))
                        return
                    }

                    var http = VPNNaruzhuAPI.getOTPVerificationHTTPRequest()

                    http.onreadystatechange = function() {
                        if(http.readyState === XMLHttpRequest.DONE) {
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
                                        waitingBox.visible = false
                                        showError(qsTr('Wrong Dummy Key File'))
                                    }
                                }
                                root.enableAll()
                            } else {
                                waitingBox.visible = false
                                showHTTPError(http)
                            }
                        }
                    }

                    const body = '{ "email": "' + root.email +'", "otp_code": "' + root.otpCode + '" }'
                    waitingBox.visible = true
                    http.send(body)
                }
            }
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.leftMargin: 16
        anchors.bottomMargin: 24

        Text {
            text: 'v' + VPNNWebApi.getAppVersion()
            color: VPNNaruzhuStyle.color.footnotes
            opacity: 0.56
            font.pixelSize: 12
            font.weight: Font.Medium
            font.family: VPNNaruzhuStyle.font

            Layout.alignment: Qt.AlignVCente | Qt.AlignLeft
        }

        VPNNaruzhuButton {
            id: telegramButton

            Layout.alignment: Qt.AlignRight

            implicitHeight: 38
            implicitWidth: 144
            radius: 3

            borderWidth: 1
            borderFocusedWidth: 1

            defaultColor: 'transparent'
            pressedColor: 'transparent'
            hoveredColor: 'transparent'

            leftIcon: 'qrc:/images/controls/telegram.svg'
            leftIconColor: '#FFFFFF'

            textColor: '#FFFFFF'
            textSize: 14
            letterSpacing: textSize * (-0.05)
            mainText: qsTr('Telegram')

            onClicked: {
                Qt.openUrlExternally("https://t.me/vpn_naruzhu")
            }
        }
    }

    function switchPageStatusToInputOtp() {
        root.pageStatus = VPNNaruzhuPageEmailLogIn.PageStatus.InputOTP
        header.text = root.pleaseInputOtp
        input.text = ''
        input.placeholderText = root.placeholderOtpCode
        root.enableAll()
    }

    function switchPageStatusToInputEmail() {
        root.pageStatus = VPNNaruzhuPageEmailLogIn.PageStatus.InputEmail
        header.text = root.pleaseInputEmail
        input.text = root.email
        input.placeholderText = root.placeholderEmail
        root.enableAll()
    }

    function enableAll() {
        input.enabled = true
        backButton.enabled = true
        continueButton.enabled = true
    }

    function disableAll() {
        input.enabled = false
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
                        waitingBox.visible = false
                        showError(qsTr('Wrong Key File'))
                    }
                } else {
                    waitingBox.visible = false
                    print('Cannot download file')
                    print(http.responseText.toString())
                    showHTTPError(http)
                }
            }
        }

        http.send()
    }
}
