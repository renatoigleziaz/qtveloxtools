import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Delega suporte a janela Main e controla o ListView
*
*  QML Delegate Module
*
*  por Renato Igleziaz
*  9/9/2016
*
*/

Item {
    id: root
    width: parent.width
    height: txtTitle.height + txtHelp.height + UI.vscale(10)
    Component.onCompleted: {
        UI.context()
    }

    property alias configTitle: txtTitle.text
    property alias configHelp: txtHelp.text
    property alias configViewArrow: txtNextItem.visible
    property bool configLine: true
    signal clicked

    Rectangle {
        id: rootBackcolor
        anchors.fill: parent
        anchors.leftMargin: UI.hscale(20)
        anchors.rightMargin: UI.hscale(20)
        visible: mouse.pressed
        color: "#373737"
        opacity: 0.2
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: UI.hscale(20)
        anchors.right: parent.right
        anchors.rightMargin: UI.hscale(20)
        anchors.margins: 0
        height: UI.listviewHeightLine()
        color: Material.accent
        visible: configLine
        opacity: 0.2
    }

    Image {
        id: txtNextItem
        anchors.right: parent.right
        anchors.rightMargin: UI.hscale(20)
        anchors.verticalCenter: parent.verticalCenter
        source: "../imagens/navigation_next_item.png"
        sourceSize.height: UI.hscale(38)
        sourceSize.width: UI.hscale(38)
        smooth: true
        visible: true
        opacity: 0.5
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Q_Label {
        id: txtTitle
        font.pixelSize: UI.textSizeNormal()
        font.family: UI.textFontNormal()
        anchors.left: parent.left
        anchors.leftMargin: UI.hscale(20)
        anchors.top: parent.top
        anchors.topMargin: UI.vscale(10)
    }

    Label {
        id: txtHelp
        font.pixelSize: UI.textSizeSmall()
        font.family: UI.textFontLato()
        anchors.left: parent.left
        anchors.leftMargin: UI.hscale(20)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: UI.vscale(10)
    }

}
