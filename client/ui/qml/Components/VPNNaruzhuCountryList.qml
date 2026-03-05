import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Style 1.0

ComboBox {
    id: root

    wheelEnabled: true

    model: VPNNCountriesModel

    Connections {
        target: VPNNWebApi

        function onDefaultAccountStatusUpdated() {
            VPNNCountriesModel.refresh()
            root.currentIndex = model.currentIndex
            selectedCountryImage.source = root.model.get(root.currentIndex).icon
            selectedCountryName.text = root.model.get(root.currentIndex).name
        }
    }

    currentIndex: model.currentIndex
    onActivated: {
        model.currentIndex = root.currentIndex
    }

    indicator: Image {
        anchors.right: parent.right
        anchors.rightMargin : 12.5
        anchors.verticalCenter: parent.verticalCenter
        source: 'qrc:/images/controls/drop-list.svg'
    }

    background: Rectangle {
        color: 'transparent'
        border.width: 1
        border.color: '#3C3C3C'
        radius: 4
    }

    MouseArea {
        anchors.fill: root.background
        enabled: false
        cursorShape: Qt.PointingHandCursor
    }

    contentItem: Item {
        id: selectedCountry
        anchors.fill: root
        implicitWidth: root.width
        implicitHeight: root.height

        RowLayout {
            anchors.fill: parent
            implicitWidth: root.width
            implicitHeight: root.height
            spacing: 0

            Image {
                id: selectedCountryImage
                Layout.leftMargin: 12
                Layout.alignment: Qt.AlignLeft
                width: 20
                height: 20
                source: root.model.get(root.currentIndex).icon
            }

            Text {
                id: selectedCountryName
                Layout.leftMargin: 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: root.model.get(root.currentIndex).name
                color: '#FFFFFF'
                font.family: VPNNaruzhuStyle.font
                font.weight: Font.Bold
                font.letterSpacing: 14 * (-0.05)
                font.pixelSize: 14

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
        }
    }

    popup: Popup {
        y: root.height
        width: root.width
        implicitHeight: 360

        background: Rectangle {
            radius: 4
            color: '#151515'
            border.color: '#3C3C3C'
            border.width: 1
        }

        contentItem: ListView {
            implicitHeight: contentHeight
            model: root.delegateModel
            spacing: 8
            clip: true

            currentIndex: root.highlightedIndex

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
                active: ScrollBar.AlwaysOn
            }
        }
    }

    delegate: ItemDelegate {
        id: delegateItem
        width: 168

        background: Rectangle {
            implicitHeight: 32
            color: {
                if (root.currentIndex === index) {
                    return '#FFD600'
                } else if (delegateItem.hovered) {
                    return '#FFD600'
                } else {
                    return 'transparent'
                }
            }
            opacity: (delegateItem.hovered) ? '0.5' : 1
            radius: 4
        }

        topPadding: 8
        bottomPadding: 8

        contentItem: Row {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: model.icon
                width: 20
                height: 20
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: model.name
                color: {
                    if (root.currentIndex === index) {
                        return '#121212'
                    } else {
                        return '#BDBDBD'
                    }
                }
                font.family: VPNNaruzhuStyle.font
                font.weight: Font.Medium
                font.pixelSize: 16

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
