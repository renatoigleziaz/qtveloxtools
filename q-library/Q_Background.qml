import QtQuick 2.0

Image {
    source: "../imagens/background.jpg"
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
    opacity: main.getOpacityBackground()
    visible: main.getImageBackground()
    /*
    Rectangle {
        anchors.fill: parent
        smooth: true
        color: "#373737"
        opacity: main.getOpacityBackground()
    }
    */
}
