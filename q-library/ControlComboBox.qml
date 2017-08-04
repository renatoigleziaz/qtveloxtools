import QtQuick 2.6
import QtQuick.Controls 2.0

import "../q-js/ui.js" as UI

ComboBox {
    id: control
    Component.onCompleted: UI.context()
    font.pixelSize: UI.textSizeSmall()

    delegate: ItemDelegate {
        width: control.width
        contentItem: Text {
            text: key
            color: "#373737"
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: control.highlightedIndex == index
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            onPressedChanged: canvas.requestPaint()
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.pressed ? UI.textColorTitle() : "#373737";
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 0
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: UI.textFontNormal()
        color: control.pressed ? UI.textColorTitle() : "#373737"
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        border.color: control.pressed ? UI.textColorTitle() : "#373737"
        border.width: control.visualFocus ? 2 : 1
        radius: 2
        color: "transparent"
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: listview.contentHeight
        padding: 1

        contentItem: ListView {
            id: listview
            clip: true
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: "#373737"
            radius: 2
        }
    }
}
