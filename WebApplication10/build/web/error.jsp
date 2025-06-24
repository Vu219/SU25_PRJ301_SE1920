<%-- 
    Document   : error
    Created on : Jun 9, 2025, 6:06:21 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.lang.String"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String errorMessage = (String) request.getAttribute("error_" + request.getAttribute("errorField"));
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
        <div class="error-message"><%= errorMessage %></div>
        <%
            }
        %>
    </body>
</html>
