package com.yc.controller;

import com.yc.dao.ProductDAO;
import com.yc.dao.CategoryDAO;
import com.yc.model.Product;
import com.yc.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminProductServlet")
public class AdminProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        // Get search parameter if any
        String search = request.getParameter("search");
        List<Product> products;

        if (search != null && !search.trim().isEmpty()) {
            products = productDAO.searchProducts(search.trim());
            request.setAttribute("searchQuery", search);
        } else {
            products = productDAO.getAllProducts();
        }

        // Get categories for filter/display
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("AdminProduct.jsp").forward(request, response);
    }
}
