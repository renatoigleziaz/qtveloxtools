import QtQuick 2.2
import QtQuick.Layouts 1.3
import "../q-js/ui.js" as UI

/*
*
*  ControlSpacer - Faz uma pequena quebra no layout, dando mais espaço entre os controles
*
*  QML Control
*
*  por Renato Igleziaz
*  9/9/2016
*
*/

Rectangle {

    property bool finalPage: false

    width: parent.width
    height: UI.vscale(50)
    Layout.alignment: Qt.AlignCenter
    Layout.preferredHeight: Qt.inputMethod.visible ? calculateKeyBoard() : UI.vscale(25)
    color: "Transparent"
    Component.onCompleted: {
        UI.context()
    }

    function calculateKeyBoard() {

        return finalPage ? UI.vscale(500) : UI.vscale(100)
    }
}
