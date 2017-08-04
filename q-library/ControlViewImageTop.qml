import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import LibIOS 0.1
import LibAlert 0.1
import HTTP 1.0
import "../q-js/ui.js" as UI
import "../q-library/"

/*
*
*  ControlViewImage - Recursos:
*
*               - Exibe uma imagem no App;
*               - Faz o download do servidor;
*               - Grava uma copia virtual no dispositivo;
*               - Carrega a Cópia em cache para economizar banda;
*
*  QML Control
*
*  por Renato Igleziaz
*  8/2/2016
*
*/

Rectangle {

    id: control
    width: parent.width
    height: perfilImageCentral.paintedHeight === 0 ? UI.vscale(300) : perfilImageCentral.height
    color: "transparent"

    property int fillmode: Image.PreserveAspectFit
    property string imageSource: ""
    property string imageFolder: configcall.getsession_login_company()
    property string imageUrl: configcall.getlocalhostDataFolder() + imageFolder + "/"
    property string path: configcall.getpathcacheimage()
    property int fase: 0
    property string imageSourceWeb: ""
    property bool imageCache: true
    property bool imagePressed: false
    property bool isAlert: false
    property bool noHeight: false
    property alias imageContainer: perfilImageCentral

    signal clicked
    signal clickedPressed

    Component.onCompleted: {
        UI.context()
    }

    ControlLoading {
        id: perfilBorderBGLoad
        anchors.top: parent.top
        visible: false
    }

    Image {

        id: perfilImageCentral
        fillMode: control.fillmode
        antialiasing: true
        smooth: true
        source: ""
        mipmap: true
        clip: true
        width: parent.width
        onStatusChanged: {

            if (perfilImageCentral.status === Image.Ready) {

                perfilBorderBGLoad.visible = false

                // evita salvar em cache com valor "0",
                // para salvar uma imagem que foi carregada do disco
                if (control.fase > 0) {

                    perfilImageCentral.grabToImage(function(result) {

                                                        result.saveToFile(control.path + control.imageSourceWeb)

                                                   });
                }
            }
            else if (perfilImageCentral.status === Image.Error) {

                // limita a quantidade de tentativas de obter o arquivo do servidor
                if (control.fase > 10) {
                    return
                }

                // tenta baixar da Web
                control.fase++
                getimagename()
            }
        }
        Component.onCompleted: {

            UI.context()

            if (control.imageSource.length === 0) {

                return
            }

            perfilBorderBGLoad.visible = true
            checkimagename()
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: {

                // repassa o evento click
                control.clicked()
            }
            onPressed: {

                if (!control.imagePressed) return

                control.clickedPressed()
            }
        }

        HttpRequest {
            id: httpRequest
            onGetFinish: perfilImageCentral.ongetimagenameCallback(data)
            onGetError: {
                console.log("O servidor retornou o seguinte erro: " + data[1])
                return
            }
        }

        HttpRequest {
            id: httpCheck
            onGetFinish: perfilImageCentral.checkimagenameCallback(data)
            onGetError: {
                console.log("O servidor retornou o seguinte erro: " + data[1])
                return
            }
        }

        function checkimagename() {
            // obtem o nome correto da ID

            var data = [
                {"login":configcall.getusername(),
                 "password":configcall.getpassword(),
                 "module":"imagem.php",
                 "class":"Imagem",
                 "func":"uploadgetname",
                 "id":control.imageSource,
                 "folder":control.imageFolder}
            ]

            httpCheck.get(JSON.stringify(data))
        }

        function checkimagenameCallback(data) {
            // callback -> obtem o nome correto da ID

            control.imageSourceWeb = data[1]

            if (control.imageSourceWeb != "semimagem") {

                if (configcall.getdata("cache") === "0") {
                    // neste caso o usuário está forçando sempre baixar as imagens
                    control.imageCache = false
                }

                if (control.imageCache) {
                    // tenta reproduzir a imagem a partir do disco, caso já tenha baixado.
                    // se não conseguir encontrar uma fonte local, vai buscar no
                    // servidor o arquivo para download.
                    control.fase = 0
                    perfilImageCentral.source = "file:///" + control.path + control.imageSourceWeb
                }
                else {
                    // sem cache, sempre baixa da nuvem
                    control.fase++
                    perfilImageCentral.source = control.imageUrl + control.imageSourceWeb
                }
            }
        }

        function getimagename() {
            // obtem o nome correto da ID

            var data = [
                {"login":configcall.getusername(),
                 "password":configcall.getpassword(),
                 "module":"imagem.php",
                 "class":"Imagem",
                 "func":"uploadgetname",
                 "id":control.imageSource,
                 "folder":control.imageFolder}
            ]

            httpRequest.get(JSON.stringify(data))
        }

        function ongetimagenameCallback(data) {
            // callback -> obtem o nome correto da ID

            var name = data[1]
            if (name !== "semimagem") {
                perfilImageCentral.source = control.imageUrl + name
            }
        }
    }
}
