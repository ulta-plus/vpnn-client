pragma Singleton

import QtQuick

QtObject {
    readonly property string api_url: VPNNWebApi.getApiBaseUrl()
    readonly property string user_agent: VPNNWebApi.getUserAgent()
    readonly property string awg_version: VPNNWebApi.getAwgVersion()

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
