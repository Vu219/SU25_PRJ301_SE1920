/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ProductDAO;
import model.ProductDTO;
import utils.AuthUtils;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    ProductDAO pdao = new ProductDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        try {
            String action = request.getParameter("action");
            //--- Xu ly cac action cua Product ---
            if (action.equals("addProduct")) {
                url = handleProductAdding(request, response);
            }else if (action.equals("searchProduct")) {
                url = handleProductSearching(request, response);
            }
            
        } catch (Exception e) {
        } finally {
            System.out.println(url);
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private String handleProductAdding(HttpServletRequest request, HttpServletResponse response) {
        String checkError = "";
        String message = "";

        if (AuthUtils.isAdmin(request)) {
            //lay thong tin ra 
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String image = request.getParameter("image");
            String description = request.getParameter("description");
            String price = request.getParameter("price");
            String size = request.getParameter("size");
            String status = request.getParameter("status");

            double price_value = 0;
            try {
                price_value = Double.parseDouble(price);
            } catch (Exception e) {
            } finally {
            }

            boolean status_value = true;
            try {
                status_value = Boolean.parseBoolean(status);
            } catch (Exception e) {
            } finally {
            }

            //kiem tra loi
            //kiem tra san pham bi trung
            if (pdao.isProductExists(id)) {
                request.setAttribute("error_id", "This Product ID already exists.");
                checkError = "This Product ID already exists. Can not add new product.";
            } else if (id == null || id.trim().isEmpty()) {
                checkError += "Product ID is required.<br/>";
                request.setAttribute("errorId", "Product ID is required.");
            }

            if (name == null || name.trim().isEmpty()) {
                checkError += "Product name is required.<br/>";
                request.setAttribute("errorName", "Product name is required.");
            }

            if (price_value <= 0) {
                request.setAttribute("error_price", "Price must be greater than zero!");
                checkError += "<br/>Price must be greater than zero!";
            }

            ProductDTO product = new ProductDTO(id, name, image, description, price_value, size, status_value);

            if (checkError.isEmpty()) {
                if (!pdao.createProduct(product)) {
                    checkError = "<br/> Can not add product!";
                    request.setAttribute("error_general", checkError);
                } else {
                    message = "Add product successfully!";
                }
            }

            request.setAttribute("product", product);
        }
        request.setAttribute("checkError", checkError);
        request.setAttribute("message", message);
        return "productForm.jsp";
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

    private String handleProductSearching(HttpServletRequest request, HttpServletResponse response) {
        String keyword = request.getParameter("strKeyword");
        List<ProductDTO> list = pdao.searchProductsByName(keyword);
        request.setAttribute("list", list);
        request.setAttribute("keyword", keyword);
        return "welcome.jsp";
    }

}
