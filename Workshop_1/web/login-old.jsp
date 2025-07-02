<%-- 
    Document   : login
    Created on : Jun 20, 2025, 8:49:48 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils"%>
<%@ page import="model.UserDAO" %>
<%@ page import="model.UserDTO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        <%
            if (AuthUtils.isLoggedIn(request)) {
                response.sendRedirect("welcome.jsp");
            } else {
        %>
        <h1>Login</h1>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="login" />
            Username: <input type="text" name="strUsername" required /> <br/>
            Password: <input type="password" name="strPassword" required /> <br/>

            <!-- Bao loi -->
            <%
                Object objMessage = request.getAttribute("message");
                String message = objMessage == null ? "" : (objMessage + "");
                if (!message.isEmpty()) {
            %>
            <div style="color: red; font-size: 14px; margin-bottom: 12px; text-align: center;"><%= message %></div>
            <%
                }
            %>

            <input type="Submit" value="Login" >
        </form>
        <%
                }
        %>
    </body>
</html>
