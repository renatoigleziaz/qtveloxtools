import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import LibIOS 0.1
import LibAlert 0.1
import HTTP 1.0
import "../q-js/ui.js" as UI
import "../q-library/"

/*
*
*  ControlImage - Recursos:
*
*               - Exibe uma imagem no App;
*               - Faz o download do servidor;
*               - Grava uma copia virtual no dispositivo;
*               - Carrega a Cópia em cache para economizar banda;
*               - Inclui uma nova imagem com suporte Cross-Plataforma para seleção de arquivo;
*               - Faz o upload da imagem para o servidor;
*               - Tira Foto;
*
*  QML Control
*
*  por Renato Igleziaz
*  19/9/2016
*
*/

Image {

    property string imageSource: ""
    property string imageFolder: configcall.getsession_login_company()
    property string imageUrl: configcall.getlocalhostDataFolder() + imageFolder + "/"
    property real defaultWidth: 1280
    property real defaultHeight: 720
    property real cWidth: parent.width
    property real cHeight: imageHeightAspectRate(defaultWidth, defaultHeight, cWidth) + 2
    property string path: configcall.getpathcacheimage()
    property int fase: 0
    property bool editImage: false
    property variant id_parent
    property Q_Label id_alert
    property ControlLoading id_load
    property ProgressBar id_bar
    property string imageSourceWeb: ""
    property bool imageCache: true
    property bool imagePressed: false
    property bool isAlert: false
    property bool noHeight: false
    property bool rounded: false
    property bool adapt: false


    signal clicked
    signal clickedPressed

    id: perfilImageCentral
    fillMode: Image.PreserveAspectFit
    Layout.alignment: Qt.AlignTop
    antialiasing: true
    smooth: true
    source: ""
    mipmap: true
    clip: true
    //mirror: true
    layer.enabled: rounded
    layer.effect: OpacityMask {
        maskSource: Item {
            width: perfilImageCentral.width
            height: perfilImageCentral.height
            Rectangle {
                anchors.centerIn: parent
                width: adapt ? perfilImageCentral.width : Math.min(perfilImageCentral.width, perfilImageCentral.height)
                height: adapt ? perfilImageCentral.height : width
                radius: Math.min(width, height)
            }
        }
    }
    onStatusChanged: {

        if (perfilImageCentral.status === Image.Ready) {

            id_load.visible = false
            id_parent.height = cHeight

            // evita salvar em cache com valor "0",
            // para salvar uma imagem que foi carregada do disco
            if (fase > 0) {

                // salva em cache
                borderImageBackground.visible = false

                perfilImageCentral.grabToImage(function(result) {

                                                    result.saveToFile(path + imageSourceWeb)
                                                    //borderImageBackground.visible = editImage
                                               });
            }
            else {

                //borderImageBackground.visible = editImage

            }
        }
        else if (perfilImageCentral.status === Image.Error) {

            // limita a quantidade de tentativas de obter o arquivo do servidor
            if (fase > 10) {
                id_load.visible = false
                return
            }

            // tenta baixar da Web
            fase++
            getimagename()
        }
    }
    Component.onCompleted: {

        UI.context()     
        //id_bar.visible = false

        if (imageSource.length === 0) {

            return
        }

        onComponentLoad()
    }

    Rectangle {
        // botão de EDITAR
        id: borderImageBackground
        width: UI.hscale(100)
        height: UI.vscale(50)
        radius: 1
        anchors.right: perfilImageCentral.right
        anchors.bottom: perfilImageCentral.bottom
        border.color: "gray"
        border.width: 1
        color: Qt.rgba(100,100,100,0.5)
        visible: false

        Q_Label {
            text: "Editar"
            font.pixelSize: UI.textSizeVerySmall()
            anchors.horizontalCenter: borderImageBackground.horizontalCenter
            anchors.verticalCenter: borderImageBackground.verticalCenter
        }
    }

    Timer {
        // timer de resposta | usado no ANDROID
        property int fase: 0

        id: timerAndroidResponse
        repeat: true
        running: false
        interval: 100
        onTriggered: {

            var response = utilcall.getFileAndroidResponse()

            if (fase === 0) {

                if (response.length > 0) {

                    if (response === "0") {

                        timerAndroidResponse.running = false
                        onCameraAppControl()
                    }
                    else {

                        utilcall.getFileAndroid()
                        fase = 1
                        timerAndroidResponse.running = true
                    }
                }
            }
            else {

                if (response.length > 1) {

                    if (response === "error") {

                        console.log("Cancelado");
                    }
                    else {

                        uploadImage(response)
                    }

                    timerAndroidResponse.running = false
                    fase = 0
                }
            }
        }
    }

    Timer {
        // timer de resposta do processo de atualização de imagem
        id: timerCallbackUploadImage
        repeat: true
        running: false
        interval: 100
        onTriggered: {

            var responseUpload = uploader.getUploadState()

            if (responseUpload === -1) {

                console.log("Processo terminou com erro")
                timerCallbackUploadImage.running = false

                id_bar.visible = false
                id_load.visible = false
                //id_parent.color = "#f7f8f9"
                id_alert.text = "Imagem não suportada"
                id_alert.visible = true

                borderImageBackground.visible = editImage
            }
            else if (responseUpload === 2) {

                console.log("Processo concluído com sucesso")
                timerCallbackUploadImage.running = false

                id_bar.visible = false
                id_parent.color = "transparent"
                id_load.visible = true
                fase = 1
                getimagename()
            }
            else {
                // upload em progresso

                id_bar.visible = true
                id_bar.to      = uploader.getUploadMaxValue();
                id_bar.value   = uploader.getUploadValue();
            }
        }
    }

    MouseArea {
        // importa uma nova imagem para o sistema
        id: mouse
        anchors.fill: parent
        onClicked: {

            if (editImage) {
                // edição automática de imagem
                onImportImage()
            }
            else {
                // repassa o evento click
                perfilImageCentral.clicked()
            }
        }
        onPressed: {

            if (!imagePressed) return

            if (!editImage) {
                // repassa o evento click
                perfilImageCentral.clickedPressed()
            }
        }
    }

    AlertView {
        id: alert
        title : "Obter Imagem"
        message: "Selecione como deseja obter a imagem:"
        buttons : [qsTr("Tirar Foto"),qsTr("Galeria"),qsTr("Cancelar")]
        onClicked : {
            console.log("Clicked button : ",clickedButtonIndex);

            var plataform = configcall.getSystemBase()

            if (plataform === "IOS") {

                if (clickedButtonIndex == 0) {

                    picker.sourceType = ImagePicker.Camera
                    picker.show(false)
                }
                else if (clickedButtonIndex == 1) {

                    picker.sourceType = ImagePicker.PhotoLibrary
                    picker.show(false)
                }
            }
            else {
                // desktop

                if (clickedButtonIndex == 0) {

                    onCameraAppControl()
                }
                else if (clickedButtonIndex == 1) {

                    var files = utilcall.getFileDesktop()
                    uploadImage(files)
                }
            }
        }
    }

    ImagePicker {
        // Controle usado somente no iOS
        id: picker

        onReady: {
            if (status === ImagePicker.Ready) {

                picker.busy = true
                picker.saveAsTemp()
            }
        }

        onSaved: {
            console.log("salva em " + url);

            picker.close()
            picker.busy = false

            uploadImage(url.replace("file://", ""), 0)
        }
    }

    HttpRequest {
        id: httpCheck
        onGetFinish: checkimagenameCallback(data)
        onGetError: {
            console.log("O servidor retornou o seguinte erro: " + data[1])
            return
        }
    }

    HttpRequest {
        id: httpRequest
        onGetFinish: ongetimagenameCallback(data)
        onGetError: {
            console.log("O servidor retornou o seguinte erro: " + data[1])
            return
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
             "id":imageSource,
             "folder":imageFolder}
        ]

        httpRequest.get(JSON.stringify(data))
    }

    function ongetimagenameCallback(data) {
        // callback -> obtem o nome correto da ID

        var name = data[1]
        if (name !== "semimagem") {
            perfilImageCentral.source = imageUrl + name
        }
        else {
            id_load.visible = false
            //id_parent.color = "#f7f8f9"
            id_alert.visible = true
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
             "id":imageSource,
             "folder":imageFolder}
        ]

        httpCheck.get(JSON.stringify(data))
    }

    function checkimagenameCallback(data) {
        // callback -> obtem o nome correto da ID

        imageSourceWeb = data[1]
        if (imageSourceWeb === "semimagem") {

            id_load.visible = false
            //id_parent.color = "#f7f8f9"
            id_alert.visible = true

        }
        else {

            if (configcall.getdata("cache") === "0") {
                // neste caso o usuário está forçando sempre baixar as imagens
                imageCache = false
            }

            if (imageCache) {
                // tenta reproduzir a imagem a partir do disco, caso já tenha baixado.
                // se não conseguir encontrar uma fonte local, vai buscar no
                // servidor o arquivo para download.
                id_load.visible = true
                fase = 0
                perfilImageCentral.source = "file:///" + path + imageSourceWeb
            }
            else {
                // sem cache, sempre baixa da nuvem
                fase++
                perfilImageCentral.source = imageUrl + imageSourceWeb
            }
        }
    }

    function onCameraAppControl() {
        // controla a camera dentro do App

        stackView.push({item: Qt.resolvedUrl("../camera/declarative-camera.qml"),
                        properties: {container: perfilImageCentral}
                       })
    }

    function onCameraAppNotify(path, rotation) {

        console.log(path)
        console.log(rotation)

        uploadImage(path, rotation)
    }

    function onComponentLoad() {

        //id_parent.color = "white"
        id_load.visible = true

        // ajusta a proporção do dispositivo
        perfilImageCentral.sourceSize.width = cWidth
        if (!noHeight) {

            perfilImageCentral.sourceSize.height = cHeight
        }

        checkimagename()
    }

    function onImportImage() {

        console.log("image: Evento Sinalizado")

        // descobre qual o sistema
        var plataform = configcall.getSystemBase()

        if (plataform === "ANDROID") {

            // chama a API de disco do ANDROID
            alert.show()

            // callback de retorno do arquivo
            timerAndroidResponse.running = true
        }
        else if (plataform === "IOS") {

            // chama a API de disco do IOS
            alert.show()
        }
        else if (plataform === "WINPHONE") {

        }
        else {
            // qualquer outra plataforma exibe o carregador normal de arquivos para o upload
            alert.show()
        }
    }

    function uploadImage(pathimage, rotation) {
        // faz o upload para o servidor

        if (pathimage.length === 0) {
            return
        }

        id_load.visible = true
        //id_parent.color = "white"
        id_alert.visible = false

        console.log(pathimage)

        // c++ call
        uploader.uploadImage(pathimage, imageSource, rotation, imageFolder)

        // callback de retorno
        timerCallbackUploadImage.running = true
    }

    function imageResize() {
        // recebe o sinal de alinhamento
        //perfilImageCentral.sourceSize.width = UI.screenWidth
    }

    function imageHeightAspectRate(sizeWidthOriginal, sizeHeightOriginal, newsizeWidth) {
        // calcula a proporção correta de altura de uma imagem

        return parseInt( (sizeHeightOriginal / sizeWidthOriginal) * newsizeWidth )
    }
}
