import QtQuick
import Style 1.0

Text {
    lineHeight: 24 + LanguageModel.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: Sotka.color.text
    font.pixelSize: 16
    font.weight: 500
    font.family: Sotka.font

    wrapMode: Text.WordWrap
}
