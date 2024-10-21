-- Tabla Cliente
CREATE TABLE cliente (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre TEXT NOT NULL,
    Apell_pat TEXT NOT NULL,
    Apell_mat TEXT NOT NULL,
    Fecha_nac TEXT,
    RFC TEXT,
    Correo TEXT,
    Password TEXT
);

-- Tabla Empleado
CREATE TABLE empleado (
    No_empleado INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_empleado TEXT NOT NULL,
    password TEXT NOT NULL,
    Apell_pat_empleado TEXT NOT NULL,
    Apell_mat_empleado TEXT NOT NULL,
    Fecha_nac TEXT,
    RFCE TEXT NOT NULL,
    Salario INTEGER NOT NULL,
    estado_civil TEXT,
    estatus TEXT,
    nivel_estudio TEXT,
    tipoUsuario TEXT
);

-- Tabla Empresa
CREATE TABLE empresa (
    id_empresa INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_empresa TEXT NOT NULL,
    Razon_social TEXT,
    Giro TEXT
);

-- Tabla Estado
CREATE TABLE estado (
    id_estado INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_estado TEXT NOT NULL
);

-- Tabla Inventario
CREATE TABLE inventario (
    id_inventario INTEGER PRIMARY KEY,
    Fecha_inv TEXT,
    Entradap INTEGER,
    Salidap INTEGER,
    Saldop INTEGER,
    Entradac REAL,
    Salidac REAL,
    Saldoc REAL,
    Costop REAL,
    Precio REAL,
    id_producto INTEGER NOT NULL,
    id_pedido INTEGER NOT NULL,
    FOREIGN KEY (id_inventario) REFERENCES estado(id_estado),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Tabla Paquete
CREATE TABLE paquete (
    id_paquete INTEGER PRIMARY KEY,
    Cantidad INTEGER,
    id_producto INTEGER NOT NULL,
    id_pedido INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    FOREIGN KEY (id_paquete) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Tabla Pedido
CREATE TABLE pedido (
    id_pedido INTEGER PRIMARY KEY,
    Fecha TEXT,
    Observaciones TEXT NOT NULL,
    Edo_pedido TEXT,
    id_cliente INTEGER NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES cliente(id_cliente)
);

-- Tabla Producto
CREATE TABLE producto (
    id_producto INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_producto TEXT NOT NULL,
    Descripcion TEXT,
    Presentacion TEXT,
    Caducidad TEXT,
    Precio_prov REAL,
    Precio_uni REAL,
    Existencias INTEGER,
    Fech TEXT NOT NULL,
    marca TEXT,
    id_proveedor INTEGER NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- Tabla Proveedor
CREATE TABLE proveedor (
    id_proveedor INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_proveedor TEXT NOT NULL,
    Apell_pat_proveedor TEXT NOT NULL,
    Apell_mat_proveedor TEXT NOT NULL,
    empresa TEXT
);
