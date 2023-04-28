/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package iotbay.servlets;

import iotbay.database.DatabaseManager;
import iotbay.models.Category;
import iotbay.models.Product;
import iotbay.models.httpResponses.GenericApiResponse;
import iotbay.models.httpResponses.ProductResponse;
import iotbay.util.CustomHttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.Builder;
import lombok.Setter;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.List;

/**
 * @author cmesina
 */
public class ShopServlet extends HttpServlet {

    DatabaseManager db;

    @Override
    public void init() throws ServletException {
        super.init(); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/OverriddenMethodBody

        this.db = (DatabaseManager) getServletContext().getAttribute("db");
    }


    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomHttpServletResponse res = new CustomHttpServletResponse(response);
        int limit = request.getParameter("limit") != null ? Integer.parseInt(request.getParameter("limit")) : 10;
        int offset = request.getParameter("offset") != null ? Integer.parseInt(request.getParameter("offset")) : 0;
        boolean getResponseAsJson = request.getParameter("json") != null && Boolean.parseBoolean(request.getParameter("json"));
        String searchNameParam = request.getParameter("searchName");

        // If the search name is empty, redirect to the shop page.
        if (searchNameParam != null) {
            if (searchNameParam.trim().equals("")) {
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }
        }

        String pageParameter = request.getParameter("page");
        if (pageParameter != null) {
            offset = (Integer.parseInt(pageParameter) - 1) * limit;
        }

        List<Product> products;
        try {
            if (searchNameParam != null) {
                products = this.db.getProducts().searchProduct(searchNameParam, limit, offset);
            } else {
                products = this.db.getProducts().getProducts(limit, offset, false);
            }

        } catch (SQLException e) {
            throw new ServletException("Failed to query database: " + e.getMessage());
        }

        List<Category> categories;
        try {
            categories = this.db.getCategories().getCategories();
        } catch (Exception e) {
            throw new ServletException("Failed to query database: " + e.getMessage());
        }

        int totalProducts = 0;
        try {
            if (searchNameParam != null) {
                totalProducts = this.db.getProducts().getProductCount(searchNameParam);
            } else {
                totalProducts = this.db.getProducts().getProductCount();
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // Pagination logic

        // Calculate the number of pages.
        int numberOfPages = (int) Math.ceil((double) totalProducts / limit);

        // Calculate the current page
        int currentPage = (int) Math.ceil((double) offset / limit) + 1;

        // Calculate the last offset
        int lastOffset = (numberOfPages - 1) * limit;

        // Calculate the next and previous offset
        int nextOffset = 0;
        int prevOffset = offset - limit;

        // If we have less products than the limit, we are at the end of the list
        if (products.size() < limit) {
            nextOffset = -1;
        } else {
            // Otherwise, we can calculate the next offset
            nextOffset = offset + limit;
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("limit", limit);
        request.setAttribute("nextOffset", nextOffset);
        request.setAttribute("prevOffset", prevOffset);
        request.setAttribute("numberOfPages", numberOfPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("lastOffset", lastOffset);

        // If we have a search name, pass it to the view.
        if (searchNameParam != null) {
            request.setAttribute("searchName", searchNameParam);
        }


        if (!getResponseAsJson) {
            request.getRequestDispatcher("/WEB-INF/jsp/products.jsp").forward(request, response);
        } else {
            ProductResponse productResponse = new ProductResponse();
            productResponse.setLimit(limit);
            productResponse.setNextOffset(nextOffset);
            productResponse.setPrevOffset(prevOffset);
            productResponse.setNumberOfPages(numberOfPages);
            productResponse.setCurrentPage(currentPage);
            productResponse.setLastOffset(lastOffset);
            productResponse.setProducts(products);

            res.sendJsonResponse(GenericApiResponse.<ProductResponse>builder()
                    .statusCode(200)
                    .message("OK")
                    .error(false)
                    .data(productResponse)
                    .build());
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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


}
