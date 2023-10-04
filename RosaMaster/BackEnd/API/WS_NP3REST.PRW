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

	WSMETHOD POST   LISTA     DESCRIPTION "Retorna lista de registros da empresa - generico. Será preciso informar no BODY uma lista de registros com a informação da empresa, filial, select, campos de retorno e delimitador."  WSSYNTAX "NP3REST/LISTA" PATH "/LISTA"
	// WSMETHOD POST   PROCESSA  DESCRIPTION "Processa uma requisição compilada - generico"     WSSYNTAX "NP3REST/PROCESSA"  PATH "/PROCESSA"
	// WSMETHOD POST   USRNP3    DESCRIPTION "Retorna lista de usuáriso - generico"  			 WSSYNTAX "NP3REST/USRNP3" 	  PATH "/USRNP3"
	// WSMETHOD POST   VALARTE   DESCRIPTION "Validação pelo setor de Arte - generico"  		 WSSYNTAX "NP3REST/VALARTE"	  PATH "/VALARTE"
	// WSMETHOD POST   MARKWF    DESCRIPTION "Mark a Z35 como retornado do fluig - generico"    WSSYNTAX "NP3REST/MARKWF" 	  PATH "/MARKWF"
	// WSMETHOD POST   TABDA1    DESCRIPTION "GRAVA TABELA DE PREÇO - generico"   			     WSSYNTAX "NP3REST/TABDA1" 	  PATH "/TABDA1"
	// WSMETHOD POST   NP3JUS    DESCRIPTION "Retorna justificativa - generico"   			     WSSYNTAX "NP3REST/NP3JUS" 	  PATH "/NP3JUS"
	// WSMETHOD POST   LOGZ34    DESCRIPTION "Geração de Log"                                   WSSYNTAX "NP3REST/LOGZ34"    PATH "/LOGZ34"
	// WSMETHOD PUT    ALTERAR   DESCRIPTION "Altera um registro - generico"                    WSSYNTAX "NP3REST/ALTERAR"   PATH "/ALTERAR"
	// WSMETHOD DELETE EXCLUIR   DESCRIPTION "Exclui um registro - generico"                    WSSYNTAX "NP3REST/EXCLUIR"   PATH "/EXCLUIR"
	// WSMETHOD POST   TES       DESCRIPTION "Retorna TES"                                      WSSYNTAX "NP3REST/TES"       PATH "/TES"
	// WSMETHOD POST   HMLDIGFIS DESCRIPTION "Gravação da HML Digital e Fisica"			     WSSYNTAX "NP3REST/HMLDIGFIS" PATH "/HMLDIGFIS"

END WSRESTFUL

//Methodo post para execução de querys genericas
WSMETHOD POST LISTA WSSERVICE NP3REST

	Local cJson     := Self:GetContent()
	Local oJson		:= JsonObject():New()
	Local oRet      := JsonObject():New()

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

	endif

Return .T.

// //Methodo post para execução de funcões genericas no ERP Protheus
// WSMETHOD POST PROCESSA WSRECEIVE cWsFuncao WSSERVICE NP3REST

// 	local aRetorno  := {}
// 	Local lSetResp := .F.
// 	Local lErro := .F.
// 	Local lRet := .T.

// 	PRIVATE cError := ""
// 	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )
// 	PRIVATE cJson   := Self:GetContent()
// 	PRIVATE oJson	:= JsonObject():New()
// 	PRIVATE oRet    := JsonObject():New()

// 	::SetContentType("application/json")
// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()
// 		oRet := oJson:FromJson(cJson)

// 		if ValType(oRet) == "U"

// 			aRetAux := NP3AUTO(Self,MODEL_OPERATION_INSERT)
// 			if len(aRetAux) > 0

// 				lSetResp := aRetAux[1]
// 				aRetorno := ACLONE( aRetAux[2] )

// 			endif

// 			if !lSetResp

// 				IF len(aRetorno) > 0

// 					IF ('ERROR' $ aRetorno[1,3])

// 						self:setStatus(400)
// 						::SetResponse('{"ERROR:":' + FWJsonSerialize(aRetorno,.F.,.F.) + "}")
// 						lErro := .T.
// 						lRet := .F.
// 						BREAK

// 					Else

// 						::SetResponse( FWJsonSerialize(aRetorno,.F.,.F.) )

// 					EndIf

