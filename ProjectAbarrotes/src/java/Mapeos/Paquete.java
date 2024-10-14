package java.Mapeos;
// Generated 27/10/2014 08:16:01 AM by Hibernate Tools 4.3.1



/**
 * Paquete generated by hbm2java
 */
public class Paquete  implements java.io.Serializable {


     private Integer idPaquete;
     private Cliente cliente;
     private Pedido pedido;
     private Producto producto;
     private Integer cantidad;
     private int idProducto;
     private int idPedido;
     private int idCliente;

    public Paquete() {
    }

	
    public Paquete(Cliente cliente, Pedido pedido, Producto producto, int idProducto, int idPedido, int idCliente) {
        this.cliente = cliente;
        this.pedido = pedido;
        this.producto = producto;
        this.idProducto = idProducto;
        this.idPedido = idPedido;
        this.idCliente = idCliente;
    }
    public Paquete(Cliente cliente, Pedido pedido, Producto producto, Integer cantidad, int idProducto, int idPedido, int idCliente) {
       this.cliente = cliente;
       this.pedido = pedido;
       this.producto = producto;
       this.cantidad = cantidad;
       this.idProducto = idProducto;
       this.idPedido = idPedido;
       this.idCliente = idCliente;
    }
   
    public Integer getIdPaquete() {
        return this.idPaquete;
    }
    
    public void setIdPaquete(Integer idPaquete) {
        this.idPaquete = idPaquete;
    }
    public Cliente getCliente() {
        return this.cliente;
    }
    
    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }
    public Pedido getPedido() {
        return this.pedido;
    }
    
    public void setPedido(Pedido pedido) {
        this.pedido = pedido;
    }
    public Producto getProducto() {
        return this.producto;
    }
    
    public void setProducto(Producto producto) {
        this.producto = producto;
    }
    public Integer getCantidad() {
        return this.cantidad;
    }
    
    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
    }
    public int getIdProducto() {
        return this.idProducto;
    }
    
    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }
    public int getIdPedido() {
        return this.idPedido;
    }
    
    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }
    public int getIdCliente() {
        return this.idCliente;
    }
    
    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }




}


