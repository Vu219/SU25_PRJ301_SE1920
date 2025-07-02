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
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }
            
            .header {
                background-color: #008080;
                color: white;
                padding: 20px 0;
                margin-bottom: 30px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            
            .header h1 {
                color: #ffd700;
                text-align: center;
            }
            
            .notification {
                padding: 15px;
                margin: 20px 0;
                border-radius: 5px;
                font-weight: 500;
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
            
            .user-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }
            
            .user-header h2 {
                color: #006666;
            }
            
            .user-name {
                color: #ccac00;
                font-weight: bold;
            }
            
            .logout-btn {
                background-color: #008080;
                color: white;
                padding: 8px 15px;
                border-radius: 4px;
                text-decoration: none;
                transition: background-color 0.3s;
            }
            
            .logout-btn:hover {
                background-color: #006666;
            }
            
            .action-buttons {
                display: flex;
                gap: 15px;
                margin-bottom: 30px;
            }
            
            input[type="submit"], 
            .action-link {
                background-color: #008080;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
            }
            
            .action-link.gold {
                background-color: #ffd700;
                color: #333;
                font-weight: bold;
            }
            
            input[type="submit"]:hover, 
            .action-link:hover {
                background-color: #006666;
                color: white;
            }
            
            .search-form {
                display: flex;
                gap: 10px;
                align-items: center;
                margin-bottom: 30px;
            }
            
            .search-form input[type="text"] {
                flex-grow: 1;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 16px;
            }
            
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
                background-color: white;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            th, td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #f0f0f0;
            }
            
            th {
                background-color: #008080;
                color: white;
            }
            
            tr:hover {
                background-color: #e6f2f2;
            }
            
            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 14px;
                display: inline-block;
            }
            
            .status-ideation {
                background-color: #e6f7ff;
            }
            
            .status-development {
                background-color: #fff7e6;
            }
            
            .status-launch {
                background-color: #e6ffe6;
            }
            
            .status-scaling {
                background-color: #f0e6ff;
            }
            
            .status-form {
                display: flex;
                gap: 5px;
                margin: 0;
            }
            
            .status-form select {
                padding: 5px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            
            .status-form input[type="submit"] {
                padding: 5px 10px;
                font-size: 14px;
            }
            
            .footer {
                text-align: center;
                padding: 20px;
                margin-top: 50px;
                background-color: #008080;
                color: white;
            }
            
            .no-projects {
                background: white;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                border-left: 4px solid #ffd700;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Welcome to Project Dashboard</h1>
        </div>
        
        <div class="container">
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
            <div class="notification error">
                <%= request.getAttribute("error_general") %>
            </div>
            <% } %>    

            <div class="user-header">
                <h2>Hello <span class="user-name"><%= user.getName() %></span>!</h2>
                <a href="MainController?action=logout" 
                   onclick="return confirm('Are you sure you want to log out?');"
                   class="logout-btn">
                    Logout
                </a>
            </div>

            <div class="action-buttons">
                <form action="MainController" method="post" style="margin: 0;">
                    <input type="hidden" name="action" value="viewProjects">
                    <input type="submit" value="View Startup Projects"/>
                </form>      

                <% if(AuthUtils.isFounder(request)) { %>
                <a href="MainController?action=addProjects" class="action-link gold">
                    Create New Project
                </a>
                <% } %>
            </div>

            <% if(AuthUtils.isFounder(request)) { %>
            <div class="search-form">
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="searchProject"/>
                    <input type="text" name="strKeyword" placeholder="Search project name..." 
                           value="<%= request.getParameter("strKeyword") != null ? request.getParameter("strKeyword") : "" %>"/>
                    <input type="submit" value="Search"/>
                </form>
            </div>
            <% } %>

            <%
                List<ProjectsDTO> projects = (List<ProjectsDTO>) request.getAttribute("projects");

                if (projects != null && projects.isEmpty()) {
            %>
            <div class="no-projects">
                <p>There are no projects to display.</p>
            </div>
            <%
                } else if (projects != null && !projects.isEmpty()) {
            %>

            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ProjectID</th>
                            <th>ProjectName</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Estimated Launch</th>
                            <% if(AuthUtils.isFounder(request)) { %>
                            <th>Action</th>
                            <% } %>
                        </tr>
                    </thead>

                    <tbody>
                        <% for (ProjectsDTO p : projects) { %>
                        <tr>
                            <td><%= p.getProject_id() %></td>
                            <td><strong><%= p.getProject_name() %></strong></td>
                            <td><%= p.getDescription() %></td>
                            <td>
                                <span class="status-badge 
                                      <% switch(p.getStatus()) { 
                                           case "Ideation": %>status-ideation<% break; 
                                           case "Development": %>status-development<% break; 
                                           case "Launch": %>status-launch<% break; 
                                           case "Scaling": %>status-scaling<% break; 
                                         } %>">
                                    <%= p.getStatus() %>
                                </span>
                            </td>
                            <td><%= p.getEstimated_launch() %></td>

                            <% if(AuthUtils.isFounder(request)) { %>
                            <td>
                                <form action="MainController" method="post" class="status-form">
                                    <input type="hidden" name="action" value="updateStatus"/>
                                    <input type="hidden" name="project_id" value="<%= p.getProject_id() %>"/>
                                    <select name="Status">
                                        <option value="Ideation" <%= "Ideation".equals(p.getStatus()) ? "selected" : "" %>>Ideation</option>
                                        <option value="Development" <%= "Development".equals(p.getStatus()) ? "selected" : "" %>>Development</option>
                                        <option value="Launch" <%= "Launch".equals(p.getStatus()) ? "selected" : "" %>>Launch</option>
                                        <option value="Scaling" <%= "Scaling".equals(p.getStatus()) ? "selected" : "" %>>Scaling</option>
                                    </select>
                                    <input type="submit" value="Update"/>
                                </form>
                            </td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <%
                    }
            %>

            <%
                }
            %>
        </div>
        
        <div class="footer">
            &copy; 2025 Project Management System
        </div>
    </body>
</html>