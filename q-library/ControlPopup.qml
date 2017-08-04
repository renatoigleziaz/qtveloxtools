import QtQuick 2.0
import QtQuick.Controls 2.0
import "../q-js/ui.js" as UI

Popup {
    id: settingsPopup
    property real altura: 0
    x: (main.width - width) / 2
    y: main.height / 6
    width: Math.min(main.width, main.height) / 3 * 2
    height: contentHeight + topPadding + bottomPadding
    modal: true
    focus: true
    Component.onCompleted: UI.context()
}
