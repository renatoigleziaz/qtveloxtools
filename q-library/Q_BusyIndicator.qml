import QtQuick 2.6
import QtQuick.Controls 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_BusyIndicator
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  24/2/2017
*
*/

BusyIndicator {

    function getScreenHeight() {
        UI.context()
        return UI.screenHeight
    }

    function getScreenWidth() {
        UI.context()
        return UI.screenWidth
    }

    readonly property int size: Math.min(getScreenWidth(), getScreenHeight()) / 10

    width: size
    height: size
    anchors.horizontalCenter: parent.horizontalCenter
    Component.onCompleted: UI.context()
}
