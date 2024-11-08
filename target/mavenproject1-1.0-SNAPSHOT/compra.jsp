<%-- 
    Document   : compra
    Created on : 3/11/2013, 12:19:50 PM
    Author     : USUARIO
--%>

<%@page import="Mapeos.Cliente"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Beans.ProductoDAO"%>
<%@page import="Mapeos.Producto"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Compras!</h1>
        <%
            ProductoDAO productoDAO = new ProductoDAO();
            Cliente b = (Cliente) session.getAttribute("usuario");
// Obtener el parámetro 'comprar' que contiene los datos en formato 'id,cantidad,id,cantidad...'
            String comprarParam = request.getParameter("comprar");

            if (comprarParam != null && !comprarParam.isEmpty()) {
                String[] data = comprarParam.split(",");
                List<List<Integer>> products = new ArrayList<>();

                // Procesar los datos en pares de id y cantidad
                for (int i = 0; i < data.length; i += 2) {
                    int id = Integer.parseInt(data[i]);
                    int quantity = Integer.parseInt(data[i + 1]);
                    List<Integer> productData = Arrays.asList(id, quantity);
                    products.add(productData);
                }

                // Actualizar la base de datos
                for (List<Integer> productData : products) {
                    int id = productData.get(0);
                    int quantity = productData.get(1);
                    Producto producto = productoDAO.obtenProducto(id);
                    if (producto != null) {
                        int newExistence = producto.getExistencias() - quantity;
                        producto.setExistencias(newExistence);
                        productoDAO.actualizaProducto(producto);
                    }
                }

                // Responder con un JSON de éxito
                response.setContentType("application/json");
                response.getWriter().write("{\"status\": \"ok\"}");
            } else {
                // Responder con un JSON de error
                response.setContentType("application/json");
                response.getWriter().write("{\"status\": \"error\"}");
            }
        %>

    </body>
</html>
