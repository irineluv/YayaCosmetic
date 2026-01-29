package com.yc.controller;

import com.yc.dao.CartDAO;
import com.yc.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int cartId = cartDAO.getOrCreateCart(userId);
        
        List<CartItem> cartItems = cartDAO.getCartItems(cartId);
        BigDecimal cartTotal = cartDAO.getCartTotal(cartId);
        int cartCount = cartDAO.getCartItemCount(cartId);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("cartCount", cartCount);
        session.setAttribute("cartCount", cartCount);
        
        request.getRequestDispatcher("Cart.jsp").forward(request, response);
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int cartId = cartDAO.getOrCreateCart(userId);
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");

            if (productIdStr != null) {
                int productId = Integer.parseInt(productIdStr);
                int quantity = quantityStr != null ? Integer.parseInt(quantityStr) : 1;
                cartDAO.addToCart(cartId, productId, quantity);

                session.setAttribute("cartMessage", "  Item has been added to cart");
            }

            String referer = request.getHeader("Referer");
            if (referer != null && !referer.contains("Cart")) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect("CartServlet");
            }
            int cartCount = cartDAO.getCartItemCount(cartId);
            session.setAttribute("cartCount", cartCount);

        }
         else if ("update".equals(action)) {
            String cartItemIdStr = request.getParameter("cartItemId");
            String quantityStr = request.getParameter("quantity");
            
            if (cartItemIdStr != null && quantityStr != null) {
                int cartItemId = Integer.parseInt(cartItemIdStr);
                int quantity = Integer.parseInt(quantityStr);
                
                if (quantity <= 0) {
                    cartDAO.removeCartItem(cartItemId);
                } else {
                    cartDAO.updateCartItemQuantity(cartItemId, quantity);
                }
            }
            response.sendRedirect("CartServlet");

        } else if ("remove".equals(action)) {
            String cartItemIdStr = request.getParameter("cartItemId");
            
            if (cartItemIdStr != null) {
                int cartItemId = Integer.parseInt(cartItemIdStr);
                cartDAO.removeCartItem(cartItemId);
            }
            response.sendRedirect("CartServlet");

        } else if ("clear".equals(action)) {
            cartDAO.clearCart(cartId);
            response.sendRedirect("CartServlet");

        } else {
            response.sendRedirect("CartServlet");
        }
    }
}
