import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Style 1.0

import "../Controls2"

Rectangle {
    id: root
    property var activeButtonColor: '#FFFFFF'
    property var activeTextColor: '#000000'
    property var inactiveButtonColor: 'transparent'
    property var inactiveTextColor: '#BDBDBD'

    property string smartModeTitle: VPNNConnectionMode.getSmartModeTitle()
    property string deirectModeTitle: VPNNConnectionMode.getDirectModeTitle()

    property int numberOfModes: VPNNConnectionMode.getNumberOfModes()
    property bool is_visible: (numberOfModes >= 2)

    implicitWidth: root.is_visible ? 343 : 0
    implicitHeight: root.is_visible ? 49 : 0

    radius: 6
    color: 'transparent'
    border.width: 1
    border.color: '#242424'

    visible: root.is_visible

    RowLayout {
        id: modePannel
        anchors.centerIn: parent

        VPNNaruzhuButton {
            id: smartMode

            radius: 4
            implicitWidth: 165.5
            implicitHeight: 41

            Layout.alignment: Qt.AlignRight
            mainText: root.smartModeTitle

            defaultColor: VPNNConnectionMode.isSmartRouteMode() ? root.activeButtonColor : root.inactiveButtonColor
            disableColor: VPNNConnectionMode.isSmartRouteMode() ? root.activeButtonColor : root.inactiveButtonColor
            hoveredColor: VPNNConnectionMode.isSmartRouteMode() ? root.activeButtonColor : root.inactiveButtonColor
            textColor: VPNNConnectionMode.isSmartRouteMode() ? root.activeTextColor : root.inactiveTextColor
            onClicked: {
                smartMode.defaultColor = root.activeButtonColor
                smartMode.disableColor = smartMode.defaultColor
                smartMode.hoveredColor = smartMode.defaultColor
                smartMode.textColor = root.activeTextColor
                directMode.defaultColor = root.inactiveButtonColor
                directMode.disableColor = directMode.defaultColor
                directMode.textColor = root.inactiveTextColor
                directMode.hoveredColor = directMode.defaultColor

                VPNNConnectionMode.setSmartRouteMode()
            }
        }

        VPNNaruzhuButton {
            id: directMode

            radius: 4
            implicitWidth: 165.5
            implicitHeight: 41

            Layout.alignment: Qt.AlignLeft
            mainText: root.deirectModeTitle

            defaultColor: VPNNConnectionMode.isDirectRouteMode() ? root.activeButtonColor : root.inactiveButtonColor
            disableColor: VPNNConnectionMode.isDirectRouteMode() ? root.activeButtonColor : root.inactiveButtonColor
            hoveredColor: VPNNConnectionMode.isDirectRouteMode() ? root.activeButtonColor : root.inactiveButtonColor
            textColor: VPNNConnectionMode.isDirectRouteMode() ? root.activeTextColor : root.inactiveTextColor
            onClicked: {
                smartMode.defaultColor = root.inactiveButtonColor
                smartMode.disableColor = smartMode.defaultColor
                smartMode.hoveredColor = smartMode.defaultColor
                smartMode.textColor = root.inactiveTextColor
                directMode.defaultColor = root.activeButtonColor
                directMode.disableColor = directMode.defaultColor
                directMode.textColor = root.activeTextColor
                directMode.hoveredColor = directMode.defaultColor

                VPNNConnectionMode.setDirectRouteMode()
            }
        }
    }
}