<%-- 
    Document   : AutentificarAdmon
    Created on : 19/11/2013, 07:12:35 PM
    Author     : USUARIO
--%>

<%@page import="java.util.List"%>
<%@page import="Beans.EmpleadoDAO"%>
<%@page import="Mapeos.Empleado"%>
<jsp:useBean id="uname" scope="session" class="Mapeos.Empleado" />
<link rel="stylesheet" type="text/css" href="css.css" title="style">
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Acceso</title>
    </head>
    <body>
        <form method="POST">
            <center>
                <h1>Acceso del empleado</h1>
                <div id="menu">
                    <ul>
                        <li><a href="Conocenos.jsp"  class="normalMenu">Conocenos</a></li>
                        <li><a href="Productos.jsp"  class="normalMenu">Productos</a></li>
                        <li><a href="Contacto.jsp"  class="normalMenu">Contacto</a></li>
                        <li><a href="Acceso.jsp"  class="normalMenu">Ingresar</a></li>
                        <li><a href="registro.jsp"  class="normalMenu">Registrate_Aquí</a></li>
                    </ul>
                </div>
                <table border="1" width="30%" cellpadding="3">
                    <thead>
                        <tr>
                            <th colspan="2">Login</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Nombre</td>
                            <td><input type="text" name="usuario" value="" /></td>
                        </tr>
                        <tr>
                            <td>Password</td>
                            <td><input type="password" name="contrasenia" value="" /></td>
                        </tr>
                        <tr>
                            <td><input type="submit" name="enviar" value="Entrar" /></td>
                            <td><input type="reset" value="Limpiar" /></td>
                        </tr>
                    </tbody>
                </table>
                <a href="index.html">Pagina Principal</a>
            </center>
        </form>
        
        <% 
        if (request.getParameter("enviar") != null) {
            String usuario = request.getParameter("usuario");
            String contrasenia = request.getParameter("contrasenia");
            boolean us = false;
            
            try {
                EmpleadoDAO empDAO = new EmpleadoDAO();
                List<Empleado> listaEmpleados = empDAO.obtenListaEmpleado();
                
                for (Empleado empleado : listaEmpleados) {
                    // Verificamos si el usuario y contraseña coinciden
                    if (empleado.getNombreEmpleado().equals(usuario) && empleado.getPassword().equals(contrasenia)) {
                        // Asignamos los valores al objeto uname de la sesión
                        uname.setNombreEmpleado(usuario);  
                        uname.setTipoUsuario(empleado.getTipoUsuario());  
                        us = true;
                        
                        // Verificamos el tipo de usuario y mostramos el contenido correspondiente
                        if (empleado.getTipoUsuario().equals("Empleado") || empleado.getTipoUsuario().equals("Administrador")) {
        %>
                        <center>
                            <h3>Bienvenido <% out.println(uname.getNombreEmpleado()); %>, eres <% out.println(uname.getTipoUsuario()); %></h3>
                            <p><b>PORTAL PARA LOS PRODUCTOS</b></p>
                            <input type="button" onclick="location.href = 'EliminarProducto.jsp'" value="Productos" name="boton" />
                            <p><b>PORTAL PARA LA CONFIGURACION DE CLIENTES</b></p>
                            <input type="button" onclick="location.href = 'EliminarCliente.jsp'" value="Clientes" name="boton" />
                            <%  if (empleado.getTipoUsuario().equals("Administrador")) {
%>
        <p><b>PORTAL PARA LA CONFIGURACION DE EMPLEADOS</b></p>
                            <input type="button" onclick="location.href = 'EliminarEmpleado.jsp'" value="Empleados" name="boton" />
    <% } %>
                        </center>
        <%
                            break;
                        } else {
        %>
                        <center>
                            <h3>ACCESO DENEGADO - SOLO PERSONAL AUTORIZADO</h3>
                            <a href="index.html">Página Principal</a>
                        </center>
        <%
                            break;
                        }
                    }
                }
                
                if (!us) {
        %>
                    <center>
                        <h3>El usuario y/o contraseña son incorrectos.</h3>
                        <a href="AutentificarEmpleado.jsp">Intentar de nuevo</a>
                    </center>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        }
        %>
    </body>
</html>