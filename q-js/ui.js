var ui_version = "1.4"
/*
*
*  Front-End / Core functions / User Interface
*
*  Javascript / QT
*
*  por Renato Igleziaz
*  29/08/2016
*
*  Revisão: 3/11/2016
*           - SCALA2x melhora no sistema de calculo de escala,
*             que ajusta o tamanho correto dos objetos da tela
*             Resulta em menos alterações para versões desktop
*             - hscale(), vscale()
*           14/03/2017
*           - Novas funções de tratamento de hora e data
*/

/*
 * Referência de Resolução
 *
 * Móveis -> 600x1200
 * PC     -> 1280x720
*/
var refPort          = "SCALA2x"
var refScreenWidth   = 600
var refScreenHeight  = 1200

// resolução que será substituida pela do aparelho
var screenWidth      = 400
var screenHeight     = 700

// resolução travada para algumas telas
var screenLock       = false
var screenLockWidth  = 400
var screenLockHeight = 700

// servers URL´s
var serverDataUrl    = ""
var serverSpritesUrl = ""

function context() {
    // inicializa e obtem a resolução para calcular a escala correta
    // para um eventual resize ou mudança de perspectiva. Usar
    // a chamada context() para atualizar altura e comprimento
    // correto da janela toda vez que for necessário.
    screenHeight = main.height
    screenWidth = main.width

    //console.log("ui.Horizontal: " + screenHeight)
    //console.log("ui.Vertical: " + screenWidth)
}

function appname() {
    // nome do app
    return "Lidergaz App"
}

function appversion() {
    // versão do app
    return "Revisão 26 (Produção)"
}

function hscale(size, maxrange, screenLock) {
    // Calcula a escala horizontal de todos os objetos da tela

    // obtem a resolução atual
    context()

    // verifica se precisa manter o tamanho para esse objeto
    // usado para a versão desktop
    var swidth = screenWidth
    screenLock = (typeof screenLock === "undefined" ? main.screenLockState : screenLock)

    if (refPort === "DESKTOP") {
        if (screenLock) {

            swidth  = screenLockWidth
        }
    }

    // aqui verifica os valores de referência para o calculo
    // da escala, se for Retrato ou paisagem os valores
    // de referência tem que retornar corretamente.
    // valores de ref atuais
    // retrato 600 / 1200
    // paisagem 1280 / 720
    refScreenWidth = screenHeight > screenWidth ? 600 : 1600 //1366

    // calcula o tamanho do objeto por escala
    var max    = (typeof maxrange === "undefined" ? 0 : maxrange)
    var h      = (swidth / refScreenWidth)
    var result = parseInt(size * h)

    // verifica se tem um range de limite de tamanho
    if ((maxrange > 0) && (result > maxrange)) {
        result = maxrange
    }

    return result
}

function vscale(size, maxrange, screenLock) {
    // Calcula a escala horizontal de todos os objetos da tela

    // obtem a resolução atual
    context()

    // verifica se precisa manter o tamanho para esse objeto
    // usado para a versão desktop
    var sheight = screenHeight
    screenLock = (typeof screenLock === "undefined" ? main.screenLockState : screenLock)

    if (refPort === "DESKTOP") {
        if (screenLock) {

            sheight = screenLockHeight
        }
    }

    // aqui verifica os valores de referência para o calculo
    // da escala, se for Retrato ou paisagem os valores
    // de referência tem que retornar corretamente.
    // valores de ref atuais
    // retrato 600 / 1200
    // paisagem 1280 / 720
    refScreenHeight = screenLockHeight > screenLockWidth ? 1200 : 900//768

    // calcula o tamanho do objeto por escala
    var max    = (typeof maxrange === "undefined" ? 0 : maxrange)
    var v      = (sheight / refScreenHeight)
    var result = parseInt(size * v)

    // verifica se tem um range de limite de tamanho
    if ((maxrange > 0) && (result > maxrange)) {
        result = maxrange
    }

    return result
}

