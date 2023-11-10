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
| Programa:| NP3P0504                          Data:06/11/2023  |
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

User Function NP3P0504()
    Private oBrowse := Nil
	Private aRotina := MenuDef()
    Private CCAD := "Cadastro de Taréfas"

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZ9")
    oBrowse:SetDescription(CCAD) 	
    oBrowse:AddLegend( "!Empty(ZZ9->ZZ9_IDMOV)", "BR_VERDE",    "Integrado no Umov" )
    oBrowse:AddLegend( "Empty(ZZ9->ZZ9_IDMOV) ", "BR_VERMELHO", "Não Integrado no Umov" )
    oBrowse:Activate()
Return

/*-------------------------------------------------------MVC-------------------------------------------------------*/

// Menus
Static Function MenuDef()
	Local aRot  := {}
    ADD OPTION aRot  TITLE 'Pesquisar'    ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //OPERATION 1
	ADD OPTION aRot  TITLE 'Visualizar'   ACTION 'VIEWDEF.NP3P0504'   OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 2
	ADD OPTION aRot  TITLE 'Incluir'      ACTION 'VIEWDEF.NP3P0504'   OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot  TITLE 'Alterar'      ACTION 'VIEWDEF.NP3P0504'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot  TITLE 'Excluir'      ACTION 'VIEWDEF.NP3P0504'   OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 
    ADD OPTION aRot  TITLE 'Legenda'      ACTION 'U_P3P0504B()'       OPERATION 9 ACCESS 0 //OPERATION 9
Return aRot 

// Model
Static function ModelDef()
    Local oModel  := nil
    Local oZZ9 :=  FWFormStruct(1,'ZZ9')
    //instanciando o modelo de dados
    oModel := MPFormModel():New('MDL1ZZ9',/*bPre*/,/*bPos*/{|oModel| P3P05042(oModel) },/*bCommit*/{|oModel| P3P05043(oModel) },/*bCancel*/)
    //formulario para o modelo de dados
    oModel:AddFields('ZZ9MASTER',,oZZ9)
    //Função para validar antes de abrir a tela
	oModel:SetVldActivate({|oModel| P3P05041(oModel)})
    //primary key
	oModel:SetPrimaryKey({'ZZ9_FILIAL','ZZ9_CODIGO'})
    // Descrição
    oModel:SetDescription(CCAD)
    oModel:GetModel('ZZ9MASTER'):SetDescription('Taréfas')
Return oModel

// View
Static Function ViewDef()
    Local oView  := Nil
	Local oModel := FWLoadModel("NP3P0504")
	Local oZZ9 := FWFormStruct(2,'ZZ9')
    // Setando o modelo
    oView := FWFormView():New()
	oView:SetModel(oModel)
    //formulario para o modelo de dados
    oView:AddField('VIEW_ZZ9',oZZ9,'ZZ9MASTER') //exibindo os dados do viewdef
    // Posição da tela
    oView:CreateHorizontalBox('EMCIMA',100)
    oView:SetOwnerView('VIEW_ZZ9','EMCIMA')
    // Descrição 
    oView:EnableTitleView('VIEW_ZZ9','Taréfas')
Return oView

/*-------------------------------------------------------Validações-------------------------------------------------------*/

// Valida antes de abrir o modelo
Static Function P3P05041(oModel)
    Local lOk   := .T.
Return lOk

// Valida ok antes do commit
Static Function P3P05042(oModel)
    Local lOk   := .T.
    Local cAliasZZ9 := GetNextAlias()
    // Valida Ok na inclusão
    If oModel:GetOperation() == MODEL_OPERATION_INSERT
        If Select(cAliasZZ9) <> 0
            (cAliasZZ9)->(DbCloseArea())
        EndIf
        
        BeginSql alias cAliasZZ9
            Select COUNT(*) AS QTD
            from %Table:ZZ9% ZZ9
            Where ZZ9_FILIAL = %Exp:xFilial("ZZ9")%
                and ZZ9_DESCR = %Exp:FwFldGet("ZZ9_DESCR")%
                and ZZ9.%notDel%
        EndSql
        
        If (cAliasZZ9)->QTD > 0
            Help(nil,nil,'INCLUIR',nil,'Taréfa já existe - Inclusão não permitida',1,0,nil,nil,nil,nil,nil,;
				{'Não é possível incluir essa taréfa pois a mesma já existe!'})
            lOk := .f.
        EndIf
        (cAliasZZ9)->(DbCloseArea())
    EndIf
Return lOk

// Depois do commit
Static Function P3P05043(oModel)
    Local lRet := .T.
    FWFormCommit(oModel)
    // Integração com umov
    // MsgInfo("Integração com o Umov em desenvolvimento")// U_P3P0504A(oModel) // TODO: Habilitar
Return lRet

/*-------------------------------------------------------Funções-------------------------------------------------------*/

// Legandas
User Function P3P0504B()
	Local oLegend as object

    oLegend := FWLegend():New()

    oLegend:Add("", "BR_VERDE"      , "Integrado no Umov")
    oLegend:Add("", "BR_VERMELHO"   , "Não Integrado no Umov")
    
    oLegend:Activate()
    oLegend:View()
    oLegend:Deactivate()

    FreeObj(oLegend)
Return .T.
