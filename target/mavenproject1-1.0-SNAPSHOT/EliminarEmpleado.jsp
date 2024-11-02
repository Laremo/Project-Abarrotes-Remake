<%@page import="Mapeos.Empleado"%>
<%@page import="java.util.List"%>
<%@page import="Beans.EmpleadoDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="uname" scope="session" class="Mapeos.Empleado" />

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Eliminar Empleado</title>
</head>
<body>
    <h1>Portal de información del empleado</h1>
    <% 
        // Verificar si el objeto de sesión uname es nulo o si el tipo de usuario no es "Administrador"
        if (uname == null || uname.getTipoUsuario() == null || !uname.getTipoUsuario().equals("Administrador")) {
            response.sendRedirect("AccesoDenegado.jsp");
            return; // Salir para evitar que el resto del código se ejecute
        }
        
        EmpleadoDAO empleadoDAO = new EmpleadoDAO();
        List<Empleado> listaEmpleados = empleadoDAO.obtenListaEmpleado();
    %>
    
    <form method="POST">
        <hr> 
        <i>Para eliminar un empleado, selecciónalo en la columna final. <a href="AutentificarAdmon.jsp">Cerrar Sesión</a></i>
        <hr>
        <table border="1">
            <thead>
                <tr>
                    <th>Número de empleado</th>
                    <th>Nombre empleado</th>
                    <th>Contraseña</th>
                    <th>Apellido paterno</th>
                    <th>Apellido materno</th>
                    <th>Fecha de nacimiento</th>
                    <th>RFC</th>
                    <th>Salario</th>
                    <th>Estado civil</th>
                    <th>Estatus</th>
                    <th>Nivel de estudio</th>
                    <th>Tipo de usuario</th>
                    <th>Eliminar</th> <!-- Columna para checkbox -->
                </tr>
            </thead>
            <tbody>
                <% for (Empleado a : listaEmpleados) { %>
                    <tr>
                        <td><%= a.getNoEmpleado() %></td>
                        <td><%= a.getNombreEmpleado() %></td>
                        <td><%= a.getPassword() %></td>
                        <td><%= a.getApellPatEmpleado() %></td>
                        <td><%= a.getApellMatEmpleado() %></td>
                        <td><%= a.getFechaNac() %></td>
                        <td><%= a.getRfce() %></td>
                        <td><%= a.getSalario() %></td>
                        <td><%= a.getEstadoCivil() %></td>
                        <td><%= a.getEstatus() %></td>
                        <td><%= a.getNivelEstudio() %></td>
                        <td><%= a.getTipoUsuario() %></td>
                        <td><input type="checkbox" name="cbactores" value="<%= a.getNoEmpleado() %>"/></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        <input type="submit" value="Eliminar Seleccionados" name="eliminar" />
        <input type="button" onclick="location.href='InsertarEmpleado.jsp'" value="Insertar Empleado" />
        <input type="button" onclick="location.href='ModificarEmpleado.jsp'" value="Modificar Empleado" />
    </form>

    <%
        if (request.getParameter("eliminar") != null) {
            String[] chbEmpleados = request.getParameterValues("cbactores");
            if (chbEmpleados == null || chbEmpleados.length == 0) {
                out.println("<p style='color:red;'>Por favor, selecciona al menos un empleado para eliminar.</p>");
            } else {
                for (String empleadoId : chbEmpleados) {
                    empleadoDAO.eliminaEmpleado(Short.valueOf(empleadoId));
                    out.println("<li>El empleado con ID " + empleadoId + " ha sido eliminado.</li>");
                }
            }
        }
    %>
</body>
</html>
