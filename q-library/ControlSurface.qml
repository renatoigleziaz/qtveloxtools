import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "../q-js/ui.js" as UI

/*
*
*  ControlSurface - Gera um controle responsivo deslizante que serve
*                   de base de todos os controles da janela
*
*  QML Control
*
*  por Renato Igleziaz
*  9/9/2016
*
*/

Flickable {
    id: flickable
    width: parent.width
    height: parent.height
    anchors.fill: parent
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    Component.onCompleted: {
        UI.context()
    }
    ScrollBar.vertical: Q_ScrollBar {}

    MouseArea {
        anchors.fill: parent
        onClicked: {

            Qt.inputMethod.commit()
            Qt.inputMethod.hide()

        }
        ToolTip.delay: 1000
        ToolTip.visible: pressed
        ToolTip.text: "Arraste a janela para deslizar"
    }
}
