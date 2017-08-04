import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_TextField -> Calendar Standard
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  05-07/07/2017
*
*/

Item {

    id: container
    width: space.implicitWidth
    height: space.implicitHeight + 10
    Component.onCompleted: UI.context()
    // mapeamento de propriedades do Q_TextField
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
    // mapeamento de propriedades do Q_TextFieldDate
    readonly property int keyBack: 16777219
    readonly property int keyBackspace: 32
    readonly property int keyDelete: 16777223
    // estagio do cursor
    property int cursorState: 0

    function selectAll() {
        textField.selectAll()
    }

    function forceFocus() {
        textField.forceActiveFocus()
    }

    function showCalendar() {
        if (!popup.visible) {

            textField.text = UI.validDate(textField.text)
            if (textField.text.length === 0) {
                textField.text = UI.getnow()
            }

            var day    = 0
            var month  = 0
            var year   = 0
            var input  = textField.text
            var result = ""

            for (var x = 0; x < input.length; x++) {
                if (UI.isNumeric(input.charAt(x))) {
                    result = result + input.charAt(x)
                }
            }

            if (result.length === 0) return

            day   = result.substring(0, 2)
            month = result.substring(2, 4)
            year  = result.substring(4, 8)

            calendar.selectedDate = new Date(year, month - 1, day)
            popup.open()
        }
        else {
            popup.close()
            textField.forceActiveFocus()
        }
    }

    signal editingFinished
    signal returnPressed

    Rectangle {
        anchors.fill: parent
        color: textField.activeFocus ? Material.accent : "#373737"
        opacity: textField.activeFocus ? main.getOpacityObjectSelect() :  main.getOpacityObject()
        radius: 4
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (popup.visible) popup.close()
                container.forceFocus()
            }
        }
    }

    Column {
        id: space
        spacing: 0
        anchors.fill: container
        anchors.margins: 10

        Label {
            elide: Label.ElideRight
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: container.placeholderText
            opacity: textField.length > 0 ? 1.0 : 0.0
            font.family: UI.textFontUbuntu()
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

        Row {
            width: parent.width

            TextField {
                id: textField
                cursorVisible: true
                inputMask: "00/00/0000"
                selectByMouse: true
                width: UI.calcPercentArea(70, parent.width)
                //anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: container.placeholderText
                font.family: UI.textFontNormal()
                font.pixelSize: UI.tscale(22)
                onEditingFinished: container.editingFinished()
                //Component.onCompleted: text = UI.getnow()
                onActiveFocusChanged: {
                    if (activeFocus) {
                        // acerta a primeira posicao
                        cursorPosition = 0
                        select(0,2)
                    }
                }
                onCursorPositionChanged: {
                    // faz mapeamento da posicao do cursor dentro
                    // da caixa de texto para saber se esta dentro
                    // do dia/mes/ano.
                    switch (cursorPosition) {
                        case 0:
                            cursorState = 1
                            break
                        case 1:
                            cursorState = 1
                            break
                        case 2:
                            cursorState = 1
                            break
                        case 3:
                            cursorState = 2
                            break
                        case 4:
                            cursorState = 2
                            break
                        case 5:
                            cursorState = 2
                            break
                        case 6:
                            cursorState = 3
                            break
                        case 7:
                            cursorState = 3
                            break
                        case 8:
                            cursorState = 3
                            break
                        case 9:
                            cursorState = 3
                            break
                        case 10:
                            cursorState = 3
                            break
                    }
                    if (cursorPosition === 10) {
                        // verifica se a data esta correta
                        text = UI.validDate(text)
                        if (text.length !== 10) {
                            text = UI.getnow()
                            cursorPosition = 0
                        }
                    }
                }
                Keys.onPressed: {
                    // IA de Teclado do Q_TextFieldDate
                    if (event.key === Qt.Key_Left) {
                        // refaz movimento para esquerda
                        if (cursorState === 1) {
                            cursorPosition = 0
                            select(0,2)
                        }
                        else if (cursorState === 2) {
                            cursorPosition = 0
                            select(0,2)
                        }
                        else if (cursorState === 3) {
                            cursorPosition = 3
                            select(3,5)
                        }
                        event.accepted = true
                    }
                    else if (event.key === Qt.Key_Right) {
                        // refaz movimento para direita
                        if (cursorState === 1) {
                            cursorPosition = 3
                            select(3,5)
                        }
                        else if (cursorState === 2) {
                            cursorPosition = 6
                            select(6,10)
                        }
                        event.accepted = true
                    }
                    else if (event.key === keyBack) {
                        // cancela o back
                        event.accepted = true
                    }
                    else if (event.key === keyBackspace) {
                        // cancela o backspace
                        event.accepted = true
                    }
                    else if (event.key === keyDelete) {
                        // cancela o delete
                        event.accepted = true
                    }
                    // IA de Teclado do Q_TextField
                    else if (event.key === Qt.Key_Up) {
                        // move o cursor pra cima e rola a janela caso precise
                        event.accepted = true
                        nextItemInFocusChain(false).forceActiveFocus()
                        if (myFlickControl !== undefined) {
                            myFlickControl.flick(0,200)
                        }
                    }
                    else if (event.key === Qt.Key_Down) {
                        container.showCalendar()
                        event.accepted = true
                    }
                    else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                        // enter direcionamento de evento e rola a janela caso precise
                        if (!keyboardInteration) return
                        event.accepted = true
                        returnPressedState ? container.returnPressed() : nextItemInFocusChain().forceActiveFocus()
                        if (myFlickControl !== undefined) {
                            myFlickControl.flick(0,-200)
                        }
                    }
                    else if (event.key === Qt.Key_PageUp || event.key === Qt.Key_Home) {
                        // inicio de pagina
                        if (!keyboardInteration) return
                        event.accepted = true
                        if (myFlickControl !== undefined) {
                            myFlickControl.contentY = 0
                        }
                    }
                    else if (event.key === Qt.Key_PageDown || event.key === Qt.Key_End) {
                        // fim de pagina
                        if (!keyboardInteration) return
                        event.accepted = true
                        if (myFlickControl !== undefined) {
                            myFlickControl.contentY = myFlickControl.contentHeight
                        }
                    }
                }
                MouseArea {
                    // bloqueia o mouse selecionar partes do texto
                    anchors.fill: parent
                    onClicked: {
                        if (popup.visible) popup.close()
                        parent.cursorPosition = 0
                        parent.select(0,2)
                        parent.forceActiveFocus()
                    }
                }
            }

            ToolButton {
                width: UI.calcPercentArea(30, parent.width)
                contentItem: Image {
                    id: img1
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "../imagens/nav-down.png"
                    sourceSize.height: 20
                    sourceSize.width: 20
                    rotation: calendar.visible ? 180 : 0
                    Behavior on rotation { NumberAnimation{ easing.type: Easing.OutCubic } }
                }
                onClicked: {
                    container.showCalendar()
                }
            }
        }

        Menu {
            id: popup
            x: textField.x
            y: textField.y + textField.height + 10
            width: myCol.width
            height: myCol.height + UI.vscale(30)
            modal: false
            focus: false
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            /*
            enter: Transition {
                NumberAnimation {duration: 30; property: "y"; from: 1500; to: textField.y + textField.height + 10 }
            }
            exit: Transition {
                NumberAnimation {duration: 30; property: "y"; from: textField.y + textField.height + 10; to: 1500 }
            }
            */
            /*
            onActiveFocusChanged: {
                if (!activeFocus && !calendar.activeFocus) {
                    close()
                }
            }
            */
            onOpened: {
                calendar.forceActiveFocus()
            }
            Column {
                id: myCol
                width: UI.hscale(300)
                spacing: 20
                ControlCalendar {
                    id: calendar
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: UI.hscale(290)
                    width: UI.hscale(290)
                    onSelectedDateChanged: {
                        textField.text = UI.dateEx_format(selectedDate)
                    }
                    onDoubleClicked: {
                        popup.close()
                        textField.forceActiveFocus()
                    }
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                            popup.close()
                            textField.forceActiveFocus()
                            event.accepted = true
                        }
                    }
                }
                Button {
                    text: "ir para Hoje"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        calendar.selectedDate = new Date()
                        calendar.forceActiveFocus()
                    }
                    visible: false
                }
            }
        }
    }
}
