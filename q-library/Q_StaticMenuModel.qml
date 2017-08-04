import QtQuick 2.0
import "../q-js/ui.js" as UI

Item {
    id: func
    property real q_height: calcHeight()
    property real q_width: calcWidth()
    property int q_typemodel: UI.menuGetModelView()
    property bool update: main.updateMenuList

    signal updated

    Timer {
        interval: 50
        repeat: false
        running: update
        onTriggered: {
            q_typemodel = UI.menuGetModelView()
            func.updated()
        }
    }

    function getmodelcolumn() {
        var ret = 0
        switch (q_typemodel) {
            case 0:
                ret = 1
                break
            case 1:
                ret = 2
                break
            case 2:
                ret = 2
                break
            case 3:
                ret = 3
                break
        }
        return ret
    }

    function calcWidth() {
        UI.context()
        var ret = 0
        switch (q_typemodel) {
            case 0:
                ret = UI.hscale(160)
                break
            case 1:
                ret = UI.hscale(600)
                break
            case 2:
                ret = main.width / 2
                break
            case 3:
                ret = main.width / 3
                break
        }
        return ret
    }

    function calcHeight() {
        var ret = 0
        switch (q_typemodel) {
            case 0:
                ret = UI.hscale(180)
                break;
            case 1:
                ret = UI.hscale(70)
                break;
            case 2:
                ret = UI.hscale(90)
                break;
            case 3:
                ret = UI.hscale(80)
                break;
        }
        return ret
    }
}
