pragma Singleton

import QtQuick

QtObject {
    property QtObject color: QtObject {
        readonly property color buttonText: AmneziaStyle.color.midnightBlack
        readonly property color buttonDefault: AmneziaStyle.color.paleGray
        readonly property color buttonDisable: AmneziaStyle.color.charcoalGray
        readonly property color buttonPressed: AmneziaStyle.color.mutedGray
        readonly property color buttonHovered: AmneziaStyle.color.lightGray
        readonly property color buttonBorder: AmneziaStyle.color.paleGray
        readonly property color buttonBorderFocused: AmneziaStyle.color.paleGray
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
}
