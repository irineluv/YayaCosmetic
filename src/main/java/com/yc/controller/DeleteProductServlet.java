package com.yc.controller;

import com.yc.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        String idStr = request.getParameter("productId");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("AdminProductServlet?error=invalid");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);
            boolean success = productDAO.deleteProduct(productId);

            if (success) {
                response.sendRedirect("AdminProductServlet?success=deleted");
            } else {
                response.sendRedirect("AdminProductServlet?error=deletefailed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("AdminProductServlet?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminProductServlet?error=system");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST for security
        doPost(request, response);
    }
}
