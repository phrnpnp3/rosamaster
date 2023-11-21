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
| Programa:| NP3P0502                          Data:23/10/2023  |
|---------------------------------------------------------------|
| Autor:   | NP3 Tecnologia                                     |
|---------------------------------------------------------------|
| Objetivo:| Cadastro de Veículos                              |
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

User Function NP3P0502()
    Private oBrowse := Nil
	Private aRotina := MenuDef()
    Private CCAD := "Cadastro de Veículos"

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZ7")
    oBrowse:SetDescription(CCAD) 	
    oBrowse:AddLegend( "!Empty(ZZ7->ZZ7_IDMOV)", "BR_VERDE",    "Integrado no Umov" )
    oBrowse:AddLegend( "Empty(ZZ7->ZZ7_IDMOV) ", "BR_VERMELHO", "Não Integrado no Umov" )
    oBrowse:Activate()
Return

/*-------------------------------------------------------MVC-------------------------------------------------------*/

// Menus
Static Function MenuDef()
	Local aRot  := {}
    ADD OPTION aRot  TITLE 'Pesquisar'    ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //OPERATION 1
	ADD OPTION aRot  TITLE 'Visualizar'   ACTION 'VIEWDEF.NP3P0502'   OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 2
	ADD OPTION aRot  TITLE 'Incluir'      ACTION 'VIEWDEF.NP3P0502'   OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot  TITLE 'Alterar'      ACTION 'VIEWDEF.NP3P0502'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot  TITLE 'Excluir'      ACTION 'VIEWDEF.NP3P0502'   OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 
    ADD OPTION aRot  TITLE 'Legenda'      ACTION 'U_P3P0502B()'       OPERATION 9 ACCESS 0 //OPERATION 9
Return aRot 

// Model
Static function ModelDef()
    Local oModel  := nil
    Local oZZ7 :=  FWFormStruct(1,'ZZ7')
    //instanciando o modelo de dados
    oModel := MPFormModel():New('MDL1ZZ7',/*bPre*/,/*bPos*/{|oModel| P3P05022(oModel) },/*bCommit*/{|oModel| P3P05023(oModel) },/*bCancel*/)
    //formulario para o modelo de dados
    oModel:AddFields('ZZ7MASTER',,oZZ7)
    //Função para validar antes de abrir a tela
	oModel:SetVldActivate({|oModel| P3P05021(oModel)})
    //primary key
	oModel:SetPrimaryKey({'ZZ7_FILIAL','ZZ7_CODIGO'})
    // Descrição
    oModel:SetDescription(CCAD)
    oModel:GetModel('ZZ7MASTER'):SetDescription('Veículos')
Return oModel

// View
Static Function ViewDef()
    Local oView  := Nil
	Local oModel := FWLoadModel("NP3P0502")
	Local oZZ7 := FWFormStruct(2,'ZZ7')
    // Setando o modelo
    oView := FWFormView():New()
	oView:SetModel(oModel)
    //formulario para o modelo de dados
    oView:AddField('VIEW_ZZ7',oZZ7,'ZZ7MASTER') //exibindo os dados do viewdef
    // Posição da tela
    oView:CreateHorizontalBox('EMCIMA',100)
    oView:SetOwnerView('VIEW_ZZ7','EMCIMA')
    // Descrição 
    oView:EnableTitleView('VIEW_ZZ7','Veículos')
Return oView

/*-------------------------------------------------------Validações-------------------------------------------------------*/

// Valida antes de abrir o modelo
Static Function P3P05021(oModel)
    Local lOk   := .T.
Return lOk

// Valida ok antes do commit
Static Function P3P05022(oModel)
    Local lOk   := .T.
    Local cAliasZZ7 := GetNextAlias()
    // Valida Ok na inclusão
    If oModel:GetOperation() == MODEL_OPERATION_INSERT
        If Select(cAliasZZ7) <> 0
            (cAliasZZ7)->(DbCloseArea())
        EndIf
        
        BeginSql alias cAliasZZ7
            Select COUNT(*) AS QTD
            from %Table:ZZ7% ZZ7
            Where ZZ7_FILIAL = %Exp:xFilial("ZZ7")%
                and ZZ7_CODIGO = %Exp:FwFldGet("ZZ7_CODIGO")%
                and ZZ7.%notDel%
        EndSql
        
        If (cAliasZZ7)->QTD > 0
            Help(nil,nil,'INCLUIR',nil,'Veículo já existe - Inclusão não permitida',1,0,nil,nil,nil,nil,nil,;
				{'Não é possível incluir essa veículo pois a mesma já existe!'})
            lOk := .f.
        EndIf
        (cAliasZZ7)->(DbCloseArea())
    EndIf
Return lOk

// Depois do commit
Static Function P3P05023(oModel)
    Local lRet := .T.
    FWFormCommit(oModel)
    // Integração com umov
    U_P3P0502A(oModel)
Return lRet

/*-------------------------------------------------------Funções-------------------------------------------------------*/

// Integração Umov
User Function P3P0502A(oModel)
    Local lOk   := .f.
    Local oZZ7  := oModel:GetModel('ZZ7MASTER')
    Local oUMOV := NP3UMOV():New()
    Local aStandard     := {}
    Local aCustom       := {}
    Local cTxt := ""
    Local cMsg := ""
    // Alimenta as informações
    aAdd(aStandard,{; 
        {"active","true"},;
        {"agentType",{{{"alternativeIdentifier","1"}}}},;
        {"login",oZZ7:GetValue("ZZ7_DESCR")},;
        {"name",oZZ7:GetValue("ZZ7_DESCR")},;
        {"password","12345"},;
        {"alternativeIdentifier",oZZ7:GetValue("ZZ7_CODIGO")};
    })
    aAdd(aCustom,{})
    // Se for exclução
    If oModel:GetOperation() == MODEL_OPERATION_DELETE
        // Se estiver integrado com o umov
        IF !Empty(oZZ7:GetValue("ZZ7_IDMOV"))
            // Executa integração de cancelamento
            lOk := oUMOV:Agent(aStandard,aCustom,oZZ7:GetValue("ZZ7_CODIGO"),,.t.)
            cTxt := "Excluído com sucesso";cMsg := "Erro ao tentar excluir no umov:"
        EndIf
    Else
        // Se estiver integrado com o umov
        IF !Empty(oZZ7:GetValue("ZZ7_IDMOV"))
            // Executa integração de alteração
            lOk := oUMOV:Agent(aStandard,aCustom,oZZ7:GetValue("ZZ7_CODIGO"))
            cTxt := "Alterado com sucesso";cMsg := "Erro ao tentar alterar no umov:"
        Else
            // Executa integração de inclusão
            lOk := oUMOV:Agent(aStandard,aCustom)
            cTxt := "Incuído com sucesso";cMsg := "Erro ao tentar incluir no umov:"
            If RecLock('ZZ7',.f.)
                ZZ7_IDMOV := oUMOV:GetIdUmov()
                ZZ7->(MsUnlock())
            EndIf
        EndIf
        If lOk
            MsgInfo(cTxt,"Integração UMOV")
        Else
            MsgAlert(cMsg+CRLF+oUMOV:cTxtErro,"Integração UMOV")
        EndIf
    EndIf
Return 

// Legandas
User Function P3P0502B()
	Local oLegend as object
    oLegend := FWLegend():New()
    oLegend:Add("", "BR_VERDE"      , "Integrado no Umov")
    oLegend:Add("", "BR_VERMELHO"   , "Não Integrado no Umov")
    oLegend:Activate()
    oLegend:View()
    oLegend:Deactivate()
    FreeObj(oLegend)
Return .T.
