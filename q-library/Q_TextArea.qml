import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_TextArea
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  01/03/2017
*
*/

Item {

    id: container
    width: space.implicitWidth
    height: space.implicitHeight
    Component.onCompleted: UI.context()

    property alias text: textArea.text
    property string placeholderText: ""
    property alias inputMethodHints: textArea.inputMethodHints
    property alias readOnly: textArea.readOnly
    property alias maximumLength: textArea.length
    property alias length: textArea.length

    Column {
        id: space
        spacing: 0
        anchors.fill: container

        Label {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: TextArea.Wrap
            text: container.placeholderText
            visible: textArea.length > 0 ? true : false
            font.family: UI.textFontNormal()
            font.pixelSize: UI.tscale(22)
            color: Material.accent
            antialiasing: true
        }

        TextArea {
            id: textArea
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: TextArea.Wrap
            placeholderText: container.placeholderText
            font.family: UI.textFontNormal()
        }
    }
}

