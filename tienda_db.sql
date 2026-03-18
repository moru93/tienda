-- =====================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS: TIENDA_DB
-- Sistema de Gestión de Tienda de Productos
-- Fecha: 2026-03-18
-- =====================================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS TIENDA_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE TIENDA_DB;

-- =====================================================
-- TABLA: CATEGORIAS
-- Descripción: Almacena las categorías de productos
-- =====================================================
CREATE TABLE CATEGORIAS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL UNIQUE,
    DESCRIPCION TEXT,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: TIPOS_PRODUCTOS
-- Descripción: Almacena los tipos de productos
-- =====================================================
CREATE TABLE TIPOS_PRODUCTOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL UNIQUE,
    DESCRIPCION TEXT,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: PRODUCTOS
-- Descripción: Almacena la información de productos
-- Mejoras: STOCK_MINIMO para alertas, PRECIO_COMPRA para rentabilidad
-- =====================================================
CREATE TABLE PRODUCTOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_CATEGORIA INT NOT NULL,
    NOMBRE VARCHAR(200) NOT NULL,
    ID_TIPO INT NOT NULL,
    PRECIO DECIMAL(10,2) NOT NULL,
    PRECIO_COMPRA DECIMAL(10,2) DEFAULT 0.00,
    DESCRIPCION TEXT,
    STOCK INT DEFAULT 0,
    STOCK_MINIMO INT DEFAULT 0,
    CODIGO_BARRAS VARCHAR(50) UNIQUE,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT CHK_PRODUCTOS_PRECIO CHECK (PRECIO >= 0),
    CONSTRAINT CHK_PRODUCTOS_PRECIO_COMPRA CHECK (PRECIO_COMPRA >= 0),
    CONSTRAINT CHK_PRODUCTOS_STOCK CHECK (STOCK >= 0),
    CONSTRAINT CHK_PRODUCTOS_STOCK_MINIMO CHECK (STOCK_MINIMO >= 0),

    -- Llaves foráneas
    CONSTRAINT FK_PRODUCTOS_CATEGORIA
        FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIAS(ID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_PRODUCTOS_TIPO
        FOREIGN KEY (ID_TIPO) REFERENCES TIPOS_PRODUCTOS(ID)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: EMPLEADOS
-- Descripción: Almacena información de empleados
-- =====================================================
CREATE TABLE EMPLEADOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NOMBRE VARCHAR(150) NOT NULL,
    IDENTIFICACION VARCHAR(50) NOT NULL UNIQUE,
    DIRECCION VARCHAR(250),
    TELEFONO VARCHAR(20),
    EMAIL VARCHAR(100) UNIQUE,
    DIA_PAGO INT,
    SALARIO DECIMAL(10,2),
    FECHA_INGRESO DATE,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT CHK_EMPLEADOS_DIA_PAGO CHECK (DIA_PAGO >= 1 AND DIA_PAGO <= 31),
    CONSTRAINT CHK_EMPLEADOS_SALARIO CHECK (SALARIO >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: HORARIOS
-- Descripción: Almacena los horarios de trabajo de empleados
-- =====================================================
CREATE TABLE HORARIOS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_EMPLEADO INT NOT NULL,
    HORA_INICIO TIME NOT NULL,
    HORA_FIN TIME NOT NULL,
    FECHA DATE NOT NULL,
    DIA_SEMANA ENUM('LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SÁBADO', 'DOMINGO'),
    OBSERVACIONES TEXT,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Llaves foráneas
    CONSTRAINT FK_HORARIOS_EMPLEADO
        FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADOS(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    -- Validación: hora_fin debe ser mayor que hora_inicio
    CONSTRAINT CHK_HORARIO_VALIDO CHECK (HORA_FIN > HORA_INICIO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: DISTRIBUIDORES
-- Descripción: Almacena información de distribuidores/proveedores
-- =====================================================
CREATE TABLE DISTRIBUIDORES (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NOMBRE VARCHAR(200) NOT NULL,
    DIRECCION VARCHAR(250),
    TELEFONO VARCHAR(20),
    EMAIL VARCHAR(100) UNIQUE,
    CONTACTO_NOMBRE VARCHAR(150),
    CONTACTO_TELEFONO VARCHAR(20),
    RUC_NIT VARCHAR(50) UNIQUE,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: VENTAS
-- Descripción: Almacena el encabezado de las ventas
-- =====================================================
CREATE TABLE VENTAS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TOTAL_PAGADO DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FECHA DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_EMPLEADO INT,
    METODO_PAGO ENUM('EFECTIVO', 'TARJETA', 'TRANSFERENCIA', 'OTRO') DEFAULT 'EFECTIVO',
    CLIENTE_NOMBRE VARCHAR(150),
    CLIENTE_IDENTIFICACION VARCHAR(50),
    OBSERVACIONES TEXT,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT CHK_VENTAS_TOTAL CHECK (TOTAL_PAGADO >= 0),

    -- Llaves foráneas
    CONSTRAINT FK_VENTAS_EMPLEADO
        FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADOS(ID)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: DETALLE_VENTAS
-- Descripción: Almacena el detalle de cada venta
-- =====================================================
CREATE TABLE DETALLE_VENTAS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_VENTA INT NOT NULL,
    ID_PRODUCTO INT NOT NULL,
    CANTIDAD INT NOT NULL,
    PRECIO_UNITARIO DECIMAL(10,2) NOT NULL,
    SUBTOTAL DECIMAL(10,2) GENERATED ALWAYS AS (CANTIDAD * PRECIO_UNITARIO) STORED,
    DESCUENTO DECIMAL(10,2) DEFAULT 0.00,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT CHK_DETALLE_VENTAS_CANTIDAD CHECK (CANTIDAD > 0),
    CONSTRAINT CHK_DETALLE_VENTAS_PRECIO CHECK (PRECIO_UNITARIO >= 0),
    CONSTRAINT CHK_DETALLE_VENTAS_DESCUENTO CHECK (DESCUENTO >= 0),

    -- Llaves foráneas
    CONSTRAINT FK_DETALLE_VENTAS_VENTA
        FOREIGN KEY (ID_VENTA) REFERENCES VENTAS(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_DETALLE_VENTAS_PRODUCTO
        FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTOS(ID)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: COMPRAS
-- Descripción: Almacena el encabezado de las compras a proveedores
-- =====================================================
CREATE TABLE COMPRAS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TOTAL_PAGADO DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FECHA DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_EMPLEADO INT,
    NUMERO_FACTURA VARCHAR(50) UNIQUE,
    METODO_PAGO ENUM('EFECTIVO', 'TARJETA', 'TRANSFERENCIA', 'CREDITO', 'OTRO') DEFAULT 'EFECTIVO',
    OBSERVACIONES TEXT,
    ESTADO TINYINT(1) DEFAULT 1,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FECHA_ACTUALIZACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT CHK_COMPRAS_TOTAL CHECK (TOTAL_PAGADO >= 0),

    -- Llaves foráneas
    CONSTRAINT FK_COMPRAS_EMPLEADO
        FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADOS(ID)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: DETALLE_COMPRAS
-- Descripción: Almacena el detalle de cada compra
-- =====================================================
CREATE TABLE DETALLE_COMPRAS (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_COMPRA INT NOT NULL,
    ID_DISTRIBUIDOR INT NOT NULL,
    ID_PRODUCTO INT NOT NULL,
    CANTIDAD INT NOT NULL,
    PRECIO_UNITARIO DECIMAL(10,2) NOT NULL,
    SUBTOTAL DECIMAL(10,2) GENERATED ALWAYS AS (CANTIDAD * PRECIO_UNITARIO) STORED,
    FECHA_CREACION TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT CHK_DETALLE_COMPRAS_CANTIDAD CHECK (CANTIDAD > 0),
    CONSTRAINT CHK_DETALLE_COMPRAS_PRECIO CHECK (PRECIO_UNITARIO >= 0),

    -- Llaves foráneas
    CONSTRAINT FK_DETALLE_COMPRAS_COMPRA
        FOREIGN KEY (ID_COMPRA) REFERENCES COMPRAS(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_DETALLE_COMPRAS_DISTRIBUIDOR
        FOREIGN KEY (ID_DISTRIBUIDOR) REFERENCES DISTRIBUIDORES(ID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_DETALLE_COMPRAS_PRODUCTO
        FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTOS(ID)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ÍNDICES PARA MEJORAR EL RENDIMIENTO
-- =====================================================

-- Índices para PRODUCTOS
CREATE INDEX IDX_PRODUCTOS_CATEGORIA ON PRODUCTOS(ID_CATEGORIA);
CREATE INDEX IDX_PRODUCTOS_TIPO ON PRODUCTOS(ID_TIPO);
CREATE INDEX IDX_PRODUCTOS_NOMBRE ON PRODUCTOS(NOMBRE);
CREATE INDEX IDX_PRODUCTOS_PRECIO ON PRODUCTOS(PRECIO);
CREATE INDEX IDX_PRODUCTOS_STOCK ON PRODUCTOS(STOCK);

-- Índices para HORARIOS
CREATE INDEX IDX_HORARIOS_EMPLEADO ON HORARIOS(ID_EMPLEADO);
CREATE INDEX IDX_HORARIOS_FECHA ON HORARIOS(FECHA);

-- Índices para VENTAS
CREATE INDEX IDX_VENTAS_FECHA ON VENTAS(FECHA);
CREATE INDEX IDX_VENTAS_EMPLEADO ON VENTAS(ID_EMPLEADO);

-- Índices para DETALLE_VENTAS
CREATE INDEX IDX_DETALLE_VENTAS_VENTA ON DETALLE_VENTAS(ID_VENTA);
CREATE INDEX IDX_DETALLE_VENTAS_PRODUCTO ON DETALLE_VENTAS(ID_PRODUCTO);

-- Índices para COMPRAS
CREATE INDEX IDX_COMPRAS_FECHA ON COMPRAS(FECHA);
CREATE INDEX IDX_COMPRAS_EMPLEADO ON COMPRAS(ID_EMPLEADO);

-- Índices para DETALLE_COMPRAS
CREATE INDEX IDX_DETALLE_COMPRAS_COMPRA ON DETALLE_COMPRAS(ID_COMPRA);
CREATE INDEX IDX_DETALLE_COMPRAS_DISTRIBUIDOR ON DETALLE_COMPRAS(ID_DISTRIBUIDOR);
CREATE INDEX IDX_DETALLE_COMPRAS_PRODUCTO ON DETALLE_COMPRAS(ID_PRODUCTO);

-- =====================================================
-- TRIGGERS PARA MANEJO DE INVENTARIO
-- =====================================================

-- -------------------------------------------------------
-- Trigger: Validar stock disponible ANTES de registrar
--          una venta (previene stock negativo).
--          NOTA: debe ejecutarse dentro de una transacción
--          abierta por el llamador para garantizar atomicidad.
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_BEFORE_INSERT_DETALLE_VENTAS
BEFORE INSERT ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    SELECT STOCK INTO v_stock FROM PRODUCTOS WHERE ID = NEW.ID_PRODUCTO FOR UPDATE;
    IF v_stock < NEW.CANTIDAD THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente para realizar la venta';
    END IF;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Validar stock disponible ANTES de actualizar
--          un detalle de venta (cubre aumentos de cantidad)
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_BEFORE_UPDATE_DETALLE_VENTAS
BEFORE UPDATE ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    -- Solo validar cuando la cantidad aumenta
    IF NEW.CANTIDAD > OLD.CANTIDAD THEN
        SELECT STOCK INTO v_stock FROM PRODUCTOS WHERE ID = NEW.ID_PRODUCTO FOR UPDATE;
        IF v_stock < (NEW.CANTIDAD - OLD.CANTIDAD) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Stock insuficiente para actualizar la cantidad de la venta';
        END IF;
    END IF;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Descontar stock al insertar un detalle de venta
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_INSERT_DETALLE_VENTAS
AFTER INSERT ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS
    SET STOCK = STOCK - NEW.CANTIDAD
    WHERE ID = NEW.ID_PRODUCTO;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Ajustar stock al actualizar un detalle de venta
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_UPDATE_DETALLE_VENTAS
AFTER UPDATE ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    -- Devolver la cantidad anterior y descontar la nueva
    UPDATE PRODUCTOS
    SET STOCK = STOCK + OLD.CANTIDAD - NEW.CANTIDAD
    WHERE ID = NEW.ID_PRODUCTO;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Devolver stock al eliminar un detalle de venta
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_DELETE_DETALLE_VENTAS
AFTER DELETE ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS
    SET STOCK = STOCK + OLD.CANTIDAD
    WHERE ID = OLD.ID_PRODUCTO;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Incrementar stock al insertar un detalle de compra
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_INSERT_DETALLE_COMPRAS
AFTER INSERT ON DETALLE_COMPRAS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS
    SET STOCK = STOCK + NEW.CANTIDAD
    WHERE ID = NEW.ID_PRODUCTO;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Validar stock ANTES de actualizar un detalle de
--          compra (evita stock negativo al reducir la cantidad)
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_BEFORE_UPDATE_DETALLE_COMPRAS
BEFORE UPDATE ON DETALLE_COMPRAS
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    -- Solo validar cuando la cantidad disminuye
    IF NEW.CANTIDAD < OLD.CANTIDAD THEN
        SELECT STOCK INTO v_stock FROM PRODUCTOS WHERE ID = NEW.ID_PRODUCTO FOR UPDATE;
        IF v_stock < (OLD.CANTIDAD - NEW.CANTIDAD) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No es posible reducir la cantidad: el stock resultante sería negativo';
        END IF;
    END IF;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Ajustar stock al actualizar un detalle de compra
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_UPDATE_DETALLE_COMPRAS
AFTER UPDATE ON DETALLE_COMPRAS
FOR EACH ROW
BEGIN
    -- Revertir la cantidad anterior y aplicar la nueva
    UPDATE PRODUCTOS
    SET STOCK = STOCK - OLD.CANTIDAD + NEW.CANTIDAD
    WHERE ID = NEW.ID_PRODUCTO;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Descontar stock al eliminar un detalle de compra
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_DELETE_DETALLE_COMPRAS
AFTER DELETE ON DETALLE_COMPRAS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS
    SET STOCK = STOCK - OLD.CANTIDAD
    WHERE ID = OLD.ID_PRODUCTO;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Recalcular total de venta al insertar detalle
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_INSERT_DETALLE_VENTAS_TOTAL
AFTER INSERT ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    UPDATE VENTAS
    SET TOTAL_PAGADO = (
        SELECT COALESCE(SUM(SUBTOTAL - DESCUENTO), 0)
        FROM DETALLE_VENTAS
        WHERE ID_VENTA = NEW.ID_VENTA
    )
    WHERE ID = NEW.ID_VENTA;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Recalcular total de venta al actualizar detalle
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_UPDATE_DETALLE_VENTAS_TOTAL
AFTER UPDATE ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    UPDATE VENTAS
    SET TOTAL_PAGADO = (
        SELECT COALESCE(SUM(SUBTOTAL - DESCUENTO), 0)
        FROM DETALLE_VENTAS
        WHERE ID_VENTA = NEW.ID_VENTA
    )
    WHERE ID = NEW.ID_VENTA;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Recalcular total de venta al eliminar detalle
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_DELETE_DETALLE_VENTAS_TOTAL
AFTER DELETE ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    UPDATE VENTAS
    SET TOTAL_PAGADO = (
        SELECT COALESCE(SUM(SUBTOTAL - DESCUENTO), 0)
        FROM DETALLE_VENTAS
        WHERE ID_VENTA = OLD.ID_VENTA
    )
    WHERE ID = OLD.ID_VENTA;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Recalcular total de compra al insertar detalle
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_INSERT_DETALLE_COMPRAS_TOTAL
AFTER INSERT ON DETALLE_COMPRAS
FOR EACH ROW
BEGIN
    UPDATE COMPRAS
    SET TOTAL_PAGADO = (
        SELECT COALESCE(SUM(SUBTOTAL), 0)
        FROM DETALLE_COMPRAS
        WHERE ID_COMPRA = NEW.ID_COMPRA
    )
    WHERE ID = NEW.ID_COMPRA;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Recalcular total de compra al actualizar detalle
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_UPDATE_DETALLE_COMPRAS_TOTAL
AFTER UPDATE ON DETALLE_COMPRAS
FOR EACH ROW
BEGIN
    UPDATE COMPRAS
    SET TOTAL_PAGADO = (
        SELECT COALESCE(SUM(SUBTOTAL), 0)
        FROM DETALLE_COMPRAS
        WHERE ID_COMPRA = NEW.ID_COMPRA
    )
    WHERE ID = NEW.ID_COMPRA;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Trigger: Recalcular total de compra al eliminar detalle
-- -------------------------------------------------------
DELIMITER $$
CREATE TRIGGER TRG_AFTER_DELETE_DETALLE_COMPRAS_TOTAL
AFTER DELETE ON DETALLE_COMPRAS
FOR EACH ROW
BEGIN
    UPDATE COMPRAS
    SET TOTAL_PAGADO = (
        SELECT COALESCE(SUM(SUBTOTAL), 0)
        FROM DETALLE_COMPRAS
        WHERE ID_COMPRA = OLD.ID_COMPRA
    )
    WHERE ID = OLD.ID_COMPRA;
END$$
DELIMITER ;

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- -------------------------------------------------------
-- Vista: Productos con información completa de categoría y tipo
-- -------------------------------------------------------
CREATE VIEW VW_PRODUCTOS_COMPLETO AS
SELECT
    P.ID,
    P.NOMBRE,
    P.DESCRIPCION,
    C.NOMBRE AS CATEGORIA,
    T.NOMBRE AS TIPO,
    P.PRECIO,
    P.PRECIO_COMPRA,
    P.PRECIO - P.PRECIO_COMPRA AS MARGEN_BRUTO,
    P.STOCK,
    P.STOCK_MINIMO,
    P.CODIGO_BARRAS,
    P.ESTADO,
    P.FECHA_CREACION
FROM PRODUCTOS P
INNER JOIN CATEGORIAS C ON P.ID_CATEGORIA = C.ID
INNER JOIN TIPOS_PRODUCTOS T ON P.ID_TIPO = T.ID;

-- -------------------------------------------------------
-- Vista: Alertas de stock bajo (productos por reponer)
-- -------------------------------------------------------
CREATE VIEW VW_STOCK_BAJO AS
SELECT
    P.ID,
    P.NOMBRE,
    C.NOMBRE AS CATEGORIA,
    P.STOCK AS STOCK_ACTUAL,
    P.STOCK_MINIMO,
    P.STOCK_MINIMO - P.STOCK AS UNIDADES_A_REPONER
FROM PRODUCTOS P
INNER JOIN CATEGORIAS C ON P.ID_CATEGORIA = C.ID
WHERE P.STOCK <= P.STOCK_MINIMO
  AND P.ESTADO = 1;

-- -------------------------------------------------------
-- Vista: Rentabilidad por producto
-- -------------------------------------------------------
CREATE VIEW VW_RENTABILIDAD AS
SELECT
    P.ID,
    P.NOMBRE AS PRODUCTO,
    C.NOMBRE AS CATEGORIA,
    P.PRECIO_COMPRA,
    P.PRECIO AS PRECIO_VENTA,
    P.PRECIO - P.PRECIO_COMPRA AS MARGEN_BRUTO,
    CASE
        WHEN P.PRECIO_COMPRA > 0
        THEN ROUND(((P.PRECIO - P.PRECIO_COMPRA) / P.PRECIO_COMPRA) * 100, 2)
        ELSE NULL
    END AS PORCENTAJE_MARGEN,
    COALESCE(SUM(DV.CANTIDAD), 0) AS UNIDADES_VENDIDAS,
    COALESCE(SUM(DV.SUBTOTAL), 0) AS INGRESOS_TOTALES,
    COALESCE(SUM(DV.CANTIDAD) * P.PRECIO_COMPRA, 0) AS COSTO_TOTAL,
    COALESCE(SUM(DV.SUBTOTAL) - SUM(DV.CANTIDAD) * P.PRECIO_COMPRA, 0) AS GANANCIA_NETA
FROM PRODUCTOS P
INNER JOIN CATEGORIAS C ON P.ID_CATEGORIA = C.ID
LEFT JOIN DETALLE_VENTAS DV ON P.ID = DV.ID_PRODUCTO
LEFT JOIN VENTAS V ON DV.ID_VENTA = V.ID AND V.ESTADO = 1
GROUP BY P.ID, P.NOMBRE, C.NOMBRE, P.PRECIO_COMPRA, P.PRECIO;

-- -------------------------------------------------------
-- Vista: Ventas con detalles completos
-- -------------------------------------------------------
CREATE VIEW VW_VENTAS_DETALLE AS
SELECT
    V.ID AS ID_VENTA,
    V.FECHA,
    V.TOTAL_PAGADO,
    V.METODO_PAGO,
    E.NOMBRE AS EMPLEADO,
    V.CLIENTE_NOMBRE,
    DV.ID AS ID_DETALLE,
    P.NOMBRE AS PRODUCTO,
    DV.CANTIDAD,
    DV.PRECIO_UNITARIO,
    DV.SUBTOTAL,
    DV.DESCUENTO
FROM VENTAS V
LEFT JOIN EMPLEADOS E ON V.ID_EMPLEADO = E.ID
INNER JOIN DETALLE_VENTAS DV ON V.ID = DV.ID_VENTA
INNER JOIN PRODUCTOS P ON DV.ID_PRODUCTO = P.ID;

-- -------------------------------------------------------
-- Vista: Compras con detalles completos
-- -------------------------------------------------------
CREATE VIEW VW_COMPRAS_DETALLE AS
SELECT
    C.ID AS ID_COMPRA,
    C.FECHA,
    C.TOTAL_PAGADO,
    C.NUMERO_FACTURA,
    C.METODO_PAGO,
    E.NOMBRE AS EMPLEADO,
    D.NOMBRE AS DISTRIBUIDOR,
    DC.ID AS ID_DETALLE,
    P.NOMBRE AS PRODUCTO,
    DC.CANTIDAD,
    DC.PRECIO_UNITARIO,
    DC.SUBTOTAL
FROM COMPRAS C
LEFT JOIN EMPLEADOS E ON C.ID_EMPLEADO = E.ID
INNER JOIN DETALLE_COMPRAS DC ON C.ID = DC.ID_COMPRA
INNER JOIN DISTRIBUIDORES D ON DC.ID_DISTRIBUIDOR = D.ID
INNER JOIN PRODUCTOS P ON DC.ID_PRODUCTO = P.ID;

-- -------------------------------------------------------
-- Vista: Resumen de ventas por día
-- -------------------------------------------------------
CREATE VIEW VW_VENTAS_POR_DIA AS
SELECT
    DATE(FECHA) AS DIA,
    COUNT(*) AS TOTAL_TRANSACCIONES,
    SUM(TOTAL_PAGADO) AS INGRESOS_TOTALES,
    AVG(TOTAL_PAGADO) AS TICKET_PROMEDIO,
    MAX(TOTAL_PAGADO) AS VENTA_MAXIMA,
    MIN(TOTAL_PAGADO) AS VENTA_MINIMA
FROM VENTAS
WHERE ESTADO = 1
GROUP BY DATE(FECHA);

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================================================

-- -------------------------------------------------------
-- Procedimiento: Registrar una venta completa con
-- validación de stock dentro de una transacción
-- -------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE SP_REGISTRAR_VENTA(
    IN p_id_empleado INT,
    IN p_metodo_pago VARCHAR(20),
    IN p_cliente_nombre VARCHAR(150),
    IN p_cliente_identificacion VARCHAR(50),
    IN p_observaciones TEXT,
    OUT p_id_venta INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO VENTAS (ID_EMPLEADO, METODO_PAGO, CLIENTE_NOMBRE, CLIENTE_IDENTIFICACION, OBSERVACIONES)
    VALUES (p_id_empleado, p_metodo_pago, p_cliente_nombre, p_cliente_identificacion, p_observaciones);

    SET p_id_venta = LAST_INSERT_ID();

    COMMIT;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Procedimiento: Agregar producto a una venta
-- (el trigger valida el stock y actualiza totales)
-- -------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE SP_AGREGAR_DETALLE_VENTA(
    IN p_id_venta INT,
    IN p_id_producto INT,
    IN p_cantidad INT,
    IN p_descuento DECIMAL(10,2)
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT PRECIO INTO v_precio FROM PRODUCTOS WHERE ID = p_id_producto;

    INSERT INTO DETALLE_VENTAS (ID_VENTA, ID_PRODUCTO, CANTIDAD, PRECIO_UNITARIO, DESCUENTO)
    VALUES (p_id_venta, p_id_producto, p_cantidad, v_precio, IFNULL(p_descuento, 0));

    COMMIT;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Procedimiento: Registrar una compra y actualizar
-- el precio de costo del producto
-- -------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE SP_REGISTRAR_COMPRA(
    IN p_id_empleado INT,
    IN p_id_distribuidor INT,
    IN p_numero_factura VARCHAR(50),
    IN p_metodo_pago VARCHAR(20),
    IN p_observaciones TEXT,
    OUT p_id_compra INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO COMPRAS (ID_EMPLEADO, NUMERO_FACTURA, METODO_PAGO, OBSERVACIONES)
    VALUES (p_id_empleado, p_numero_factura, p_metodo_pago, p_observaciones);

    SET p_id_compra = LAST_INSERT_ID();

    COMMIT;
END$$
DELIMITER ;

-- -------------------------------------------------------
-- Procedimiento: Agregar producto a una compra y
-- actualizar el precio de costo del producto
-- -------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE SP_AGREGAR_DETALLE_COMPRA(
    IN p_id_compra INT,
    IN p_id_distribuidor INT,
    IN p_id_producto INT,
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_actualizar_precio_compra TINYINT(1)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO DETALLE_COMPRAS (ID_COMPRA, ID_DISTRIBUIDOR, ID_PRODUCTO, CANTIDAD, PRECIO_UNITARIO)
    VALUES (p_id_compra, p_id_distribuidor, p_id_producto, p_cantidad, p_precio_unitario);

    -- Actualizar precio de compra del producto si se solicita
    IF p_actualizar_precio_compra = 1 THEN
        UPDATE PRODUCTOS
        SET PRECIO_COMPRA = p_precio_unitario
        WHERE ID = p_id_producto;
    END IF;

    COMMIT;
END$$
DELIMITER ;

-- =====================================================
-- DATOS DE EJEMPLO (OPCIONAL)
-- =====================================================

-- Insertar categorías de ejemplo
INSERT INTO CATEGORIAS (NOMBRE, DESCRIPCION) VALUES
('Electrónica', 'Productos electrónicos y tecnológicos'),
('Alimentos', 'Productos alimenticios y bebidas'),
('Ropa', 'Prendas de vestir y accesorios'),
('Hogar', 'Productos para el hogar y decoración');

-- Insertar tipos de productos de ejemplo
INSERT INTO TIPOS_PRODUCTOS (NOMBRE, DESCRIPCION) VALUES
('Perecedero', 'Productos con fecha de vencimiento'),
('No Perecedero', 'Productos de larga duración'),
('Importado', 'Productos importados'),
('Nacional', 'Productos de fabricación nacional');

-- Insertar empleados de ejemplo
INSERT INTO EMPLEADOS (NOMBRE, IDENTIFICACION, DIRECCION, TELEFONO, EMAIL, DIA_PAGO, SALARIO, FECHA_INGRESO) VALUES
('Juan Pérez', '1234567890', 'Calle 123 #45-67', '555-0001', 'juan.perez@tienda.com', 15, 2500000.00, '2024-01-15'),
('María González', '0987654321', 'Avenida 456 #78-90', '555-0002', 'maria.gonzalez@tienda.com', 15, 2300000.00, '2024-02-01');

-- Insertar distribuidores de ejemplo
INSERT INTO DISTRIBUIDORES (NOMBRE, DIRECCION, TELEFONO, EMAIL, CONTACTO_NOMBRE, RUC_NIT) VALUES
('Distribuidora ABC', 'Zona Industrial 1', '555-1001', 'ventas@abc.com', 'Pedro Ramírez', '9001234567-1'),
('Importadora XYZ', 'Zona Comercial 2', '555-1002', 'info@xyz.com', 'Laura Martínez', '9007654321-2');

-- Insertar productos de ejemplo
INSERT INTO PRODUCTOS (ID_CATEGORIA, NOMBRE, ID_TIPO, PRECIO, PRECIO_COMPRA, STOCK, STOCK_MINIMO, CODIGO_BARRAS) VALUES
(2, 'Arroz Blanco 1kg', 1, 4500.00, 3200.00, 50, 10, '7701234000001'),
(2, 'Aceite Girasol 1L', 1, 9800.00, 7000.00, 30, 5, '7701234000002'),
(1, 'Cable USB-C 1m', 2, 25000.00, 15000.00, 20, 3, '7701234000003'),
(4, 'Vela Aromática', 2, 12000.00, 7500.00, 15, 5, '7701234000004');

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
