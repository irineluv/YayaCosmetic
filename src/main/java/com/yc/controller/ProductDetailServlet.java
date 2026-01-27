package com.yc.controller;

import com.yc.dao.ProductDAO;
import com.yc.dao.CartDAO;
import com.yc.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ProductDetailServlet")
public class ProductDetailServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("ProductListServlet");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendRedirect("ProductListServlet");
                return;
            }

            // Get cart count if user is logged in
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("userId") != null) {
                int userId = (Integer) session.getAttribute("userId");
                int cartId = cartDAO.getOrCreateCart(userId);
                int cartCount = cartDAO.getCartItemCount(cartId);
                request.setAttribute("cartCount", cartCount);
            }

            request.setAttribute("product", product);
            request.getRequestDispatcher("ProductDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ProductListServlet");
        }
    }
}
