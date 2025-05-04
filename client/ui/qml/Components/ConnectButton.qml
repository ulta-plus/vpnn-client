import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

import ConnectionState 1.0
import PageEnum 1.0
import Style 1.0
import WebAPI 1.0

Button {
    id: root

    property string defaultButtonColor: "#F1F0EF"
    property string progressButtonColor: "#FFDD51"
    property string connectedButtonColor: "#33CC8C"
    property string errorButtonColor: "#FF6969"
    property bool buttonActiveFocus: activeFocus && (Qt.platform.os !== "android" || SettingsController.isOnTv())

    property bool isFocusable: true

    Keys.onTabPressed: {
        FocusController.nextKeyTabItem()
    }

    Keys.onBacktabPressed: {
        FocusController.previousKeyTabItem()
    }

    Keys.onUpPressed: {
        FocusController.nextKeyUpItem()
    }

    Keys.onDownPressed: {
        FocusController.nextKeyDownItem()
    }

    Keys.onLeftPressed: {
        FocusController.nextKeyLeftItem()
    }

    Keys.onRightPressed: {
        FocusController.nextKeyRightItem()
    }

    implicitWidth: 190
    implicitHeight: 190

    text: qsTr(ConnectionController.connectionStateText)

    Connections {
        target: ConnectionController

        function onPreparingConfig() {
            PageController.showNotificationMessage(qsTr("Unable to disconnect during configuration preparation"))
        }
    }

//    enabled: !ConnectionController.isConnectionInProgress

    background: Item {
        implicitWidth: parent.width
        implicitHeight: parent.height
        transformOrigin: Item.Center

        Shape {
            id: backgroundCircle
            width: parent.implicitWidth
            height: parent.implicitHeight
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            layer.enabled: true
            layer.samples: 4
            layer.smooth: true
            layer.effect: DropShadow {
                anchors.fill: backgroundCircle
                horizontalOffset: 0
                verticalOffset: 0
                radius: 10
                samples: 25
                color: root.activeFocus ? "#D7D8DB" : "#F1F0EF"
                source: backgroundCircle
            }

            ShapePath {
                fillColor: AmneziaStyle.color.transparent
                strokeColor: AmneziaStyle.color.paleGray
                strokeWidth: root.buttonActiveFocus ? 1 : 0
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: backgroundCircle.width / 2
                    centerY: backgroundCircle.height / 2
                    radiusX: 94
                    radiusY: 94
                    startAngle: 0
                    sweepAngle: 360
                }
            }

            ShapePath {
                fillColor: AmneziaStyle.color.transparent
                strokeColor: {
                    if (ConnectionController.isConnectionInProgress) {
                        return progressButtonColor
                    } else if (ConnectionController.isConnected) {
                        return connectedButtonColor
                    } else if (ConnectionController.isConnectionFailed) {
                        return errorButtonColor
                    } else {
                        return defaultButtonColor
                    }
                }
                strokeWidth: root.buttonActiveFocus ? 2 : 3
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: backgroundCircle.width / 2
                    centerY: backgroundCircle.height / 2
                    radiusX: 93 - (root.buttonActiveFocus ? 2 : 0)
                    radiusY: 93 - (root.buttonActiveFocus ? 2 : 0)
                    startAngle: 0
                    sweepAngle: 360
                }
            }

            MouseArea {
                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor
                enabled: false
            }
        }

        Shape {
            id: shape
            width: parent.implicitWidth
            height: parent.implicitHeight
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            layer.enabled: true
            layer.samples: 4

            property bool startConnectionAnimation: false
            visible: ConnectionController.isConnectionInProgress || startConnectionAnimation

            ShapePath {
                fillColor: "transparent"
                strokeColor: "black"
                strokeWidth: 3
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    radiusX: 93
                    radiusY: 93
                    startAngle: 245
                    sweepAngle: -180
                }
            }

            RotationAnimator {
                target: shape
                running: ConnectionController.isConnectionInProgress || shape.startConnectionAnimation
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }
    }

    contentItem: Text {
        height: 24

        font.family: "PT Root UI VF"
        font.weight: 700
        font.pixelSize: 20

        color: {
            if (ConnectionController.isConnectionInProgress) {
                return progressButtonColor
            } else if (ConnectionController.isConnected) {
                return connectedButtonColor
            } else if (ConnectionController.isConnectionFailed) {
                return errorButtonColor
            } else {
                return defaultButtonColor
            }
        }

        text: root.text

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    function defaultConnectButtonClicked() {
        ServersModel.setProcessedServerIndex(ServersModel.defaultIndex)
        ConnectionController.connectButtonClicked()
        shape.startConnectionAnimation = false
    }

    function updateDefaultAccountConfigAndConnect() {
        const public_request_id = ServersModel.getDefaultAccount().public_request_id
        var http = VPNNaruzhuAPI.getRequestKeyHTTP(public_request_id)

        http.onreadystatechange = function() {
            if(http.readyState === XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    ImportController.extractConfigFromData(http.responseText.toString())
                    ImportController.updateDefaultAccountConfig()
                    defaultConnectButtonClicked()
                } else {
                    print('Cannot update default account config')
                    shape.startConnectionAnimation = false
                }
            }
        }

        http.send()
    }

    onClicked: {
        if (ConnectionController.isConnected) {
            defaultConnectButtonClicked()
            return
        } else {
            shape.startConnectionAnimation = true
        }

        const public_request_id = ServersModel.getDefaultAccount().public_request_id
        var http = VPNNaruzhuAPI.getPublicRequestIdStatusHTTP(public_request_id)

        http.onreadystatechange = function() {
            if(http.readyState === XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    ServersModel.updateDefaultAccountStatus(http.responseText.toString())
                    if (ServersModel.getDefaultAccount().simplified_status != 'blocked') {
                        if (ServersModel.defaultIndex == ServersModel.getDefaultAccountIndex()) {
                            updateDefaultAccountConfigAndConnect()
                        } else {
                            defaultConnectButtonClicked()
                        }
                    } else {
                        PageController.showNotificationMessage(qsTr('Your account blocked'))
                        shape.startConnectionAnimation = false
                    }
                } else {
                    print('Cannot update default account status')
                    shape.startConnectionAnimation = false
                }
            }
        }

        http.send()
    }

    Keys.onEnterPressed: this.clicked()
    Keys.onReturnPressed: this.clicked()
}
