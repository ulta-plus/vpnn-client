pragma Singleton

import QtQuick

QtObject {
    property QtObject color: QtObject {
        readonly property color black: '#000000'
        readonly property color white: '#FFFFFF'
        readonly property color yellow: '#FFDA00'
        readonly property color red: '#FF0000'
        readonly property color text: '#000000'
        readonly property color mainBackGround: '#FFFFFF'
        readonly property color buttonText: '#000000'
        readonly property color buttonDefault: 'transparent'
        readonly property color buttonDisable: 'transparent'
        readonly property color buttonPressed: 'transparent'
        readonly property color buttonHovered: 'transparent'
        readonly property color buttonBorder: '#000000'
        readonly property color buttonBorderFocused: '#000000'
        readonly property color notificationText: AmneziaStyle.color.paleGray
        readonly property color notificationBorder: AmneziaStyle.color.slateGray
        readonly property color notificationBackground: AmneziaStyle.color.onyxBlack
        readonly property color textFieldText: '#000000'
        readonly property color textFieldBorder: '#000000'
        readonly property color textFieldBackgroundColor: 'transparent'
        readonly property color textFieldBorderFocusedColor: '#000000'
        readonly property color textFieldBackgroundTextColor: '#000000'
        readonly property color textFieldBackgroundDisabledColor: 'transparent'
    }

    readonly property string font: 'IBM Plex Mono'
}
