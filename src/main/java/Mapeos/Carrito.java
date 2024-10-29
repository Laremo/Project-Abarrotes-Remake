package Mapeos;

import java.util.List;

public class Carrito implements java.io.Serializable {

    private Integer idCarrito;  // ID del carrito
    private Cliente cliente;  // Cliente al que pertenece el carrito
    private List<Producto> productos;  // Lista de productos en el carrito

    public Carrito() {
    }

    public Carrito(Cliente cliente, List<Producto> productos) {
        this.cliente = cliente;
        this.productos = productos;
    }

    // Getters y setters

    public Integer getIdCarrito() {
        return idCarrito;
    }

    public void setIdCarrito(Integer idCarrito) {
        this.idCarrito = idCarrito;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public List<Producto> getProductos() {
        return productos;
    }

    public void setProductos(List<Producto> productos) {
        this.productos = productos;
    }

    // Método para agregar un producto al carrito
    public void agregarProducto(Producto producto) {
        this.productos.add(producto);
    }

    // Método para remover un producto del carrito
    public void removerProducto(Producto producto) {
        this.productos.remove(producto);
    }

    // Método para vaciar el carrito
    public void vaciarCarrito() {
        this.productos.clear();
    }
}