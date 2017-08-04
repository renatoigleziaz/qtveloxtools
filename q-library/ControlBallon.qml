import QtQuick 2.5
import "../q-js/ui.js" as UI

/*
*
*  ControlBallon - faz um balão de notificação sobre uma opção
*                  alertando o total de novas mensagens
*
*  QML Control
*
*  por Renato Igleziaz
*  4/10/2016
*
*/

Rectangle {

    property int mNotifyCount: 0

    id: ballon
    width: UI.hscale(23, 33)
    height: width
    radius: height / 2
    color: "#b22121"
    anchors.top: parent.top
    anchors.right: parent.right
    visible: mNotifyCount === 0 ? false : true
    //border.color: "white"
    //border.width: 1
    antialiasing: true
    Component.onCompleted: {

        UI.context()
    }

    Text {
        text: mNotifyCount.toString()
        font.bold: true
        antialiasing: true
        font.pixelSize: UI.tscale(12, true)
        font.family: UI.textFontNormal()
        color: "white"
        anchors.centerIn: parent
        smooth: true
    }
}
