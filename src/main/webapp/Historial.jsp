<%-- 
    Document   : Historial
    Created on : Nov 13, 2024, 1:21:01 PM
    Author     : laremo
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="Mapeos.Compra"%>
<%@page import="Beans.CompraDAO"%>
<%@page import="Mapeos.Cliente"%>
<%@page import="Beans.ClienteDAO"%>
<%@page import="java.util.List"%>
<%@page import="Mapeos.Carrito"%>
<%@page import="Mapeos.Producto"%>
<%@page import="Beans.ProductoDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css.css" title="style">
        <title>Mis Compras</title>
    </head>
    <body>
        <h1>Historial de Compras</h1>
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
            CompraDAO compraDAO = new CompraDAO();
            Cliente b = (Cliente) session.getAttribute("usuario");
            int idCliente = b.getIdCliente();
            List<List> listaCompras = compraDAO.compraPorCliente(idCliente);

        %>
        <form method="post">
            <center>
                <hr>
                <i>Estos son los productos que has comprado</i>
                </hr>
                <i>---------- </i><tr><i>BIENVENID@</i>.<%= b.getNombre()%><i></tr>
                    <i>---------- </i><a href="Acceso.jsp">Cerrar Sesion</a>
                    <div id="compras">
                        <%
                            int count = 1;
                            for (List<Compra> compras : listaCompras) {
                        %>
                        <div class="compra-section">
                            <button type="button" class="collapsible">Compra <%= count%></button>
                            <div class="compra-content">
                                <table border="1">
                                    <thead>
                                        <tr>
                                            <th>Nombre producto</th>
                                            <th>Marca</th>
                                            <th>Presentación</th>
                                            <th>P. Unitario</th>
                                            <th>Cantidad</th>
                                            <th>Total</th>
                                            <th>Fecha de Compra</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Compra c : compras) {%>
                                        <tr>
                                            <td><%= c.getProducto().getNombreProducto()%></td>
                                            <td><%= c.getProducto().getMarca()%></td>
                                            <td><%= c.getProducto().getPresentacion()%></td>
                                            <td><%= c.getProducto().getPrecioUni()%></td>
                                            <td><%= c.getCantidad()%></td>
                                            <td><%= c.getCantidad() * c.getProducto().getPrecioUni()%></td>
                                            <td><%= c.getFecha()%></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <%
                                count++;
                            }
                        %>
                    </div>
            </center>
        </form>


        <script>
            const existingCart = JSON.parse(sessionStorage.getItem("cart"));
            const cart = existingCart ? existingCart : {};

            if (existingCart) {
                const cartList = document.getElementById('cartList');
                Object.entries(existingCart).forEach(([productId, productData]) => {
                    displayCartItem(productId, productData.name, productData.quantity, productData.price);
                });
                calculateTotals();
            }

            function addToCart(productId, productName, productPrice, productStock) {
                const inputElement = document.getElementById('item-' + productId);
                const quantityToAdd = parseInt(inputElement.value);

                // Validate the quantity
                if (isNaN(quantityToAdd) || quantityToAdd <= 0) {
                    alert('Por favor, ingrese una cantidad válida.');
                    return;
                }

                // Check if we exceed stock
                if (!cart[productId]) {
                    cart[productId] = {name: productName, price: productPrice, quantity: 0};
                }
                const newQuantity = cart[productId].quantity + quantityToAdd;

                if (newQuantity > productStock) {
                    alert('No hay suficiente stock para esta cantidad!');
                    return;
                }

                // Update the cart with the new quantity
                cart[productId].quantity = newQuantity;

                // Display the updated cart item
                displayCartItem(productId, productName, cart[productId].quantity, productPrice);

                // Update sessionStorage and totals
                sessionStorage.setItem("cart", JSON.stringify(cart));
                calculateTotals();
            }

            function removeFromCart(productId) {
                if (cart[productId]) {
                    cart[productId].quantity -= 1;

                    // If quantity is zero, remove the item from the cart
                    if (cart[productId].quantity <= 0) {
                        delete cart[productId];
                        const listItem = document.querySelector("li[data-product-id='" + productId + "']");
                        if (listItem) {
                            listItem.remove();
                        }
                    } else {
                        // Update the display with the new quantity
                        displayCartItem(productId, cart[productId].name, cart[productId].quantity, cart[productId].price);
                    }

                    // Update sessionStorage and totals
                    sessionStorage.setItem("cart", JSON.stringify(cart));
                    calculateTotals();
                }
            }


            function displayCartItem(productId, productName, quantity, price) {
                const cartList = document.getElementById('cartList');
                let listItem = document.querySelector("li[data-product-id='" + productId + "']");

                if (!listItem) {
                    listItem = document.createElement('li');
                    listItem.setAttribute('data-product-id', productId);

                    // Create a span for the product details
                    const productText = document.createElement('span');
                    productText.className = 'productText';
                    listItem.appendChild(productText);

                    // Add a remove button
                    const removeButton = document.createElement('button');
                    removeButton.textContent = '-';
                    removeButton.className = 'rm-btn';
                    removeButton.onclick = () => removeFromCart(productId);
                    listItem.appendChild(removeButton);

                    cartList.appendChild(listItem);
                }

                // Update the text for the product details
                const total = price * quantity;
                const productText = listItem.querySelector('.productText');
                productText.textContent = productName + ': ' + quantity + ' (Total: ' + total + ')';
            }


            function calculateTotals() {
                let grandTotal = 0;
                Object.values(cart).forEach(product => {
                    grandTotal += product.price * product.quantity;
                });
                document.getElementById("totalCost").textContent = 'Total de todos los productos: ' + grandTotal;
            }

            async function saveCart() {
                if (Object.entries(cart).length === 0) {
                    return;
                }
                const comprarData = Object.entries(cart).map(([id, product]) => '' + parseInt(id) + ',' + product.quantity);
                let tosend = '';
                console.log(comprarData)
                for (let i = 0; i < comprarData.length; i++) {
                    tosend += comprarData[i] + ",";
                }
                const url = "compra.jsp?comprar=" + tosend;
                console.log(url);

                try {
                    const response = await fetch(url, {method: 'GET'});
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    alert("Compra Registrada!");
                    sessionStorage.removeItem("cart");
                    location.reload();
                } catch (error) {
                    alert("Error saving cart!");
                    console.error('Error: (on fetch!)', error);
                }
            }

            document.addEventListener("DOMContentLoaded", function () {
                const collapsibles = document.querySelectorAll(".collapsible");
                collapsibles.forEach(button => {
                    button.addEventListener("click", function () {
                        this.classList.toggle("active");
                        const content = this.nextElementSibling;
                        content.style.display = content.style.display === "block" ? "none" : "block";
                    });
                });
            });
        </script>
        <style>
            .collapsible {
                background-color: #f9f9f9;
                color: #333;
                cursor: pointer;
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
                outline: none;
                font-size: 18px;
                width: 100%;
            }

            .active, .collapsible:hover {
                background-color: #ccc;
            }

            .compra-content {
                padding: 10px;
                display: none;
                overflow: hidden;
                border: 1px solid #ddd;
            }

            .compra-content table {
                width: 100%;
            }
        </style>
    </body>

</html>
