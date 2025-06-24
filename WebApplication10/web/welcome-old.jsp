<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="utils.AuthUtils"%>
<%@page import="java.util.List"%>
<%@page import="model.ProductDTO"%>
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
                String keyword = (String)request.getAttribute("keyword");
        %>
        <h1>Welcome <%=user.getFullName()%> !</h1>
        <a href="MainController?action=logout">Logout</a>
        <hr/>
        Search by name:
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="searchProduct"/>
            <input type="text" name="strKeyword" value="<%=keyword != null ? keyword : ""%>"/>
            <input type="submit" value="Search" />
        </form>
        <%
            List<ProductDTO> list = (List<ProductDTO>)request.getAttribute("list");
                    
            if(list != null && list.isEmpty()) {
        %>
        No product have names that match the keyword!
        <% 
            }else if(list != null && !list.isEmpty()) {
        %>
        <br/>
        <table>
            <thead>
            <th>Id</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Size</th>
            <th>Status</th>
                <% if(AuthUtils.isAdmin(request)) {%>
            <th>Action<th>
                <% } %>
                </thead>
            <tbody>
                <%
                    for(ProductDTO p : list) {
                %>
                <tr>
                    <td><%=p.getId()%></td>
                    <td><%=p.getName()%></td>
                    <td><%=p.getDescription()%></td>
                    <td><%=p.getPrice()%></td>
                    <td><%=p.getSize()%></td>
                    <td><%=p.isStatus()%></td>
                    <% if(AuthUtils.isAdmin(request)) {%>
                    <td>
                        <div class="action-buttons">
                            <form action="MainController" method="post">
                                <input type="hidden" name="action" value="editProduct"/>
                                <input type="hidden" name="productId" value="<%=p.getId()%>"/>
                                <input type="hidden" name="strKeyword" value="<%=keyword!=null?keyword:""%>"/>
                                <input type="submit" value="Edit" class="edit-btn" />
                            </form>

                            <form action="MainController" method="post" class="delete-form">
                                <input type="hidden" name="action" value="changeProductStatus"/>
                                <input type="hidden" name="productId" value="<%=p.getId()%>"/>
                                <input type="hidden" name="strKeyword" value="<%=keyword!=null?keyword:""%>" />
                                <input type="submit" value="Delete" class="delete-btn"
                                       onclick="return confirm('Are you sure you want to delete this product?')"/>
                            </form>    
                        </div>
                    </td>
                    <% } %>
                </tr>    
                <% 
                    }
                %>
            </tbody>
        </table>
        <%
            }
        %>

        <%
            }
        %>
    </body>
</html>
