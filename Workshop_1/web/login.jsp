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
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            
            body {
                background-color: #f5f5f5;
                color: #333;
                line-height: 1.6;
            }
            
            .container {
                max-width: 500px;
                margin: 50px auto;
                padding: 20px;
            }
            
            .header {
                background-color: #008080;
                color: white;
                padding: 20px 0;
                text-align: center;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            
            .header h1 {
                color: #ffd700;
                font-size: 28px;
            }
            
            .login-form {
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .login-form h1 {
                color: #006666;
                text-align: center;
                margin-bottom: 30px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            label {
                display: block;
                margin-bottom: 8px;
                color: #006666;
                font-weight: 600;
            }
            
            input[type="text"],
            input[type="password"] {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 16px;
            }
            
            input[type="submit"] {
                background-color: #008080;
                color: white;
                border: none;
                padding: 12px;
                width: 100%;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            
            input[type="submit"]:hover {
                background-color: #006666;
            }
            
            .error {
                color: #721c24;
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 4px;
                font-size: 14px;
                text-align: center;
            }
            
            .footer {
                text-align: center;
                padding: 20px;
                margin-top: 30px;
                color: #666;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Project Management System</h1>
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
            &copy; 2025 Project Management System
        </div>
    </body>
</html>