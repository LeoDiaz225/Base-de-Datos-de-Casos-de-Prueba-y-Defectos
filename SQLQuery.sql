CREATE DATABASE QA_Tests;
GO
USE QA_Tests;
GO

-- Tabla de módulos del software
CREATE TABLE Modulos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(MAX) NULL
);
GO


-- Tabla de casos de prueba
CREATE TABLE Casos_Prueba (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    modulo_id INT,
    tipo NVARCHAR(20) NOT NULL CHECK (tipo IN ('Manual', 'Automatizado')),
    FOREIGN KEY (modulo_id) REFERENCES Modulos(id)
);
GO

-- Tabla de ejecuciones de prueba
CREATE TABLE Ejecuciones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    caso_id INT,
    fecha_ejecucion DATETIME DEFAULT GETDATE(),
    resultado NVARCHAR(10) NOT NULL CHECK (resultado IN ('Éxito', 'Fallo')),
    notas NVARCHAR(MAX) NULL,
    FOREIGN KEY (caso_id) REFERENCES Casos_Prueba(id)
);
GO

-- Tabla de defectos
CREATE TABLE Defectos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    caso_id INT,
    severidad NVARCHAR(10) NOT NULL CHECK (severidad IN ('Baja', 'Media', 'Alta', 'Crítica')),
    descripcion NVARCHAR(MAX) NOT NULL,
    estado NVARCHAR(20) NOT NULL CHECK (estado IN ('Nuevo', 'En Progreso', 'Resuelto', 'Cerrado')),
    fecha_reporte DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (caso_id) REFERENCES Casos_Prueba(id)
);
GO

-- INSERCION DE DATOS -- 

-- Insertar módulos del software
INSERT INTO Modulos (nombre, descripcion) VALUES
('Autenticación', 'Módulo encargado del login y gestión de usuarios'),
('Pagos', 'Módulo encargado del procesamiento de pagos'),
('Notificaciones', 'Módulo que gestiona las notificaciones y alertas');
GO

-- Insertar casos de prueba
INSERT INTO Casos_Prueba (titulo, descripcion, modulo_id, tipo) VALUES
('Prueba de login con credenciales válidas', 'Validar acceso con usuario y contraseña correctos', 1, 'Manual'),
('Prueba de login con credenciales incorrectas', 'Verificar que no se permita el acceso con credenciales inválidas', 1, 'Automatizado'),
('Pago con tarjeta de crédito válida', 'Confirmar que una transacción con tarjeta de crédito es procesada correctamente', 2, 'Manual'),
('Prueba de notificación por email', 'Verificar que los usuarios reciben notificaciones por correo electrónico', 3, 'Automatizado');
GO

-- Insertar ejecuciones de prueba
INSERT INTO Ejecuciones (caso_id, fecha_ejecucion, resultado, notas) VALUES
(1, '2025-02-10 10:30:00', 'Éxito', 'El login funcionó correctamente'),
(2, '2025-02-10 10:35:00', 'Fallo', 'El sistema permite acceso con contraseña incorrecta'),
(3, '2025-02-10 11:00:00', 'Éxito', 'Pago aprobado con tarjeta válida'),
(4, '2025-02-10 11:15:00', 'Fallo', 'Correo de notificación no recibido en la bandeja de entrada');
GO

-- Insertar defectos encontrados
INSERT INTO Defectos (caso_id, severidad, descripcion, estado, fecha_reporte) VALUES
(2, 'Alta', 'El sistema permite login con credenciales incorrectas', 'Nuevo', '2025-02-10 10:40:00'),
(4, 'Media', 'Las notificaciones por email no llegan al usuario', 'En Progreso', '2025-02-10 11:20:00');
GO



-- Consultar todos los defectos por módulo
SELECT M.nombre AS Modulo, D.descripcion, D.severidad, D.estado
FROM Defectos D
JOIN Casos_Prueba C ON D.caso_id = C.id
JOIN Modulos M ON C.modulo_id = M.id;


-- Contar defectos por severidad
SELECT severidad, COUNT(*) AS total FROM Defectos GROUP BY severidad;

-- Casos de prueba fallidos
SELECT C.titulo, E.fecha_ejecucion, E.resultado, E.notas
FROM Ejecuciones E
JOIN Casos_Prueba C ON E.caso_id = C.id
WHERE E.resultado = 'Fallo';

-- Consultar defectos abiertos
SELECT * FROM Defectos WHERE estado != 'Cerrado';


