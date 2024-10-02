CREATE DATABASE Juvenil
GO
use Juvenil
GO

CREATE TABLE SOCIOS (
	DNI VARCHAR(10) NOT NULL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Direccion VARCHAR(20),
	Penalizaciones NUMERIC(2) DEFAULT 0
);

CREATE TABLE LIBROS (
	RefLibro VARCHAR(10) NOT NULL PRIMARY KEY,
	Nombre VARCHAR(30) NOT NULL,
	Autor VARCHAR(30) NOT NULL,
	Genero VARCHAR(10),
	AñoPublicacion NUMERIC,
	Editorial VARCHAR(10)
)

CREATE TABLE PRESTAMOS(
	DNI VARCHAR(10) NOT NULL,
	RefLibro VARCHAR(10) NOT NULL,
	FechaPrestamo DATE NOT NULL,
	Duracion NUMERIC DEFAULT 24,
	CONSTRAINT PK_Prestamos PRIMARY KEY (DNI, RefLibro, FechaPrestamo)
)

-- Insertar datos en la tabla SOCIOS
INSERT INTO SOCIOS (DNI, Nombre, Direccion, Penalizaciones) VALUES 
('123456789A', 'Juan Perez', 'Calle Sol 15', 0),
('234567890B', 'Ana López', 'Calle Luna 22', 1),
('345678901C', 'Luis García', 'Avenida Mar 7', 0),
('456789012D', 'Marta Ruiz', 'Plaza Tierra 3', 2),
('567890123E', 'Carlos Sanchez', 'Calle Estrella 11', 0),
('678901234F', 'Laura Martín', 'Paseo Río 18', 1),
('789012345G', 'David Torres', 'Calle Montaña 8', 0),
('890123456H', 'María Romero', 'Avenida Viento 9', 2),
('901234567I', 'Pedro Gil', 'Plaza Fuego 10', 0),
('012345678J', 'Sara Fernández', 'Calle Bosque 5', 0);

-- Insertar datos en la tabla LIBROS
INSERT INTO LIBROS (RefLibro, Nombre, Autor, Genero, AñoPublicacion, Editorial) VALUES 
('L001', 'Cien Años de Soledad', 'Gabriel García Márquez', 'Novela', 1967, 'America'),
('L002', 'Don Quijote de la Mancha', 'Miguel de Cervantes', 'Novela', 1605, 'Francisco'),
('L003', 'El Amor en los Tiempos', 'Gabriel García Márquez', 'Romance', 1985, 'Oveja'),
('L004', 'La Sombra del Viento', 'Carlos Ruiz Zafón', 'Novela', 2001, 'Planeta'),
('L005', 'Rayuela', 'Julio Cortázar', 'Ficción', 1963, 'America'),
('L006', 'Ficciones', 'Jorge Luis Borges', 'Relatos', 1944, 'Sur'),
('L007', 'Crónica de una Muerte', 'Gabriel García Márquez', 'Crónica', 1981, 'Oveja'),
('L008', 'Pedro Páramo', 'Juan Rulfo', 'Novela', 1955, 'Cultura'),
('L009', 'La Casa de los Espíritus', 'Isabel Allende', 'Novela', 1982, 'America'),
('L010', 'Los Detectives Salvajes', 'Roberto Bolaño', 'Novela', 1998, 'Anagrama');

-- Insertar datos en la tabla PRESTAMOS
INSERT INTO PRESTAMOS (DNI, RefLibro, FechaPrestamo, Duracion) VALUES 
('123456789A', 'L002', '2024-10-03', 24),
('123456789A', 'L003', '2024-10-07', 30),
('234567890B', 'L001', '2024-10-04', 20),
('234567890B', 'L004', '2024-10-06', 24),
('345678901C', 'L002', '2024-10-10', 24),
('345678901C', 'L006', '2024-10-12', 15),
('456789012D', 'L003', '2024-10-14', 24),
('456789012D', 'L007', '2024-10-16', 30),
('567890123E', 'L005', '2024-10-18', 24),
('567890123E', 'L008', '2024-10-19', 20),
('678901234F', 'L001', '2024-10-20', 24),
('678901234F', 'L009', '2024-10-22', 24),
('789012345G', 'L007', '2024-10-23', 24),
('789012345G', 'L010', '2024-10-24', 25),
('890123456H', 'L005', '2024-10-25', 15),
('890123456H', 'L008', '2024-10-26', 30),
('901234567I', 'L004', '2024-10-28', 24),
('901234567I', 'L009', '2024-10-29', 20),
('012345678J', 'L006', '2024-10-30', 24),
('012345678J', 'L010', '2024-10-31', 24),
('123456789A', 'L009', '2024-11-01', 30),
('234567890B', 'L010', '2024-11-02', 24),
('345678901C', 'L001', '2024-11-03', 20),
('456789012D', 'L005', '2024-11-04', 24),
('567890123E', 'L002', '2024-11-05', 30),
('678901234F', 'L003', '2024-11-06', 24),
('789012345G', 'L004', '2024-11-07', 20),
('890123456H', 'L006', '2024-11-08', 25),
('901234567I', 'L007', '2024-11-09', 30),
('012345678J', 'L008', '2024-11-10', 24),
('234567890B', 'L005', '2024-10-05', 15),
('345678901C', 'L009', '2024-10-08', 20),
('456789012D', 'L002', '2024-10-11', 30),
('567890123E', 'L010', '2024-10-15', 24),
('678901234F', 'L007', '2024-10-17', 18),
('789012345G', 'L002', '2024-10-21', 12),
('890123456H', 'L003', '2024-10-27', 21),
('901234567I', 'L006', '2024-11-01', 30),
('012345678J', 'L008', '2024-11-03', 24),
('123456789A', 'L001', '2024-11-05', 15);



