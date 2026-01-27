package com.yc.controller;

import com.yc.dao.CartDAO;
import com.yc.dao.AddressDAO;
import com.yc.model.CartItem;
import com.yc.model.Address;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private AddressDAO addressDAO = new AddressDAO();

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
        
        // Check if cart is empty
        if (cartItems.isEmpty()) {
            response.sendRedirect("CartServlet");
            return;
        }
        
        BigDecimal cartTotal = cartDAO.getCartTotal(cartId);
        int cartCount = cartDAO.getCartItemCount(cartId);
        
        // Get user addresses
        List<Address> addresses = addressDAO.getAddressesByUserId(userId);
        Address defaultAddress = addressDAO.getDefaultAddress(userId);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("cartCount", cartCount);
        request.setAttribute("addresses", addresses);
        request.setAttribute("defaultAddress", defaultAddress);
        request.getRequestDispatcher("Checkout.jsp").forward(request, response);
    }
}
