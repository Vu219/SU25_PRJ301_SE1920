<%-- 
    Document   : examsForm
    Created on : Jul 2, 2025, 9:29:13 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ExamCategoriesDTO"%>
<%@page import="java.util.List"%>
<%@page import="utils.AuthUtils"%>
<%@page import="model.ExamsDTO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create New Exam</title>
        <link rel="stylesheet" href="assets/css/styles.css">
    </head>
    <body>
        <div class="header">
            <h1>Online Examination System</h1>
        </div>

        <div class="exam-form">
            <%
                if (AuthUtils.isInstructor(request)) {         
                ExamsDTO exams = (ExamsDTO) request.getAttribute("exams");
                String checkError = (String) request.getAttribute("checkError");
                String message = (String) request.getAttribute("message");
            %>
            <form action="MainController" method="post">
                <h1>Create New Exam</h1>

                <input type="hidden" name="action" value="createExam" />

                <div class="form-group">
                    <label for="examTitle">Exam Title:</label>
                    <input type="text" name="exam_title" id="examTitle" required 
                           value="<%= exams != null && exams.getExam_title() != null ? exams.getExam_title() : "" %>"
                           placeholder="Enter Exam Title"
                           class="<%=request.getAttribute("error_examTitle") !=null ? "error-field" : ""%>"/>
                    <% if(request.getAttribute("error_examTitle") != null) { %>
                    <div class="error-message"><%= request.getAttribute("error_examTitle") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label for="subject">Subject:</label>
                    <input type="text" name="Subject" id="subject" required 
                           value="<%= exams != null && exams.getSubject() != null ? exams.getSubject() : "" %>"
                           placeholder="Enter Subject"
                           class="<%=request.getAttribute("error_Subject") !=null ? "error-field" : ""%>"/>
                    <% if(request.getAttribute("error_Subject") != null) { %>
                    <div class="error-message"><%= request.getAttribute("error_Subject") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label for="categoryId">Category:</label>
                    <select name="category_id" id="categoryId" required
                            class="<%=request.getAttribute("error_categoryId") !=null ? "error-field" : ""%>">
                        <option value="">Select a category</option>
                        <%
                            List<ExamCategoriesDTO> categories = (List<ExamCategoriesDTO>) request.getAttribute("categories");
                            int selectedCategoryId = exams != null ? exams.getCategory_id() : 0;
                            
                            if (categories != null) {
                                for (ExamCategoriesDTO category : categories) {
                                    String selected = (category.getCategory_id() == selectedCategoryId) ? "selected" : "";
                        %>
                        <option value="<%= category.getCategory_id() %>" <%= selected %>>
                            <%= category.getCategory_name() %>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <% if(request.getAttribute("error_categoryId") != null) { %>
                    <div class="error-message"><%= request.getAttribute("error_categoryId") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label for="totalMarks">Total Marks:</label>
                    <input type="number" name="total_marks" id="totalMarks" required 
                           value="<%= exams != null ?  exams.getTotal_marks() : "" %>"
                           placeholder="0"
                           class="<%=request.getAttribute("error_totalMarks") !=null ? "error-field" : "" %>"/>
                    <% if(request.getAttribute("error_totalMarks") != null) { %>
                    <div class="error-message"><%= request.getAttribute("error_totalMarks") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label for="duration">Duration (minutes):</label>
                    <input type="number" name="Duration" id="duration" required 
                           value="<%= exams != null ?  exams.getDuration() : "" %>"
                           placeholder="0"
                           class="<%=request.getAttribute("error_Duration") !=null ? "error-field" : "" %>"/>
                    <% if(request.getAttribute("error_Duration") != null) { %>
                    <div class="error-message"><%= request.getAttribute("error_Duration") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <button type="submit">Create Exam</button>
                </div>
            </form>

            <% if (checkError != null && !checkError.isEmpty()) { %>
            <div class="error"><%= checkError %></div>
            <% } %>

            <% if (message != null && !message.isEmpty()) { %>
            <div class="success-message"><%= message %></div>
            <% } %>

            <%
                } else {
            %>
            <div>
                <%=AuthUtils.getAccessDeniedMessage(" exam-form page ")%>
            </div>
            <%
                }
            %>
        </div>

        <div class="footer">
            &copy; 2025 Exam Management System
        </div>
    </body>
</html>
