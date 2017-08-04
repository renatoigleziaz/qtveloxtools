import QtQuick 2.0
import QtQuick.Controls 1.4

import "../q-js/ui.js" as UI

StackView {

    signal page(variant currentItem)

    id: control
    focus: true
    Keys.onReleased: controlKeyboard(event)
    onCurrentItemChanged: {
        try {
            currentItem.forceActiveFocus()
            control.page(currentItem)
        }
        catch (e) {}
    }

    function controlKeyboard(event) {
        // controla o botão de voltar do dispositivo movel

        if (event.key === Qt.Key_Back && stackView.depth > 1) {

            control.pop()
            event.accepted = true
        }
    }
}
