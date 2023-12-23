#INCLUDE 'COLORS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#include "parmtype.ch"
#include "fwmvcdef.ch"
#INCLUDE "FWADAPTEREAI.CH"
#INCLUDE "Totvs.CH"
/*
#---------------------------------------------------------------#
| Programa:| NP3P0505                          Data:10/11/2023  |
|---------------------------------------------------------------|
| Autor:   | NP3 Tecnologia                                     |
|---------------------------------------------------------------|
| Objetivo:| Cadastro de Taréfas                                |
|---------------------------------------------------------------|
|                        ALTERAÇÕES                             |
|---------------------------------------------------------------|
|     Analista      |   Data     |  Motivo                      |
|---------------------------------------------------------------|
|                   |            |                              |
|                   |            |                              |
#---------------------------------------------------------------#
LINK TDN: ** NÃO TEM **
*/

User Function NP3P0505()
    Private oBrowse := Nil
	Private aRotina := MenuDef()
    Private CCAD := "Movimentos de Taréfas"

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZB")
    oBrowse:SetDescription(CCAD) 	
    // oBrowse:AddLegend( "!Empty(ZZB->ZZB_IDMOV)", "BR_VERDE",    "Integrado no Umov" )
    // oBrowse:AddLegend( "Empty(ZZB->ZZB_IDMOV) ", "BR_VERMELHO", "Não Integrado no Umov" )
    oBrowse:Activate()
Return

/*-------------------------------------------------------MVC-------------------------------------------------------*/

// Menus
Static Function MenuDef()
	Local aRot  := {}
    // ADD OPTION aRot  TITLE 'Pesquisar'    ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //OPERATION 1
	ADD OPTION aRot  TITLE 'Visualizar'   ACTION 'VIEWDEF.NP3P0505'   OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 2
	ADD OPTION aRot  TITLE 'Incluir'      ACTION 'VIEWDEF.NP3P0505'   OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	// ADD OPTION aRot  TITLE 'Alterar'      ACTION 'VIEWDEF.NP3P0505'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	// ADD OPTION aRot  TITLE 'Excluir'      ACTION 'VIEWDEF.NP3P0505'   OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 
    // ADD OPTION aRot  TITLE 'Legenda'      ACTION 'U_P3P0505B()'       OPERATION 9 ACCESS 0 //OPERATION 9
Return aRot 

// Model
Static function ModelDef()
    Local oModel  := nil
    Local oZZB :=  FWFormStruct(1,'ZZB',{|cCampo| AllTrim(cCampo) $  "ZZB_IDFLUI"})
    Local oZZBGrid :=  FWFormStruct(1,'ZZB')
    Local oZZCGrid :=  FWFormStruct(1,'ZZC')
    //instanciando o modelo de dados
    oModel := MPFormModel():New('MDL1ZZB',/*bPre*/,/*bPos*/,/*bCommit*/{|oModel| P3P05053(oModel) },/*bCancel*/)
    //formulario para o modelo de dados
    oModel:AddFields('ZZBMASTER',,oZZB)
    oModel:AddGrid('ZZBGRID','ZZBMASTER',oZZBGrid)
    oModel:AddGrid('ZZCGRID','ZZBGRID',oZZCGrid)
    //primary key
	oModel:SetPrimaryKey({'ZZB_FILIAL','ZZB_IDFLUI'})
    oModel:SetRelation('ZZBGRID',{{'ZZB_FILIAL','xFilial("ZZB")'},{'ZZB_IDFLUI','ZZB_IDFLUI'}},ZZB->(IndexKey(1)) )
    oModel:SetRelation('ZZCGRID',{{'ZZC_FILIAL','xFilial("ZZC")'},{'ZZC_IDFLUI','ZZB_IDFLUI'},{'ZZC_SEQ','ZZB_SEQ'}},ZZC->(IndexKey(1)) )
    // Descrição
    oModel:SetDescription("Movimentos de Taréfas")
    oModel:GetModel('ZZBMASTER'):SetDescription('Taréfa')
    oModel:GetModel('ZZBGRID'):SetDescription('Taréfas')
    oModel:GetModel('ZZCGRID'):SetDescription('Itens')
    // Propriedades dos grids
    oModel:GetModel('ZZCGRID'):SetOptional( .T. )
