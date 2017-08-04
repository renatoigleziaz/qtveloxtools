import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

/*
*
*  Q_ImageSideBar
*
*  QML Material Control 2.0
*
*  por Renato Igleziaz
*  20/07/2017
*
*/

Item {
    property alias fillMode: imgSource.fillMode
    property alias source: imgSource.source
    property alias sourceSize: imgSource.sourceSize

    id: root
    width: imgSource.implicitWidth
    height: imgSource.implicitHeight

    Image {
        id: imgSource
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        smooth: true
        antialiasing: true
    }

    ColorOverlay {
        anchors.fill: imgSource
        source: imgSource
        color: Material.foreground
    }
}
