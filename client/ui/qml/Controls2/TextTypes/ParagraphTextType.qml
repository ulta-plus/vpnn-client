import QtQuick
import Style 1.0

Text {
    lineHeight: 24 + LanguageUiController.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: AmneziaStyle.color.paleGray
    font.pixelSize: 16
    font.weight: Font.DemiBold
    font.family: VPNNaruzhuStyle.font

    wrapMode: Text.WordWrap
}