// 				Else

// 					cError := "Falha ao executar JsonObject. Não foi possivel processar as informações. Verifique os Logs do sistema para maiores informações"
// 					self:setStatus(400)
// 					SetRestFault(400, EncodeUTF8( cError ), .T.,400)
// 					lErro := .T.
// 					lRet := .F.
// 					BREAK

// 				Endif

// 			endif

// 		Else

// 			cError := "Falha ao executar JsonObject. Erro: objeto array nao identificado no bory do post"
// 			self:setStatus(400)
// 			SetRestFault(400, EncodeUTF8( cError ), .T.,400)
// 			lErro := .T.
// 			lRet := .F.
// 			BREAK

// 		EndIf

// 		FreeObj(oJson)
// 		ErrorBlock(oLastError)

// 	END SEQUENCE

// 	IF !Empty(cError) .and. !lErro

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)
// 		lRet := .F.

// 	Endif

// Return lRet//.t.

// //Methodo post para listar usuários genericos no ERP Protheus
// WSMETHOD POST USRNP3 WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local oRet      := JsonObject():New()
// 	Local oJsonRet := nil

// 	Local cId 		:= ""
// 	Local cLogin 	:= ""
// 	Local cNome 	:= ""
// 	Local cEmail 	:= ""
// 	Local nScan 	:= 0
// 	Local aRet 		:= {}
// 	Local AllUsers 		:= FWSFAllUsers()
// 	Local lRet 		:= .F.

// 	PRIVATE cError := ""

// 	::SetContentType("application/json")

// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()

// 		oRet := oJson:FromJson(cJson)

// 		cId 	:= oJson:GetNames()[1]
// 		cLogin 	:= oJson:GetNames()[2]
// 		cNome 	:= oJson:GetNames()[3]
// 		cEmail 	:= oJson:GetNames()[4]

// 		if ValType(oJson[cId]) == "C" .and. !EMPTY( oJson[cId] )

// 			nScan := aScan(AllUsers,{|x| AllTrim(x[2])==oJson[cId]})

// 		Elseif ValType(oJson[cLogin]) == "C" .and. !EMPTY( oJson[cLogin] )

// 			nScan := aScan(AllUsers,{|x| AllTrim(x[3])==oJson[cLogin]})

// 		Elseif ValType(oJson[cNome]) == "C" .and. !EMPTY( oJson[cNome] )

// 			nScan := aScan(AllUsers,{|x| AllTrim(x[4])==oJson[cNome]})

// 		Elseif ValType(oJson[cEmail]) == "C" .and. !EMPTY( oJson[cEmail] )

// 			nScan := aScan(AllUsers,{|x| AllTrim(x[5])==oJson[cEmail]})

// 		ElseIf EMPTY( oJson[cId] ) .and. EMPTY( oJson[cLogin] ) .and. EMPTY( oJson[cNome] ) .and. EMPTY( oJson[cEmail] )
			
// 			nScan := -1

// 		EndIf

// 		If  nScan > 0

// 			aRet:=AllUsers[nScan]
// 			lRet := .T.

// 		ElseIf nScan == -1

// 			aRet:=AllUsers
// 			lRet := .T.

// 		EndIf

// 		If lRet

// 			oJsonRet := JsonObject():new()
// 			oJsonRet:Set(aRet)

// 			::SetResponse('{"USRNP3":' +oJsonRet:ToJson()+ '}')

// 		Else

// 			cError := "Não foi possivel encontrar o usuário"

// 		EndIf

// 	END SEQUENCE

// 	if !empty(cError)

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	endif

// Return .T.


// //Methodo post para validar arte
// WSMETHOD POST VALARTE WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local oRet      := JsonObject():New()

// 	Local cAprova 		:= ""
// 	Local cCliente 		:= ""
// 	Local cSolicitacao 	:= ""
// 	Local cIml 			:= ""
// 	Local cFluig		:= ""
// 	Local cArte			:= ""
// 	Local cReenvio 		:= ""
// 	Local lReenvio 		:= .F.
// 	Local lRet 			:= .F.
// 	Local aRetorno		:= {}

// 	Local oLOG02

// 	PRIVATE cError := ""

// 	::SetContentType("application/json")

// 	BEGIN SEQUENCE

// 		oRet := oJson:FromJson(cJson)

// 		if ValType(oRet) == "U"

