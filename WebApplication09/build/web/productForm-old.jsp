<%-- 
    Document   : productForm
    Created on : Jun 6, 2025, 7:37:34 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="model.ProductDTO"%>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            if(AuthUtils.isAdmin(request)) {
                ProductDTO product = (ProductDTO) request.getAttribute("product");
                String checkError = (String) request.getAttribute("checkError");
                String message = (String) request.getAttribute("message");
        %>
        <h1>Product Form</h1>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="addProduct"/><br/>

            <div> 
                <label for="id">Product ID:</label>
                <input type="text" id="id" name="id" required="required"/><br/>
            </div>

            <div>
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required="required"/><br/>
            </div>     

            <div>    
                <label for="image">Image:</label>
                <input type="text" id="image" name="image" /><br/> 
            </div>

            <div>    
                <label for="description">Description:</label>
                <textarea type="text" id="description" name="description">
                </textarea><br/>
            </div>

            <div>
                <label for="price">Price:</label>
                <input type="number" id="price" name="price" min="0" step="0.01" required="required"/><br/>
            </div>

            <div>
                <label for="size">Size</label>
                <input type="text" id="size" name="size" /><br/>
            </div>

            <div>
                <label for="status">Status (Active Product)</label>
                <input type="checkbox" id="status" name="status" value="true"/><br/>
            </div>
        
            <div>
                <input type="submit" value="Add Product"/>
                <input type="reset" value="Reset"/>
            </div>
        </form>
        
        <%
        }else {
            %>        
            <%=AuthUtils.getAccessDeniedMessage("product") %>        
            <%
        }
            %>
    </body>
</html>
