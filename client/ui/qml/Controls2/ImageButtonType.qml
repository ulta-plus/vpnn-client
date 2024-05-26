import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Style 1.0

Button {
    id: root

    property string image

    property string hoveredColor: UltaStyle.color.buttonBackGroundSelected
    property string defaultColor: UltaStyle.color.buttonBackGround
    property string pressedColor: AmneziaStyle.color.sheerWhite
    property string disableColor: AmneziaStyle.color.slateGray

    property string imageColor: UltaStyle.color.icon

    property string disableImageColor: AmneziaStyle.color.slateGray

    property string backgroundColor: UltaStyle.color.buttonBackGround
    property string borderColor: UltaStyle.color.border

    property alias backgroundRadius: background.radius

    hoverEnabled: true
    focus: true
    focusPolicy: Qt.TabFocus

    icon.source: image
    icon.color: imageColor

    property Flickable parentFlickable

    onFocusChanged: {
        if (root.activeFocus) {
            if (root.parentFlickable) {
                root.parentFlickable.ensureVisible(this)
            }
        }
    }

    background: Rectangle {
        id: background

        anchors.fill: parent
        border.color: borderColor

        color: backgroundColor
        radius: 12
    }

    MouseArea {
        anchors.fill: parent
        enabled: false
        cursorShape: Qt.PointingHandCursor
    }
}