// 			aAux := oJson:GetNames()

// 			cAprova 		:= oJson:GetNames()[aScan(aAux,{|x| alltrim(x) == "aprova"})]
// 			cCliente 		:= oJson:GetNames()[aScan(aAux,{|x| alltrim(x) == "cliente"})]
// 			cSolicitacao 	:= oJson:GetNames()[aScan(aAux,{|x| alltrim(x) == "solicitacao"})]
// 			cIml 			:= oJson:GetNames()[aScan(aAux,{|x| alltrim(x) == "iml"})]
// 			cFluig 			:= oJson:GetNames()[aScan(aAux,{|x| alltrim(x) == "fluig"})]
// 			cArte 			:= oJson:GetNames()[aScan(aAux,{|x| alltrim(x) == "arte"})]
// 			cReenvio		:= Iif(aScan(aAux,{|x| alltrim(x) == "reenvio"})>0, oJson:GetNames()[aScan(aAux,{|x| alltrim(x) == "reenvio"})],"")
// 			lReenvio		:= Iif(Iif(cReenvio<>"",oJson[cReenvio],"N")=="N",.F.,.T.)

// 			If oJson[cAprova] == "S"

// 				// Cria registro na integração WF x Fluig
// 				oLOG02 := NP3LOG02():New(oJson[cFluig],"","")
// 				If !oLOG02:IsExist() .or. lReenvio

// 					lRet := U_P3WF0201(oJson[cCliente],oJson[cSolicitacao],oJson[cIml],oJson[cFluig],oJson[cArte])
// 					If !lReenvio

// 						oLOG02:Grava()

// 					EndIf

// 				Else

// 					conout( oJson[cFluig] + ' Já foi enviado ao cliente.' )
// 					cError += oJson[cFluig] + ' Já foi enviado ao cliente.' +chr(10)+chr(13)

// 				EndIf

// 			EndIf

// 			If lRet

// 				aadd(aRetorno,{'Função VALARTE',"VALARTE",'Ok WorkFlow enviado com sucesso!',"","",""})
// 				oJsonRet := JsonObject():new()
// 				oJsonRet:Set(aRetorno)

// 				::SetResponse('{"VALARTE":' +oJsonRet:ToJson()+ '}')

// 			Else

// 				cError += "Não foi possivel Enviar o WF. Analise o log do Protheus. " + oJson[cFluig]+chr(10)+chr(13)
			
// 			EndIf

// 		Else
		
// 			cError += "Falha ao executar JsonObject. Erro: objeto array nao identificado no bory do post"+chr(10)+chr(13)
		
// 		EndIf

// 	END SEQUENCE

// 	if !empty(cError)

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	endif

// Return lRet//.T.



// //Methodo post para validar arte
// WSMETHOD POST MARKWF WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local oRet      := JsonObject():New()
// 	Local oLOG02

// 	Local cFluig 	:= ""
// 	Local lRet 		:= .F.
// 	// Local aRetorno	:= {}

// 	Private cError := ""

// 	::SetContentType("application/json")

// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()

// 		oRet := oJson:FromJson(cJson)

// 		cFluig 		:= oJson:GetNames()[1]

// 		oLOG02 := NP3LOG02():New(oJson[cFluig],/*cAprov*/,"S")
// 		If oLOG02:IsExist()

// 			oLOG02:Update()
// 			lRet := .T.

// 		EndIf

// 	END SEQUENCE

// Return lRet

// //Methodo GRAVA TABELA DE PREÇO
// WSMETHOD POST TABDA1 WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local oRet      := JsonObject():New()

// 	Local cProd 	:= ""
// 	Local nPrc 		:= 0
// 	Local aRetorno	:= {}
// 	Local cAliasDA1	:= GetNextAlias()
// 	Local cItem		:= ""
// 	Local cIdLot	:= ""
// 	Local lRet		:= .F.

// 	PRIVATE cError := ""

// 	::SetContentType("application/json")

// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()

// 		oRet := oJson:FromJson(cJson)

// 		cCodTab 	:= oJson:GetNames()[1]
// 		cProd 		:= oJson:GetNames()[2]
// 		nPrc 		:= oJson:GetNames()[3]
// 		cAtivo 		:= oJson:GetNames()[4]
// 		cTpOper 	:= oJson:GetNames()[5]
// 		cCodFi  	:= oJson:GetNames()[6]
// 		cTipo  		:= oJson:GetNames()[7]