Return oModel

// View
Static Function ViewDef()
    Local oView  := Nil
	Local oModel := FWLoadModel("NP3P0505")
	Local oZZB := FWFormStruct(2,'ZZB',{|cCampo| AllTrim(cCampo) $  "ZZB_IDFLUI"})
    Local oZZBGrid :=  FWFormStruct(2,'ZZB',{|cCampo| !AllTrim(cCampo) $  "ZZB_IDFLUI|ZZB_IDUMOV"})
    Local oZZCGrid :=  FWFormStruct(2,'ZZC',{|cCampo| !AllTrim(cCampo) $  "ZZC_FILIAL|ZZC_IDFLUI|ZZC_SEQ|ZZC_CHECK"})
    // Setando o modelo
    oView := FWFormView():New()
	oView:SetModel(oModel)
    //formulario para o modelo de dados
    oView:AddField('VIEW_ZZB',oZZB,'ZZBMASTER') //exibindo os dados do viewdef
    oView:AddGrid( 'VIEW_GRID',oZZBGrid,'ZZBGRID')
    oView:AddGrid( 'VIEW_ITENS',oZZCGrid,'ZZCGRID')
    // Posição da tela
    oView:CreateHorizontalBox('EMCIMA',20)
    oView:CreateHorizontalBox('MEIO',40)
    oView:CreateHorizontalBox('EMBAIXO',40)
    oView:SetOwnerView('VIEW_ZZB','EMCIMA')
    oView:SetOwnerView('VIEW_GRID','MEIO')
    oView:SetOwnerView('VIEW_ITENS','EMBAIXO')
    // Descrição 
    oView:EnableTitleView('VIEW_ZZB','Taréfa')
    oView:EnableTitleView('VIEW_GRID','Taréfas')
    oView:EnableTitleView('VIEW_ITENS','Itens')
Return oView

/*-------------------------------------------------------Validações-------------------------------------------------------*/

// Depois do commit
Static Function P3P05053(oModel)
    Local lRet := .f.
    Local lIntUmov := SuperGetMv("P3_INTUMOV",,.f.)
    If lIntUmov
        // Integração com umov
       lRet := P3P0505A(oModel)
    Else 
        FWFormCommit(oModel)
        lRet := .t.
    EndIf
Return lRet

/*-------------------------------------------------------Funções-------------------------------------------------------*/

