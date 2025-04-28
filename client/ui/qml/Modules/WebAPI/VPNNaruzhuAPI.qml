pragma Singleton

import QtQuick

QtObject {
    readonly property string api_url: 'https://web-api.vpn-naruzhu.website'
    readonly property string user_agent: 'naruzhu-desktop/1.2.1.123'

    function createGetRequest(request) {
        var http = new XMLHttpRequest()
        http.open('GET', api_url + request)

        const uuid = SettingsController.getInstallationUuid(true)
        http.setRequestHeader('X-Device-Id', uuid)
        http.setRequestHeader('User-Agent', user_agent)

        return http
    }

    function getPublicRequestIdStatusHTTP() {
        const public_request_id = ServersModel.getDefaultConfig().public_request_id
        const check_public_request_id = '/api/v1/mobile_request?public_request_id='
        const request = check_public_request_id + public_request_id

        var http = createGetRequest(request)
        return http
    }

    function updateDefaultConfig() {
        if (!ServersModel.isThereDefaultConfig()) {
            return
        }

        var http = getPublicRequestIdStatusHTTP()

        http.onreadystatechange = function() {
            if(http.readyState === XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    ServersModel.updateDefaultConfig(http.responseText.toString())
                } else {
                    print('Cannot update default key status')
                }
            }
        }

        http.send()
    }

    function getEmailVerificationHTTPRequest(email) {
        const check_email_api = '/api/v1/auth/request_email_verification?reason=mobile_request&email='
        const request = check_email_api + email

        var http = createGetRequest(request)
        return http
    }

    function createPostRequest(request) {
        var http = new XMLHttpRequest()
        http.open('POST', api_url + request)

        const contentType = 'application/json'
        http.setRequestHeader('Content-Type', contentType)

        const uuid = SettingsController.getInstallationUuid(true)
        http.setRequestHeader('X-Device-Id', uuid)
        http.setRequestHeader('User-Agent', user_agent)

        return http
    }

    function getOTPVerificationHTTPRequest() {
        const verify_otp_api = '/api/v1/mobile_request'
        var http = createPostRequest(verify_otp_api)
        return http
    }
}
