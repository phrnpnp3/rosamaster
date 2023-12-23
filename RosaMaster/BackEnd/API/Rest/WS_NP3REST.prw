#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "TopConn.ch"
#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TBICONN.CH"
#include "parmtype.ch"
#INCLUDE "FWADAPTEREAI.CH"
#Include "TBICODE.CH"
#include 'fileio.ch'

#DEFINE ENTER chr(10)+chr(13)


//Inicio da declaração da estrutura do Webservice;
WSRESTFUL NP3REST DESCRIPTION "Serviço REST para requisições ao ERP Protheus"
	
	WSDATA cWsFuncao AS CHARACTER OPTIONAL

	WSMETHOD POST   LISTA     	DESCRIPTION "Retorna lista de registros da empresa - generico. Será preciso informar no BODY uma lista de registros com a informação da empresa, filial, select, campos de retorno e delimitador."  WSSYNTAX "NP3REST/LISTA" PATH "/LISTA"
	WSMETHOD POST 	CALLBACK 	DESCRIPTION "Executa callback do UMOV"  WSSYNTAX "NP3REST/CALLBACK" PATH "/CALLBACK"
	WSMETHOD POST   CLIENTE   	DESCRIPTION "Cadastro de Cliente MVC/EXECAUTO. Será preciso informar no BODY as informações do cliente e metodo utilizador."  WSSYNTAX "NP3REST/CLIENTE" PATH "/CLIENTE"
	WSMETHOD POST   APONTAMENTO DESCRIPTION "Cadastro de Apontamento MVC/EXECAUTO. Será preciso informar no BODY as informações do apontamento e metodo utilizador."  WSSYNTAX "NP3REST/APONTAMENTO" PATH "/APONTAMENTO"
	WSMETHOD POST   TAREFAS 	DESCRIPTION "Movimento de tarefas Fluig x Protheus x Umov."  WSSYNTAX "NP3REST/TAREFAS" PATH "/TAREFAS"

END WSRESTFUL

//Methodo post para execução de querys genericas
WSMETHOD POST LISTA WSSERVICE NP3REST

	Local cJson     := Self:GetContent()
	Local oJson		:= JsonObject():New()
	Local oRet      := JsonObject():New()
	Local lRet		:= .t.
	Local oJsonRet := nil
	Local oItem := nil
	Local aRetorno  := {}
	Local cObjJson := ''
	Local cQuery 	:= ''
	Local cAlias    := GetNextAlias()
	Local aWsFiltro := {} //strtokarr(::cWsFiltro, ::cWsDelimitador)
	Local nX0 := 0

	PRIVATE cError := ""
	//PRIVATE oLastError := ErrorBlock({|e| cError := "ERROR: " + e:Description +chr(10)+ e:ErrorStack})
	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )

	::SetContentType("application/json")

	BEGIN SEQUENCE

		oJson := JsonObject():New()

		oRet := oJson:FromJson(cJson)
		cObjJson := oJson:GetNames()[1]
		if ValType(oJson[cObjJson]) == "C"

			if empty(oJson[cObjJson]) //.or. empty(aCampos[2]) //.or. empty(aCampos[3])

				cError := 'É preciso informar a query para devida execução da rotina! Ex.: {"query": "select * from CTT010 where ... "}"'
			
			endif

			cQuery := ChangeQuery(oJson[cObjJson]) //query para execução

			TcQuery cQuery Alias (cAlias) New
			(cAlias)->(DbGoTop())

			//listando todos os campos da query
			aWsFiltro := (cAlias)->(DBSTRUCT())


			(cAlias)->(DbGoTop())
			nX0 := 0
			Do While !(cAlias)->(EOF())

				oItem := JsonObject():new()

				for nX0 := 1 to len(aWsFiltro)

					if !empty(aWsFiltro[nx0][1])

						IF Valtype((cAlias)->&(aWsFiltro[nx0][1])) == "C"

							oItem[aWsFiltro[nx0][1]] := EncodeUTF8((cAlias)->&(aWsFiltro[nx0][1]))

						else

							oItem[aWsFiltro[nx0][1]] := (cAlias)->&(aWsFiltro[nx0][1])

						Endif

					endif

				next nX0

				AADD(aRetorno,oItem)

				(cAlias)->(dbskip())

			enddo
			(cAlias)->(DbCloseArea())

			oJsonRet := JsonObject():new()
			oJsonRet:Set(aRetorno)

			::SetResponse('{"LISTA":' +oJsonRet:ToJson()+ '}')

		Else

			cError := "Falha ao executar JsonObject. Erro: objeto array nao identificado no bory do post"

		endif
		FreeObj(oJson)
		ErrorBlock(oLastError)

	END SEQUENCE

	if !empty(cError)

		self:setStatus(400)
		SetRestFault(400, EncodeUTF8( cError ), .T.,400)
		lRet := .f.
	endif

Return lRet

