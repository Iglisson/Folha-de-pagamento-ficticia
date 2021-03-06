-- PROCEDURE PARA CALCULAR A GRATIFICACAO POR ESCOLARIDADE (GPE)
ALTER PROCEDURE SP_GRATIFICACAO_POR_ESCOLARIDADE
(@MATRICULA_FUNCIONARIO VARCHAR(4), @BONUS_GPE MONEY OUTPUT)
AS
BEGIN
	IF @MATRICULA_FUNCIONARIO IN (SELECT MATRICULA FROM FUNCIONARIOS)
		BEGIN
			-- VARIAVEIS DA PROCEDURE
			DECLARE @PORC DECIMAL(5,2),
					@SALARIO_BRUTO MONEY,
					@GRAU_ESCOL VARCHAR(1)

			-- SETANDO VALORES
			SELECT	@SALARIO_BRUTO = C.SALARIO,		-- DEFININDO O SALARIO BRUTO
					@GRAU_ESCOL = F.ESCOLARIDADE	-- DEFININDO O GRAU DE ESCOLARIDADE
			FROM	FUNCIONARIOS F
					INNER JOIN CARGOS C ON C.CARGO = F.CARGO
			WHERE F.MATRICULA = @MATRICULA_FUNCIONARIO
	
			-- DEFININDO O PERCENTUAL A SER PAGO
			SET @PORC = (SELECT BONUS_PORC FROM GRATIFICACAO_POR_ESCOLARIDADE WHERE ID LIKE @GRAU_ESCOL) / 100

			SET @BONUS_GPE = @SALARIO_BRUTO * @PORC
		END
	ELSE
		BEGIN
			SET @BONUS_GPE = -1
			PRINT 'SP_GRATIFICACAO_POR_ESCOLARIDADE: MATRICULA INV?LIDA!' 
		END
END

--TESTE
DECLARE @GPE MONEY
EXEC SP_GRATIFICACAO_POR_ESCOLARIDADE 1060, @GPE OUTPUT
SELECT @GPE AS GPE