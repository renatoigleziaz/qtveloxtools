import QtQuick 2.6
import QtQuick.Controls 2.0

import "../q-js/ui.js" as UI

/*
*
*  Q_RadioButton
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  01/03/2017
*
*/

RadioButton {
    font.family: UI.textFontNormal()
    font.pixelSize: UI.textSizeVerySmall()
    Component.onCompleted: UI.context()
}
