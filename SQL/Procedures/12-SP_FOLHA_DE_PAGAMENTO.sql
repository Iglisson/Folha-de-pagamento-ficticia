ALTER PROCEDURE SP_FOLHA_DE_PAGAMENTO
(@MATRICULA_FUNCIONARIO VARCHAR(4))
AS
BEGIN
	IF @MATRICULA_FUNCIONARIO IN (SELECT MATRICULA FROM FUNCIONARIOS)
		BEGIN
			DECLARE @SALARIO_BRUTO MONEY,
					@REPOUSO_REMUNERADO MONEY,
					@GRATIFICACAO_ESCOLAR MONEY,
					@AUX_ALIMENTACAO MONEY,
					@SALARIO_FAMILIA MONEY,
					@ANUENIO MONEY,
					@VALE_CULTURA MONEY,
					@PROVENTOS MONEY,
					@INSS MONEY,
					@VALE_TRANSPORTE MONEY,
					@IRRF MONEY,
					@PLANO_SAUDE MONEY

			/*	SETANDO OS VALORES	*/
			-- DEFININDO O SALARIO BRUTO
			EXEC SP_SALARIO_BRUTO @MATRICULA_FUNCIONARIO, @SALARIO_BRUTO OUTPUT
			
			-- DEFININDO O REPOUSO REMUNERADO
			EXEC SP_REPOUSO_REMUNERADO @MATRICULA_FUNCIONARIO, @REPOUSO_REMUNERADO OUTPUT

			-- DEFININDO A GRATIFICACAO POR ESCOLARIDADE
			EXEC SP_GRATIFICACAO_POR_ESCOLARIDADE @MATRICULA_FUNCIONARIO, @GRATIFICACAO_ESCOLAR OUTPUT

			-- DEFININDO O VALOR DO AUX. ALIMENTAÇÃO
			SELECT @AUX_ALIMENTACAO = AUXILIO FROM AUXILIO_ALIMENTACAO

			-- DEFININDO O SALARIO FAMILIA
			EXEC SP_SALARIO_FAMILIA @MATRICULA_FUNCIONARIO, @SALARIO_FAMILIA OUTPUT

			-- DEFININDO O BONUS POR ANO(S) DE TRABALHO(S)
			EXEC SP_ANUENIO @MATRICULA_FUNCIONARIO, @ANUENIO OUTPUT

			-- DEFININDO VALE CULTURA
			SELECT @VALE_CULTURA = BONUS FROM VALE_CULTURA

			-- SOMA DE TODOS OS PROVENTOS
			EXEC SP_SOMAR_PROVENTOS @MATRICULA_FUNCIONARIO, @PROVENTOS OUTPUT

			-- OBTENDO O INSS
			EXEC SP_CALCULAR_INSS @MATRICULA_FUNCIONARIO, @INSS OUTPUT

			-- VALE TRANSPORTE
			EXEC SP_VALE_TRANSPORTE @MATRICULA_FUNCIONARIO, @VALE_TRANSPORTE OUTPUT

			-- IMPOSTO DE RENDA DA RECEITA FEDERAL
			EXEC SP_CALCULAR_IRRF @MATRICULA_FUNCIONARIO, @IRRF OUTPUT

			-- PLANO DE SAUDE
			EXEC SP_PLANO_SAUDE @MATRICULA_FUNCIONARIO, @PLANO_SAUDE OUTPUT

			/*	IMPRESSAO DE VALORES	*/
			DECLARE @NOME VARCHAR(40),
					@DATA_ATUAL DATE,
					@CPF VARCHAR(15),
					@CARGO VARCHAR(40),
					@DATA_ADMISSAO DATE,
					@TOT_DESC MONEY,
					@TOT_PROV MONEY,
					@FGTS MONEY

			-- INSERINDO A DATA DO SISTEMA
			SET @DATA_ATUAL = CONVERT(DATE, GETDATE())

			-- OBETENDO O VALOR DO FGTS
			SELECT @FGTS = (@SALARIO_BRUTO + @PROVENTOS) * PERCENTUAL / 100 FROM FGTS
			
			-- TOTAL DE DESCONTO
			SET @TOT_DESC = @INSS + @VALE_TRANSPORTE + @IRRF + @PLANO_SAUDE

			-- TOTAL DE PROVENTOS
			SET @TOT_PROV = @SALARIO_BRUTO + @PROVENTOS

			-- SETANDO INFORMAÇÕES DO FUNCIONARIO
			SELECT	@NOME = F.NOME,
					@CPF = F.CPF,
					@CARGO = C.NOMECARGO,
					@DATA_ADMISSAO = F.ADMISSAO
			FROM	FUNCIONARIOS F
					INNER JOIN CARGOS C ON C.CARGO = F.CARGO
			WHERE	MATRICULA = @MATRICULA_FUNCIONARIO

			PRINT	'GOVERNO DO ESTADO DO PARÁ'
			PRINT	'SECRETARIA ESPECIAL DE ESTADO DE GESTÃO'
			PRINT	'SECRETARIA DE ESTADO DE ADMINISTRAÇÃO'
			PRINT	'SISTEMA DE GESTÃO INTEGRADA DE RECURSOS HUMANOS'
			PRINT	''
			PRINT	'				COMPROVANTE DE PAGAMENTO'
			PRINT	'------------------------------------------------------------'
			PRINT	'ID FUNCIONAL: ' + @MATRICULA_FUNCIONARIO
			PRINT	'MÊS/ANO: ' + CONVERT(VARCHAR(2), MONTH(@DATA_ATUAL)) + '/' + CONVERT(CHAR(4), YEAR(@DATA_ATUAL))
			PRINT	'NOME: '	+ @NOME
			PRINT	'CPF: '		+ @CPF
			PRINT	'CARGO: '	+ @CARGO
			PRINT	'ADMISSÃO: '+ CONVERT(VARCHAR(10), @DATA_ADMISSAO)
			PRINT	'-------------------------------------------------------------'
			PRINT	'ITEM		REFERÊNCIA				PROVENTOS		DESCONTOS'
			PRINT	'1			SALARIO BRUTO			' + CONVERT(VARCHAR(20), @SALARIO_BRUTO)
			PRINT	'2			REPOUSO REMUNERADO		' + CONVERT(VARCHAR(20), @REPOUSO_REMUNERADO)
			PRINT	'3			ESCOLARIDADE			' + CONVERT(VARCHAR(20), @GRATIFICACAO_ESCOLAR)
			PRINT	'4			AUX. ALIMENTAÇÃO		' + CONVERT(VARCHAR(20), @AUX_ALIMENTACAO)
			PRINT	'5			SALÁRIO FAMÍLIA			' + CONVERT(VARCHAR(20), @SALARIO_FAMILIA)
			PRINT	'6			ANUÊNIO					' + CONVERT(VARCHAR(20), @ANUENIO)
			PRINT	'7			VALE CULTURA			' + CONVERT(VARCHAR(20), @VALE_CULTURA)
			PRINT	'8			INSS									' + CONVERT(VARCHAR(20), @INSS)
			PRINT	'9			VALE TRANSPORTE							' + CONVERT(VARCHAR(20), @VALE_TRANSPORTE)
			PRINT	'10			IRRF									' + CONVERT(VARCHAR(20), @IRRF)
			PRINT	'11			PLANO DE SAUDE							' + CONVERT(VARCHAR(20), @PLANO_SAUDE)
			PRINT	'-------------------------------------------------------------'
			PRINT	'									TOT. PROV.		TOT.DESC.'
			PRINT	'									'+CONVERT(VARCHAR(20), @TOT_PROV) + '			' + CONVERT(VARCHAR(10), @TOT_DESC)
			PRINT	'-------------------------------------------------------------'
			PRINT	'BASE FGTS:	' + CONVERT(VARCHAR(20), (@SALARIO_BRUTO+@PROVENTOS)) + '					DEPÓSITO DO MÊS: ' + CONVERT(VARCHAR(10), @FGTS) 
			PRINT	'-------------------------------------------------------------'
			PRINT	'									SAL. LÍQUIDO: ' + CONVERT(VARCHAR(10), (@TOT_PROV-@TOT_DESC))
		END
	ELSE
		BEGIN
			PRINT 'SP_TESTE: MATRÍCULA INVÁLIDA'
		END
END

-- CHAMADA DE TESTE
EXEC SP_FOLHA_DE_PAGAMENTO 1002