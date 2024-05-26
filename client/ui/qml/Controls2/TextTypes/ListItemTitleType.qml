import QtQuick

import Style 1.0

Text {
    lineHeight: 21.6 + LanguageModel.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: UltaStyle.color.mainText
    font.pixelSize: 18
    font.weight: 400
    font.family: "Montserrat Medium"

    wrapMode: Text.Wrap
}
