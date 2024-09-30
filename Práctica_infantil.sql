use SCOTT;

SELECT * FROM DEPT;
SELECT * FROM EMP;
SELECT * FROM SALGRADE;
SELECT * FROM BONUS;

-- ej 1:
/*
	Haz una función llamada DevolverCodDept que reciba el nombre de un departamento 
	y devuelva su código.
*/

CREATE FUNCTION DevolverCodDept (@nombre VARCHAR(30)) RETURNS INT AS
BEGIN
	DECLARE @codDept int;

	SELECT @codDept=DEPTNO FROM DEPT WHERE DNAME LIKE '%' + @nombre + '%';

	RETURN @codDept;
END

SELECT dbo.DevolverCodDept('ACC');

-- ej 2:
/*
Realiza un procedimiento llamado HallarNumEmp que recibiendo un nombre de departamento,
muestre en pantalla el número de empleados de dicho departamento. 
Puedes utilizar la función creada en el ejercicio 1.

Si el departamento no tiene empleados deberá mostrar un mensaje informando de ello. 
Si el departamento no existe se tratará la excepción correspondiente.
*/
CREATE OR ALTER PROCEDURE HallarNumEmp (@nombreDept VARCHAR(15), @nEmp INT OUTPUT) AS
BEGIN

	SELECT @nEmp=COUNT(EMPNO) FROM EMP INNER JOIN DEPT 
	ON DEPT.DEPTNO = EMP.DEPTNO WHERE DEPT.DEPTNO = dbo.DevolverCodDept(@nombreDept)

	DECLARE @deptExiste BIT;
	SELECT @deptExiste=CAST(COUNT(DEPT.DEPTNO) AS BIT) FROM DEPT WHERE DEPTNO = dbo.DevolverCodDept(@nombreDept)


	SELECT 
		CASE WHEN (@deptExiste=1 and @nEmp >0)
			THEN (SELECT 'Hay ' + CAST(@nEmp as VARCHAR(4)) + ' empleados.')
			WHEN @deptExiste=0
			THEN (SELECT 'El departamento no existe.')
			WHEN @nEmp = 0
			THEN (SELECT 'No hay empleados en el departamento seleccionado.')
		END
END

DECLARE @dept VARCHAR(15) = 'ACC';
DECLARE @nEmp INT;
EXEC dbo.HallarNumEmp @dept, @nEmp;
PRINT(@nEmp);

-- ej 3
/*
Realiza una función llamada CalcularCosteSalarial que reciba un nombre de departamento
y devuelva la suma de los salarios y comisiones de los empleados de dicho 
departamento. 

Trata las excepciones que consideres necesarias.
*/
CREATE OR ALTER FUNCTION CalcularCosteSalarial(@nombreDept VARCHAR(15)) RETURNS DECIMAL(8,2) AS
BEGIN
	DECLARE @coste DECIMAL(8,2);
	SELECT @coste=(SUM(SAL) + SUM(ISNULL(COMM, 0))) FROM EMP WHERE DEPTNO = dbo.DevolverCodDept(@nombreDept);
	
	RETURN @coste;
END


SELECT dbo.CalcularCosteSalarial('SALES');

-- ej 4
/*
	Realiza un procedimiento MostrarCostesSalariales que muestre los nombres de 
	todos los departamentos y el coste salarial de cada uno de ellos. 
	
	Puedes usar la función del ejercicio 3.
*/
CREATE OR ALTER PROCEDURE MostrarCostesSalariales AS 
BEGIN
	DECLARE @nDepto VARCHAR(15)
	DECLARE @salario DECIMAL(8,2)
	
	DECLARE costesSalariales CURSOR FOR
	SELECT d.DNAME, SUM(ISNULL(e.SAL, 0)) FROM DEPT d
	FULL JOIN EMP e ON d.DEPTNO = e.DEPTNO
	GROUP BY d.DNAME;

	OPEN costesSalariales
	FETCH costesSalariales into @nDepto, @salario

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		PRINT @nDepto + ' - ' + CAST(@salario AS VARCHAR(10)) + '€'

		FETCH costesSalariales into @nDepto, @salario
	END

	CLOSE costesSalariales

	DEALLOCATE costesSalariales
END

EXEC dbo.MostrarCostesSalariales;

-- ej 5
/*
	Realiza un procedimiento MostrarAbreviaturas que muestre las tres
	primeras letras del nombre de cada empleado.
*/
CREATE OR ALTER PROCEDURE MostrarAbreviaturas AS
BEGIN
	SELECT SUBSTRING(ENAME, 1, 3) FROM EMP;
END

