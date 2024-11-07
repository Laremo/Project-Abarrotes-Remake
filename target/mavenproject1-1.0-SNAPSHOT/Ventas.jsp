<%-- 
    Document   : Ventas
    Created on : 3/01/2014, 12:53:47 PM
    Author     : Search
--%>

<%@page import="Mapeos.Carrito"%>
<%@page import="Mapeos.Producto"%>
<%@page import="Mapeos.Cliente"%> 
<%@page import="java.util.List"%>
<%@page import="Beans.ProductoDAO"%>
<%@page import="Beans.ClienteDAO"%>
<jsp:useBean id="var1" scope="page" class="Mapeos.Producto" />
<jsp:useBean id="var2" scope="page" class="Mapeos.Cliente" />
<link rel="stylesheet" type="text/css" href="css.css" title="style">
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>producto</title>
    </head>
    <body>
        <h1>Portal de información del producto</h1>
        <div id="menu">
            <ul>
                <li><a href="Conocenos.jsp" class="normalMenu">Conocenos</a></li>
                <li><a href="Productos.jsp" class="normalMenu">Productos</a></li>
                <li><a href="Contacto.jsp" class="normalMenu">Contacto</a></li>
                <li><a href="Acceso.jsp" class="normalMenu">Ingresar</a></li>
                <li><a href="registro.jsp" class="normalMenu">Registrate Aquí</a></li>
            </ul>
        </div>

        <%
            ProductoDAO productoDAO = new ProductoDAO();
            List<Producto> listaproductos = productoDAO.obtenListaProducto();

            ClienteDAO clienteDAO = new ClienteDAO();
            Cliente b = (Cliente) session.getAttribute("usuario");
            b.setCarrito(new Carrito());
        %>
        <form method="post">
            <center>
                <hr> 
                <i>Selecciona en la columna final el producto que deseas comprar.</i>
                </hr>
                <%
                %><i>---------- </i><tr><i>BIENVENID@</i>.<%= b.getNombre()%><i></tr> 
                    <i>---------- </i><th>SU CARRITO</i>. <%= b.getCarrito()%></th>
                <i>---------- </i><a href="Acceso.jsp">Cerrar Sesion</a> <%
                %>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Nombre producto</th>
                            <th>Presentación</th>
                            <th>Caducidad</th>
                            <th>P. Unitario</th>
                            <th>Fecha</th>
                            <th>Marca</th>
                            <th>Seleccionar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%  for (Producto a : listaproductos) {%>
                        <tr>
                            <td><%= a.getNombreProducto()%></td>
                            <td><%= a.getPresentacion()%></td>
                            <td><%= a.getCaducidad()%></td>
                            <td><%= a.getPrecioUni()%></td>
                            <td><%= a.getFech()%></td>
                            <td><%= a.getMarca()%></td>
                            <td>
                                <% if (a.getExistencias() > 0) {%>
                                <input type="checkbox" name="cbactores" value="<%= a.getIdProducto()%>" />
                                <%} else {
                                %>
                                ND
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <input type="submit" value="Comprar" name="comprar" />

                <%

                    if (request.getParameter(
                            "comprar") != null) {
                        String[] chbproductos = request.getParameterValues("cbactores");
                        if (chbproductos != null) {
                            for (String idStr : chbproductos) {
                                int id = Integer.parseInt(idStr);
                                Producto producto = productoDAO.obtenProducto(id);
                                if (producto != null) {
                                    int compra = producto.getExistencias() - 1;  // Reduces existence by 1, adjust as needed
                                    producto.setExistencias(compra);
                                    productoDAO.actualizaProducto(producto);  // Save changes to the database

                                    out.println("*Compra efectuada*  " + "Producto: " + producto.getNombreProducto() + ", Carrito actual: " + compra);
                                }
                            }
                        }
                    }
                %>
            </center>
        </form>
    </body>
</html>
