Trabalho de BANCO DE DADOS II
Objetivo: criação de uma Folha de Pagamento fictícia

1 - Os arquivos .sql possuem uma chamada de teste para verificar se tudo foi importado corretamente
2 - Selecione a parte de importação apenas e só depois a execução da tabela ou procedure

Execução do programa
1 - Para imprimir a folha de pagamento de apenas um funcionário
EXEC SP_FOLHA_DE_PAGAMENTO <NUMERO_DE_MATRICULA_FUNCIONARIO>

2 - Para imprimir a folha de pagamento de todos os funcionários
EXEC SP_FOLHA_DE_PAGAMENTO_DE_TODOS