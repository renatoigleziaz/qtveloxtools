import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

ScrollBar {
    id: control
    active: true

    /*
      V5.7 USAR ISSO EM VERSOES 5.7 DO QT !!!
    contentItem: Rectangle {
        implicitWidth: 10
        implicitHeight: 100
        color: control.pressed ? Material.accent : Material.foreground
        opacity: control.pressed ? 0.5 : 0.2
    }
    */
}
