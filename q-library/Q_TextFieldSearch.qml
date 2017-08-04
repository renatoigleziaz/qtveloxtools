import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import HTTP 1.0
import "../q-js/ui.js" as UI

/*
*
*  Q_TextFieldSearch
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  06/07/2017
*
*/

Item {

    id: container
    width: space.implicitWidth
    height: space.implicitHeight + 10
    Component.onCompleted: UI.context()
    // propridades adicionais para o mecanismo de pesquisa
    property real maxHeightSearchBox: UI.vscale(250)
    property bool stopSearch: false
    // determina qual opcao foi escolhida
    property string select_id: "-1"
    property string select_result: ""
    // determina qual o metodo de busca
    property string get_module: ""
    property string get_class: ""
    property string get_func: ""
    property string column_result_id: ""
    property string column_result_name: ""
    // propriedades que sao refeitas para o uso com caixas de texto
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
    signal searchSelected

    Rectangle {
        anchors.fill: parent
        color: textField.activeFocus ? Material.accent : "#373737"
        opacity: textField.activeFocus ? main.getOpacityObjectSelect() :  main.getOpacityObject()
        radius: 4
        MouseArea {
            anchors.fill: parent
            onClicked: container.forceFocus()
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

        TextField {
            id: textField
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            placeholderText: container.placeholderText
            font.family: UI.textFontNormal()
            font.pixelSize: UI.tscale(22)
            onEditingFinished: container.editingFinished()
            inputMethodHints: Qt.ImhSensitiveData
            onFocusChanged: {
                if (!activeFocus && popup.visible) {
                    if (!popup.activeFocus && !listViewMenu.activeFocus) {
                        popup.close()
                    }
                }
            }
            Keys.onPressed: {
                // IA de Teclado
                if (event.key === Qt.Key_Up) {
                    event.accepted = true

                    if (textField.text.length > 0 && !popup.visible) {
                        lstModel.clear()
                        timerSearchCheck.lastSearch = ""
                        popup.open()
                        listViewMenu.forceActiveFocus()
                    }
                    else if (lstModel.count > 0 && popup.visible) {
                        listViewMenu.forceActiveFocus()
                    }
                    else {
                        nextItemInFocusChain(false).forceActiveFocus()
                        if (myFlickControl !== undefined) {
                            myFlickControl.flick(0,200)
                        }
                    }
                }
                else if (event.key === Qt.Key_Down) {
                    // verifica se tem dados para serem exibidos e
                    // abre um lista com eles para selecao ou
                    // move o cursor pra outro controle e rola a janela caso precise
                    event.accepted = true

                    if (textField.text.length > 0 && !popup.visible) {
                        lstModel.clear()
                        timerSearchCheck.lastSearch = ""
                        popup.open()
                        listViewMenu.forceActiveFocus()
                    }
                    else if (lstModel.count > 0 && popup.visible) {
                        listViewMenu.forceActiveFocus()
                    }
                    else {
                        returnPressedState ? container.returnPressed() : nextItemInFocusChain().forceActiveFocus()
                        if (myFlickControl !== undefined) {
                            myFlickControl.flick(0,-200)
                        }
                    }
                }
                else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    event.accepted = true
                    if (!keyboardInteration) return
                    if (popup.visible) {
                        popup.close()
                        return
                    }
                    // enter direcionamento de evento e rola a janela caso precise
                    returnPressedState ? container.returnPressed() : nextItemInFocusChain().forceActiveFocus()
                    if (myFlickControl !== undefined) {
                        myFlickControl.flick(0,-200)
                    }
                }
                else if (event.key === Qt.Key_PageUp || event.key === Qt.Key_Home) {
                    if (!keyboardInteration) return
                    if (popup.visible) return
                    // inicio de pagina
                    event.accepted = true
                    if (myFlickControl !== undefined) {
                        myFlickControl.contentY = 0
                    }
                }
                else if (event.key === Qt.Key_PageDown || event.key === Qt.Key_End) {
                    if (!keyboardInteration) return
                    if (popup.visible) return
                    // fim de pagina
                    event.accepted = true
                    if (myFlickControl !== undefined) {
                        myFlickControl.contentY = myFlickControl.contentHeight
                    }
                }
            }
        }

        Popup {
            property bool invert: false
            id: popup
            x: textField.x
            height: maxHeightSearchBox
            width: textField.width
            modal: false
            focus: true
            margins: 5
            padding: 5
            closePolicy: Popup.CloseOnPressOutsideParent
            onActiveFocusChanged: {
                if (!activeFocus) {
                    close()
                }
            }
            Q_BusyIndicator {
                id: loaderPopup
                anchors.centerIn: parent
                visible: timerSearchCheck.timebusy
            }
            ListView {
                property int nCurrentIndex: 0
                id: listViewMenu
                currentIndex: 0
                anchors.fill: parent
                visible: !loaderPopup.visible
                snapMode: ListView.SnapPosition
                highlightRangeMode: ListView.NoHighlightRange
                clip: true
                focus: true
                onCurrentIndexChanged: {
                    // atualiza a posição do item visivel
                    nCurrentIndex = currentIndex
                }
                Keys.onPressed: {
                    // sistema de teclado
                    if (event.key === Qt.Key_Up && currentIndex === 0) {
                        textField.forceActiveFocus()
                        event.accepted = true
                    }
                    else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        onProcessEvent(nCurrentIndex)
                        popup.close()
                        textField.forceActiveFocus()
                        event.accepted = true
                    }
                    else if (event.key === Qt.Key_Escape) {
                        popup.close()
                        textField.forceActiveFocus()
                        event.accepted = true
                    }
                }

                delegate: ItemDelegate {
                    id: itemdelegate
                    width: parent.width
                    background: Rectangle {
                        opacity: main.getOpacityObjectSelect()
                        anchors.fill: parent
                        color: Material.accent
                        visible: itemdelegate.highlighted
                    }
                    contentItem: Item {
                        id: myItemDelegate
                        implicitHeight: itemdelegate.height
                        implicitWidth: parent.width
                        Q_Label {
                            wrapMode: TextArea.NoWrap
                            text: itemdelegate.text
                            font.family: UI.textFontNormal()
                            font.pixelSize: UI.tscale(18)
                            color: Material.foreground
                            elide: Text.ElideRight
                            visible: itemdelegate.text
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                        }
                    }
                    text: model.title
                    font.family: UI.textFontNormal()
                    font.pixelSize: UI.textSizeSmall()
                    highlighted: ListView.isCurrentItem
                    enabled: true
                    onClicked: {
                        listViewMenu.currentIndex = index
                        listViewMenu.onProcessEvent(index)
                        popup.close()
                        textField.forceActiveFocus()
                    }
                }

                model: ListModel {
                    id: lstModel
                }

                ScrollBar.vertical: Q_ScrollBar { }

                function onProcessEvent(index) {
                    timerSearchCheck.timebusy = true

                    var obj = lstModel.get(index)
                    container.select_id = obj.id
                    container.select_result = obj.title

                    textField.text = container.select_result
                    timerSearchCheck.lastSearch = container.select_result
                    timerSearchCheck.timebusy = false
                    container.searchSelected()
                }
            }
        }

        Timer {
            property string lastSearch: ""
            property bool timebusy: false

            id: timerSearchCheck
            repeat: true
            running: (textField.text.length > 0 && !timebusy && !stopSearch) ? true : false
            interval: 1500
            onRunningChanged: {
                if (timebusy) {
                    return
                }
                // recebe o que estiver no buffer do teclado
                var buffer = textField.text
                if (buffer.length === 0) {
                    // reset de lista
                    lstModel.clear()
                    popup.close()
                    lastSearch = ""
                }
            }
            onTriggered: {
                if (timebusy) {
                    return
                }
                // recebe o que estiver no buffer do teclado
                var buffer = textField.text

                if (buffer.length > 0 && buffer !== lastSearch) {
                    // nova pesquisa com parametros diferentes
                    lastSearch = buffer

                    var vglobalCoordinares = textField.mapToItem(null, 0, 0)
                    var vposcontrol = vglobalCoordinares.y
                    var vheight = main.height
                    var vresult = (vheight - vposcontrol)
                    var vfinal = 0
                    if (vresult < (container.maxHeightSearchBox + textField.height)) {
                        popup.invert = true
                        vfinal = container.maxHeightSearchBox
                    }
                    else {
                        popup.invert = false
                        if (container.maxHeightSearchBox > vresult) {
                            vfinal = vresult - UI.vscale(20)
                        }
                        else {
                            vfinal = maxHeightSearchBox
                        }
                    }
                    popup.height = vfinal

                    if (!popup.invert) {
                        popup.y = textField.y + textField.height - 3
                    }
                    else {
                        popup.y = textField.y - (container.maxHeightSearchBox + UI.vscale(50))
                    }

                    popup.focus = false
                    popup.open()
                    http.onSearch(buffer)
                }
            }
        }

        HttpRequest {
            id: http
            onGetFinish: {
                timerSearchCheck.timebusy = false
                lstModel.clear()
                for (var i in data) {
                    var obj = data[i]
                    lstModel.append({"title":obj[container.column_result_name],
                                     "id":obj[container.column_result_id]})
                }
                if (lstModel.count === 0) {
                    popup.close()
                }
            }
            onGetError: {
                timerSearchCheck.timebusy = false
                console.log(errorCode, errorMessage)
            }
            function onSearch(searchString) {
                timerSearchCheck.timebusy = true

                var data = [
                    {"login":configcall.getusername(),
                     "password":configcall.getpassword(),
                     "module":container.get_module,
                     "class":container.get_class,
                     "func":container.get_func,
                     search:searchString}
                ]

                get(JSON.stringify(data))
            }
        }

    }
}
