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
    </head>
    <body>
        <%
            if (!AuthUtils.isFounder(request)) {
                response.sendRedirect("MainController?action=viewProjects");
                return;
            }

            ProjectsDTO project = (ProjectsDTO) request.getAttribute("project");
            String checkError = (String) request.getAttribute("checkError");
            String message = (String) request.getAttribute("message");
        %>
        <div>
            <form action="ProjectsController" method="post">
                <h1>Create New Project</h1>

                <input type="hidden" name="action" value="addProjects" />

                <div>
                    <label for="project_name">Project Name</label> 
                    <input type="text" name="project_name" id="project_name" required="required"
                           value="<%= project != null && project.getProject_name() != null ? project.getProject_name() : "" %>"
                           placeholder="Enter Project Name"
                           class="<%=request.getAttribute("error_projectName") !=null ? "error-field" : ""%>"/>
                    <% if (request.getAttribute("error_projectName") != null) { %>
                    <%= request.getAttribute("error_projectName") %>
                    <% } %>
                </div>

                <div>
                    <label for="Description">Description</label> 
                    <textarea name="Description" id="Description" 
                              placeholder="Enter product description"><%= project != null && project.getDescription() != null ? project.getDescription() : "" %></textarea>
                </div>

                <div>
                    <label for="Status">Status</label>
                    <select id="Status" name="Status" required
                            class="<%= request.getAttribute("errorStatus") != null ? "error-field" : "" %>">
                        <option value="Ideation" <%= (project != null && "Ideation".equals(project.getStatus())) || project == null ? "selected" : "" %>>Ideation</option>
                        <option value="Development" <%= project != null && "Development".equals(project.getStatus()) ? "selected" : "" %>>Development</option>
                        <option value="Launch" <%= project != null && "Launch".equals(project.getStatus()) ? "selected" : "" %>>Launch</option>
                        <option value="Scaling" <%= project != null && "Scaling".equals(project.getStatus()) ? "selected" : "" %>>Scaling</option>
                    </select>
                    <% if (request.getAttribute("error_Status") != null) { %>
                    <%= request.getAttribute("error_Status") %>
                    <% } %>
                </div>

                <div>
                    <label for="estimated_launch">Estimated Launch Date</label>
                    <input type="date" id="estimated_launch" name="estimated_launch" required
                           value="<%= project != null ? project.getEstimated_launch() : "" %>"
                           class="<%= request.getAttribute("error_estimated_launch") != null ? "error-field" : "" %>">       
                    <% if (request.getAttribute("error_estimated_launch") != null) { %>
                    <%= request.getAttribute("error_estimated_launch") %>
                    <% } %>
                </div>

                <button type="submit" class="btn-submit">Create Project</button>
            </form>

        </form>

        <% if (checkError != null && !checkError.isEmpty()) { %>
        <div class="error"><%= checkError %></div>
        <% } %>

        <% if (message != null && !message.isEmpty()) { %>
        <div class="success-message"><%= message %></div>
        <% } %>
    </div>

</body>
</html>
