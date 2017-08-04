import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import "../q-js/ui.js" as UI
import "../q-library/"

ListModel {
    id: myModel

    function addItem(iId, iTitulo, iChecked, iParcelas, iValor, iTipRec) {
        myModel.append({"lid"       : iId,
                        "ltitulo"   : iTitulo,
                        "lchecked"  : iChecked,
                        "lparcelas" : iParcelas,
                        "lvalor"    : iValor,
                        "ltiprec"   : iTipRec
                       });
    }

}
