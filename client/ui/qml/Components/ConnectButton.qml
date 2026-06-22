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

    property string defaultButtonColor: '#FFD600'
    property string blockedColor: "#3C3C3C"
    property string progressButtonColor: "#FFDD51"
    property string connectedButtonColor: '#FFD600'
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

    implicitWidth: 284
    implicitHeight: 284

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
            layer.effect: InnerShadow {
                anchors.fill: backgroundCircle
                radius: 50
                samples: 32
                verticalOffset: 10
                source: backgroundCircle
                spread: 0.0
                color: {
                    if (ConnectionController.isConnected) {
                        return '#FFD600'
                    } else {
                        'transparent'
                    }
                }
            }

            ShapePath {
                fillColor: {
                    if (ConnectionController.isConnectionInProgress) {
                        return '#FFFFFF'
                    } else if (ConnectionController.isConnected) {
                        return '#151515'
                    } else if (VPNNApp.isAccountBlocked) {
                        return root.blockedColor
                    } else {
                        return root.defaultButtonColor
                    }
                }
                strokeColor: AmneziaStyle.color.paleGray
                strokeWidth: root.buttonActiveFocus ? 1 : 0
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: backgroundCircle.width / 2
                    centerY: backgroundCircle.height / 2
                    radiusX: 141
                    radiusY: 141
                    startAngle: 0
                    sweepAngle: 360
                }
            }

        /*
            ShapePath {
                fillColor: AmneziaStyle.color.transparent
                strokeColor: {
                    if (ConnectionController.isConnectionInProgress) {
                        return '#FFFFFF'
                    } else if (ConnectionController.isConnected) {
                        return '#FFD600'
                    } else {
                        return '#FFD600'
                    }
                }

                strokeWidth: root.buttonActiveFocus ? 2 : 3
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: backgroundCircle.width / 2
                    centerY: backgroundCircle.height / 2
                    radiusX: 140 - (root.buttonActiveFocus ? 2 : 0)
                    radiusY: 140 - (root.buttonActiveFocus ? 2 : 0)
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        */

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

            visible: ConnectionController.isConnectionInProgress

            ShapePath {
                fillColor: "transparent"
                strokeColor: "black"
                strokeWidth: 3
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    radiusX: 140
                    radiusY: 140
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

    contentItem: Item {
            ColumnLayout {
                anchors.centerIn: parent
                Image {
                    id: image
                    width: 95
                    height: 95
                    Layout.preferredWidth: 95
                    Layout.preferredHeight: 95
                    Layout.alignment: Qt.AlignCenter

                    source: {
                        if (ConnectionController.isConnectionInProgress) {
                            return 'qrc:/images/connect button/progress.svg'
                        } else if (ConnectionController.isConnected) {
                            return 'qrc:/images/connect button/connected.svg'
                        } else {
                            return 'qrc:/images/connect button/default.svg'
                        }
                    }

                    layer {
                        enabled: true
                        effect: ColorOverlay {
                            color: {
                                if (ConnectionController.isConnectionInProgress) {
                                    return '#000000'
                                } else if (ConnectionController.isConnected) {
                                    return '#FFD600'
                                } else {
                                    return '#000000'
                                }
                            }
                        }
                    }
                }

                Text {
                    height: 24

                    font.family: VPNNaruzhuStyle.font
                    font.weight: Font.DemiBold
                    font.pixelSize: 16
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 16 * (-0.04)

                    color: {
                        if (ConnectionController.isConnectionInProgress) {
                            return '#000000'
                        } else if (ConnectionController.isConnected) {
                            return '#FFD600'
                        } else {
                            return '#000000'
                        }
                    }

                    text: root.text

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
        }
    }

    onClicked: {
        ConnectionController.connectButtonClicked()
    }

    Keys.onEnterPressed: this.clicked()
    Keys.onReturnPressed: this.clicked()
}
