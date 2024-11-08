<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="Mapeos.Carrito"%>
<%@ page import="Mapeos.Producto"%>
<%@ page import="Mapeos.Cliente"%>
<%@ page import="java.util.List"%>
<%@ page import="Beans.ProductoDAO"%>
<%@ page import="Beans.ClienteDAO"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="var1" scope="page" class="Mapeos.Producto" />
<jsp:useBean id="var2" scope="page" class="Mapeos.Cliente" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css.css" title="style">
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
            Carrito carrito = null;
            ClienteDAO clienteDAO = new ClienteDAO();
            Cliente b = (Cliente) session.getAttribute("usuario");
            if (b.getCarrito() != null) {
                carrito = b.getCarrito();
            } else {
                carrito = new Carrito();
                b.setCarrito(carrito);
                session.setAttribute("usuario", b);
            }
        %>
        <form method="post">
            <center>
                <hr>
                <i>Oprime el botón "Aadir" del producto que deseas comprar.</i>
                </hr>
                <i>---------- </i><tr><i>BIENVENID@</i>.<%= b.getNombre()%><i></tr>
                    <i>---------- </i><a href="Acceso.jsp">Cerrar Sesion</a>
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
                            <% for (Producto a : listaproductos) {%>
                            <tr>
                                <td><%= a.getNombreProducto()%></td>
                                <td><%= a.getPresentacion()%></td>
                                <td><%= a.getCaducidad()%></td>
                                <td><%= a.getPrecioUni()%></td>
                                <td><%= a.getFech()%></td>
                                <td><%= a.getMarca()%></td>
                                <td>
                                    <% if (a.getExistencias() > 0) {%>
                                    <button type="button" onclick="addToCart(<%= a.getIdProducto()%>, '<%= a.getNombreProducto()%>', <%= a.getExistencias()%>)">Añadir</button>
                                    <% } else { %>
                                    ND
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <button type="button" onclick="saveCart()">Comprar</button>
                    <div id="cartItems">
                        <h2>Productos en el carrito:</h2>
                        <ul id="cartList"></ul>
                    </div>
            </center>
        </form>

        <script>
            // Load existing cart from sessionStorage
            const existingCart = JSON.parse(sessionStorage.getItem("cart"));
            const cart = existingCart ? existingCart : {};

            // Function to display the existing cart items on page load
            if (existingCart) {
                const cartList = document.getElementById('cartList');
                Object.entries(existingCart).forEach(([productId, productData]) => {
                    let listItem = document.querySelector("li[data-product-id='" + productId + "']");

                    // If the list item does not exist, create a new one and append it to the cart list
                    if (!listItem) {
                        listItem = document.createElement('li');
                        listItem.setAttribute('data-product-id', productId);
                        cartList.appendChild(listItem);
                    }

                    // Update the text content of the list item with the product name and quantity
                    listItem.textContent = productData.name + ": " + productData.quantity;
                });
            }

            // Function to add products to the cart
            function addToCart(productId, productName, productStock) {
                console.log(productId, productName, productStock);
                if (!cart[productId]) {
                    cart[productId] = {name: productName, quantity: 0};
                }
                if (cart[productId].quantity < productStock) {
                    // Increment the quantity in the cart
                    cart[productId].quantity += 1;

                    // Get the cart list element
                    const cartList = document.getElementById('cartList');

                    // Check if the list item for this product already exists
                    let listItem = document.querySelector("li[data-product-id='" + productId + "']");

                    // If the list item does not exist, create a new one and append it to the cart list
                    if (!listItem) {
                        listItem = document.createElement('li');
                        listItem.setAttribute('data-product-id', productId);
                        cartList.appendChild(listItem);
                    }

                    // Update the text content of the list item with the product name and quantity
                    listItem.textContent = productName + ": " + cart[productId].quantity;
                } else {
                    // Alert the user if they try to add more than the available stock
                    alert('No hay más existencias de este producto!');
                }


                sessionStorage.setItem("cart", JSON.stringify(cart));
            }

            async function saveCart() {
                if (Object.entries(cart).length === 0) {
                    return;
                }
                const comprarData = Object.entries(cart).map(([id, product]) => [parseInt(id), product.quantity]);
                const encodedData = comprarData;
                const url = "compra.jsp?comprar=" + encodedData;
                console.log(url);
                try {
                    const response = await fetch(url, {method: 'GET'});
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    //const json = await response.json();
                    //console.log('json decoded', json);
                    alert("Compra Registrada!");
                    sessionStorage.removeItem("cart");
                    location.reload();
                } catch (error) {
                    alert("Error saving cart!");
                    console.error('Error: (on fetch!)', error);
                }
            }
        </script>


        <%
            if (request.getParameter("comprar") != null) {
                String jsonData = request.getParameter("comprar");
                Gson gson = new Gson(); // Convert JSON string to your expected type 
                Map<String, List<List<Integer>>> dataMap = gson.fromJson(jsonData, new TypeToken<Map<String, List<List<Integer>>>>() {
                }.getType());
                List<List<Integer>> products = dataMap.get("cart");
                out.println(products.size());
                for (List<Integer> productData : products) {
                    int id = productData.get(0);
                    int quantity = productData.get(1);
                    Producto producto = productoDAO.obtenProducto(id);
                    if (producto != null) {
                        int newExistence = producto.getExistencias() - quantity;
                        producto.setExistencias(newExistence);
                        productoDAO.actualizaProducto(producto); // Save changes to the database 
                    }
                }
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"success\"}");
            } // Send a response 


        %>
    </body>
    <style>
        li{
            list-style: none;
        }
    </style>
</html>
