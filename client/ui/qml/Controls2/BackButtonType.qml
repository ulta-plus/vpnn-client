import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import Style 1.0

Item {
    id: root

    property string backButtonImage: "qrc:/images/controls/arrow-left.svg"
    property var backButtonFunction

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    visible: backButtonImage !== ""

    onActiveFocusChanged: {
        if (activeFocus) {
            backButton.forceActiveFocus()
        }
    }

    RowLayout {
        id: content

        anchors.fill: parent
        anchors.leftMargin: 8

        ImageButtonType {
            id: backButton
            image: backButtonImage
            imageColor: UltaStyle.color.icon
            backgroundColor: UltaStyle.color.buttonBackGround

            implicitWidth: 40
            implicitHeight: 40

            onClicked: {
                if (backButtonFunction && typeof backButtonFunction === "function") {
                    backButtonFunction()
                } else {
                    PageController.closePage()
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: {
            backButton.imageColor = UltaStyle.color.iconSelected
            backButton.backgroundColor = UltaStyle.color.buttonBackGroundSelected
            backButton.borderColor = UltaStyle.color.borderSelected
        }

        onExited: {
            backButton.imageColor = UltaStyle.color.icon
            backButton.backgroundColor = UltaStyle.color.buttonBackGround
            backButton.borderColor = UltaStyle.color.border
        }

        onClicked: {
            backButton.clicked()
        }
    }

    Keys.onEnterPressed: backButton.clicked()
    Keys.onReturnPressed: backButton.clicked()
}
