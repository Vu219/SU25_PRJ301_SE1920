<%-- 
    Document   : login
    Created on : Jun 28, 2025, 7:25:51 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
        <link rel="stylesheet" href="assets/css/styles.css">
    </head>
    <body>
        <div class="header">
            <h1>Online Examination System</h1>
        </div>
        
        <div class="container">
            <%
                if (AuthUtils.isLoggedIn(request)) {
                    response.sendRedirect("welcome.jsp");
                } else {
            %>
            <div class="login-form">
                <h1>Login</h1>
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="login" />
                    
                    <div class="form-group">
                        <label for="strUsername">Username</label>
                        <input type="text" name="strUsername" id="strUsername" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="strPassword">Password</label>
                        <input type="password" name="strPassword" id="strPassword" required />
                    </div>

                    <%
                        Object objMessage = request.getAttribute("message");
                        String message = objMessage == null ? "" : (objMessage + "");
                        if (!message.isEmpty()) {
                    %>
                    <div class="error">
                        <%= message %>
                    </div>
                    <%
                        }
                    %>

                    <div class="form-group">
                        <input type="submit" value="Login">
                    </div>
                </form>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="footer">
            &copy; 2025 Exam Management System
        </div>
    </body>
</html>
