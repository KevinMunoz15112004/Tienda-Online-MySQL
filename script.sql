-- Creacion de la base de datos y tablas

CREATE DATABASE tienda_online;
USE tienda_online;

CREATE TABLE Clientes(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefono VARCHAR(15) NOT NULL,
    Fecha_registro DATE NOT NULL
);

CREATE TABLE Productos(
	Id INT AUTO_INCREMENT PRIMARY KEY,
	Nombre VARCHAR(100) NOT NULL UNIQUE,
    Precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    Stock INT NOT NULL CHECK (stock >= 0),
    Descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE Pedidos(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Cliente_id INT NOT NULL,
    Fecha_pedido DATE NOT NULL,
    Total DECIMAL(10, 2),
    FOREIGN KEY (Cliente_id) REFERENCES Clientes(Id)
);

CREATE TABLE Detalles_Pedido(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Pedido_id INT NOT NULL,
    Producto_id INT NOT NULL,
    Cantidad INT NOT NULL CHECK (cantidad > 0),
    Precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario > 0),
    FOREIGN KEY (Pedido_id) REFERENCES Pedidos(Id),
    FOREIGN KEY (Producto_id) REFERENCES Productos(Id)
);

-- Creación de funciones de usuario

-- Funcion para obtener el nombre completo del cliente

DELIMITER $$

CREATE FUNCTION Obtener_Nombre_Completo(Cliente_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN 
	DECLARE Nombre_Completo VARCHAR(100);
    SELECT CONCAT(Nombre, " ", Apellido) INTO Nombre_Completo
    FROM Clientes
    WHERE Id = Cliente_id;
    RETURN Nombre_Completo;
END $$

DELIMITER ;

-- Función para calcular el descuento de un producto

DELIMITER $$

CREATE FUNCTION Calcular_Descuento(Precio DECIMAL(10, 2), Descuento DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC 
BEGIN
	RETURN Precio - (Precio * Descuento / 100);
END $$

DELIMITER ;

-- Función para calcular el total de un pedido

DELIMITER $$

CREATE FUNCTION Calcular_Total_Pedido(p_Pedido_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
	DECLARE Total DECIMAL(10, 2);
    SELECT SUM(Cantidad * Precio_unitario) INTO Total
    FROM Detalles_Pedido
    WHERE Pedido_id = p_Pedido_id;
    RETURN Total;
END $$

DELIMITER ;

-- Función para verificar la disponibilidad de stock de un producto

DELIMITER $$

CREATE FUNCTION Verificar_Disponibilidad(Producto_id INT, Cantidad_Solicitada INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE Stock_Actual INT;
    SELECT Stock INTO Stock_Actual
    FROM Productos
    WHERE Id = Producto_id;
    RETURN Stock_Actual >= Cantidad_Solicitada;
END $$

DELIMITER ;

-- Función para calcular la antigüedad de un cliente

DELIMITER $$

CREATE FUNCTION Calcular_Antiguedad_Cliente(Cliente_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE Antiguedad INT;
    SELECT TIMESTAMPDIFF(YEAR, Fecha_registro, CURDATE()) INTO Antiguedad
    FROM Clientes
    WHERE Id = Cliente_id;
    RETURN Antiguedad;
END $$

DELIMITER ;

-- Consultas

-- Consulta para obtener el nombre completo de un cliente dado su cliente_id.

SELECT Obtener_Nombre_Completo(3) AS Nombre_Completo;

-- Consulta para calcular el descuento de un producto dado su precio y un descuento del 10%.

SELECT Calcular_Descuento(1000.00, 10) AS Precio_con_descuento;

-- Calcular el total de un pedido dado su pedido_id

SELECT Calcular_Total_Pedido(3) AS Total_pedido;

-- Verificar si un producto tiene suficiente stock para una cantidad solicitada

SELECT Verificar_Disponibilidad(1, 85) AS Disponible_1_0;
SELECT Verificar_Disponibilidad(2, 15) AS Disponible_1_0;

-- Verificar antigüedad del cliente

SELECT Calcular_Antiguedad_Cliente(4) AS Antiguedad_del_cliente;
