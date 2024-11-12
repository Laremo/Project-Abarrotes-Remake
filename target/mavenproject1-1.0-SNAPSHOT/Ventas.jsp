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
                <i>Oprime el botón "Añadir" del producto que deseas comprar.</i>
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
                                <th>Existencias</th>
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
                                <td><%= a.getExistencias()%></td>
                                <td><%= a.getFech()%></td>
                                <td><%= a.getMarca()%></td>
                                <td>
                                    <% if (a.getExistencias() > 0) {%>
                                    <input id="item-<%=a.getIdProducto()%>" type="number" min="0" max="<%=a.getExistencias()%>" value="1"/>
                                    <button type="button" onclick="addToCart(<%= a.getIdProducto()%>, '<%= a.getNombreProducto()%>', <%= a.getPrecioUni()%>, <%= a.getExistencias()%>)">Añadir</button>
                                    <% } else { %>
                                    ND
                                    <% } %>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                    <div class="cart"> 
                        <div id="cartItems">
                            <h4>Productos en el carrito:</h4>
                            <ul id="cartList"></ul>
                            <div id="totalCost">Total de todos los productos: 0</div>
                        </div>
                        <button type="button" onclick="saveCart()">Comprar</button>
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
        </script>
    </body>
    <style>
        li {
            list-style: none;
        }

        .cart{
            position: absolute;
            top: 180px;
            left: calc(100vw - 425px);
            width: 420px;
            border: 1px solid #1a1a1a;
            border-radius: 12px;
            background: #fff;
        }

        h4{
            margin: 0px;
        }

        #cartList {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
            box-sizing: border-box;
            margin: 0px;
            padding: 12px 0px;
        }

        #cartList li{
            text-align: left;
            width: 100%;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-sizing: border-box;
            border: 1px solid #e1e1e1;
            padding: 0px 8px
        }

        .rm-btn{
            width: 24px;
            font-size: 1.3rem;
            font-weight: bold;
            background: #CC1A1A;
            color: white;
            border: #BB1111 solid 1px;
            border-radius: 4px;
            cursor:pointer;
            padding: 0px 4px;
        }

        .rm-btn:hover{
            background: #AA1414;
            border: #BB0000 solid 1px;

        }
    </style>
</html>
