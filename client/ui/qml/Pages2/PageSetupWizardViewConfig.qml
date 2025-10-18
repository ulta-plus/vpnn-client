import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Controls2/TextTypes"
import "../Config"

PageType {
    id: root

    property bool showContent: false

    BackButtonType {
        id: backButton

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 20

        onActiveFocusChanged: {
            if(backButton.enabled && backButton.activeFocus) {
                listView.positionViewAtBeginning()
            }
        }
    }

    Connections {
        target: ImportController

        function onImportErrorOccurred(error, goToPageHome) {
            if (goToPageHome) {
                PageController.goToStartPage()
            } else {
                PageController.closePage()
            }
        }

        function onImportFinished() {
            if (!ConnectionController.isConnected) {
                ServersModel.setDefaultServerIndex(ServersModel.getServersCount() - 1);
                ServersModel.processedIndex = ServersModel.defaultIndex
            }

            PageController.goToPageHome()
        }
    }

    ListViewType {
        id: listView

        anchors.top: backButton.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        header: ColumnLayout {
            width: listView.width

            BaseHeaderType {
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                headerText: qsTr("New connection")
            }

            RowLayout {
                Layout.topMargin: 32
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                spacing: 8

                visible: fileName.text !== ""

                Image {
                    source: "qrc:/images/controls/file-check-2.svg"
                }

                Header2TextType {
                    id: fileName

                    Layout.fillWidth: true

                    text: ImportController.getConfigFileName()
                    wrapMode: Text.Wrap
                }
            }

            BasicButtonType {
                id: showContentButton
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                implicitHeight: 32

                defaultColor: AmneziaStyle.color.transparent
                hoveredColor: AmneziaStyle.color.translucentWhite
                pressedColor: AmneziaStyle.color.sheerWhite
                disabledColor: AmneziaStyle.color.mutedGray
                textColor: AmneziaStyle.color.goldenApricot

                text: showContent ? qsTr("Collapse content") : qsTr("Show content")

                clickedFunc: function() {
                    showContent = !showContent
                }
            }

            CheckBoxType {
                id: cloakingCheckBox
                objectName: "cloakingCheckBox"

                visible: ImportController.isNativeWireGuardConfig()

                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                text: qsTr("Enable WireGuard obfuscation. It may be useful if WireGuard is blocked on your provider.")
            }
        }

        model: 1 // fake model to force the ListView to be created without a model

        delegate: ColumnLayout { // TODO(CyAn84): add DelegateChooser after have migrated to 6.9
            width: listView.width

            WarningType {
                Layout.fillWidth: true
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16

                textString: ImportController.getMaliciousWarningText()
                textFormat: Qt.RichText
                visible: textString !== ""

                iconPath: "qrc:/images/controls/alert-circle.svg"

                textColor: AmneziaStyle.color.vibrantRed
                imageColor: AmneziaStyle.color.vibrantRed
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 16
                Layout.bottomMargin: 48
                Layout.rightMargin: 16
                Layout.leftMargin: 16

                implicitHeight: configContent.implicitHeight

                radius: 10
                color: AmneziaStyle.color.onyxBlack

                visible: showContent

                ParagraphTextType {
                    id: configContent

                    anchors.fill: parent
                    anchors.margins: 16

                    wrapMode: Text.Wrap

                    text: ImportController.getConfig()
                }
            }
        }

        footer: ColumnLayout {
            width: listView.width

            BasicButtonType {
                id: connectButton

                Layout.fillWidth: true
                Layout.topMargin: 16
                Layout.bottomMargin: 32
                Layout.rightMargin: 16
                Layout.leftMargin: 16

                text: qsTr("Connect")

                defaultColor: "transparent"
                hoveredColor: "#FFDD51"
                pressedColor: "#FFDD51"
                disabledColor: "#878B91"
                textColor: "#000000" // Set default text color to black

                // Button styling
                background: Rectangle {
                    color: parent.hovered ? "#FFDD51" : "transparent"
                    border.color: parent.hovered ? "#191919" : "#FFDD51" // Set border color to corner color when hovered
                    radius: 10
                }

                // Button text color
                contentItem: Text {
                    text: parent.text
                    color: parent.hovered ? "#000000" : "#FFDD51" // Change text color when hovered
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 16
                }

                clickedFunc: function() {
                    const headerItem = listView.headerItem;
                    if (!headerItem) {
                        console.error("Header item not found in ListView")
                        return
                    }

                    const cloakingCheckBoxItem = listView.findChildWithObjectName(headerItem.children, "cloakingCheckBox");
                    if (!cloakingCheckBoxItem) {
                        console.error("cloakingCheckBox not found")
                        return
                    }

                    if (cloakingCheckBoxItem.checked) {
                        ImportController.processNativeWireGuardConfig()
                    }
                    ImportController.importConfig()
                }
            }
        }
    }
}
