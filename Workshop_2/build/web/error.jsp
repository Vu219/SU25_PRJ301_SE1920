<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.lang.String"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>ERROR Page</title>
        <style>
            .error-message {
                color: #d9534f;
                background-color: #f2dede;
                border: 1px solid #ebccd1;
                padding: 8px 15px;
                border-radius: 4px;
                margin: 5px 0;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <%
            String errorField = (String) request.getAttribute("errorField");
            if (errorField != null) {
                String errorMessage = (String) request.getAttribute("error_" + errorField);
                if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
        <div class="error-message"><%= errorMessage %></div>
        <%
                }
            }
        %>
    </body>
</html>