function tscale(size, screenLock) {
    // Calcula a escala vertical e horizontal dos textos do app, baseado em escala

    // verifica se tem algum limite adicional de tamanho
    screenLock = (typeof screenLock === "undefined" ? false : screenLock)

    // calculo
    var result = parseInt((hscale(size, 0, screenLock) + vscale(size, 0, screenLock)) / 2)

    // limite padrão para a versão desktop
    if (refPort === "DESKTOP" || screenLock === true) {

        if (result > 28) {

            result = 28
        }
    }

    return result
}

function textFontNormal() {
    // retorna a font padrão
    return fontNormal.name
}

function textFontLato() {
    // retorna a font Lato
    return fontAux.name
}

function textFontUbuntu() {
    // retorna a font UBuntu
    return fontUbuntu.name
}

function textSizeNormal()
{
    // tamanho do texto Normal
    return tscale(32)
}

function textSizeSmall()
{
    // tamanho do texto Médio
    return tscale(22)
}

function textSizeVerySmall()
{
    // Tamanho do texto pequeno
    return tscale(18)
}

function textColorBar() {
    // cor do texto da barra
    return "#fafafa"
}

function textColorPlaceholder() {
    // cor do texto do placeholderText
    return "#FCFCFC"
}

function textColorTitle() {
    // retorna a cor do texto de titulo
    return "#C31A27"
}

function backgroundColor() {
    // cor de fundo do aplicativo

    return "#C31A27"
}

function backgroundMainColor() {
    // cor de fundo principal do aplicativo

    return "#C31A27"
}

function backgroundTimeLineColor() {
    // cor de fundo da timeline

    return "#FCFCFC"
}

function textColorBarBackground() {
    // retorna a cor do texto de titulo
    return "#C31A27"
}

function textColorNormal() {
    // cor do texto padrão
    return "#373737"
}

function textColorAlert() {
    // cor de texto para alerta
    return "#b22121"
}

function buttonSmallSizeWidth() {
    // retorna o tamanho pequeno de um botão

    context()

    var x = 150

    return hscale(x)
}

function buttonSmallSizeHeight() {
    // retorna a altura pequeno de um botão

    context()

    var x = 78

    return vscale(x)
}

function buttonNormalSizeWidth() {
    // retorna o tamanho padrão de um botão
    context()

    var x = 370

    return hscale(x)
}

function buttonNormalSizeHeight() {
    // retorna a altura padrão de um botão
    context()

    var x = 78

    return vscale(x)
}

function buttonBorderSize() {
    // retorna a largura da borda
    return 8
}

function buttonRadius() {
    // retorna o radius
    return 2
}

function buttonGradientApressed() {
    // retona o gradient anti-pressed
    return ["#ccc", "#eee"]
}

function buttonGradientPressed() {
    // retona o gradient pressed
    return ["#aaa", "#ccc"]
}

function backgroundGradient() {
    return ['#ECF1F8','#efefef']
}

function buttonBorderColor() {
    // retorna a cor da borda
    return "#373737"
}

function layoutColumnSpacing() {
    // retorna a largura de espaço para os objetos
    return hscale(25)
}

function layoutRowSpacing() {
    // retorna a altura de espaço para os objetos
    return vscale(40)
}

function listviewRowHeight() {
    // retorna a altura da linha

    var ret = 0

    context()

    if (screenHeight > screenWidth) {
        ret = hscale(110)
    }
    else {
        ret = vscale(110)
    }

    return ret
}

function listviewColorLine() {
    // retorna a cor da linha de divisão de itens
    return "#aaa"
}

function listviewHeightLine() {
    // retorna a altura da linha de divisão
    return 1
}

function listviewColorSelected() {
    return Qt.rgba(1,69,79,0.1)
}

function isScreenPortrait() {
    // retorna se está em modo retrato
    context()
    return screenHeight > screenWidth
}

function sliderColorBall() {
    // retorna a cor da bolinha do slider
    return textColorTitle()
}

