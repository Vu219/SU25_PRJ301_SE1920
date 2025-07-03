<%-- 
    Document   : welcome
    Created on : Jun 28, 2025, 7:25:19 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.UserDTO"%>
<%@page import="utils.AuthUtils"%>
<%@page import="model.ExamCategoriesDTO"%>
<%@page import="java.util.List"%>
<%@page import="model.ExamsDTO"%>
<%@page import="utils.AuthUtils"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome Page</title>
        <link rel="stylesheet" href="assets/css/styles.css">
    </head>
    <body>
        <div class="header">
            <h1>Welcome to Exam Dashboard</h1>
        </div>

        <div class="container">
            <%
                UserDTO user = AuthUtils.getCurrentUser(request);
                if(!AuthUtils.isLoggedIn(request)) {
                    response.sendRedirect("MainController");
                } else {
                    String keyword = (String) request.getAttribute("keyword");
            %>

            <div class="user-header">
                <h2>Hello <span class="user-name"><%= user.getName() %></span>!</h2>
                
                <div class="logout">
                    <a href="MainController?action=logout" 
                       onclick="return confirm('Are you sure you want to log out?');"
                       class="logout-btn">
                        Logout
                    </a>
                </div>
            </div>

            <% if(AuthUtils.isInstructor(request)) { %>
            <div class="create">
                <a href="MainController?action=createExam" >
                    Create New Exam
                </a>
            </div>
            <% } %>   

            <%    
                List<ExamCategoriesDTO> categories = (List<ExamCategoriesDTO>) request.getAttribute("categories"); 
                List<ExamsDTO> exams = (List<ExamsDTO>) request.getAttribute("exams");
                
                Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
                
                if (categories != null && categories.isEmpty()) {
            %>
            <p>There is no ExamCategories.</p>
            <%
                } else if (categories != null && !categories.isEmpty()) {
            %>
            <table>
                <thead>
                    <tr>
                        <th>Category Name</th>
                        <th>Description</th>

                        <% if(AuthUtils.isStudent(request)) { %>
                        <th>Action</th> 
                            <% } %>
                    </tr>
                </thead>
                <tbody>
                    <%       
                        for (ExamCategoriesDTO category : categories) {
                    %>
                    <tr>
                        <td><%= category.getCategory_name() %></td>
                        <td><%= category.getDescription() %></td>

                        <% if(AuthUtils.isStudent(request)) { %>
                        <td>                                                     
                            <form action="MainController" method="post">
                                <input type="hidden" name="action" value="viewExamsByCategory"/>
                                <input type="hidden" name="categoryId" value="<%= category.getCategory_id() %>"/>
                                <input type="submit" value="View Exams"/>
                            </form>   
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
                if(AuthUtils.isStudent(request)) { 
                    if (exams != null && !exams.isEmpty()) {
            %>

            <h3>Exams for Selected Category</h3>
            <table>
                <thead>
                    <tr>
                        <th>Exam Title</th>
                        <th>Subject</th>
                        <th>Category</th>
                        <th>Total Marks</th>
                        <th>Duration (minutes)</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (ExamsDTO exam : exams) {
                    %>
                    <tr>
                        <td><%= exam.getExam_title() %></td>
                        <td><%= exam.getSubject() %></td>
                        <td><%= exam.getCategory_name() %></td>
                        <td><%= exam.getTotal_marks() %></td>
                        <td><%= exam.getDuration() %></td>

                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                } else if (selectedCategoryId != null) {
            %>
            <p>No exams found for this category.</p>
            <%
                }
            %>

            <%
                }
            %>
            <%
                }
            %>
        </div>

        <div class="footer">
            &copy; 2025 Exam Management System
        </div>
    </body>
</html>
