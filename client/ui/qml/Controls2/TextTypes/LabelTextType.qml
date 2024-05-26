import QtQuick

import Style 1.0

Text {
    lineHeight: 16 + LanguageModel.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: AmneziaStyle.color.mutedGray
    font.pixelSize: 13
    font.weight: 400
    font.family: "Montserrat Medium"
    font.letterSpacing: 0.02

    wrapMode: Text.WordWrap
}