function sliderColorSelection() {
    // retorna a cor da barra selecionada
    return "#aaa"
}

function sliderColorNoArea() {
    //retorna a cor da barra ainda não selecionada
    return "#eee"
}

function sliderSizeWidth() {
    // retorna o tamanho da barra
    return hscale(300)
}

function switchColorSelection() {
    // retorna a cor de seleção do Switch
    return "#aaa"
}

function switchColorNoArea() {
    // retorna a cor de não seleção do Switch
    return "#eee"
}

function msgbox(title, message) {
    // caixa de mensagem

    //main.showEx(title, message)
}

function sessionRegistryUser(username, privilegiesid, remember, company, segment, customer) {
    // registra uma sessão de usuário na memoria do dispositivo

    // Nivel de Privilégios de Usuários

    // Considerar :
    // 0 -> Nível Aluno
    // 1 -> Nível Vendedor ou Pedagogico
    // 2 -> Nível Franquiado
    // 3 -> Nível TI
    configcall.setsession_login(username, privilegiesid, remember, company, segment, customer)

    // Serviço de Monitoramento de Mensagens
    var plataform = Qt.platform.os

    if (plataform === "android") {
        // No android o sistema de monitoramento é carregado
        // como serviço e processo isolado da atividade.
        // Mesmo que App estiver fechado a notificação é
        // processada em segundo plano.
        //utilcall.startServices()
    }
    else {

        // nas outros plataformas por enquanto o serviço
        // é instanciado junto ao segmento principal
        console.log("Iniciando 'Serviços sob Demanda' dentro da Atividade principal...")

        // ativa o sistema de notificações
        if (!thread.isWorking()) {

            // se não tiver em execução
            //configcall.setcontrol_timeSync(0)
            //thread.start()
        }
        else {

            // tira o sistema de notificação do sono
            //thread.notifySleep(false)
        }
    }

    // ativa a barra de tarefas
    main.sessionStateBar(true)
}

function validVarSessions() {
    // verifica as variaveis de configuração padrão
    var getdata = ""

    try {

        // fonte padrão
        getdata = configcall.getdata("fonts.geral")
        if (getdata.length === 0) {
            configcall.setdata("fonts.geral", "1")
        }

        // login automatico
        getdata = configcall.getdata("remember")
        if (getdata.length === 0) {
            configcall.setdata("remember", "0")
        }

        // notificações ativas
        getdata = configcall.getdata("notifyalert")
        if (getdata.length === 0) {
            configcall.setdata("notifyalert", "1")
        }

        // consumo baixo de dados
        getdata = configcall.getdata("cache")
        if (getdata.length === 0) {
            configcall.setdata("cache", "1")
        }

    } catch (e) {

        console.error(e)
    }
}

function sessionLogOff() {
    // encerra uma sessão

    thread.notifySleep(true)
    configcall.setsession_logoff()
    main.sessionStateBar(false)
    stackView.clear()
}

function sessionGetUser() {
    // verifica se tem algum usuário logado

    var data

    try {

        data = configcall.getsession_login() === 1 ? true : false
    }
    catch(err) {

        data = false
    }

    return data
}

function sessionGetUserPrivilegies() {
    // retorna qual é o privilégio de um usuário

    if (sessionGetUser()) {

        return configcall.getsession_login_privilegies()
    }
    else {
        // -1 indica que não ocorreu login no dispositivo
        return -1
    }
}

function sessionGetUserRemember() {
    // retorna se o usuário deve ser lembrado
    return configcall.getsession_login_remember() === 1 ? true : false
}

function isNumeric(expression) {
    // retorna se uma variavel é numerica

    if (expression.length === 0) {
        return false
    }

    return isNaN(expression) ? false : true
}

