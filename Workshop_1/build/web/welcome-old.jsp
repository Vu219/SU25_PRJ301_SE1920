<%-- 
    Document   : welcome
    Created on : Jun 20, 2025, 8:50:25 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="utils.AuthUtils"%>
<%@page import="java.util.List"%>
<%@page import="model.ProjectsDTO"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome Page</title>
        <style>
        .notification {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
    </head>
    <body>
        <%
            UserDTO user = AuthUtils.getCurrentUser(request);
            if(!AuthUtils.isLoggedIn(request)){
                response.sendRedirect("MainController");
            }else{
                String keyword = (String) request.getAttribute("keyword");
        %>

        <% if(request.getAttribute("message") != null) { %>
        <div class="notification success">
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <% if (request.getAttribute("error_general") != null) { %>
        <div class="notification error" >
            <%= request.getAttribute("error_general") %>
        </div>
        <% } %>    


        <h1>Hello <%= user.getName() %>!</h1>
        <a href="MainController?action=logout" 
           onclick="return confirm('Are you sure you want to log out?');">Logout</a>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="viewProjects">
            <input type="submit" value="View Startup Projects"/>
        </form>      

        <div>
            <% if(AuthUtils.isFounder(request)) { %>
            <a href="MainController?action=addProjects" >Create New Project</a>
            <form action="MainController" method="post">
                <input type="hidden" name="action" value="searchProject"/>
                <input type="text" name="strKeyword" placeholder="Search project name..." value="<%= keyword != null ? keyword : "" %>"/>
                <input type="submit" value="Search"/>
            </form>
            <% } %>
        </div>

        <%
            List<ProjectsDTO> projects = (List<ProjectsDTO>) request.getAttribute("projects");

            if (projects != null && projects.isEmpty()) {
        %>
        <p>There is no Project</p>
        <%
            } else if (projects != null && !projects.isEmpty()) {
        %>

        <table>
            <thead>
                <tr>
                    <th>ProjectID</th>
                    <th>ProjectName</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>estimated_launch</th>
                        <% if(AuthUtils.isFounder(request)) { %>
                    <th>Action</th>
                        <% } %>
                </tr>
            </thead>

            <tbody>
                <% for (ProjectsDTO p : projects) { %>
                <tr>
                    <td><%= p.getProject_id() %></td>
                    <td><%= p.getProject_name() %></td>
                    <td><%= p.getDescription() %></td>
                    <td><%= p.getStatus() %></td>
                    <td><%= p.getEstimated_launch() %></td>

                    <% if(AuthUtils.isFounder(request)) { %>
                    <td>
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="updateStatus"/>
                            <input type="hidden" name="project_id" value="<%= p.getProject_id() %>"/>
                            <select name="Status">
                                <option value="Ideation" <%= "Ideation".equals(p.getStatus()) ? "selected" : "" %>>Ideation</option>
                                <option value="Development" <%= "Development".equals(p.getStatus()) ? "selected" : "" %>>Development</option>
                                <option value="Launch" <%= "Launch".equals(p.getStatus()) ? "selected" : "" %>>Launch</option>
                                <option value="Scaling" <%= "Scaling".equals(p.getStatus()) ? "selected" : "" %>>Scaling</option>
                            </select>
                            <input type="submit" value="Update Status"/>
                        </form>
                    </td>
                    <% } %>
                </tr>
                <% } %>
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
