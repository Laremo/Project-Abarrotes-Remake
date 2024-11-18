package Mapeos;

import java.sql.Timestamp;

public class Compra implements java.io.Serializable {

    private int id;
    private int idCliente;
    private int idProducto;
    private int cantidad;
    private int numero;
    private Timestamp fecha;
    Producto producto;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public int getNumero(){
        return this.numero;
    }
    
    public void setNumero(int numero){
        this.numero = numero;
    }
    
    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public Producto getProducto() {
        return this.producto;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public Timestamp getFecha() {
        return fecha;
    }

    public void setFecha(Timestamp fecha) {
        this.fecha = fecha;
    }
}
