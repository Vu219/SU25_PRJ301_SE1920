<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="utils.AuthUtils"%>
<%@page import="java.util.List"%>
<%@page import="model.ProductDTO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome Page</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        h1 {
            color: #2c3e50;
            margin: 0;
        }

        .logout {
            background-color: #e74c3c;
            color: white;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .logout:hover {
            background-color: #c0392b;
        }

        form {
            margin-top: 20px;
        }

        input[type="text"] {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            width: 250px;
        }

        input[type="submit"] {
            padding: 8px 16px;
            border: none;
            background-color: #3498db;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 5px;
        }

        input[type="submit"]:hover {
            background-color: #2980b9;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #2980b9;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .status-active {
            color: #27ae60;
            font-weight: bold;
        }

        .status-inactive {
            color: #c0392b;
            font-weight: bold;
        }
    </style>
</head>
<body>
<%
    UserDTO user = AuthUtils.getCurrentUser(request);
    if (!AuthUtils.isLoggedIn(request)) {
        response.sendRedirect("MainController");
    } else {
        String keyword = (String) request.getAttribute("keyword");
%>

<div class="header">
    <h1>Welcome <%= user.getFullName() %>!</h1>
    <a href="MainController?action=logout" class="logout">Logout</a>
</div>

<hr/>

<form action="MainController" method="post">
    <input type="hidden" name="action" value="searchProduct"/>
    <input type="text" name="strKeyword" placeholder="Search product name..." value="<%= keyword != null ? keyword : "" %>"/>
    <input type="submit" value="Search"/>
</form>

<%
    List<ProductDTO> list = (List<ProductDTO>) request.getAttribute("list");

    if (list != null && list.isEmpty()) {
%>
    <p>No product have names that match the keyword!</p>
<%
    } else if (list != null && !list.isEmpty()) {
%>
    <table>
        <thead>
        <tr>
            <th>Id</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Size</th>
            <th>Status</th>
            <% if (AuthUtils.isAdmin(request)) { %>
            <th>Action</th>
            <% } %>
        </tr>
        </thead>
        <tbody>
        <%
            for (ProductDTO p : list) {
        %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getName() %></td>
            <td><%= p.getDescription() %></td>
            <td><%= p.getPrice() %></td>
            <td><%= p.getSize() %></td>
            <td>
                <span class="<%= p.isStatus() ? "status-active" : "status-inactive" %>">
                    <%= p.isStatus() ? "Active" : "Inactive" %>
                </span>
            </td>
            <% if (AuthUtils.isAdmin(request)) { %>
            <td>
                <div class="action-buttons">
                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="editProduct"/>
                        <input type="hidden" name="productId" value="<%= p.getId() %>"/>
                        <input type="hidden" name="strKeyword" value="<%= keyword != null ? keyword : "" %>"/>
                        <input type="submit" value="Edit"/>
                    </form>

                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="changeProductStatus"/>
                        <input type="hidden" name="productId" value="<%= p.getId() %>"/>
                        <input type="hidden" name="strKeyword" value="<%= keyword != null ? keyword : "" %>"/>
                        <input type="submit" value="Delete"
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
