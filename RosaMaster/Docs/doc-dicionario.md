# Dicionário de dados RosaMaster

Esse documento tem a funcionalidade de mapear todo o dicionário de dados utilizados no projeto do cliente RosaMaster

## Tabelas
ZZ5010-Regra de Comissao(C,C,C)

ZZ6010-Filiais de Serviço(C,C,C)

ZZ7010-Veículos(C,C,C)

ZZ8010-Log(C,C,C)

ZZ9010-Taréfas(C,C,C)

ZZA010-CallBack Umov(E,E,E)

ZZB010-Movimento de tarefas(E,E,E)

ZZC010-Itens Movimento de tarefas(E,E,E)

## Índices
ZZ5010 1-ZZ5_FILIAL+ZZ5_CODIGO+ZZ5_GRUPO

ZZ5010 2-ZZ5_FILIAL+ZZ5_GRUPO+ZZ5_INIVI

ZZ6010 1-ZZ6_FILIAL+ZZ6_FILSER

ZZ6010 2-ZZ6_FILIAL+ZZ6_EXESER

ZZ7010 1-ZZ7_FILIAL+ZZ7_CODIGO

ZZ8010 1-ZZ8_FILIAL+ZZ8_ID+ZZ8_SEQUEN

ZZ9010 1-ZZ9_FILIAL+ZZ9_CODIGO

ZZA010 1-ZZA_FILIAL+ZZA_IDFLUI

ZZA010 2-ZZA_FILIAL+ZZA_IDUMOV

ZZB010 1-ZZB_FILIAL+ZZB_IDFLUI+ZZB_IDUMOV

ZZB010 2-ZZB_FILIAL+ZZB_IDUMOV+ZZB_IDFLUI

ZZB010 1-ZZC_FILIAL+ZZC_IDFLUI+ZZC_SEQ

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
    -Ini Padrão: DATE()
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

ZZ6_IDMOV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
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

ZZ7_CODIGO

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Código
    -Descição: Código
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão: GetSXENum("ZZ7","ZZ7_CODIGO")
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
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
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Descricao
    -Descição: Descricao
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
    -Browse: Sim
]: #

ZZ7_LOGIN

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 15
    -Decimal: 0
    -Formato: @N
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Login
    -Descição: Login
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

ZZ7_IDMOV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
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

ZZ8_ID

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: ID Fluig
    -Descição: ID Fluig
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

ZZ8_SEQUEN

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 3
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Sequencia
    -Descição: Sequencia
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

ZZ8_DATA

[
CAMPO
    -Tipo: 4-Data
    -Tamanho: 8
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Sequencia
    -Descição: Sequencia
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

ZZ8_HORA

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 5
    -Decimal: 0
    -Formato: 99:99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Hora
    -Descição: Hora
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

ZZ8_USER  

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Usuario
    -Descição: Usuario
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

ZZ8_JUSTIF  

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 3
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Justificativ
    -Descição: Justificativa
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

ZZ8_DESJUS  

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Descricao
    -Descição: Descricao
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

ZZ8_JSON  

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 2
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Status
    -Descição: Status
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

ZZ8_STATUS  

[
CAMPO
    -Tipo: 5-Memo
    -Tamanho: 10
    -Decimal: 0
    -Formato: 
    -Contexto: Real        
    -Propriedade: Alterar        
INFORMAÇÕES
    -Titulo: Json                
    -Descição: Json                
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

ZZ9_CODIGO

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Código
    -Descição: Código
    -Help:
OPÇÕES
    -Lista:
    -Ini Padrão: GetSXENum("ZZ9","ZZ9_CODIGO")
    -Ini Browse:
    -Modo Edição:
    -Cons Padrão:
VALIDAÇÕES
    -Val Usuário:
    -Val Sistema:
    -Nivel:
USO
    -Obrigatório:Sim
    -Usado: Sim
    -Browse: Sim
]: #

ZZ9_DESCR

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Descricao
    -Descição: Descricao
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
    -Browse: Sim
]: #

ZZ9_IDMOV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato: @!
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

ZZA_IDFLUI

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Id Fluig
    -Descição: Id Fluig
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
    -Browse:
]: #

ZZA_IDUMOV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Id Umov
    -Descição: Id Umov
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
    -Browse:
]: #

ZZA_SEQUEN

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 15
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Sequencia
    -Descição: Sequencia
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
    -Browse:
]: #

ZZA_JSONP

[
CAMPO
    -Tipo: 5-Memo
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Json POST
    -Descição: Json POST
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
    -Browse:
]: #

ZZA_JSONG 

[
CAMPO
    -Tipo: 5-Memo
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Json GET
    -Descição: Json GET
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
    -Browse:
]: #

ZZA_STATUS 

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 1
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Status
    -Descição: Status
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
    -Browse:
]: #

ZZB_IDFLUI

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Id Fluig
    -Descição: Id Fluig
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
    -Browse:
]: #

