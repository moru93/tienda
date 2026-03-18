# Tienda — Sistema de Gestión de Tienda de Barrio

Aplicación web para administrar y gestionar una tienda de productos, abarcando inventario, ventas, compras a proveedores y empleados.

## Base de datos

El archivo [`tienda_db.sql`](tienda_db.sql) contiene el script completo de creación de la base de datos **TIENDA_DB** para MySQL/MariaDB.

### Tablas

| Tabla | Descripción |
|---|---|
| `CATEGORIAS` | Categorías de productos |
| `TIPOS_PRODUCTOS` | Tipos/clasificaciones de productos |
| `PRODUCTOS` | Catálogo de productos con stock y precios |
| `EMPLEADOS` | Información y datos de nómina de empleados |
| `HORARIOS` | Horarios de trabajo por empleado |
| `DISTRIBUIDORES` | Proveedores y distribuidores |
| `VENTAS` | Encabezado de transacciones de venta |
| `DETALLE_VENTAS` | Líneas de detalle de cada venta |
| `COMPRAS` | Encabezado de compras a proveedores |
| `DETALLE_COMPRAS` | Líneas de detalle de cada compra |

### Características

- **Control de inventario automático**: triggers que incrementan o decrementan el stock al registrar ventas y compras, incluyendo correcciones al editar o eliminar líneas de detalle.
- **Validación de stock antes de vender**: un trigger `BEFORE INSERT` lanza un error si la cantidad vendida supera el stock disponible.
- **Totales calculados automáticamente**: triggers `AFTER INSERT/UPDATE/DELETE` mantienen el `TOTAL_PAGADO` de ventas y compras siempre sincronizado con sus detalles.
- **Precio de compra y margen**: el campo `PRECIO_COMPRA` en `PRODUCTOS` permite calcular la rentabilidad por artículo.
- **Stock mínimo configurable**: el campo `STOCK_MINIMO` habilita alertas de reposición.
- **Vistas listas para usar**: `VW_PRODUCTOS_COMPLETO`, `VW_STOCK_BAJO`, `VW_RENTABILIDAD`, `VW_VENTAS_DETALLE`, `VW_COMPRAS_DETALLE`, `VW_VENTAS_POR_DIA`.
- **Procedimientos almacenados**: `SP_REGISTRAR_VENTA`, `SP_AGREGAR_DETALLE_VENTA`, `SP_REGISTRAR_COMPRA`, `SP_AGREGAR_DETALLE_COMPRA` con manejo de transacciones.
- **Índices de rendimiento**: índices en columnas de búsqueda frecuente.
- **Datos de ejemplo**: categorías, tipos, empleados, distribuidores y productos de muestra.

### Requisitos

- MySQL 8.0+ o MariaDB 10.3+

### Ejecución

```bash
mysql -u <usuario> -p < tienda_db.sql
```

o desde el cliente MySQL:

```sql
SOURCE tienda_db.sql;
```
