# Base de Datos de Casos de Prueba y Defectos

## 📌 Descripción
Este proyecto proporciona una base de datos en **SQL Server** para gestionar **casos de prueba y defectos** en un proceso de testing de software. La base de datos permite almacenar pruebas manuales y automatizadas, registrar sus ejecuciones y analizar defectos encontrados en distintos módulos de un software.

## 🎯 Objetivos
- Gestionar **casos de prueba** (manuales y automatizados).
- Registrar **ejecuciones de prueba** con resultados (éxito o fallo).
- Documentar **defectos** y analizarlos por severidad y estado.
- Obtener información clave con consultas para detectar tendencias y mejorar la calidad del software.

---
## 🛠️ Requisitos
- **SQL Server** (cualquier versión reciente: 2017, 2019 o superior).
- **SQL Server Management Studio (SSMS)** (opcional pero recomendado para ejecutar las consultas).

---
## 🚀 Instalación y Configuración
Sigue estos pasos para configurar y ejecutar la base de datos en **SQL Server**:

### 1️⃣ Crear la Base de Datos
Ejecuta el siguiente comando en **SQL Server Management Studio (SSMS)**:
```sql
CREATE DATABASE QA_Tests;
GO
USE QA_Tests;
GO
```

### 2️⃣ Crear las Tablas
Ejecuta el siguiente script para crear las tablas necesarias:
```sql
-- Tabla de módulos del software
CREATE TABLE Modulos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT
);

-- Tabla de casos de prueba
CREATE TABLE Casos_Prueba (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    modulo_id INT,
    tipo VARCHAR(20) CHECK (tipo IN ('Manual', 'Automatizado')) NOT NULL,
    FOREIGN KEY (modulo_id) REFERENCES Modulos(id)
);

-- Tabla de ejecuciones de prueba
CREATE TABLE Ejecuciones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    caso_id INT,
    fecha_ejecucion DATETIME DEFAULT GETDATE(),
    resultado VARCHAR(10) CHECK (resultado IN ('Éxito', 'Fallo')) NOT NULL,
    notas TEXT,
    FOREIGN KEY (caso_id) REFERENCES Casos_Prueba(id)
);

-- Tabla de defectos
CREATE TABLE Defectos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    caso_id INT,
    severidad VARCHAR(10) CHECK (severidad IN ('Baja', 'Media', 'Alta', 'Crítica')) NOT NULL,
    descripcion TEXT NOT NULL,
    estado VARCHAR(15) CHECK (estado IN ('Nuevo', 'En Progreso', 'Resuelto', 'Cerrado')) NOT NULL,
    fecha_reporte DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (caso_id) REFERENCES Casos_Prueba(id)
);
GO
```

### 3️⃣ Insertar Datos de Prueba
Ejecuta este script para poblar la base de datos con datos iniciales:
```sql
-- Insertar módulos
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
```

---
## 🔍 Consultas Útiles
Puedes ejecutar las siguientes consultas para analizar los datos:

### 📌 Obtener cantidad de defectos por severidad:
```sql
SELECT severidad, COUNT(*) AS cantidad FROM Defectos GROUP BY severidad;
```

### 📌 Listar todos los defectos en estado "Nuevo" o "En Progreso":
```sql
SELECT * FROM Defectos WHERE estado IN ('Nuevo', 'En Progreso');
```

### 📌 Ver tasa de éxito/fallo en ejecuciones de prueba:
```sql
SELECT resultado, COUNT(*) AS total FROM Ejecuciones GROUP BY resultado;
```

---
## 📢 Contribuciones
Si tienes sugerencias para mejorar este proyecto, ¡las contribuciones son bienvenidas! Puedes hacer un **fork** del repositorio y enviar un **pull request** con tus mejoras.

---
## 📜 Licencia
Este proyecto es de código abierto y puede ser utilizado libremente para fines educativos y profesionales.

---
## 📞 Contacto
Si tienes dudas o sugerencias, puedes encontrarme en **GitHub** o enviarme un mensaje.

¡Gracias por revisar este proyecto! 🚀