function formatNumber(input, decimals) {
    // formata e valida um valor
    try {

        if (input.length === 0) {

            return ""
        }

        input = input.replace(",",".")

        if (!isNumeric(input)) {
            return (0).toFixed(decimals).replace(".",",")
        }

        var v_input = parseFloat(input)
        return v_input.toFixed(decimals).replace(".",",")
    }
    catch (e) {

        console.error("formatnumber", e)
        return (0).toFixed(decimals).replace(".",",")
    }
}

function toPixels(percentage) {

    return percentage * Math.min(screenWidth, screenHeight)
}

function calc_digitos_posicoes( digitos, posicoes, soma_digitos) {

    // Garante que o valor é uma string
    digitos = digitos.toString();

    // Faz a soma dos dígitos com a posição
    // Ex. para 10 posições:
    //   0    2    5    4    6    2    8    8   4
    // x10   x9   x8   x7   x6   x5   x4   x3  x2
    //   0 + 18 + 40 + 28 + 36 + 10 + 32 + 24 + 8 = 196
    for ( var i = 0; i < digitos.length; i++  ) {
        // Preenche a soma com o dígito vezes a posição
        soma_digitos = soma_digitos + ( digitos[i] * posicoes );

        // Subtrai 1 da posição
        posicoes--;

        // Parte específica para CNPJ
        // Ex.: 5-4-3-2-9-8-7-6-5-4-3-2
        if ( posicoes < 2 ) {
            // Retorno a posição para 9
            posicoes = 9;
        }
    }

    // Captura o resto da divisão entre soma_digitos dividido por 11
    // Ex.: 196 % 11 = 9
    soma_digitos = soma_digitos % 11;

    // Verifica se soma_digitos é menor que 2
    if ( soma_digitos < 2 ) {
        // soma_digitos agora será zero
        soma_digitos = 0;
    } else {
        // Se for maior que 2, o resultado é 11 menos soma_digitos
        // Ex.: 11 - 9 = 2
        // Nosso dígito procurado é 2
        soma_digitos = 11 - soma_digitos;
    }

    // Concatena mais um dígito aos primeiro nove dígitos
    // Ex.: 025462884 + 2 = 0254628842
    var cpf = digitos + soma_digitos;

    // Retorna
    return cpf;

}

function valida_cpf( valor ) {

    // Garante que o valor é uma string
    valor = valor.toString();

    // Remove caracteres inválidos do valor
    valor = valor.replace(/[^0-9]/g, '');

    // Captura os 9 primeiros dígitos do CPF
    // Ex.: 02546288423 = 025462884
    var digitos = valor.substr(0, 9);

    // Faz o cálculo dos 9 primeiros dígitos do CPF para obter o primeiro dígito
    var novo_cpf = calc_digitos_posicoes( digitos, 10, 0 );

    // Faz o cálculo dos 10 dígitos do CPF para obter o último dígito
    novo_cpf = calc_digitos_posicoes( novo_cpf, 11, 0 );

    // Verifica se o novo CPF gerado é idêntico ao CPF enviado
    if ( novo_cpf === valor ) {
        // CPF válido
        return true;
    } else {
        // CPF inválido
        return false;
    }

}

function valida_cnpj ( valor ) {

    // Garante que o valor é uma string
    valor = valor.toString();

    // Remove caracteres inválidos do valor
    valor = valor.replace(/[^0-9]/g, '');

    // O valor original
    var cnpj_original = valor;

    // Captura os primeiros 12 números do CNPJ
    var primeiros_numeros_cnpj = valor.substr( 0, 12 );

    // Faz o primeiro cálculo
    var primeiro_calculo = calc_digitos_posicoes( primeiros_numeros_cnpj, 5, 0 );

    // O segundo cálculo é a mesma coisa do primeiro, porém, começa na posição 6
    var segundo_calculo = calc_digitos_posicoes( primeiro_calculo, 6, 0 );

    // Concatena o segundo dígito ao CNPJ
    var cnpj = segundo_calculo;

    // Verifica se o CNPJ gerado é idêntico ao enviado
    if ( cnpj === cnpj_original ) {
        return true;
    }

    // Retorna falso por padrão
    return false;

}

