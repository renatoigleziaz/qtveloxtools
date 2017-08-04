import QtQuick 2.6
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_Label
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  01/03/2017
*
*/

Label {

    font.family: UI.textFontNormal()
    font.pixelSize: UI.tscale(20)
    antialiasing: true
    smooth: true
}