// 		If Select(cAliasDA1) <> 0
// 			(cAliasDA1)->(DbCloseArea())
// 		EndIf

// 		BEGINSQL alias cAliasDA1
	
// 		     SELECT MAX(DA1.DA1_ITEM) AS DA1_ITEM,
// 		     	DA1.DA1_DATVIG
// 		     FROM %Table:DA1% DA1 (NOLOCK)
// 		     WHERE DA1.DA1_CODTAB = %EXP:oJson[cCodTab]%
// 		       AND DA1.%notDel%
// 		     GROUP BY DA1.DA1_DATVIG

// 		ENDSQL

// 		If (cAliasDA1)->(!EOF())

// 			cItem := StrZero(Val((cAliasDA1)->DA1_ITEM)+1,4)
// 			dDtVig:= (cAliasDA1)->DA1_DATVIG
// 			cIdLot := "000000000999999.99"

// 			DbSelectArea("DA1")
// 			DA1->(DbSetOrder(1))
// 			If DA1->(DbSeek(xFilial('DA1')+PADR(oJson[cCodTab],TamSX3("DA1_CODTAB")[1])+PADR(oJson[cProd],TamSX3("DA1_CODPRO")[1])+PADR(cIdLot,TamSX3("DA1_INDLOT")[1])+PADR(cItem,TamSX3("DA1_ITEM")[1]) ))
				
// 				cError := "Esse registro já se encontra cadastrado."
// 				self:setStatus(400)
// 				SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 			Else

// 				RECLOCK( "DA1", .T. )
// 				DA1->DA1_FILIAL 	:= xFilial("DA1")
// 				DA1->DA1_ITEM 		:= cItem
// 				DA1->DA1_CODTAB 	:= oJson[cCodTab]
// 				DA1->DA1_CODPRO 	:= oJson[cProd]
// 				DA1->DA1_PRCVEN 	:= oJson[nPrc]
// 				DA1->DA1_ATIVO	 	:= oJson[cAtivo]
// 				DA1->DA1_TPOPER	 	:= oJson[cTpOper]
// 				DA1->DA1_MOEDA	 	:= 1
// 				DA1->DA1_DATVIG	 	:= STOD(dDtVig)
// 				DA1->DA1_YCODFI	 	:= oJson[cCodFi]
// 				DA1->DA1_YTIPO	 	:= oJson[cTipo]
// 				DA1->DA1_INDLOT	 	:= cIdLot
// 				DA1->(MSUNLOCK())

// 				aadd(aRetorno,{'Função TABDA1',"TABDA1",'Ok Tabela de preco criada com sucesso!',"","",""})
// 				oJsonRet := JsonObject():new()
// 				oJsonRet:Set(aRetorno)

// 				::SetResponse('{"TABDA1":' +oJsonRet:ToJson()+ '}')

// 				lRet := .T.

// 			EndIf

// 		Else

// 			cError := "Tabela de preço " + oJson[cCodTab] + " não encontrada."
// 			self:setStatus(400)
// 			SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 		EndIf

// 		(cAliasDA1)->(DbCloseArea())


// 	END SEQUENCE

// Return lRet



// //Methodo post para listar usuários genericos no ERP Protheus
// WSMETHOD POST NP3JUS WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local oRet      := JsonObject():New()
// 	Local oJsonRet := nil

// 	Local aRet 		:= {}
// 	Local lRet 		:= .F.

// 	PRIVATE cError := ""

// 	::SetContentType("application/json")

// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()

// 		oRet := oJson:FromJson(cJson)

// 		aRet := FWGetSX5( "ZA" )

// 		If Len(aRet) > 0

// 			oJsonRet := JsonObject():new()
// 			oJsonRet:Set(aRet)

// 			::SetResponse('{"NP3JUS":' +oJsonRet:ToJson()+ '}')
// 		Else

// 			cError := "Não foi possivel encontrar o usuário"

// 		EndIf

// 	END SEQUENCE

// 	if !empty(cError)

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	endif

// 	If lRet

// 		aadd(aRetorno,{'Função MARKWF',"MARKWF",'Ok integração marcada com sucesso!',"","",""})
// 		oJsonRet := JsonObject():new()
// 		oJsonRet:Set(aRetorno)

