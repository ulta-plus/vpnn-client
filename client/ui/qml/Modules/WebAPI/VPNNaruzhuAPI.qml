pragma Singleton

import QtQuick

QtObject {
    readonly property string api_url: SettingsController.vpnNaruzhuGetApiBaseUrl()
    readonly property string user_agent: VPNNWebApi.getUserAgent()
    readonly property string awg_version: VPNNWebApi.getAwgVersion()

    function createGetRequest(request) {
        var http = new XMLHttpRequest()
        http.open('GET', api_url + request)

        const uuid = SettingsController.getInstallationUuid(true)
        http.setRequestHeader('X-Device-Id', uuid)
        http.setRequestHeader('X-Supported-Awg-Version', awg_version)
        http.setRequestHeader('User-Agent', user_agent)

        return http
    }

    function getRequestKeyHTTP(public_request_id) {
        const request_key_api = '/client-api/v1/download-awg-key?public_request_id='
        const request = request_key_api + public_request_id

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
        http.setRequestHeader('X-Supported-Awg-Version', awg_version)
        http.setRequestHeader('User-Agent', user_agent)

        return http
    }

    function getEmailVerificationHTTPRequest() {
        const check_email_api = '/client-api/v1/request-email-verification'
        var http = createPostRequest(check_email_api)
        return http
    }

    function getOTPVerificationHTTPRequest() {
        const verify_otp_api = '/client-api/v1/check-email-otp'
        var http = createPostRequest(verify_otp_api)
        return http
    }
}
