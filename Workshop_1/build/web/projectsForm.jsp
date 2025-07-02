<%-- 
    Document   : ProjectsForm
    Created on : Jun 22, 2025, 9:46:36 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils"%>
<%@page import="model.ProjectsDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Project Dashboard</title>
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
            
            .project-form-container {
                max-width: 800px;
                margin: 0 auto;
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .project-form-container h1 {
                color: #006666;
                margin-bottom: 30px;
                text-align: center;
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
            input[type="date"],
            textarea,
            select {
                width: 100%;
                padding: 12px;
                margin: 8px 0 15px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 16px;
            }
            
            textarea {
                min-height: 120px;
                resize: vertical;
            }
            
            .error-field {
                border: 1px solid #f8d7da !important;
                background-color: #fff0f0;
            }
            
            .error-message {
                color: #721c24;
                font-size: 14px;
                margin-top: -10px;
                margin-bottom: 15px;
            }
            
            .submit-btn {
                background-color: #ffd700;
                color: #333;
                border: none;
                padding: 12px 30px;
                font-size: 16px;
                font-weight: bold;
                border-radius: 4px;
                cursor: pointer;
                display: block;
                margin: 30px auto 0;
                transition: background-color 0.3s;
            }
            
            .submit-btn:hover {
                background-color: #ccac00;
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
            
            .footer {
                text-align: center;
                padding: 20px;
                margin-top: 50px;
                background-color: #008080;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Project Management</h1>
        </div>
        
        <div class="container">
            <%
                if (!AuthUtils.isFounder(request)) {
                    response.sendRedirect("MainController?action=viewProjects");
                    return;
                }

                ProjectsDTO project = (ProjectsDTO) request.getAttribute("project");
                String checkError = (String) request.getAttribute("checkError");
                String message = (String) request.getAttribute("message");
            %>
            
            <div class="project-form-container">
                <form action="ProjectsController" method="post">
                    <h1> Create New Project </h1>

                    <input type="hidden" name="action" value="addProjects" />

                    <div class="form-group">
                        <label for="project_name">Project Name:</label> 
                        <input type="text" name="project_name" id="project_name" required
                               value="<%= project != null && project.getProject_name() != null ? project.getProject_name() : "" %>"
                               placeholder="Enter Project Name"
                               class="<%=request.getAttribute("error_projectName") !=null ? "error-field" : ""%>"/>
                        <% if (request.getAttribute("error_projectName") != null) { %>
                        <div class="error-message">
                            <%= request.getAttribute("error_projectName") %>
                        </div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label for="Description">Description:</label> 
                        <textarea name="Description" id="Description" 
                                  placeholder="Enter project description"
                                  class="<%= request.getAttribute("error_description") != null ? "error-field" : "" %>"><%= project != null && project.getDescription() != null ? project.getDescription() : "" %>
                        </textarea>
                        <% if (request.getAttribute("error_description") != null) { %>
                        <div class="error-message">
                            <%= request.getAttribute("error_description") %>
                        </div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label for="Status">Status:</label>
                        <select id="Status" name="Status" required
                                class="<%= request.getAttribute("errorStatus") != null ? "error-field" : "" %>">
                            <option value="Ideation" <%= (project != null && "Ideation".equals(project.getStatus())) || project == null ? "selected" : "" %>>Ideation</option>
                            <option value="Development" <%= project != null && "Development".equals(project.getStatus()) ? "selected" : "" %>>Development</option>
                            <option value="Launch" <%= project != null && "Launch".equals(project.getStatus()) ? "selected" : "" %>>Launch</option>
                            <option value="Scaling" <%= project != null && "Scaling".equals(project.getStatus()) ? "selected" : "" %>>Scaling</option>
                        </select>
                        <% if (request.getAttribute("error_Status") != null) { %>
                        <div class="error-message">
                            <%= request.getAttribute("error_Status") %>
                        </div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label for="estimated_launch">Estimated Launch Date:</label>
                        <input type="date" id="estimated_launch" name="estimated_launch" required
                               value="<%= project != null ? project.getEstimated_launch() : "" %>"
                               class="<%= request.getAttribute("error_estimated_launch") != null ? "error-field" : "" %>">       
                        <% if (request.getAttribute("error_estimated_launch") != null) { %>
                        <div class="error-message">
                            <%= request.getAttribute("error_estimated_launch") %>
                        </div>
                        <% } %>
                    </div>

                    <button type="submit" class="submit-btn">
                        <%= request.getParameter("action") != null && request.getParameter("action").equals("editProject") ? "Update Project" : "Create Project" %>
                    </button>
                </form>

                <% if (checkError != null && !checkError.isEmpty()) { %>
                <div class="notification error">
                    <%= checkError %>
                </div>
                <% } %>

                <% if (message != null && !message.isEmpty()) { %>
                <div class="notification success">
                    <%= message %>
                </div>
                <% } %>
            </div>
        </div>
        
        <div class="footer">
            &copy; 2025 Project Management System
        </div>
    </body>
</html>