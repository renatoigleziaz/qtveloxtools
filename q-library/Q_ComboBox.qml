import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_ComboBox
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  01/03/2017
*
*/

ComboBox {
    id: comboBox

    property bool returnPressedState: false
    property bool keyboardInteration: true
    property bool stateOpen: false
    readonly property int q_areaWidth: getScreenWidth()
    readonly property int q_implicitWidth: UI.hscale(300)
    readonly property int q_itemWidth: Math.max(q_implicitWidth, Math.min(q_implicitWidth * 2, q_areaWidth / 3))

    signal returnPressed

    function getScreenWidth() {
        UI.context()
        return UI.screenWidth
    }

    font.family: UI.textFontNormal()
    font.pixelSize: UI.textSizeSmall()
    height: UI.vscale(90) // 5.9
    width: q_itemWidth
    Component.onCompleted: getScreenWidth()
    onFocusChanged: {
        if (!stateOpen) {
            tmr_focus.running = true
            return
        }
        stateOpen = false
    }

    background: Rectangle {
        implicitWidth: comboBox.implicitWidth
        implicitHeight: comboBox.implicitHeight
        color: comboBox.activeFocus ? Material.accent : "#373737"
        opacity: comboBox.activeFocus ? main.getOpacityObjectSelect() :  main.getOpacityObject()
        radius: 4
        anchors.fill: parent
    }

    Timer {
        id: tmr_focus
        repeat: false
        running: false
        interval: 200
        onTriggered: {
            comboBox.popup.visible = true
            stateOpen = true
        }
    }

    popup: Popup {
        y: comboBox.height - 1
        width: comboBox.width
        implicitHeight: listview.contentHeight
        padding: 1

        contentItem: ListView {
            id: listview
            clip: true
            model: comboBox.popup.visible ? comboBox.delegateModel : null
            currentIndex: comboBox.highlightedIndex
            snapMode: ListView.SnapPosition
            highlightRangeMode: ListView.NoHighlightRange
            highlightMoveDuration: 0
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    Keys.onPressed: {
        // IA de Teclado
        if (!keyboardInteration) return
        if (event.key === Qt.Key_Up && comboBox.currentIndex === 0 && popup.visible === false ) {
            // move o cursor pra cima
            event.accepted = true
            returnPressedState ? returnPressed() : nextItemInFocusChain(false).forceActiveFocus()
        }
        if (event.key === Qt.Key_Down && comboBox.currentIndex === (comboBox.count - 1) && popup.visible === false ) {
            // move o cursor pra baixo
            event.accepted = true
            returnPressedState ? returnPressed() : nextItemInFocusChain().forceActiveFocus()
        }
        else if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return) && popup.visible === false ) {
            // enter direcionamento de evento
            returnPressedState ? returnPressed() : nextItemInFocusChain().forceActiveFocus()
            event.accepted = true
        }
    }

    function forceFocus() {
        comboBox.forceActiveFocus()
    }
}
