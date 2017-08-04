import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import "../q-js/ui.js" as UI

/*
*
*  ControlSlider - faz um controle deslizante de opção
*
*  QML Control
*
*  por Renato Igleziaz
*  22/2/2017
*
*/

Slider {

    width: parent.width
    Layout.alignment: Qt.AlignCenter
    property int ballHeight: UI.hscale(30)

    style: SliderStyle {
        handle: Rectangle {
            height: ballHeight
            width: height
            radius: width/2
            color: "transparent"

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: control.pressed ? ballHeight / 1.7 : ballHeight
                width: height
                radius: width/2
                color: Material.accent
                Behavior on height {
                    NumberAnimation{
                        easing.type: Easing.OutBounce
                        duration: 400
                    }
                }
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: ballHeight * 1.7
                width: height
                radius: width/2
                opacity: control.pressed ? 0.2 : 0.0
                color: Material.accent
                visible: control.pressed ? true : false
                Behavior on opacity {
                    NumberAnimation{
                        duration: 400
                    }
                }
            }
        }

        groove: Rectangle {
            implicitHeight: UI.hscale(10)
            implicitWidth: UI.sliderSizeWidth()
            radius: height/2
            color: "#373737"
            opacity: 0.5
            Rectangle {
                height: parent.height
                width: styleData.handlePosition
                implicitHeight: 6
                implicitWidth: 50
                radius: height/2
                color: Material.accent
                opacity: 0.5
            }
        }
    }

    Component.onCompleted: {
        UI.context()
    }
}
