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
	A�oPublicacion NUMERIC,
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
('234567890B', 'Ana L�pez', 'Calle Luna 22', 1),
('345678901C', 'Luis Garc�a', 'Avenida Mar 7', 0),
('456789012D', 'Marta Ruiz', 'Plaza Tierra 3', 2),
('567890123E', 'Carlos Sanchez', 'Calle Estrella 11', 0),
('678901234F', 'Laura Mart�n', 'Paseo R�o 18', 1),
('789012345G', 'David Torres', 'Calle Monta�a 8', 0),
('890123456H', 'Mar�a Romero', 'Avenida Viento 9', 2),
('901234567I', 'Pedro Gil', 'Plaza Fuego 10', 0),
('012345678J', 'Sara Fern�ndez', 'Calle Bosque 5', 0);

-- Insertar datos en la tabla LIBROS
INSERT INTO LIBROS (RefLibro, Nombre, Autor, Genero, A�oPublicacion, Editorial) VALUES 
('L001', 'Cien A�os de Soledad', 'Gabriel Garc�a M�rquez', 'Novela', 1967, 'Sudamericana'),
('L002', 'Don Quijote de la Mancha', 'Miguel de Cervantes', 'Novela', 1605, 'Francisco de Robles'),
('L003', 'El Amor en los Tiempos del C�lera', 'Gabriel Garc�a M�rquez', 'Romance', 1985, 'Oveja Negra'),
('L004', 'La Sombra del Viento', 'Carlos Ruiz Zaf�n', 'Novela', 2001, 'Planeta'),
('L005', 'Rayuela', 'Julio Cort�zar', 'Ficci�n', 1963, 'Sudamericana'),
('L006', 'Ficciones', 'Jorge Luis Borges', 'Relatos', 1944, 'Sur'),
('L007', 'Cr�nica de una Muerte Anunciada', 'Gabriel Garc�a M�rquez', 'Cr�nica', 1981, 'Oveja Negra'),
('L008', 'Pedro P�ramo', 'Juan Rulfo', 'Novela', 1955, 'Fondo de Cultura'),
('L009', 'La Casa de los Esp�ritus', 'Isabel Allende', 'Novela', 1982, 'Sudamerica'),
('L010', 'Los Detectives Salvajes', 'Roberto Bola�o', 'Novela', 1998, 'Anagrama');

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
('012345678J', 'L008', '2024-11-10', 24);



-- ej 1
CREATE OR ALTER PROCEDURE ListadoCuatroMasPrestados AS
BEGIN
	DECLARE @idLibro VARCHAR(10)

	DECLARE librosPrestados CURSOR FOR
	SELECT 
END