function validateCNPJorCPF(cnpj, input) {

    // CNPJ 18287974000163

    var retorno = ""
    var bool = false

    if (cnpj === "") {
        return
    }

    for (var x = 0; x < cnpj.length; x++) {

        bool = false

        if (cnpj.substring(x,x+1) === ".") {
            bool = true
        }
        else if (cnpj.substring(x,x+1) === "/") {
            bool = true
        }
        else if (cnpj.substring(x,x+1) === "-") {
            bool = true
        }

        if (!bool) {
            retorno = retorno + cnpj.substring(x,x+1)
        }
    }

    cnpj = retorno

    if (!valida_cnpj(cnpj) && !valida_cpf(cnpj)) {

        input.text = ""
        return
    }

    // se for um CNPJ
    if (valida_cnpj(cnpj)) {

        retorno = ""

        for (var j = 0; j < cnpj.length; j++) {

            retorno = retorno + cnpj.substring(j,j+1)

            if (retorno.length === 2) {
                retorno = retorno + "."
            }
            else if (retorno.length === 6) {
                retorno = retorno + "."
            }
            else if (retorno.length === 10) {
                retorno = retorno + "/"
            }
            else if (retorno.length === 15) {
                retorno = retorno + "-"
            }
        }

        input.text = retorno
    }

    // se for um CPF
    if (valida_cpf(cnpj)) {

        retorno = ""

        for (var i = 0; i < cnpj.length; i++) {

            retorno = retorno + cnpj.substring(i,i+1)

            if (retorno.length === 3) {
                retorno = retorno + "."
            }
            else if (retorno.length === 7) {
                retorno = retorno + "."
            }
            else if (retorno.length === 11) {
                retorno = retorno + "-"
            }
        }

        input.text = retorno
    }
}

function mobileKeyboardAccept() {
    // executa o botão OK do teclado mobile
    // cancelando a escrita
    Qt.inputMethod.commit()
}

function mobileKeyboardHide() {
    // fecha o teclado
    Qt.inputMethod.hide()
}

function getrandomfilename() {
    // cria um nome aleatorio para um arquivo

    // cria um objeto data
    var c   = new Date()

    // cria o nome pegando YYYYmmDDhhMMss
    var ano = c.getFullYear().toString()
    var mes = c.getMonth().toString()
    var dia = c.getDay().toString()
    var hor = c.getHours().toString()
    var min = c.getMinutes().toString()
    var sec = c.getSeconds().toString()

    // junta o retorno
    return ano + mes + dia + hor + min + sec
}

function listviewCacheBuffer() {
    // controla o quanto de memoria pode ser alocada
    // por pixel para o listview em cada plataforma

    var ret = 0

    try {

        // descobre qual o plataforma
        var plataform = configcall.getSystemBase()

        if (plataform === "ANDROID") {
            /*
                Android (alta performance 4.1 e 6.0)
                Alocamos mais espaço da memoria por pixel,
                para que o usuário não sinta tanto o peso
                do processo quando a rolagem da tela é feita.
            */
            ret = 1000
        }
        else if (plataform === "IOS") {
            // iOS e iPad
            ret = 1000
        }
        else if (plataform === "WINPHONE") {
            // windows phone (não testado)
            ret = 800
        }
        else {
            /*
                Desktop PORT
                A quantidade de itens alocados por pixel é mais
                baixa que no mobile, visto que o processador
                dos desktop consegue renderizar muito mais
                rapidamente quando os blocos são novamente
                alocados na memoria.
            */
            ret = 500
        }

        console.log("listviewCacheBuffer() -> Sucesso! : " + ret.toString())

    } catch (e) {

        console.log("listviewCacheBuffer() -> ERROR sistema de cache, não compativel com algumas plataformas")
        ret = 50
    }

    // retorna diretamente em ListView.CacheBuffer
    return parseInt(ret)
}

