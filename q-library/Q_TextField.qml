import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_TextField
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  01/03/2017
*
*/

Item {

    id: container
    width: space.implicitWidth
    height: space.implicitHeight + 10
    Component.onCompleted: UI.context()

    property string placeholderText: ""
    property alias echoMode: textField.echoMode
    property alias inputMethodHints: textField.inputMethodHints
    property alias readOnly: textField.readOnly
    property alias maximumLength: textField.maximumLength
    property alias text: textField.text
    property alias length: textField.length
    property bool returnPressedState: false
    property alias sfocus: textField.focus
    property variant myFlickControl: undefined
    property bool keyboardInteration: true

    function selectAll() {
        textField.selectAll()
    }

    function forceFocus() {
        textField.forceActiveFocus()
    }

    signal editingFinished
    signal returnPressed

    Rectangle {
        anchors.fill: parent
        color: textField.activeFocus ? Material.accent : "#373737"
        opacity: textField.activeFocus ? main.getOpacityObjectSelect() :  main.getOpacityObject()
        radius: 4
        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: container.forceFocus()
            ToolTip.delay: 250
            ToolTip.visible: (textField.text.length > 0 && mouse.pressed) ? true : false
            ToolTip.text: textField.text
        }
    }

    Column {
        id: space
        spacing: 0
        anchors.fill: container
        anchors.margins: 10
        ToolTip.delay: 250
        ToolTip.visible: (textField.text.length > 0 && mouse.pressed) ? true : false
        ToolTip.text: textField.text

        Label {
            elide: Label.ElideRight
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: container.placeholderText
            opacity: textField.length > 0 ? 1.0 : 0.0
            font.family: UI.textFontUbuntu()
            ToolTip.delay: 250
            ToolTip.visible: (textField.text.length > 0 && mouse.pressed) ? true : false
            ToolTip.text: textField.text
            //font.bold: true
            //font.weight: Font.Black
            //font.capitalization: Font.AllUppercase
            font.pixelSize: UI.tscale(18)
            color: Material.accent
            antialiasing: true
            Behavior on opacity {
                NumberAnimation{
                    duration: 300
                }
            }
        }

        TextField {
            id: textField
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            placeholderText: container.placeholderText
            font.family: UI.textFontNormal()
            font.pixelSize: UI.tscale(22)
            ToolTip.delay: 250
            ToolTip.visible: (textField.text.length > 0 && mouse.pressed) ? true : false
            ToolTip.text: textField.text
            onEditingFinished: container.editingFinished()
            Keys.onPressed: {
                if (!keyboardInteration) return

                // IA de Teclado
                if (event.key === Qt.Key_Up) {
                    // move o cursor pra cima e rola a janela caso precise
                    event.accepted = true
                    nextItemInFocusChain(false).forceActiveFocus()
                    if (myFlickControl !== undefined) {
                        myFlickControl.flick(0,200)
                    }
                }
                else if (event.key === Qt.Key_Down) {
                    // move o cursor pra baixo e rola a janela caso precise
                    event.accepted = true
                    returnPressedState ? container.returnPressed() : nextItemInFocusChain().forceActiveFocus()
                    if (myFlickControl !== undefined) {
                        myFlickControl.flick(0,-200)
                    }
                }
                else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    // enter direcionamento de evento e rola a janela caso precise
                    event.accepted = true
                    returnPressedState ? container.returnPressed() : nextItemInFocusChain().forceActiveFocus()
                    if (myFlickControl !== undefined) {
                        myFlickControl.flick(0,-200)
                    }
                }
                else if (event.key === Qt.Key_PageUp || event.key === Qt.Key_Home) {
                    // inicio de pagina
                    event.accepted = true
                    if (myFlickControl !== undefined) {
                        myFlickControl.contentY = 0
                    }
                }
                else if (event.key === Qt.Key_PageDown || event.key === Qt.Key_End) {
                    // fim de pagina
                    event.accepted = true
                    if (myFlickControl !== undefined) {
                        myFlickControl.contentY = myFlickControl.contentHeight
                    }
                }
            }
        }
    }
}
