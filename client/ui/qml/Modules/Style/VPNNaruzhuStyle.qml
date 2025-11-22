pragma Singleton

import QtQuick

QtObject {
    property QtObject color: QtObject {
        readonly property color backGround: '#151515'
        readonly property color headerText: '#FFFFFF'
        readonly property color footnotes: '#BDBDBD'
        readonly property color buttonText: AmneziaStyle.color.midnightBlack
        readonly property color buttonDefault: '#FFD600'
        readonly property color buttonDisable: AmneziaStyle.color.charcoalGray
        readonly property color buttonPressed: '#4D3E00'
        readonly property color buttonHovered: '#FFD600'
        readonly property color buttonBorder: '#FFFFFF'
        readonly property color buttonBorderFocused: '#FFFFFF'
        readonly property color notificationText: AmneziaStyle.color.paleGray
        readonly property color notificationBorder: AmneziaStyle.color.slateGray
        readonly property color notificationBackground: AmneziaStyle.color.onyxBlack
        readonly property color textFieldText: AmneziaStyle.color.paleGray
        readonly property color textFieldBorder: AmneziaStyle.color.slateGray
        readonly property color textFieldBackgroundColor: AmneziaStyle.color.onyxBlack
        readonly property color textFieldBorderFocusedColor: AmneziaStyle.color.paleGray
        readonly property color textFieldBackgroundTextColor: AmneziaStyle.color.charcoalGray
        readonly property color textFieldBackgroundDisabledColor: AmneziaStyle.color.transparent
    }

    readonly property string font: 'Inter'
    readonly property string fontEmoji: 'Noto Color Emoji'
}
