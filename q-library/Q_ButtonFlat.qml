import QtQuick 2.6
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_ButtonFlat
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  1/3/2017
*
*/

Button {

    property string sourceImage: "../imagens/plus.png"

    readonly property string charEdit: "\u270e"
    readonly property string charOk: "\u2713"
    property int q_areaWidth: getScreenWidth()
    property int q_implicitWidth: 30
    property int q_itemWidth: Math.max(q_implicitWidth, Math.min(q_implicitWidth * 2, q_areaWidth / 3))

    function getScreenWidth() {
        UI.context()
        return UI.screenHeight > UI.screenWidth ? UI.screenWidth : UI.screenHeight
    }

    id: button
    Component.onCompleted: UI.context()
    highlighted: true
    font.pixelSize: UI.textSizeNormal()
    font.family: UI.textFontUbuntu()

    Material.foreground: "black"

    background: Rectangle {

        implicitWidth: q_itemWidth
        implicitHeight: implicitWidth
        color: "transparent"

        Rectangle {
            anchors.centerIn: parent
            width: q_itemWidth / 1.2
            height: width
            opacity: 1
            radius: q_itemWidth / 1.2
            color: Material.accent
            layer.enabled: button.enabled
            layer.effect: DropShadow {
                verticalOffset: 1
                color: Material.dropShadowColor
                samples: button.pressed ? 20 : 10
                spread: 0.5
            }
        }

        Q_Label {
            anchors.centerIn: parent
            text: "+"
            color: Material.foreground
            visible: button.text.length > 0 ? false : true
        }
    }
}

