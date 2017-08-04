import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../q-js/ui.js" as UI

/*
*
*  controlMessageBox - Caixa de Mensagem com botão de resposta
*
*  QML Control
*
*  por Renato Igleziaz
*  22/02/2017
*
*/

Popup {
    property bool isOpening: false
    property string message: ""
    property string help: ""
    property string buttonTextOne: "SIM"
    property string buttonTextTwo: "NÃO"
    property bool dualButtonStyle: true
    property int op: -1
    property bool cpfBox: false
    property alias cpfBoxObject: txtCnpj.text

    signal clickedButtonOne
    signal clickedButtonTwo

   /*
    // ultima versao
    width: UI.isScreenPortrait()
           ? Math.min(main.width, main.height) / 3 * 2
           : Math.min(main.width, main.height) / 3 * 2.5
   */

    id: login    
    x: (main.width - width) / 2
    y: (main.height - main.header.height - height) / 2
    width: UI.isScreenPortrait()
           ? main.width
           : main.width / 2
    height: collay.implicitHeight + topPadding + bottomPadding
    modal: true
    focus: true
    closePolicy: Popup.NoAutoClose
    Keys.onPressed: {
        // IA de teclado
        if (event.key === Qt.Key_Escape) {
            event.accepted = true
        }
    }
    onActiveFocusChanged: {
        if (cpfBox) {
            txtCnpj.forceFocus()
        }
        else {
            if (dualButtonStyle) {
                btnSair.forceActiveFocus()
            }
            else {
                btnOK.forceActiveFocus()
            }
        }
    }

    Column {

        id: collay
        opacity: login.opacity
        spacing: UI.layoutColumnSpacing()
        anchors.centerIn: parent

        Q_Label {
            width: login.availableWidth
            text: login.message
            font.family: UI.textFontLato()
            font.pixelSize: UI.tscale(32,true)
        }

        Label {
            width: login.availableWidth
            text: login.help
            wrapMode: Label.Wrap
            font.family: UI.textFontNormal()
            font.pixelSize: UI.tscale(24,true)
        }

        Q_TextField {
            id: txtCnpj
            maximumLength: 30
            placeholderText: "Informar CPF no Cupom Fiscal?"
            focus: cpfBox
            width: login.availableWidth
            inputMethodHints: Qt.ImhDigitsOnly
            returnPressedState: true
            onReturnPressed: {
                if (cpfBox) {
                    if (txtCnpj.text.length > 0) {
                        // ocorreu uma tentativa de informar um documento no SAT
                        UI.validateCNPJorCPF(txtCnpj.text, txtCnpj)
                        if (txtCnpj.text.length === 0) {
                            txtCnpj.forceFocus()
                            return
                        }
                    }
                }
                login.op = 0
                tmr_closer.running = true
                login.isOpening = false
            }
            visible: cpfBox
        }

        Q_Button {
            id: btnOK
            text: buttonTextOne
            width: login.availableWidth
            Layout.alignment: Qt.AlignCenter
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if (cpfBox) {
                    if (txtCnpj.text.length > 0) {
                        // ocorreu uma tentativa de informar um documento no SAT
                        UI.validateCNPJorCPF(txtCnpj.text, txtCnpj)
                        if (txtCnpj.text.length === 0) {
                            txtCnpj.forceFocus()
                            return
                        }
                    }
                }
                login.op = 0
                tmr_closer.running = true
                login.isOpening = false
            }
            visible: dualButtonStyle ? false : true
        }

        Row {
            id: btnarea
            spacing: UI.layoutRowSpacing()
            Layout.alignment: Qt.AlignCenter
            visible: dualButtonStyle
            anchors.horizontalCenter: parent.horizontalCenter

            Q_Button {
                id: btnEntrar
                text: buttonTextOne
                implicitWidth: (main.width - width) / 2
                Layout.preferredWidth: (main.width - implicitWidth) / 2
                onClicked: {
                    if (cpfBox) {
                        if (txtCnpj.text.length > 0) {
                            // ocorreu uma tentativa de informar um documento no SAT
                            UI.validateCNPJorCPF(txtCnpj.text, txtCnpj)
                            if (txtCnpj.text.length === 0) {
                                txtCnpj.forceFocus()
                                return
                            }
                        }
                    }
                    login.op = 0
                    tmr_closer.running = true
                    login.isOpening = false
                }
            }
            Q_Button {
                id: btnSair
                text: buttonTextTwo
                highlighted: true
                implicitWidth: (main.width - width) / 2
                Layout.preferredWidth: (main.width - implicitWidth) / 2
                onClicked: {
                    login.op = 1
                    tmr_closer.running = true
                    login.isOpening = false
                }
            }
        }
    }
    Timer {
        id: tmr_closer
        repeat: false
        running: false
        interval: 10
        onTriggered: {

            if (login.op === 0) {

                login.clickedButtonOne()
            }
            else if (login.op === 1) {

                login.clickedButtonTwo()
            }

            login.close()            
            stackView.forceActiveFocus()
        }
    }

    function show() {
        login.open()
        login.isOpening = true
    }
}
