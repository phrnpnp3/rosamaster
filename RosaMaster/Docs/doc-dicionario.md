# Dicionário de dados RosaMaster

Esse documento tem a funcionalidade de mapear todo o dicionário de dados utilizados no projeto do cliente RosaMaster

## Tabelas
ZZ5010-Regra de Comissao(C,C,C)

ZZ6010-Veículos(C,C,C)

ZZ7010-Filiais de Serviço(C,C,C)

## Índices
ZZ5010 1-ZZ5_FILIAL+ZZ5_CODIGO+ZZ5_GRUPO

ZZ5010 2-ZZ5_FILIAL+ZZ5_GRUPO+ZZ5_INIVI

ZZ6010 1-ZZ6_FILIAL+ZZ6_FILSER

ZZ6010 2-ZZ6_FILIAL+ZZ6_EXESER

ZZ7010 1-ZZ7010 1-ZZ7_FILIAL+ZZ7_CODIGO

## Campos

### Tabelas Customizas
ZZ5_CODIGO

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Codigo
    -Descição: Codigo
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão: GETSXENUM("ZZ5","ZZ5_CODIGO")
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: Sim
]: #

ZZ5_GRUPO 

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 4
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Grupo Produt
    -Descição: Grupo de Produto
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição: INCLUI
    -Cons Padrão: SBM
VALIDAÇÕES
    -Val Usuário: ExistCpo("SBM",M->ZZ5_GRUPO)
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório: Sim
    -Usado: Sim
    -Browse: Sim
]: #

ZZ5_DESCR 

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Virtual
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Desc. Grupo 
    -Descição: Descricao Grupo
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão: IIF(!INCLUI,POSICIONE("SBM",1,xFilial("SBM")+ZZ5->ZZ5_GRUPO,"BM_DESC"),'')
    -Ini Browse: POSICIONE("SBM",1,xFilial("SBM")+ZZ5->ZZ5_GRUPO,"BM_DESC")
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: Sim
]: #

ZZ5_PVEND 

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 5
    -Decimal: 2
    -Formato: @E 99.99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: % Vendedor
    -Descição: % Vendedor
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: positivo() .and. FwFldGet("ZZ5_PVEND") <= 100
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_PCONF 

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 5
    -Decimal: 2
    -Formato: @E 99.99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: % Confecao  
    -Descição: % Confecao  
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: positivo() .and. FwFldGet("ZZ5_PCONF") <= 100
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_PAUXI  

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 5
    -Decimal: 2
    -Formato: @E 99.99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: %Aux. Conf   
    -Descição: % Auxiliar de Confecao   
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: positivo() .and. FwFldGet("ZZ5_PAUXI") <= 100
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_PTECN   

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 5
    -Decimal: 2
    -Formato: @E 99.99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: % Tecnico   
    -Descição: % Tecnico   
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: positivo() .and. FwFldGet("ZZ5_PTECN") <= 100
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_PCOND    

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 5
    -Decimal: 2
    -Formato: @E 99.99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: % Condutor   
    -Descição: % Condutor  
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: positivo() .and. FwFldGet("ZZ5_PCOND") <= 100
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_PAGEN     

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 5
    -Decimal: 2
    -Formato: @E 99.99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: % Agente    
    -Descição: % Agente    
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: positivo() .and. FwFldGet("ZZ5_PAGEN") <= 100
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_PSUPE      

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 5
    -Decimal: 2
    -Formato: @E 99.99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: % Supervisor
    -Descição: % Supervisor
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: positivo() .and. FwFldGet("ZZ5_PSUPE") <= 100
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_INIVI       

[
CAMPO
    -Tipo: 4-Data
    -Tamanho: 8
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Ini Vigencia
    -Descição: Inicio de Vigencia
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: 
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório: Sim
    -Usado: Sim
    -Browse: 
]: #

ZZ5_MAXAG        

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 1
    -Decimal: 0
    -Formato: 9
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Max. Agentes
    -Descição: Max. Agentes
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: FwFldGet("ZZ5_MAXAG")==1 .or. FwFldGet("ZZ5_MAXAG")==2
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ5_MAXTE        

[
CAMPO
    -Tipo: 2-Numérico
    -Tamanho: 1
    -Decimal: 0
    -Formato: 9
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Max Tecnicos
    -Descição: Max Tecnicos
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário: FwFldGet("ZZ5_MAXTE")==1 .or. FwFldGet("ZZ5_MAXTE")==2
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: 
]: #

ZZ6_FILSER

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Filial
    -Descição: Filial
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição: INCLUI
    -Cons Padrão: SM0
VALIDAÇÕES
    -Val Usuário: ExistCpo("SM0",cEmpAnt+FwFldGet("ZZ6_FILSER"))
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:Sim
    -Usado: Sim
    -Browse: Sim
]: #

ZZ6_DESFIL

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Virtual
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Descricao
    -Descição: Descricao
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão: IIF(!INCLUI,POSICIONE("SM0",1,cEmpAnt+ZZ6->ZZ6_FILSER,"M0_FILIAL"),'')
    -Ini Browse: POSICIONE("SM0",1,cEmpAnt+ZZ6->ZZ6_FILSER,"M0_FILIAL")
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: Sim
]: #

ZZ6_EXESER

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 1
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Exe Servico?
    -Descição: Exe Servico?
    -Help:
OPÇÕES
    -Lista: S=Sim;N=Não
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório: Sim
    -Usado: Sim
    -Browse: Sim
]: #

ZZ7_CODIGO

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Filial
    -Descição: Filial
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição: INCLUI
    -Cons Padrão: SM0
VALIDAÇÕES
    -Val Usuário: ExistCpo("SM0",cEmpAnt+FwFldGet("ZZ7_CODIGO"))
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:Sim
    -Usado: Sim
    -Browse: Sim
]: #

ZZ7_DESCR

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Virtual
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Descricao
    -Descição: Descricao
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão: IIF(!INCLUI,POSICIONE("SM0",1,cEmpAnt+ZZ7->ZZ7_CODIGO,"M0_FILIAL"),'')
    -Ini Browse: POSICIONE("SM0",1,cEmpAnt+ZZ7->ZZ7_CODIGO,"M0_FILIAL")
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: Sim
]: #

ZZ7_IDMOV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: ID UMOV
    -Descição: ID UMOV
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão:
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:
    -Usado: Sim
    -Browse: Sim
]: #

### Tabelas Padrões

## Gatilhos

ZZ5_GRUPO 

[
Sequencia: 001
Cnt. Dominio: ZZ5_DESCR 
Tipo: 1-Primario
Regra: POSICIONA("SBM",1,xFilial("SBM")+FwFldGet("BM_DESC"),"BM_DESC")
Posiciona: 2-Nao
Alias:
Orden:
Chave:
Condicao:
]: #

ZZ6_FILSER

[
Sequencia: 001
Cnt. Dominio: ZZ6_DESFIL 
Tipo: 1-Primario
Regra: FwFilialName(cEmpAnt,FwFldGet("ZZ6_FILSER"),1)
Posiciona: 2-Nao
Alias:
Orden:
Chave:
Condicao:
]: #

## Consulta Padrão

## Parâmetros

## Tabela Genérica
