import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.lottieqt

import ConnectionState 1.0
import PageEnum 1.0
import Style 1.0

Button {
    id: root

    property string defaultButtonColor: '#FFD600'
    property string blockedColor: "#3C3C3C"
    property string progressButtonColor: "#FFDD51"
    property string connectedButtonColor: '#FFD600'
    property string errorButtonColor: "#FF6969"

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

        function onConnectionStateChanged() {
            if (ConnectionController.isConnectionInProgress) {
                animation.play()
            } else if (ConnectionController.isConnected) {
                animation.stop()
                animation.currentFrame = 0
            } else {
                animation.stop()
                animation.currentFrame = 0
            }
        }
    }

    background: Item {
        implicitWidth: parent.width
        implicitHeight: parent.height
        ColumnLayout {
            anchors.centerIn: parent
            implicitWidth: parent.width
            implicitHeight: parent.height

            LottieAnimation {
                id: animation

                Layout.alignment: Qt.AlignCenter

                source: "qrc:/images/connect_button_animation.json"

                autoPlay: false
                frameRate: 30
                loops: LottieAnimation.Infinite
                quality: LottieAnimation.HighQuality
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            enabled: false
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

                Layout.topMargin: 25
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
        ServersModel.setProcessedServerIndex(ServersModel.defaultIndex)
        ConnectionController.connectButtonClicked()
    }

    Keys.onEnterPressed: this.clicked()
    Keys.onReturnPressed: this.clicked()
}
