import QtQuick 2.4
import QtQuick.Layouts 1.3
import "../q-js/ui.js" as UI

/*
*
*  controlMessage - Controle de Notificações
*
*  QML Control
*
*  por Renato Igleziaz
*  14/9/2016
*
*/

Flickable {
    property bool showMessage: false
    property string message: ""
    property real mHeight: 0
    property bool critical: false
    property bool dockBottom: true

    visible: showMessage
    anchors.horizontalCenter: parent.horizontalCenter
    height: showMessage ? mHeight : 0
    width: parent.width - UI.hscale(60)
    Component.onCompleted: {
        UI.context()

        if (!dockBottom) {

            anchors.top = parent.top
            anchors.topMargin = UI.vscale(40)
        }
        else {

            anchors.bottom = parent.bottom
            anchors.bottomMargin = UI.vscale(40)
        }

    }
    onWidthChanged: {

        calculateW()
    }

    function calculateW() {

        mHeight = parseInt(colray.height + 20)
    }

    Timer {
        id: messageTimer
        repeat: false
        running: showMessage
        interval: 100
        onTriggered: {

            calculateW()
            messageEndTimer.running = true
            controlMessageBG.opacity = 0.96
        }
    }

    Timer {
        id: messageEndTimer
        repeat: false
        running: false
        interval: 3000
        onTriggered: {

            controlMessageBG.opacity = 0
            mHeight = 0
            showMessage = false
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {

            messageEndTimer.running = false
            mHeight = 0
            showMessage = false
        }
    }

    Rectangle {
        id: controlMessageBG
        color: !critical ? "#6E48AA" : "#b22121"
        width: controlMessageBG.width
        height: mHeight
        anchors.fill: parent
        radius: 3
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }

        Behavior on height {
            NumberAnimation {
                easing.type: Easing.OutBack
            }
        }

        ColumnLayout {
            id: colray
            spacing: UI.layoutRowSpacing()

            Text {
                id: lblone
                text: "Aviso"
                color: UI.textColorBar()
                font.pixelSize: UI.textSizeSmall()
                font.family: UI.textFontUbuntu()
                anchors.left: parent.left
                anchors.leftMargin: UI.hscale(40)
                anchors.top: parent.top
                anchors.topMargin: UI.vscale(20)
            }

            Text {
                id: lbltwo
                text: message
                color: UI.textColorBar()
                font.pixelSize: UI.tscale(22,true)
                font.family: UI.textFontNormal()
                anchors.left: parent.left
                anchors.leftMargin: UI.hscale(40)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: UI.vscale(5)
            }
        }
    }
}
