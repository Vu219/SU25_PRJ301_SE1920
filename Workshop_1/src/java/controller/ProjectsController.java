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
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.ProjectsDAO;
import model.ProjectsDTO;
import model.UserDTO;
import utils.AuthUtils;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ProjectsController", urlPatterns = {"/ProjectsController"})
public class ProjectsController extends HttpServlet {

    ProjectsDAO pdao = new ProjectsDAO();

    private static final String WELCOME_PAGE = "welcome.jsp";
    private static final String PROJECTS_PAGE = "projectsForm.jsp";
    private static final String ERROR_PAGE = "error.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String action = request.getParameter("action");

            //Xu ly addProjects
            if (action.equals("viewProjects")) {
                url = handleViewProjects(request, response);
            } else if (action.equals("addProjects")) {
                url = handleProjectsAdding(request, response);
            } else if (action.equals("updateStatus")) {
                url = handleUpdateProjectStatus(request, response);
            } else if (action.equals("searchProject")) {
                url = handleSearchProject(request, response);
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

    private String handleViewProjects(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedIn(request)) {
            return LOGIN_PAGE;
        }

        try {
            List<ProjectsDTO> projects = pdao.getAllProjects();
            request.setAttribute("projects", projects);
            return WELCOME_PAGE;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_general", "Error retrieving projects: " + e.getMessage());
        }
        return "MainController";
    }

    private String handleProjectsAdding(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";

        if (!AuthUtils.isLoggedIn(request)) {
            return LOGIN_PAGE;
        }

        if (AuthUtils.isFounder(request)) {
            if (request.getParameter("project_name") != null) {
                String projectName = request.getParameter("project_name");
                String description = request.getParameter("Description");
                String status = request.getParameter("Status");
                String launchDateStr = request.getParameter("estimated_launch");

                java.sql.Date launchDate = null;

                try {
                    if (launchDateStr != null && !launchDateStr.trim().isEmpty()) {
                        launchDate = java.sql.Date.valueOf(launchDateStr);
                    }
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error_estimated_launch", "Invalid date format");
                    checkError += "Invalid date format.<br/>";
                }

                if (projectName == null || projectName.trim().isEmpty()) {
                    request.setAttribute("error_projectName", "Project name is required.");
                    checkError += "Project name is required.<br/>";
                }

                if (description == null || description.trim().isEmpty()) {
                    request.setAttribute("error_description", "Description is required.");
                    checkError += "Description is required.<br/>";
                }
                
                if (status == null || status.trim().isEmpty()) {
                    request.setAttribute("error_Status", "Status is required.");
                    checkError += "Status is required.<br/>";
                } else if (!status.matches("Ideation|Development|Launch|Scaling")) {
                    request.setAttribute("error_Status", "Status must be Ideation, Development, Launch or Scaling");
                    checkError += "Invalid status value.<br/>";
                }

                if (launchDate == null) {
                    request.setAttribute("error_estimated_launch", "Launch date is required");
                    checkError += "Launch date is required.<br/>";
                }

                ProjectsDTO project = new ProjectsDTO(projectName, description, status, launchDate);

                if (checkError.isEmpty()) {
                    try {
                        if (pdao.isProjectExists(projectName)) {
                            request.setAttribute("error_projectName", "Project name already exists.");
                            checkError = "Failed to add project.<br/>";
                        } else if (!pdao.addProject(project)) {
                            checkError = "Failed to add project.<br/>";
                        } else {
                            message = "Project added successfully!";
                            request.setAttribute("project", null);
                        }
                    } catch (Exception e) {
                        checkError = "Database error: " + e.getMessage();
                    }
                }
                request.setAttribute("project", project);
            }
        }
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        return PROJECTS_PAGE;
    }

    private String handleUpdateProjectStatus(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedIn(request)) {
            return LOGIN_PAGE;
        }

        if (!AuthUtils.isFounder(request)) {
            request.setAttribute("error_general", AuthUtils.getAccessDeniedMessage("update project status"));
            return handleViewProjects(request, response);
        } else {
            try {
                
                int project_id;
                try {
                    project_id = Integer.parseInt(request.getParameter("project_id"));
                } catch (NumberFormatException e) {
                    request.setAttribute("error_general", "Invalid Project ID");
                    return handleViewProjects(request, response);
                }

                String newStatus = request.getParameter("Status");
                if (!isValidStatus(newStatus)) {
                    request.setAttribute("error_general", "Invalid status value!");
                    return handleViewProjects(request, response);
                }

                boolean Updated = pdao.updateProjectStatus(project_id, newStatus);
                if (Updated) {
                    request.setAttribute("message", "Status updated successfully!");
                } else {
                    request.setAttribute("error_general", "Failed to update status. Project may not exist.");
                }

            } catch (Exception e) {
                request.setAttribute("error_general", "System error: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return handleViewProjects(request, response);
    }

    private boolean isValidStatus(String status) {
        return status != null && status.matches("Ideation|Development|Launch|Scaling");
    }

    private String handleSearchProject(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedIn(request)) {
            return LOGIN_PAGE;
        }

        if (!AuthUtils.isFounder(request)) {
            request.setAttribute("error_general", "Only Founder can search projects!");
            return handleViewProjects(request, response);
        }

        String keyword = request.getParameter("strKeyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            return handleViewProjects(request, response);
        }

        try {
            List<ProjectsDTO> projects = pdao.searchProjectsByName(keyword);
            request.setAttribute("projects", projects);
            request.setAttribute("keyword", keyword);
         
            if (projects.isEmpty()) {
                request.setAttribute("message", "No projects found for: " + keyword);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_general", "Error searching projects: " + e.getMessage());
        }
        return WELCOME_PAGE;
    }

}
