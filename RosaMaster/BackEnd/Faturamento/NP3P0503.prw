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
| Objetivo:| Cadastro de Filiais de Serviços                    |
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

User Function NP3P0503()
    Private oBrowse := Nil
	Private aRotina := MenuDef()
    Private CCAD := "Cadastro de Filiais de Serviços"
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZ6")
    oBrowse:SetDescription(CCAD) 	
    oBrowse:AddLegend( "ZZ6->ZZ6_EXESER == 'S'", "BR_VERDE",    "Executa serviço" )
    oBrowse:AddLegend( "ZZ6->ZZ6_EXESER == 'N'", "BR_VERMELHO", "Não Executa serviço" )
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
    //Função para validar antes de abrir a tela
	oModel:SetVldActivate({|oModel| P3P05031(oModel)})
    //primary key
	oModel:SetPrimaryKey({'ZZ6_FILIAL','ZZ6_FILSER'})
    // Descrição
    oModel:SetDescription(CCAD)
    oModel:GetModel('ZZ6MASTER'):SetDescription('Filiais de Serviços')
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
    // Posição da tela
    oView:CreateHorizontalBox('EMCIMA',100)
    oView:SetOwnerView('VIEW_ZZ6','EMCIMA')
    // Descrição 
    oView:EnableTitleView('VIEW_ZZ6','Filiais de Serviços')
Return oView

/*-------------------------------------------------------Validações-------------------------------------------------------*/

// Valida antes de abrir o modelo
Static Function P3P05031(oModel)
    Local lOk   := .T.
Return lOk

// Valida ok antes do commit
Static Function P3P05032(oModel)
    Local lOk   := .T.
    Local cAliasZZ6 := GetNextAlias()
    // Valida Ok na inclusão
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
            Help(nil,nil,'INCLUIR',nil,'Filial já existe - Inclusão não permitida',1,0,nil,nil,nil,nil,nil,;
				{'Não é possível incluir essa filial pois a mesma já existe!'})
            lOk := .f.
        EndIf
        (cAliasZZ6)->(DbCloseArea())
    EndIf
Return lOk

/*-------------------------------------------------------Funções-------------------------------------------------------*/


// Legandas
User Function P3P0503B()
	Local oLegend as object

    oLegend := FWLegend():New()

    oLegend:Add("", "BR_VERDE"      , "Executa serviço")
    oLegend:Add("", "BR_VERMELHO"   , "Não Executa serviço")
    
    oLegend:Activate()
    oLegend:View()
    oLegend:Deactivate()

    FreeObj(oLegend)
Return .T.
