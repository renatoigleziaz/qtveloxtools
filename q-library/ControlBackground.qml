import QtQuick 2.0
import "../q-js/ui.js" as UI

Rectangle {
    anchors.fill: parent
    gradient: Gradient {
        GradientStop { position: 0.0; color: UI.backgroundGradient()[0] }
        GradientStop { position: 1.0; color: UI.backgroundGradient()[1] }
    }
    Component.onCompleted: UI.context()
}