//Methodo post para execução de querys genericas
WSMETHOD POST CALLBACK WSSERVICE NP3REST
	Local lRet := .t.
	Local cJson     := Self:GetContent()
	Local oJson		:= JsonObject():New()
	Local oRet      := JsonObject():New()
	Local cObjJson := ''
	Local oCallBack
	Private cError := ""
	Private oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )
	::SetContentType("application/json")
	BEGIN SEQUENCE
		oJson := JsonObject():New()
		oRet := oJson:FromJson(cJson)
		cObjJson := oJson:GetNames()
		IF ValType(oJson:GetNames()) <> "A"
			cError := 'Não foi nada recebido"
			BREAK
		Else
			If !Empty(cJson)
				// Chama a classe calback
				oCallBack := NP3CALLBACK():New(cJson)
				// Cria o callback no Protheus
				If oCallBack:Create()
					// Retorna o history para o protheus
					If oCallBack:GetHistory()
						// Trata o retorno da tarefa para o protheus
						If !oCallBack:ArrayHistory()
							cError := oCallBack:GetError()
						EndIf
					Else
						cError := oCallBack:GetError()
					EndIf
				Else
					cError := oCallBack:GetError()
				EndIf
			EndIf
		endif
		FreeObj(oJson)
		ErrorBlock(oLastError)
	END SEQUENCE
	if !empty(cError)
		conout(cError)
		self:setStatus(400)
		SetRestFault(400, EncodeUTF8( cError ), .T.)
		lRet = .F.
	Else
		::SetResponse("success")
	endif
Return lRet

//Methodo post para Gravação de Cliente
WSMETHOD POST CLIENTE WSSERVICE NP3REST
	Local cJson     := Self:GetContent()
	Local oJson		:= JsonObject():New()
	Local oRet      := JsonObject():New()
	Local lRet 		:= .F.
	Local oCliente
	Local cRotina	:= ""
	PRIVATE cError     := ""
	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )

	::SetContentType("application/json")

	BEGIN SEQUENCE

		oJson := JsonObject():New()
		oRet := oJson:FromJson(cJson)
		aAux := oJson["ADADOS"]:GetNames()
		cRotina	:= oJson:GetJsonText("ROTINA")
		// Cria o bojeto e executa a rotina 
		oCliente:= NP3EP001():New(oJson["ADADOS"],aAux,cRotina)
		lRet := oCliente:Create()

	END SEQUENCE
	if !empty(oCliente:GetError())
		self:setStatus(400)
		SetRestFault(400,EncodeUTF8(oCliente:GetError()),.T.,400)
	else
		If oCliente:GetMsg() <> 'SUCCESSO'
			::SetResponse('{"CLIENTE":"'+oCliente:GetMsg()+'"}')
		Else
			::SetResponse('{"CLIENTE":"'+oCliente:GetMsg()+'","CODIGO":"'+oCliente:GetCodigo()+'","LOJA":"'+oCliente:GetLoja()+'"}')
		EndIf
	endif
Return lRet


//Methodo post para Apontamento
WSMETHOD POST APONTAMENTO WSSERVICE NP3REST
	Local cJson     := Self:GetContent()
	Local oJson		:= JsonObject():New()
	Local oRet      := JsonObject():New()
	Local lRet 		:= .F.
	Local lPos 		:= .F.
	Local oApontamento
	Local cRotina	:= ""
	Local cContra := ""
	PRIVATE cError     := ""
	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )

	SetFunname("RFUNA002")

	::SetContentType("application/json")

	BEGIN SEQUENCE

		oJson := JsonObject():New()
		oRet := oJson:FromJson(cJson)
		aAux := oJson:GetNames()
		cRotina	:= oJson:GetJsonText("ROTINA")
		cContra := oJson['ACABEC']:GetJsonText("UJ0_CONTRA")
		// Posiciona no contrato
		UF2->(DbSetOrder(1)) //UF2_FILIAL+UF2_CODIGO 
		if UF2->(MsSeek(xFilial("UF2")+cContra))
			// Posicionou
			lPos := .t.
			// Cria o bojeto e executa a rotina 
			oApontamento:= NP3EP002():New(oJson,aAux,cRotina)
			lRet := oApontamento:Create()
		EndIf
	END SEQUENCE
	IF lPos
		if !empty(oApontamento:GetError())
			self:setStatus(400)
			SetRestFault(400,EncodeUTF8(oApontamento:GetError()),.T.,400)
		else
			::SetResponse('{"APONTAMENTO":'+oApontamento:GetMsg()+'}')
		endif
	Else
		self:setStatus(400)
		SetRestFault(400,EncodeUTF8("Contrato não encontrado-"+cContra),.T.,400)
	endif
Return lRet


//Methodo post para Tarefa
WSMETHOD POST TAREFAS WSSERVICE NP3REST
	Local cJson     := Self:GetContent()
	Local oJson		:= JsonObject():New()
	Local oRet      := JsonObject():New()
	Local lRet 		:= .F.
	Local oTarefas
	Local cID	:= ""
	PRIVATE cError     := ""
	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )

	::SetContentType("application/json")

	BEGIN SEQUENCE

		oJson := JsonObject():New()
		oRet := oJson:FromJson(cJson)
		aAux := oJson:GetNames()
		cID	:= oJson:GetJsonText("ZZB_IDFLUI")
		// Cria o bojeto e executa a rotina 
		oTarefas:= NP3EP003():New(oJson,aAux,cID,cJson)
		lRet := oTarefas:Create()

	END SEQUENCE
	if !empty(oTarefas:GetError())
		self:setStatus(400)
		SetRestFault(400,EncodeUTF8(oTarefas:GetError()),.T.,400)
	else
		::SetResponse('{"TAREFAS":"'+oTarefas:GetMsg()+'"}')
	endif
Return lRet
