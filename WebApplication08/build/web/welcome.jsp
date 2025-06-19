<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            UserDTO user = AuthUtils.getCurrentUser(request);
            if(!AuthUtils.isLoggedIn(request)){
                response.sendRedirect("MainController");
            }else{
        %>
                <h1>Welcome <%=user.getFullName()%> !</h1>
                <a href="MainController?action=logout">Logout</a>
                <hr/>
                <form action="MainController" method="post">
                    <input type="text" name="strKeyword" />
                    <input type="submit" value="Seearch" />
                </form>
        <%
            }
        %>
    </body>
</html>