// 		::SetResponse('{"MARKWF":' +oJsonRet:ToJson()+ '}')

// 	Else

// 		cError := "Não foi possivel marcar a integração"

// 	EndIf

// 	if !empty(cError)

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	endif

// Return .T.

// //Methodo post para listar usuários genericos no ERP Protheus
// WSMETHOD POST LOGZ34 WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local oRet      := JsonObject():New()
// 	Local oJsonRet  := nil

// 	// Local aRet 		:= {}
// 	Local lRet 		:= .F.

// 	PRIVATE cError := ""
// 	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )

// 	::SetContentType("application/json")

// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()

// 		oRet := oJson:FromJson(cJson)

// 		aAux := oJson:GetNames()

// 		cIdFluig := oJson:GetJsonText("Z34_ID")
// 		cCdJus 	 := oJson:GetJsonText("Z34_JUSTIF")
// 		cDeJus 	 := oJson:GetJsonText("Z34_DESJU")
// 		cStatus	 := oJson:GetJsonText("Z34_STATUS")

// 		oLOG := NP3LOG01():New(cIdFluig,date(),substr(time(),1,5),__cUserId,cCdJus,cDeJus,cJson,cStatus)
// 		oLOG:GRAVA()

// 	END SEQUENCE

// 	if !empty(cError)

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	else

// 		::SetResponse('{"LOGZ34":"Log incluido com sucesso"}')

// 	endif

// 	If lRet

// 		aadd(aRetorno,{'Função MARKWF',"MARKWF",'Ok integração marcada com sucesso!',"","",""})
// 		oJsonRet := JsonObject():new()
// 		oJsonRet:Set(aRetorno)

// 		::SetResponse('{"MARKWF":' +oJsonRet:ToJson()+ '}')

// 	Else

// 		cError := "Não foi possivel marcar a integração"

// 	EndIf

// 	if !empty(cError)

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	endif

// Return .T.

// //Methodo put para alterações genericas no ERP Protheus
// WSMETHOD PUT ALTERAR WSRECEIVE cWsFuncao WSSERVICE NP3REST

// 	local aRetorno  := {}
// 	Local lSetResp  := .F.
// 	Local lErro     := .T.

// 	Private cError     := ""
// 	Private oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )
// 	private cJson      := Self:GetContent()
// 	private oJson	   := JsonObject():New()
// 	private oRet       := JsonObject():New()

// 	::SetContentType("application/json")
// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()
// 		oRet  := oJson:FromJson(cJson)

// 		aRetAux := NP3AUTO(Self,MODEL_OPERATION_UPDATE)
// 		if len(aRetAux) > 0

// 			lSetResp := aRetAux[1]
// 			aRetorno := ACLONE( aRetAux[2] )

// 		endif

// 		if !lSetResp

// 			IF len(aRetorno) > 0

// 				IF ('ERROR' $ aRetorno[3])

// 					self:setStatus(400)
// 					::SetResponse('{"ERROR:":' + FWJsonSerialize(aRetorno,.F.,.F.) + "}")

// 				Else

// 					::SetResponse( FWJsonSerialize(aRetorno,.F.,.F.) )

// 				EndIf

// 			ELSE

// 				cError := "Falha ao executar JsonObject. Não foi possivel processar as informações. Verifique os Logs do sistema para maiores informações"
// 				self:setStatus(400)
// 				SetRestFault(400, EncodeUTF8( cError ), .T.,400)
// 				lErro := .T.

// 			ENDIF

// 		endif

// 		FreeObj(oJson)
// 		ErrorBlock(oLastError)

// 	END SEQUENCE

// 	IF !Empty(cError) .and. !lErro

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	Endif

// Return .T.


// //Methodo delet para execução de funcões genericas no ERP Protheus
// WSMETHOD DELETE EXCLUIR WSRECEIVE cWsFuncao WSSERVICE NP3REST

// 	local aRetorno := {}
// 	Local lSetResp := .F.
// 	Local lErro    := .T.

// 	PRIVATE cError     := ""
// 	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )
// 	PRIVATE cJson      := Self:GetContent()
// 	PRIVATE oJson	   := JsonObject():New()
// 	PRIVATE oRet       := JsonObject():New()

// 	::SetContentType("application/json")
// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()
// 		oRet  := oJson:FromJson(cJson)

