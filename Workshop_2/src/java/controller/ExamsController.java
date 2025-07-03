/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ExamCategoriesDAO;
import model.ExamCategoriesDTO;
import model.ExamsDAO;
import model.ExamsDTO;
import utils.AuthUtils;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ExamsController", urlPatterns = {"/ExamsController"})
public class ExamsController extends HttpServlet {

    ExamsDAO examsDAO = new ExamsDAO();

    private static final String EXAM_FORM = "examsForm.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String action = request.getParameter("action");
            if (action.equals("createExam")) {
                if ("GET".equalsIgnoreCase(request.getMethod())) {
                    url = handleShowCreateExamForm(request, response);
                } else {
                    url = handleCreateExamWithCategory(request, response);
                }
            } else {
                request.setAttribute("message", "Invalid action: " + action);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "System error occurred!");
            url = ERROR_PAGE;
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private String handleCreateExamWithCategory(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";

        if (!AuthUtils.isInstructor(request)) {
            return LOGIN_PAGE;
        }

        try {
            String examTitle = request.getParameter("exam_title");
            String Subject = request.getParameter("Subject");
            String category_id = request.getParameter("category_id");
            String totalMarks = request.getParameter("total_marks");
            String Duration = request.getParameter("Duration");

            int categoryId = 0;
            int total_Marks = 0;
            int duration = 0;

            if (examTitle == null || examTitle.trim().isEmpty()) {
                request.setAttribute("error_examTitle", "Exam Title is required.");
                checkError += "Exam Title is required.<br/>";
            }

            if (Subject == null || Subject.trim().isEmpty()) {
                request.setAttribute("error_Subject", "Subject is required.");
                checkError += "Subject is required.<br/>";
            }

            if (category_id == null || category_id.trim().isEmpty()) {
                request.setAttribute("error_categoryId", "Category is required.");
                checkError += "Category is required.<br/>";
            } else {
                categoryId = Integer.parseInt(category_id);
                if (categoryId <= 0) {
                    request.setAttribute("error_categoryId", "Invalid category selected.");
                    checkError += "Invalid category selected.<br/>";
                }
            }

            if (totalMarks == null || totalMarks.trim().isEmpty()) {
                request.setAttribute("error_totalMarks", "Total Marks is required.");
                checkError += "Total Marks is required.<br/>";
            } else {
                total_Marks = Integer.parseInt(totalMarks);
                if (total_Marks <= 0) {
                    request.setAttribute("error_totalMarks", "Total Marks must be greater than 0.");
                    checkError += "Total Marks must be greater than 0.<br/>";
                }
            }

            if (Duration == null || Duration.trim().isEmpty()) {
                request.setAttribute("error_Duration", "Duration is required.");
                checkError += "Duration is required.<br/>";
            } else {
                duration = Integer.parseInt(Duration);
                if (duration <= 0) {
                    request.setAttribute("error_Duration", "Duration must be greater than 0");
                    checkError += "<br/>Duration must be greater than 0.";
                }
            }

            ExamsDTO exams = new ExamsDTO();
            exams.setExam_id(examsDAO.getMaxExamId() + 1);
            exams.setExam_title(examTitle);
            exams.setSubject(Subject);
            exams.setCategory_id(categoryId);
            exams.setTotal_marks(total_Marks);
            exams.setDuration(duration);

            if (checkError.isEmpty()) {
                boolean created = examsDAO.createExam(exams);
                if (created) {
                    message = "Exam created successfully!";
                    request.setAttribute("categories", null);
                } else {
                    checkError = "Failed to create exam. Please try again.";
                }
            }
            request.setAttribute("exams", exams);
        } catch (Exception e) {
            e.printStackTrace();
            checkError = "System error: " + e.getMessage();
        }
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        return EXAM_FORM;
    }

    private String handleShowCreateExamForm(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isInstructor(request)) {
            return LOGIN_PAGE;
        }

        try {
            ExamCategoriesDAO categoriesDAO = new ExamCategoriesDAO();
            List<ExamCategoriesDTO> categories = categoriesDAO.getAllExamCategories();
            request.setAttribute("categories", categories);
            return EXAM_FORM;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_general", "Error loading categories: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

}
