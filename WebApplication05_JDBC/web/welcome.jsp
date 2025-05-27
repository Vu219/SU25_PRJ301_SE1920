<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% 
            UserDTO user = (UserDTO)request.getAttribute("user");
        %>
            
        <h1>Welcome <%=user.getFullName()%> !</h1> <!-- ghi ra -->
    </body>
</html>
