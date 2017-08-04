import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  ControlLine - Faz uma linha de divisão de controles
*
*  QML Control
*
*  por Renato Igleziaz
*  9/9/2016
*
*/

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 0
    height: UI.listviewHeightLine()
    color: Material.accent
    opacity: 0.2
}
