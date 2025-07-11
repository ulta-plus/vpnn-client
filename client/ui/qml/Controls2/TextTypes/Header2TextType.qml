import QtQuick

import Style 1.0

Text {
    lineHeight: 30 + LanguageModel.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: Sotka.color.text
    font.pixelSize: 25
    font.weight: 700
    font.family: Sotka.font

    wrapMode: Text.WordWrap
}
