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
@WebServlet(name = "CategoriesController", urlPatterns = {"/CategoriesController"})
public class CategoriesController extends HttpServlet {

    ExamCategoriesDAO categoriesDAO = new ExamCategoriesDAO();
    ExamsDAO examsDAO = new ExamsDAO();

    private static final String WELCOME_PAGE = "welcome.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String action = request.getParameter("action");
            if (action.equals("viewExamCategories")) {
                url = handleViewAllExamCategories(request, response);
            } else if (action.equals("viewExamsByCategory")) {
                url = handleViewExamsByCategory(request, response);
            } else {
                request.setAttribute("message", "Invalid action: " + action);
                url = WELCOME_PAGE;
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

    private String handleViewAllExamCategories(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedIn(request)) {
            return LOGIN_PAGE;
        }

        try {
            List<ExamCategoriesDTO> categories = categoriesDAO.getAllExamCategories();
            request.setAttribute("categories", categories);
            return WELCOME_PAGE;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_general", "Error retrieving ExamCategories: " + e.getMessage());
        }
        return "MainController";
    }

    private String handleViewExamsByCategory(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedIn(request)) {
            return LOGIN_PAGE;
        }

        if (AuthUtils.isStudent(request)) {
            try {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                List<ExamCategoriesDTO> categories = categoriesDAO.getAllExamCategories();
                request.setAttribute("categories", categories);

                List<ExamsDTO> exams = examsDAO.getExamsByCategory(categoryId);
                request.setAttribute("exams", exams);
                request.setAttribute("selectedCategoryId", categoryId);

                return WELCOME_PAGE;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error_general", "Error retrieving exams: " + e.getMessage());
            }
        }
        return "MainController";
    }

}