ZZB_IDUMOV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Id Umov
    -Descição: Id Umov
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
    -Browse:
]: #

ZZB_SEQ

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 2
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Sequencia
    -Descição: Sequencia
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
    -Browse:
]: #

ZZB_CODVEI

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Cod Veiculo
    -Descição: Codigo Veiculo 
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
    -Browse: 
]: #

ZZB_DESVEI

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Desc Veiculo
    -Descição: Descricao Veiculo
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
    -Usado: 
    -Browse: 
]: #

ZZB_CODTAR

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 6
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Visualizar
INFORMAÇÕES
    -Titulo: Cod Tarefa
    -Descição: Código Tarefa
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
    -Browse: 
]: #

ZZB_DESTAR

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Des Tarefa
    -Descição: Descricao Tarefa
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
    -Browse:
]: #


ZZB_LOCDE

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 11
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Local DE 
    -Descição: Local DE
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
    -Browse:
]: #


ZZB_DESLDE

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Des Loc De
    -Descição: Descricao Local de
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
    -Browse:
]: #

ZZB_LOCPA

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 11
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Local Para 
    -Descição: Local Para
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
    -Browse:
]: #


ZZB_DESLPA

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Des Loc Pa
    -Descição: Descricao Local Para
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
    -Browse:
]: #


ZZB_OBSERV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 140
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Obs Tarefa
    -Descição: Observacao Tarefa
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
    -Browse:
]: #

ZZB_DTINI

[
CAMPO
    -Tipo: 4-Data
    -Tamanho: 8
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Data inicial
    -Descição: Data inicial
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
    -Browse:
]: #

ZZB_HRINI

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 5
    -Decimal: 0
    -Formato: 99:99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Hora inicial
    -Descição: Hora inicial
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
    -Browse:
]: #

ZZB_DTFIN

[
CAMPO
    -Tipo: 4-Data
    -Tamanho: 8
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Data final
    -Descição: Data final
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
    -Browse:
]: #

ZZB_HRFIN

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 5
    -Decimal: 0
    -Formato: 99:99
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Hora final
    -Descição: Hora final
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
    -Browse:
]: #

ZZB_RESUMO

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 140
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Ret Umov
    -Descição: Retorno do umov
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
    -Browse:
]: #

ZZB_KM

[
CAMPO
    -Tipo: 2-Numero
    -Tamanho: 7
    -Decimal: 2
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Km
    -Descição: Km
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
    -Browse:
]: #

ZZB_STATUS

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 1
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Ret Umov
    -Descição: Retorno do umov
    -Help:
OPÇÕES
    -Lista: 1=Aberto;2=Iniciado;3=Concluido
    -Ini Padrão: "1"
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
    -Browse:
]: #

ZZC_IDFLUI

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 10
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Id Fluig
    -Descição: Id Fluig
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
    -Browse:
]: #

ZZC_SEQ

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 2
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Sequencia
    -Descição: Sequencia
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
    -Browse:
]: #

ZZC_ITEM

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 15
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Item
    -Descição: Item
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
    -Browse:
]: #

ZZC_DESCIT

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 60
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Desc Item
    -Descição: Desc Item
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
    -Browse:
]: #

ZZC_CHECK

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 1
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Check
    -Descição: Check
    -Help:
OPÇÕES
    -Lista: 1=Sim;2=Não
    -Ini Padrão: "2"
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
    -Browse:
]: #

### Tabelas Padrões

UJC_XEND

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Endereco
    -Descição: Endereco
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
    -Browse: Sim
]: #

UJC_XBAIRR

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 100
    -Decimal: 0
    -Formato:
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Bairro
    -Descição: Bairro
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
    -Browse: Sim
]: #

UJC_XCEP

[
CAMPO
    -Tipo: 2-Numerico
    -Tamanho: 8
    -Decimal: 0
    -Formato: @R 99999-999
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: CEP
    -Descição: CEP
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
    -Browse: Sim
]: #

UJC_XCOMPL

[
CAMPO
    -Tipo: 2-Numerico
    -Tamanho: 8
    -Decimal: 0
    -Formato: @E 99,999,999
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Complemento
    -Descição: Complemento
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
    -Browse:
]: #

B1_XUMOV

[
CAMPO
    -Tipo: 1-Caracter
    -Tamanho: 1
    -Decimal: 0
    -Formato: 
    -Contexto: Real
    -Propriedade: Alterar
INFORMAÇÕES
    -Titulo: Int Umov
    -Descição: Integrado com Umov
    -Help:
OPÇÕES
    -Lista: 1=Sim;2=Não
    -Ini Padrão: "2"
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
    -Browse:
]: #

## Gatilhos

ZZ5_GRUPO 

[
Sequencia: 001
Cnt. Dominio: ZZ5_DESCR 
Tipo: 1-Primario
Regra: POSICIONE("SBM",1,xFilial("SBM")+FwFldGet("ZZ5_GRUPO"),"BM_DESC")
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
