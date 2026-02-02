import QtQuick
import QtQuick.Controls

import Style 1.0

import '../Controls2'

TextField {
    id: root

    property int textSize: 16
    property int radius : 16
    property string textColor: VPNNaruzhuStyle.color.textFieldText
    property string borderColor: VPNNaruzhuStyle.color.textFieldBorder
    property string backgroundColor: VPNNaruzhuStyle.color.textFieldBackgroundColor
    property string borderFocusedColor: VPNNaruzhuStyle.color.textFieldBorderFocusedColor
    property string backgroundTextColor: VPNNaruzhuStyle.color.textFieldBackgroundTextColor
    property string backgroundDisabledColor: VPNNaruzhuStyle.color.textFieldBackgroundDisabledColor

    placeholderText: ''
    placeholderTextColor: root.backgroundTextColor

    color: root.textColor
    font.pixelSize: root.textSize
    font.weight: 400
    font.family: 'PT Root UI VF'

    function getBorderColor() {
        return root.focus ? root.borderFocusedColor : root.borderColor
    }

    function getBackgroundColor() {
        return root.enabled ? root.backgroundColor : root.backgroundDisabledColor
    }

    background: Rectangle {
        radius: root.radius
        color: root.getBackgroundColor()
        border.color: root.getBorderColor()
        border.width: 1
        implicitHeight: 40
    }

    MouseArea {
        anchors.fill: root
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.open()
        enabled: true
    }

    ContextMenuType {
        id: contextMenu
        textObj: root
    }
}
