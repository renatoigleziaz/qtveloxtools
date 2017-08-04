import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  ControlSegmentos - Listview que armazena todos os Segmentos
*
*  QML Control
*
*  por Renato Igleziaz
*  27/1/2017
*
*/

Item {
    id: produtosControl
    width: parent.width
    height: txtTitulo.height + UI.vscale(10)
    Component.onCompleted: {
        UI.context()
    }

    property alias prodTitulo: txtTitulo.text
    property string prodId: ""
    signal clicked
    signal clickedLoadPrevious
    signal clickedLoadNext

    Rectangle {
        id: rootBackcolor
        anchors.fill: parent
        visible: mouse.pressed
        color: "#373737"
        opacity: 0.1
    }

    MouseArea {
        property bool sLoad: false
        property real sX: 0
        property real eX: 0

        id: mouse
        anchors.fill: parent
        onClicked: produtosControl.clicked()
        onContainsPressChanged: {

            if (!sLoad) {
                // inicio de processo
                sX = mouseY
                sLoad = true
                return
            }
            else {
                // fim de processo
                eX = mouseY
                sLoad = false

                if (eX > sX) {

                    console.log("Puxou pra baixo")
                    produtosControl.clickedLoadPrevious()
                }
                else if (sX > eX) {

                    console.log("Puxou pra cima")
                    produtosControl.clickedLoadNext()
                }
            }
        }
    }

    Label {
        id: txtTitulo
        font.pixelSize: UI.textSizeNormal()
        font.family: UI.textFontNormal()
        anchors.left: parent.left
        anchors.leftMargin: UI.hscale(40)
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        clip: true
        elide: Text.ElideRight
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 0
        height: UI.listviewHeightLine()
        color: Material.accent
        opacity: 0.2
    }
}