EXEC dbo.MostrarAbreviaturas;

-- ej 6
/*
	Realiza un procedimiento MostrarMasAntiguos que muestre el nombre del 
	empleado más antiguo de cada departamento junto con el nombre del 
	departamento. 
	Trata las excepciones que consideres necesarias.
*/
CREATE OR ALTER PROCEDURE MostrarMasAntiguos AS
BEGIN
	DECLARE @name VARCHAR(15), @hiredate DATE, @ndept int, @dname VARCHAR(10);
	DECLARE mostrarAntiguos CURSOR FOR
	SELECT DEPTNO FROM DEPT
	

	OPEN mostrarAntiguos
	FETCH mostrarAntiguos into @ndept

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @dname = DNAME from DEPT WHERE DEPTNO = @ndept

		SET @name='NINGUNO'
		SET @hiredate=GETDATE()
		SELECT TOP 1 @name = ENAME, @hiredate=HIREDATE
		FROM EMP
		WHERE DEPTNO=@ndept
		ORDER BY HIREDATE 

		PRINT @name + ' - ' + CAST(@hiredate AS VARCHAR(20)) + ' - ' + @dname
		
		FETCH mostrarAntiguos into @ndept
	END

	CLOSE mostrarAntiguos

	DEALLOCATE mostrarAntiguos
END

EXEC MostrarMasAntiguos

-- ej 7
/*
	Realiza un procedimiento MostrarJefes que reciba el nombre de un 
	departamento y muestre los nombres de los empleados de ese departamento 
	que son jefes de otros empleados.
	
	Trata las excepciones que consideres necesarias.
*/
CREATE OR ALTER PROCEDURE MostrarJefes(@ndepto VARCHAR(15)) AS
BEGIN
	DECLARE @empName VARCHAR(15)
	DECLARE @deptname VARCHAR(15)

	SET @deptname = (SELECT DNAME FROM DEPT WHERE DNAME LIKE '%' +  @ndepto + '%')

	IF (@deptname = null)
	BEGIN
		PRINT 'Departamento no encontrado.'
	END
	ELSE
	BEGIN
		DECLARE cJefes CURSOR FOR
		SELECT e.ENAME FROM EMP e
		INNER JOIN DEPT d ON e.DEPTNO = d.DEPTNO
		WHERE e.MGR is NOT NULL and d.DNAME LIKE '%' + @ndepto + '%';

		PRINT 'El departamento es: ' + @deptname

		OPEN cJefes
		FETCH cJefes INTO @empName

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT @empName + ' es jefe.'

			FETCH cJefes INTO @empName
		END

		CLOSE cJefes
		DEALLOCATE cJEFES
	END
END

EXEC MostrarJefes 'ACCOUNTING'

-- ej 8 
/*
	Realiza un procedimiento MostrarMejoresVendedores que muestre los nombres
	de los dos vendedores con más comisiones. 
	Trata las excepciones que consideres necesarias.
*/
CREATE OR ALTER PROCEDURE MostrarMejoresVendedores AS
BEGIN
	SELECT TOP 2 ENAME FROM EMP
	ORDER BY COMM DESC;
END

SELECT * FROM EMP;

-- ej 10
/*
	Realiza un procedimiento RecortarSueldos que recorte el sueldo un 20%
	a los empleados cuyo nombre empiece por la  letra que recibe como 
	parámetro.
	Trata las excepciones  que consideres necesarias
*/
CREATE OR ALTER PROCEDURE RecortarSueldos (@inicial char) AS
BEGIN
	UPDATE EMP SET SAL=(SAL*0.8) WHERE ENAME LIKE @inicial+'%'
END

EXEC RecortarSueldos 'K'
SELECT * FROM EMP WHERE ENAME LIKE 'K%'

--ej11
/*
	Realiza un procedimiento BorrarBecarios que borre a los dos empleados 
	más nuevos de cada departamento. 
	
	Trata las excepciones que consideres necesarias
*/
CREATE OR ALTER PROCEDURE BorrarBecarios AS
BEGIN
	DECLARE @ndept INT
	DECLARE borrarBecarios CURSOR FOR
	SELECT DEPTNO FROM DEPT

	OPEN borrarBecarios
	FETCH NEXT FROM borrarBecarios INTO @ndept

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DELETE FROM EMP WHERE EMPNO IN (SELECT TOP 2 EMPNO FROM EMP WHERE DEPTNO=@ndept ORDER BY HIREDATE DESC)

		FETCH borrarBecarios INTO @ndept
	END

	CLOSE borrarBecarios
	DEALLOCATE borrarBecarios
END

EXEC BorrarBecarios
