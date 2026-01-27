package com.yc.controller;

import com.yc.dao.ProductDAO;
import com.yc.dao.CategoryDAO;
import com.yc.dao.CartDAO;
import com.yc.model.Product;
import com.yc.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ProductListServlet")
public class ProductListServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter parameters
        String search = request.getParameter("search");
        String categoryIdStr = request.getParameter("category");
        
        List<Product> products;

        if (search != null && !search.trim().isEmpty()) {
            products = productDAO.searchProducts(search.trim());
            request.setAttribute("searchQuery", search);
        } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                products = productDAO.getProductsByCategory(categoryId);
                request.setAttribute("selectedCategory", categoryId);
            } catch (NumberFormatException e) {
                products = productDAO.getAllProducts();
            }
        } else {
            products = productDAO.getAllProducts();
        }

        // Get categories for filter
        List<Category> categories = categoryDAO.getAllCategories();

        // Get cart count if user is logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (Integer) session.getAttribute("userId");
            int cartId = cartDAO.getOrCreateCart(userId);
            int cartCount = cartDAO.getCartItemCount(cartId);
            request.setAttribute("cartCount", cartCount);
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("Product.jsp").forward(request, response);
    }
}
