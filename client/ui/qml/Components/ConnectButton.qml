import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

import ConnectionState 1.0
import PageEnum 1.0
import Style 1.0

Button {
    id: root

    property bool isUnpaid: ServersModel.isDefaultAccountUnpaid()
    property string defaultButtonColor: Sotka.color.yellow
    property string progressButtonColor: Sotka.color.black
    property string connectedButtonColor: Sotka.color.black
    property string errorButtonColor: Sotka.color.black
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

    implicitWidth: 196
    implicitHeight: 196

    text: isUnpaid ? qsTr('Renew\nSubscription') : qsTr(ConnectionController.connectionStateText)

    Connections {
        target: ConnectionController

        function onPreparingConfig() {
            PageController.showNotificationMessage(qsTr("Unable to disconnect during configuration preparation"))
        }
    }

    Connections {
        target: VPNNWebApi

        function onKeyLimitExceeded() {
            PageController.goToPage(PageEnum.SotkaKeyBinding)
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
                fillColor: {
                    if (ConnectionController.isConnectionInProgress) {
                        return Sotka.color.black
                    } else if (ConnectionController.isConnected) {
                        return Sotka.color.black
                    } else if (ConnectionController.isConnectionFailed) {
                        return Sotka.color.black
                    } else {
                        return (isUnpaid ? Sotka.color.black : Sotka.color.yellow)
                    }
                }
                strokeColor: {
                    if (ConnectionController.isConnectionInProgress) {
                        return Sotka.color.yellow
                    } else if (ConnectionController.isConnected) {
                        return Sotka.color.yellow
                    } else if (ConnectionController.isConnectionFailed) {
                        return Sotka.color.red
                    } else {
                        return (isUnpaid ? Sotka.color.red : Sotka.color.black)
                    }
                }
                strokeWidth: 10
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: backgroundCircle.width / 2
                    centerY: backgroundCircle.height / 2
                    radiusX: 98
                    radiusY: 98
                    startAngle: 0
                    sweepAngle: 360
                }
            }

            MouseArea {
                anchors.fill: backgroundCircle

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

            visible: ConnectionController.isConnectionInProgress

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
                running: ConnectionController.isConnectionInProgress
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }
    }

    contentItem: Text {
        height: 24

        font.family: Sotka.font
        font.weight: 700
        font.pixelSize: 20

        color: {
            if (ConnectionController.isConnectionInProgress) {
                return Sotka.color.white
            } else if (ConnectionController.isConnected) {
                return Sotka.color.white
            } else if (ConnectionController.isConnectionFailed) {
                return Sotka.color.white
            } else {
                return (isUnpaid ? Sotka.color.white : Sotka.color.text)
            }
        }

        text: root.text
        font.capitalization: Font.AllUppercase

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    onClicked: {
        ServersModel.setProcessedServerIndex(ServersModel.defaultIndex)
        ConnectionController.connectButtonClicked()
    }

    Keys.onEnterPressed: this.clicked()
    Keys.onReturnPressed: this.clicked()
}
