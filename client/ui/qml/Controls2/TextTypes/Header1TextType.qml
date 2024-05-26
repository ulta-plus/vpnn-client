import QtQuick

import Style 1.0

Text {
    lineHeight: 38 + LanguageModel.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: UltaStyle.color.mainText
    font.pixelSize: 32
    font.weight: 700
    font.family: "Montserrat Medium"
    font.letterSpacing: -1.0

    wrapMode: Text.WordWrap
}

