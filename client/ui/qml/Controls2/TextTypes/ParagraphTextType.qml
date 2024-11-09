import QtQuick
import Style 1.0

Text {
    lineHeight: 24 + LanguageModel.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: AmneziaStyle.color.paleGray
    font.pixelSize: 16
    font.weight: Font.DemiBold
    font.family: "Inter"

    wrapMode: Text.WordWrap
}
