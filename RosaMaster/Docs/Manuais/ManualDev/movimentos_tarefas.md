# Movimentos de Tarefas (Fluig x Protheus x Umov)

## A Tarefa veio do Fluig

### Rotina
- NP3EP003

### Campos que serão atualizados 
- ZZB_IDFLUI
- ZZB_SEQ
- ZZB_CODVEI
- ZZB_DESVEI
- ZZB_CODTAR
- ZZB_DESTAR
- ZZB_LOCDE
- ZZB_DESLDE
- ZZB_LOCPA
- ZZB_DESLPA
- ZZB_OBSERV

### JSON
- [Json](https://github.com/phrnpnp3/rosamaster/blob/JLS/RosaMaster/Docs/Miscelanea/Json/movimentos_tarefas.json)

## Enviar tarefa para o umov

### Rotina
- NP3F0505-EnvToUmov

### Regra
- ZZB_IDUMOV em branco

### Campos que serão atualizados 
- ZZB_IDUMOV

## Retorno do umov ao iniciar a tarefa

### Rotina
- NP3F0505-RetFromUmovIn

### Campos que serão atualizados 
- ZZB_DTINI
- ZZB_HRINI

## Informa ao fluig que a tarefa foi iniciada

### Rotina
- NP3F0505-RetToFluigIn

### Regra
- ZZB_DTINI preenchido
- ZZB_HRINI preenchido
- ZZB_STATUS 1=não iniciado

### Campos que serão atualizados
- ZZB_STATUS 2=iniciado, para não levar o item para o fluig novamente

## Retorno do umov ao finalizar tarefa

### Rotina
- NP3F0505-RetFromUmovFi

### Campos que serão atualizados
- ZZB_DTFIN
- ZZB_HRFIN
- ZZB_RESUMO
- ZZB_KM

## Informa ao fluig que a tarefa foi finalizada

### Rotina
- NP3F0505-RetToFluigFi

### Regra
- ZZB_DTFIN preenchido
- ZZB_HRFIN preenchido
- ZZB_STATUS 2=iniciado

### Campos que serão atualizados
- ZZB_STATUS 3=concluido, para não levar o item para o fluig novamente