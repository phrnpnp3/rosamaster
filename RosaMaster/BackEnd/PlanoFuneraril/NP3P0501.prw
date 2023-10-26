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
| Programa:| NP3P0501                          Data:16/10/2023  |
|---------------------------------------------------------------|
| Autor:   | NP3 Tecnologia                                     |
|---------------------------------------------------------------|
| Objetivo:| Cadastro de comissões                              |
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

User Function NP3P0501()
    Private oBrowse := Nil
	Private aRotina := MenuDef()
    Private CCAD := "Cadastro de Comissão"
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZ5")
    oBrowse:SetDescription(CCAD) 	
    oBrowse:AddLegend( "U_P3P0501A()", "BR_VERDE",    "Vigente" )
    oBrowse:AddLegend( "!U_P3P0501A()", "BR_VERMELHO", "Não Vigente" )
    oBrowse:Activate()
Return

/*-------------------------------------------------------MVC-------------------------------------------------------*/

// Menus
Static Function MenuDef()
	Local aRot  := {}
    ADD OPTION aRot  TITLE 'Pesquisar'    ACTION 'PesqBrw'            OPERATION 1 ACCESS 0 //OPERATION 1
	ADD OPTION aRot  TITLE 'Visualizar'   ACTION 'VIEWDEF.NP3P0501'   OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 2
	ADD OPTION aRot  TITLE 'Incluir'      ACTION 'VIEWDEF.NP3P0501'   OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot  TITLE 'Alterar'      ACTION 'VIEWDEF.NP3P0501'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot  TITLE 'Excluir'      ACTION 'VIEWDEF.NP3P0501'   OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 
    ADD OPTION aRot  TITLE 'Legenda'      ACTION 'U_P3P0501B()'       OPERATION 9 ACCESS 0 //OPERATION 9
Return aRot 

// Model
Static function ModelDef()
    Local oModel  := nil
    Local oZZ5 :=  FWFormStruct(1,'ZZ5')
    //instanciando o modelo de dados
    oModel := MPFormModel():New('MDL1ZZ5',/*bPre*/,/*bPos*/{|oModel| P3P05012(oModel) },/*bCommit*/{|oModel| P3P05013(oModel) },/*bCancel*/)
    //formulario para o modelo de dados
    oModel:AddFields('ZZ5MASTER',,oZZ5)
    //Função para validar antes de abrir a tela
	oModel:SetVldActivate({|oModel| P3P05011(oModel)})
    //primary key
	oModel:SetPrimaryKey({'ZZ5_FILIAL','ZZ5_GRUPO','ZZ5_INIVI'})
    // Descrição
    oModel:SetDescription(CCAD)
    oModel:GetModel('ZZ5MASTER'):SetDescription('Comissao')
Return oModel

// View
Static Function ViewDef()
    Local oView  := Nil
	Local oModel := FWLoadModel("NP3P0501")
	Local oZZ5 := FWFormStruct(2,'ZZ5')
    // Setando o modelo
    oView := FWFormView():New()
	oView:SetModel(oModel)
    //formulario para o modelo de dados
    oView:AddField('VIEW_ZZ5',oZZ5,'ZZ5MASTER') //exibindo os dados do viewdef
    // Posição da tela
    oView:CreateHorizontalBox('EMCIMA',100)
    oView:SetOwnerView('VIEW_ZZ5','EMCIMA')
    // Descrição 
    oView:EnableTitleView('VIEW_ZZ5','Comissao')
Return oView

/*-------------------------------------------------------Validações-------------------------------------------------------*/

// Valida antes de abrir o modelo
Static Function P3P05011(oModel)
    Local lOk   := .T.
Return lOk

// Valida ok antes do commit
Static Function P3P05012(oModel)
    Local lOk   := .T.
    Local cAliasZZ5 := GetNextAlias()
    // Valida Ok na inclusão
    If oModel:GetOperation() == MODEL_OPERATION_INSERT
        If Select(cAliasZZ5) <> 0
            (cAliasZZ5)->(DbCloseArea())
        EndIf
        
        BeginSql alias cAliasZZ5
            Select COUNT(*) AS QTD
            from %Table:ZZ5% ZZ5
            Where ZZ5_FILIAL = %Exp:xFilial("ZZ5")%
                and ZZ5_GRUPO = %Exp:FwFldGet("ZZ5_GRUPO")%
                and ZZ5_INIVI = %Exp:FwFldGet("ZZ5_INIVI")%
                and ZZ5.%notDel%
        EndSql
        
        If (cAliasZZ5)->QTD > 0
            Help(nil,nil,'INCLUIR',nil,'Regra já existe - Inclusão não permitida',1,0,nil,nil,nil,nil,nil,;
				{'Não é possível incluir essa regra pois a mesma já existe!'})
            lOk := .f.
        EndIf
        (cAliasZZ5)->(DbCloseArea())
    EndIf
Return lOk

// Depois do commit
Static Function P3P05013(oModel)
    Local lRet := .T.
    FWFormCommit(oModel)
Return lRet
/*-------------------------------------------------------Funções-------------------------------------------------------*/

// Buscar a maior data de vigencia, menor ou igual a data atual
User Function P3P0501A()
    Local aRet := {}//CTOD(Space(8))
    Local cAliasZZ5 := GetNextAlias()
    If Select(cAliasZZ5) <> 0
        (cAliasZZ5)->(DbCloseArea())
    EndIf
    
    BeginSql alias cAliasZZ5

        Select ZZ5_GRUPO,MAX(ZZ5_INIVI) ZZ5_INIVI
        from %Table:ZZ5% ZZ5
        Where ZZ5_FILIAL = %Exp:xFilial("ZZ5")%
            and ZZ5_INIVI <= %Exp:DTOS(DATE())%
            and ZZ5.%notDel%
        Group By ZZ5_GRUPO
    EndSql
    
    While (cAliasZZ5)->(!EOF())
        aAdd(aRet,(cAliasZZ5)->ZZ5_GRUPO+(cAliasZZ5)->ZZ5_INIVI)
        (cAliasZZ5)->(DbSkip())
    EndDo
    (cAliasZZ5)->(DbCloseArea())
Return aScan(aRet,{|x| x == ZZ5->ZZ5_GRUPO+DTOS(ZZ5->ZZ5_INIVI)}) > 0

// Legandas
User Function P3P0501B()
	Local oLegend as object

    oLegend := FWLegend():New()

    oLegend:Add("", "BR_VERDE"      , "Vigente")
    oLegend:Add("", "BR_VERMELHO"   , "Não Vigente")
    
    oLegend:Activate()
    oLegend:View()
    oLegend:Deactivate()

    FreeObj(oLegend)
Return .T.
