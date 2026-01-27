package com.yc.controller;

import com.yc.dao.UserDAO;
import com.yc.dao.AddressDAO;
import com.yc.dao.CartDAO;
import com.yc.model.User;
import com.yc.model.Address;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private AddressDAO addressDAO = new AddressDAO();
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
        
        User user = userDAO.getUserById(userId);
        List<Address> addresses = addressDAO.getAddressesByUserId(userId);
        
        // Get cart count
        int cartId = cartDAO.getOrCreateCart(userId);
        int cartCount = cartDAO.getCartItemCount(cartId);

        request.setAttribute("user", user);
        request.setAttribute("addresses", addresses);
        request.setAttribute("cartCount", cartCount);
        request.getRequestDispatcher("Profile.jsp").forward(request, response);
    }
}
