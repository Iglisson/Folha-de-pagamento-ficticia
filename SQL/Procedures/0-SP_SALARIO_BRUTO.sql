-- PROCEDURE PARA RETORNAR O SALARIO BRUTO
CREATE PROCEDURE SP_SALARIO_BRUTO
(@MATRICULA_FUNCIONARIO MONEY, @SAL_BRUTO MONEY OUTPUT)
AS
BEGIN
	SELECT	@SAL_BRUTO = C.SALARIO
	FROM	FUNCIONARIOS F
			INNER JOIN CARGOS C ON C.CARGO = F.CARGO
	WHERE F.MATRICULA = @MATRICULA_FUNCIONARIO
END

