import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../q-js/ui.js" as UI

/*
*
*  ControlLoading - Controle de Carregamento
*
*  QML Control
*
*  por Renato Igleziaz
*  9/9/2016
*
*/

Rectangle {
    property string gifFile: "../imagens/load.gif"
    property bool pause: false
    property int setFrame: 0
    property int frameCount: animation.frameCount
    property AnimatedImage gifParent: animation

    visible: false
    width: animation.width
    height: animation.height
    anchors.centerIn: parent
    color: "transparent"

    AnimatedImage {
        id: animation
        paused: pause
        source: gifFile
        currentFrame: setFrame
    }

    function setResize(vm_width, vm_height) {

        animation.height = vm_height
        animation.width = vm_width
    }

    Rectangle {
        property int frames: animation.frameCount
        x: (animation.width - width) * animation.currentFrame / frames
        y: animation.height
    }
}
