import QtQuick
import QtQuick.Controls

import Style 1.0

import '../Controls2'

TextField {
    id: root

    property int radius: 0
    property int textSize: 16
    property int borderWidth: 1
    property int borderFocusedWidth: 2
    property string textColor: Sotka.color.textFieldText
    property string borderColor: Sotka.color.textFieldBorder
    property string backgroundColor: Sotka.color.textFieldBackgroundColor
    property string backgroundTextColor: Sotka.color.textFieldBackgroundTextColor
    property string backgroundDisabledColor: Sotka.color.textFieldBackgroundDisabledColor

    placeholderText: ''
    placeholderTextColor: root.backgroundTextColor

    color: root.textColor
    font.pixelSize: root.textSize
    font.weight: 400
    font.family: Sotka.font

    background: Rectangle {
        radius: root.radius
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: getBorderWidht()
        implicitHeight: 45
    }

    function getBorderWidht() {
        return root.hovered || root.focus ? root.borderFocusedWidth : root.borderWidth
    }
}
