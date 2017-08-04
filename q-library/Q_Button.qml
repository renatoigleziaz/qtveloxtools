import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_Button
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  24/2/2017
*
*/

Button {

    readonly property int q_areaWidth: getScreenWidth()
    readonly property int q_implicitWidth: UI.hscale(100)
    readonly property int q_itemWidth: Math.max(q_implicitWidth,
                                              Math.min(q_implicitWidth * 2, q_areaWidth / 3))

    Material.background: highlighted ? Material.accent : "#4F4F4F"
    Material.foreground: highlighted ? "#373737" : Material.foreground

    function getScreenWidth() {
        UI.context()
        return UI.screenWidth
    }

    id: button
    font.family: UI.textFontNormal()
    font.pixelSize: UI.textSizeSmall()
    width: q_itemWidth
    ToolTip.delay: 700
    ToolTip.timeout: 5000
    ToolTip.visible: pressed
    ToolTip.text: "Use esse comando para '" + text + "'"
    Component.onCompleted: UI.context()
}