-- ej 1
CREATE OR ALTER PROCEDURE ListadoCuatroMasPrestados AS
BEGIN
	DECLARE @nombreLibro VARCHAR(30), @idLibro VARCHAR(10), @nPrestamos INT, @genero VARCHAR(10)

	DECLARE librosPrestados CURSOR FOR
	SELECT DISTINCT TOP 4 RefLibro, COUNT(RefLibro) FROM PRESTAMOS
	GROUP BY RefLibro ORDER BY COUNT(RefLibro) DESC

	OPEN librosPrestados
		
	FETCH librosPrestados INTO @idLibro, @nPrestamos

	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @nombreLibro=Nombre, @genero=Genero FROM LIBROS WHERE RefLibro = @idLibro

		PRINT 'Nombre: ' + @nombreLibro + ' Préstamos: ' + CAST(@nPrestamos as VARCHAR(5)) + ' Género: ' + @genero

		DECLARE @dni VARCHAR(10)
		DECLARE @fechaPrestamo DATE
		DECLARE prestamosLibros CURSOR FOR
		SELECT DNI, FechaPrestamo FROM PRESTAMOS WHERE RefLibro = @idLibro

		OPEN prestamosLibros

		FETCH prestamosLibros INTO @dni, @fechaPrestamo

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT '	DNI: ' + @dni + ' FechaPrestamo: ' + CAST(@fechaPrestamo as VARCHAR(15))

			FETCH prestamosLibros INTO @dni, @fechaPrestamo
		END

		CLOSE prestamosLibros

		DEALLOCATE prestamosLibros


		FETCH librosPrestados INTO @idLibro, @nPrestamos
	END

	CLOSE librosPrestados

	DEALLOCATE librosPrestados
END

EXEC ListadoCuatroMasPrestados

use Nervion
-- ej 2
CREATE OR ALTER PROCEDURE estadisticasModulo(@modulo VARCHAR(25)) AS
BEGIN
	DECLARE @nModulo VARCHAR(25), @cod int

	SELECT @nModulo = NOMBRE, @cod = COD FROM ASIGNATURAS WHERE NOMBRE LIKE '%' + @modulo + '%'

	IF EXISTS(SELECT 1 FROM ASIGNATURAS WHERE NOMBRE LIKE '%' + @modulo + '%')
	BEGIN
		PRINT @nModulo
		DECLARE @nombre VARCHAR(30), @nota int
		DECLARE @nAprobados INT = 0
		DECLARE @nSuspensos INT = 0
		DECLARE @nNotables INT = 0
		DECLARE @nSobresalientes INT = 0
		DECLARE @nombreMasAlta VARCHAR(25)
		DECLARE @notaMasAlta INT = 0
		DECLARE @nombreMasBaja VARCHAR(25)
		DECLARE @notaMasBaja INT = 10

		DECLARE alumnos CURSOR FOR
		SELECT alumnos.APENOM, notas.NOTA FROM NOTAS notas
		INNER JOIN ALUMNOS alumnos ON notas.DNI = alumnos.DNI WHERE notas.COD = @cod

		OPEN alumnos

		FETCH alumnos INTO @nombre, @nota 

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT 'Nombre: ' + @nombre + '	Nota: ' + CAST(@nota as VARCHAR(2))

			IF @nota > @notaMasAlta
			BEGIN
				SET @notaMasAlta = @nota 
				SET @nombreMasAlta = @nombre
			END

			IF @nota < @notaMasBaja 
			BEGIN
				SET @notaMasBaja = @nota
				SET @nombreMasBaja = @nombre
			END

			IF @nota >= 5
			BEGIN
				SET @nAprobados = @nAprobados + 1

				IF @nota = 8 or @nota = 9
				BEGIN
					SET @nNotables = @nNotables + 1
				END
				ELSE IF @nota = 10
				BEGIN
					SET @nSobresalientes = @nSobresalientes + 1
				END
			END
			ELSE 
			BEGIN
				SET @nSuspensos = @nSuspensos + 1
			END

			FETCH alumnos INTO @nombre, @nota
		END

		CLOSE alumnos

		DEALLOCATE alumnos

		PRINT 'Aprobados: ' + CAST(@nAprobados AS VARCHAR(2))
		PRINT 'Suspensos: ' + CAST(@nSuspensos AS VARCHAR(2))
		PRINT 'Notables: ' + CAST(@nNotables AS VARCHAR(2))
		PRINT 'Sobresalientes: ' + CAST(@nSobresalientes AS VARCHAR(2))
		PRINT 'Nota más baja: ' + @nombreMasBaja + ' Nota: ' + CAST(@notaMasBaja as VARCHAR(2))
		PRINT 'Nota más alta: ' + @nombreMasAlta + ' Nota: ' + CAST(@notaMasAlta as VARCHAR(2))
	END
	ELSE
	BEGIN
		PRINT 'El módulo no existe'
	END
END

EXEC estadisticasModulo 'Ret'

-- ej 3