// 		aRetAux := NP3AUTO(Self,MODEL_OPERATION_DELETE)
// 		if len(aRetAux) > 0

// 			lSetResp := aRetAux[1]
// 			aRetorno := ACLONE( aRetAux[2] )

// 		endif

// 		if !lSetResp

// 			IF len(aRetorno) > 0

// 				IF ('ERROR' $ aRetorno[3])

// 					self:setStatus(400)
// 					::SetResponse('{"ERROR:":' + FWJsonSerialize(aRetorno,.F.,.F.) + "}")

// 				Else

// 					::SetResponse( FWJsonSerialize(aRetorno,.F.,.F.) )

// 				EndIf

// 			ELSE

// 				cError := "Falha ao executar JsonObject. Não foi possivel processar as informações. Verifique os Logs do sistema para maiores informações"
// 				self:setStatus(400)
// 				SetRestFault(400, EncodeUTF8( cError ), .T.,400)
// 				lErro := .T.

// 			ENDIF

// 		endif
// 		FreeObj(oJson)
// 		ErrorBlock(oLastError)

// 	END SEQUENCE

// 	IF !Empty(cError) .and. !lErro

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	Endif

// Return .T.


// //metodo de unifiação para execução dos serviços
// static function NP3AUTO(oApi,nOper)

// 	Local aparam 	:= {}
// 	Local cClasse	:= ''
// 	Local aRetorno  := {}
// 	Local aAux 		:= {}
// 	Local oAux 		:= nil
// 	Local nX0 		:= 0
// 	Local lSetResp  := .f.
// 	Local aParIx    := {oJson,oApi,nOper}
// 	Local lErro     := .F.
// 	Local cPontoE   := ""
// 	Local lRet      := .T.

// 	cClasse	:= oJson['funcao']

// 	cPontoE := cClasse

// 	if empty(cClasse)
		
// 		cError := "O objeto FUNCAO não pode ser vazio!!! Informe-o para que a rotina seja executada adequadamente. "
// 		aadd(aRetorno,lSetResp)
// 		aadd(aRetorno,{'Funcao Generica',,'ERROR',cError})

// 	Else

// 		//Verificar se a função existe compilada
// 		If ExistBlock(cClasse)

// 			cClasse := "U_"+Alltrim(cClasse)

// 			IF ExistBlock("RES"+cPontoE)

// 				lSetResp :=	ExecBlock("RES"+cPontoE,.f.,.f.,aParIx)

// 			ENDIF

// 			if valtype(oJson['param']) == 'A'

// 				oAux := oJson['param'][1]
// 				aAux := oAux:GetNames()
// 				if VALTYPE( aAux ) == 'A'

// 					for nX0 := 1 to len(aAux)

// 						aadd(aparam,{aAux[nX0],oAux[aAux[nX0]]})

// 					next nX0

// 				endif

// 			endif

// 			if len(aparam) > 0
// 				//pesquisar na Z02 se a regra finaceira existe para pedidos de venda

// 				IF ExistBlock("ANT"+cPontoE)

// 					lRet :=	ExecBlock("ANT"+cPontoE,.f.,.f.,aParIx)

// 				ENDIF

// 				IF lRet

// 					aRetorno := &(cClasse+'(oApi,aparam)')

// 				Endif

// 				IF ExistBlock("POS"+cPontoE)

// 					ExecBlock("POS"+cPontoE,.f.,.f.,aParIx)

// 				ENDIF

// 			ELSE

// 				cError := "Falha ao executar JsonObject. Objetos funcao/execauto ou array de cabeçalho nao identificado no Body do método"
// 				aadd(aRetorno,lSetResp)
// 				aadd(aRetorno,{'Funcao Generica',cClasse,'ERROR',cError})
// 				lErro := .T.

// 			endif

// 		else

// 			cError := "Função "+cClasse+" não compilada."
// 			aadd(aRetorno,lSetResp)
// 			aadd(aRetorno,{'Funcao Generica',cClasse,'ERROR',cError})
// 			lErro := .T.

// 		Endif

// 	Endif

// Return aRetorno


// //Methodo post para retornar a TES
// WSMETHOD POST TES WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local xRet      := ""

// 	PRIVATE cError := ""

// 	::SetContentType("application/json")

// 	xRet:=oJson:FromJson(cJson)

// 	If Valtype(xRet) = "U"

// 		aRet := U_NP3API02(oJson)

