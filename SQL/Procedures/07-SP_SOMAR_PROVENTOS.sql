ALTER PROCEDURE SP_SOMAR_PROVENTOS
(@MATRICULA_FUNCIONARIO VARCHAR(4), @PROVENTOS MONEY OUTPUT)
AS
BEGIN
	IF @MATRICULA_FUNCIONARIO IN (SELECT MATRICULA FROM FUNCIONARIOS) -- VALIDANDO A MATRICULA
		BEGIN
			-- VARIAVEIS DA PROCEDURE
			DECLARE @REPOUSO_REMUNERADO MONEY,
					@GRATIFICACAO_ESCOLADRIDADE MONEY,
					@AUX_ALIMENTACAO MONEY,
					@SALARIO_FAMILIA MONEY,
					@ANUENIO MONEY,
					@VALE_CULTURA MONEY

			-- DEFININDO O VALOR DO REPOUSO REMUNERADO
			EXEC SP_REPOUSO_REMUNERADO @MATRICULA_FUNCIONARIO, @REPOUSO_REMUNERADO OUTPUT

			-- DEFININDO O VALOR DO BONUS POR ESCOLARIDADE
			EXEC SP_GRATIFICACAO_POR_ESCOLARIDADE @MATRICULA_FUNCIONARIO, @GRATIFICACAO_ESCOLADRIDADE OUTPUT

			-- DEFININDO O VALOR DO AUX. ALIMENTA??O
			SELECT @AUX_ALIMENTACAO = AUXILIO FROM AUXILIO_ALIMENTACAO

			-- DEFININDO O SALARIO FAMILIA
			EXEC SP_SALARIO_FAMILIA @MATRICULA_FUNCIONARIO, @SALARIO_FAMILIA OUTPUT

			-- DEFININDO O BONUS POR ANO(S) DE TRABALHO(S)
			EXEC SP_ANUENIO @MATRICULA_FUNCIONARIO, @ANUENIO OUTPUT

			-- DEFININDO VALE CULTURA
			SELECT @VALE_CULTURA = BONUS FROM VALE_CULTURA

			-- SOMANDO TODOS OS PROVENTOS
			SET @PROVENTOS = @REPOUSO_REMUNERADO + @GRATIFICACAO_ESCOLADRIDADE + @AUX_ALIMENTACAO + @SALARIO_FAMILIA + @ANUENIO + @VALE_CULTURA

			/*
			--IMPRIMINDO TODOS OS VALORES
			SELECT	@REPOUSO_REMUNERADO AS REPOUSO_REMUNERADO,
					@GRATIFICACAO_ESCOLADRIDADE AS RESCOLARIDADE,
					@AUX_ALIMENTACAO AS AUX_ALIMENTACAO,
					@SALARIO_FAMILIA AS SALARIO_FAMILIA,
					@ANUENIO AS ANUENIO,
					@VALE_CULTURA AS VALE_CULTURA
			*/
		END
	ELSE
		PRINT 'SP_SOMAR_PROVENTOS: MATR?CULA INV?LIDA'
END

--TESTE
DECLARE @A MONEY
EXEC SP_SOMAR_PROVENTOS 1060, @A OUTPUT
SELECT @A PROVENTOS