function validPhoneNumber(input) {
    // valida um telefone celular
    var result = ""

    try {

        result = input.replace(/(\d{2})(\d{1})(\d{4})(\d{4})/, "($1)$2-$3-$4");

        // (19)9-9341-3980
        if (result.length !== 15) {
            result = ""
        }

    }
    catch (e) {

        result = "";
    }

    return result
}

function checkPriv(module, func) {
    // verifica o privilegio do usuário para uma função de um modulo

    if (module.length === 0) return false
    if (func.length === 0) return false

    var ret = false
    var dataPriv = JSON.parse(configcall.getdata("dataPriv"))

    for (var i = 0; i < dataPriv.length; i++) {
        if (dataPriv[i].module === module && dataPriv[i].func === func) {
            ret = dataPriv[i].checked
            break
        }
    }

    return ret
}

function validDate(input) {
    // valida um campo de data

    var result = ""

    if (input.length === 0) {
        return ""
    }

    var day = 0
    var month = 0
    var year = 0

    // pega somente numeros
    for (var x = 0; x < input.length; x++) {
        if (isNumeric(input.charAt(x))) {
            result = result + input.charAt(x)
        }
    }

    if (result.length === 0) {
        return ""
    }

    try {

        day = result.substring(0, 2)
        month = result.substring(2, 4)
        year = result.substring(4, 8)

        if (!isValidDate(year, month, day)) {
            return ""
        }

        return day + "/" + month + "/" + year
    }
    catch (e) {
        console.error("validDate", e)
        return "";
    }
}

function isValidDate(year, month, day) {
    // valida uma data
    try {

        day   = parseInt(day)
        month = parseInt(month)
        year  = parseInt(year)

        if (year < 1000 || year > 3000 || month === 0 || month > 12) {
            return false
        }

        var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]

        if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)) {
            monthLength[1] = 29
        }

        return day > 0 && day <= monthLength[month - 1]
    }
    catch (e) {

        console.log("isValidDate error", e)
        return false
    }
}

function pad_2(number) {

     return (parseInt(number) < 10 ? '0' : '') + number;
}

function hours(date) {

    var hours = date.getHours();
    if(hours > 12)
        return hours - 12; // Substract 12 hours when 13:00 and more
    return hours;
}

function am_pm(date) {

    if(date.getHours()===0 && date.getMinutes()===0 && date.getSeconds()===0)
        return ''; // No AM for MidNight
    if(date.getHours()===12 && date.getMinutes()===0 && date.getSeconds()===0)
        return ''; // No PM for Noon
    if(date.getHours()<12)
        return ' AM';
    return ' PM';
}

function getnow() {
    // retorna date
    var date = new Date()
    return pad_2(date.getDate()) + '/' +
           pad_2(date.getMonth()+1) + '/' +
           date.getFullYear()
}

function getnowfirstday() {
    var date = new Date()
    return '01/' +
           pad_2(date.getMonth()+1) + '/' +
           date.getFullYear()
}

function dateEx_format(date) {

     return pad_2(date.getDate()) + '/' +
            pad_2(date.getMonth()+1) + '/' +
            date.getFullYear();
}

function date_format(date) {

     return pad_2(date.getDate()) + '/' +
            pad_2(date.getMonth()+1) + '/' +
            (date.getFullYear() + ' ').substring(2) +
            pad_2(hours(date)) + ':' +
            pad_2(date.getMinutes()) +
            am_pm(date);
}

function getMinutesBetweenDates(startDate, endDate) {
    var diff = endDate.getTime() - startDate.getTime();
    return (diff / 60000);
}

function calcPercentArea(percent, area) {

    return (area * percent) / 100
}

function menuSetModelView(type) {
    try {
        configcall.setdata("MenuModelView", type)
    }
    catch (e) {}
}

function menuGetModelView() {
    var ret = configcall.getdata("MenuModelView")
    if (ret.length === 0) {
        ret = 1
    }
    return ret
}















