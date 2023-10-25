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
| Programa:| NP3P0503                          Data:23/10/2023  |
|---------------------------------------------------------------|
| Autor:   | NP3 Tecnologia                                     |
|---------------------------------------------------------------|
| Objetivo:| Cadastro de Filiais de Servi�os                    |
|---------------------------------------------------------------|
|                        ALTERA��ES                             |
|---------------------------------------------------------------|
|     Analista      |   Data     |  Motivo                      |
|---------------------------------------------------------------|
|                   |            |                              |
|                   |            |                              |
#---------------------------------------------------------------#
LINK TDN: ** N�O TEM **
*/

User Function NP3P0503()
    Private oBrowse := Nil
	Private aRotina := MenuDef()
    Private CCAD := "Cadastro de Filiais de Servi�os"
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZ6")
    oBrowse:SetDescription(CCAD) 	
    oBrowse:AddLegend( "ZZ6->ZZ6_EXESER == 'S'", "BR_VERDE",    "Executa servi�o" )
    oBrowse:AddLegend( "ZZ6->ZZ6_EXESER == 'N'", "BR_VERMELHO", "N�o Executa servi�o" )
    oBrowse:Activate()
Return

/*-------------------------------------------------------MVC-------------------------------------------------------*/

// Menus
Static Function MenuDef()
	Local aRot  := {}
    ADD OPTION aRot  TITLE 'Pesquisar'    ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //OPERATION 1
	ADD OPTION aRot  TITLE 'Visualizar'   ACTION 'VIEWDEF.NP3P0503'   OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 2
	ADD OPTION aRot  TITLE 'Incluir'      ACTION 'VIEWDEF.NP3P0503'   OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot  TITLE 'Alterar'      ACTION 'VIEWDEF.NP3P0503'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot  TITLE 'Excluir'      ACTION 'VIEWDEF.NP3P0503'   OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 
    ADD OPTION aRot  TITLE 'Legenda'      ACTION 'U_P3P0503B()'       OPERATION 9 ACCESS 0 //OPERATION 9
Return aRot 

// Model
Static function ModelDef()
    Local oModel  := nil
    Local oZZ6 :=  FWFormStruct(1,'ZZ6')
    //instanciando o modelo de dados
    oModel := MPFormModel():New('MDL1ZZ6',/*bPre*/,/*bPos*/{|oModel| P3P05032(oModel) },/*bCommit*/,/*bCancel*/)
    //formulario para o modelo de dados
    oModel:AddFields('ZZ6MASTER',,oZZ6)
    //Fun��o para validar antes de abrir a tela
	oModel:SetVldActivate({|oModel| P3P05031(oModel)})
    //primary key
	oModel:SetPrimaryKey({'ZZ6_FILIAL','ZZ6_FILSER'})
    // Descri��o
    oModel:SetDescription(CCAD)
    oModel:GetModel('ZZ6MASTER'):SetDescription('Filiais de Servi�os')
Return oModel

// View
Static Function ViewDef()
    Local oView  := Nil
	Local oModel := FWLoadModel("NP3P0503")
	Local oZZ6 := FWFormStruct(2,'ZZ6')
    // Setando o modelo
    oView := FWFormView():New()
	oView:SetModel(oModel)
    //formulario para o modelo de dados
    oView:AddField('VIEW_ZZ6',oZZ6,'ZZ6MASTER') //exibindo os dados do viewdef
    // Posi��o da tela
    oView:CreateHorizontalBox('EMCIMA',100)
    oView:SetOwnerView('VIEW_ZZ6','EMCIMA')
    // Descri��o 
    oView:EnableTitleView('VIEW_ZZ6','Filiais de Servi�os')
Return oView

/*-------------------------------------------------------Valida��es-------------------------------------------------------*/

// Valida antes de abrir o modelo
Static Function P3P05031(oModel)
    Local lOk   := .T.
Return lOk

// Valida ok antes do commit
Static Function P3P05032(oModel)
    Local lOk   := .T.
    Local cAliasZZ6 := GetNextAlias()
    // Valida Ok na inclus�o
    If oModel:GetOperation() == MODEL_OPERATION_INSERT
        If Select(cAliasZZ6) <> 0
            (cAliasZZ6)->(DbCloseArea())
        EndIf
        
        BeginSql alias cAliasZZ6
            Select COUNT(*) AS QTD
            from %Table:ZZ6% ZZ6
            Where ZZ6_FILIAL = %Exp:xFilial("ZZ6")%
                and ZZ6_FILSER = %Exp:FwFldGet("ZZ6_FILSER")%
                and ZZ6.%notDel%
        EndSql
        
        If (cAliasZZ6)->QTD > 0
            Help(nil,nil,'INCLUIR',nil,'Filial j� existe - Inclus�o n�o permitida',1,0,nil,nil,nil,nil,nil,;
				{'N�o � poss�vel incluir essa filial pois a mesma j� existe!'})
            lOk := .f.
        EndIf
        (cAliasZZ6)->(DbCloseArea())
    EndIf
Return lOk

/*-------------------------------------------------------Fun��es-------------------------------------------------------*/


// Legandas
User Function P3P0503B()
	Local oLegend as object

    oLegend := FWLegend():New()

    oLegend:Add("", "BR_VERDE"      , "Executa servi�o")
    oLegend:Add("", "BR_VERMELHO"   , "N�o Executa servi�o")
    
    oLegend:Activate()
    oLegend:View()
    oLegend:Deactivate()

    FreeObj(oLegend)
Return .T.