// 	Else

// 		aAdd(aRet,{.F.,xRet})

// 	EndIf

// 	If !aRet[1]

// 		SetRestFault(400, EncodeUTF8( aRet[2] ), .T.,400)

// 	Else

// 		::SetResponse(aRet[2])

// 	EndIF

// Return aRet[1]



// //Methodo post para Gravação da HML Digital e Fisica
// WSMETHOD POST HMLDIGFIS WSSERVICE NP3REST

// 	Local cJson     := Self:GetContent()
// 	Local oJson		:= JsonObject():New()
// 	Local oRet      := JsonObject():New()
// 	Local lRet 		:= .F.
// 	Local nScan 	:= 0
// 	Local AllUsers 	:= FWSFAllUsers()
// 	Local cCodUsuario := ""

// 	PRIVATE cError     := ""
// 	PRIVATE oLastError := ErrorBlock( { |e| cError := e:ErrorStack, Break(e) } )

// 	::SetContentType("application/json")

// 	BEGIN SEQUENCE

// 		oJson := JsonObject():New()

// 		oRet := oJson:FromJson(cJson)

// 		aAux := oJson:GetNames()

// 		cZ33_IML 		:= oJson:GetJsonText("Z33_IML")
// 		cZ33_DESCRI		:= oJson:GetJsonText("Z33_DESCRI")
// 		cZ33_FORNEC		:= oJson:GetJsonText("Z33_FORNEC")
// 		cZ33_LOJA		:= oJson:GetJsonText("Z33_LOJA")
// 		cZ33_HOMO		:= oJson:GetJsonText("HOMOLOG")
// 		cTIPO 			:= AllTrim(oJson:GetJsonText("TIPO"))
// 		// cEMAIL			:= oJson:GetJsonText("EMAIL")
// 		cEMAIL			:= Iif(aScan(aAux,{|x| alltrim(x) == "EMAIL"})>0, oJson:GetJsonText("EMAIL"),"")

// 		if ValType(cEMAIL) == "C" .and. !EMPTY( cEMAIL )

// 			nScan := aScan(AllUsers,{|x| AllTrim(x[5])==cEMAIL})

// 		EndIf

// 		If  nScan > 0

// 			aRet:=AllUsers[nScan]
// 			cCodUsuario := aRet[2]

// 		EndIf

// 		If cTIPO $ "F|D"

// 			DbSelectArea("Z33")
// 			Z33->(DbSetOrder(1))//Z33_FILIAL+Z33_IML+Z33_FORNEC+Z33_LOJA
// 			If Z33->(DbSeek(xFilial("Z33")+padr(cZ33_IML,TamSX3("Z33_IML")[1])+padr(cZ33_FORNEC,TamSX3("Z33_FORNEC")[1])+padr(cZ33_LOJA,TamSX3("Z33_LOJA")[1])))
				
// 				RecLock('Z33',.f.)

// 			Else

// 				RecLock('Z33',.t.)
// 				Z33->Z33_IML 	:= cZ33_IML
// 				Z33->Z33_DESCRI := cZ33_DESCRI
// 				Z33->Z33_FORNEC := cZ33_FORNEC
// 				Z33->Z33_LOJA 	:= cZ33_LOJA

// 			EndIf

// 			If cTIPO == 'D'

// 				Z33->Z33_HOMODI 	:= cZ33_HOMO
// 				Z33->Z33_DTHMDI		:= DATE()
// 				Z33->Z33_USUHMD		:= cCodUsuario

// 			Else

// 				Z33->Z33_HOMOFI 	:= cZ33_HOMO
// 				Z33->Z33_DTHMFI		:= DATE()
// 				Z33->Z33_USUHMF		:= cCodUsuario

// 			EndIf
// 			Z33->(MsUnlock())
// 			lRet := .T.

// 		Else

// 			cError := "O tipo de ser informado 'D' para homologação digital ou 'F' para homologação fisica."
		
// 		EndIf

// 	END SEQUENCE

// 	if !empty(cError)

// 		self:setStatus(400)
// 		SetRestFault(400, EncodeUTF8( cError ), .T.,400)

// 	else
		
// 		::SetResponse('{"HMLDIGFIS":"Homologaçã'+iif(cTIPO == "D",' Digital',' Fisica') + ' gravada com sucesso"}')
	
// 	endif

// Return lRet