// Integração com umov
Static Function P3P0505A(oModel)
    Local lRet := .f.
    Local oEnvUmov
    Local oAtuUmov
    Local aAreaZZB
    Local aAreaZZC
    Local oZZB  := oModel:GetModel('ZZBMASTER')
    Local oZZBGrid	:= oModel:GetModel('ZZBGRID')
    Local aVeiculos := {}
    Local aTarefas := {}
    Local aLocais := {}
    Local aItens := {}
    Local i
    Local oLog
    // Inicia a transção, pois pós commit, se der algum erro, desfaz.
    Begin Transaction
        FWFormCommit(oModel)
        // LOG
        For i := 1 to oZZBGrid:GetQtdLine()
            oZZBGrid:GoLine(i)
            oLog := NP3LOG01():New(AllTrim(oZZB:GetValue("ZZB_IDFLUI"))+AllTrim(oZZBGrid:GetValue("ZZB_SEQ")),date(),SubStr(Time(),1,5),"AUTO","","01")
            oLog:Grava()
            FreeObj(oLog)
        Next
        // Guarda a posição atual
        aAreaZZB := ZZB->(GetArea())
        aAreaZZC := ZZB->(GetArea())
        // Coleta as informações das tarefas e locais
        ZZB->(DbSetOrder(1))
        If ZZB->(DbSeek(xFilial("ZZB")+oZZB:GetValue("ZZB_IDFLUI")))
            While ZZB->(!EOF()) .AND. ZZB->(ZZB_FILIAL+ZZB_IDFLUI) == xFilial("ZZB")+oZZB:GetValue("ZZB_IDFLUI")
                aAdd(aVeiculos,ZZB->ZZB_CODVEI)
                aAdd(aTarefas,ZZB->ZZB_CODTAR)
                aAdd(aLocais,ZZB->ZZB_LOCDE)
                aAdd(aLocais,ZZB->ZZB_LOCPA)
                // Coleta as informações dos itens
                ZZC->(DbSetOrder(1))
                If ZZC->(DbSeek(xFilial("ZZC")+oZZB:GetValue("ZZB_IDFLUI")+ZZB->ZZB_SEQ))
                    While ZZC->(!EOF()) .AND. ZZC->(ZZC_FILIAL+ZZC_IDFLUI+ZZC_SEQ) == xFilial("ZZC")+oZZB:GetValue("ZZB_IDFLUI")+ZZB->ZZB_SEQ
                        aAdd(aItens,ZZC->ZZC_ITEM)
                        ZZC->(DbSkip())
                    EndDo
                EndIf
                ZZB->(DbSkip())
            EndDo
        EndIf
        oAtuUmov := NP3F0506():New()
        // Envio de item para umov
        For i := 1 To Len(aItens)
            If oAtuUmov:Itens(aItens[i])
                lRet := .t.
            Else
                Help(nil,nil,'INCLUIR-Item',nil,'Erro na integração com umov',1,0,nil,nil,nil,nil,nil,;
                    {oAtuUmov:GetError()})
                    lRet := .f.
                    RestArea(aAreaZZB)
                    RestArea(aAreaZZC)
                    DisarmTransaction()
                    exit
            EndIf
        Next
        If lRet
            For i := 1 To Len(aVeiculos)
                // Envio de agent para umov
                If oAtuUmov:Agents(aVeiculos[i])
                    lRet := .t.
                Else
                    Help(nil,nil,'INCLUIR-Agent',nil,'Erro na integração com umov',1,0,nil,nil,nil,nil,nil,;
                        {oAtuUmov:GetError()})
                        lRet := .f.
                        RestArea(aAreaZZB)
                        RestArea(aAreaZZC)
                        DisarmTransaction()
                        exit
                EndIf
            Next
        EndIf
        If lRet
            For i := 1 To Len(aLocais)
                // Envio de locais para umov
                If oAtuUmov:Locais(aLocais[i])
                    lRet := .t.
                Else
                    Help(nil,nil,'INCLUIR-Locais',nil,'Erro na integração com umov',1,0,nil,nil,nil,nil,nil,;
                        {oAtuUmov:GetError()})
                        lRet := .f.
                        RestArea(aAreaZZB)
                        RestArea(aAreaZZC)
                        DisarmTransaction()
                        exit
                EndIf
            Next
        EndIf
        // Retaura area após loop interno
        RestArea(aAreaZZB)
        RestArea(aAreaZZC)
        // Integração com umov
        If lRet
            oEnvUmov := NP3F0505():New()
            lRet := oEnvUmov:EnvToUmov()
            If !lRet
                Help(nil,nil,'INCLUIR',nil,'Erro na integração com umov',1,0,nil,nil,nil,nil,nil,;
                {oEnvUmov:GetError()})
                lRet := .f.
                RestArea(aAreaZZB)
                RestArea(aAreaZZC)
                DisarmTransaction()
            EndIF
        EndIF
        // Retaura area após loop interno
        RestArea(aAreaZZB)
        RestArea(aAreaZZC)
    End Transaction
Return lRet
