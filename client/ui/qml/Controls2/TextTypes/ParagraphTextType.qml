import QtQuick
import Style 1.0

Text {
    lineHeight: 24 + LanguageModel.getLineHeightAppend()
    lineHeightMode: Text.FixedHeight

    color: UltaStyle.color.mainText
    font.pixelSize: 16
    font.weight: Font.Bold
    font.family: "Montserrat SemiBold"

    wrapMode: Text.WordWrap
}
