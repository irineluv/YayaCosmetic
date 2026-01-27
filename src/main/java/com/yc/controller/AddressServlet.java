package com.yc.controller;

import com.yc.dao.AddressDAO;
import com.yc.model.Address;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddressServlet")
public class AddressServlet extends HttpServlet {

    private AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Address address = new Address();
            address.setUserId(userId);
            address.setLabel(request.getParameter("label"));
            address.setAddressLine(request.getParameter("addressLine"));
            address.setCity(request.getParameter("city"));
            address.setState(request.getParameter("state"));
            address.setPostalCode(request.getParameter("postalCode"));
            address.setCountry(request.getParameter("country"));
            address.setPhone(request.getParameter("phone"));
            address.setDefault("on".equals(request.getParameter("isDefault")));

            int addressId = addressDAO.addAddress(address);
            if (addressId > 0) {
                response.sendRedirect("ProfileServlet?success=addressadded");
            } else {
                response.sendRedirect("ProfileServlet?error=addressfailed");
            }

        } else if ("update".equals(action)) {
            String addressIdStr = request.getParameter("addressId");
            if (addressIdStr != null) {
                int addressId = Integer.parseInt(addressIdStr);
                Address address = addressDAO.getAddressById(addressId);
                
                if (address != null && address.getUserId() == userId) {
                    address.setLabel(request.getParameter("label"));
                    address.setAddressLine(request.getParameter("addressLine"));
                    address.setCity(request.getParameter("city"));
                    address.setState(request.getParameter("state"));
                    address.setPostalCode(request.getParameter("postalCode"));
                    address.setCountry(request.getParameter("country"));
                    address.setPhone(request.getParameter("phone"));
                    address.setDefault("on".equals(request.getParameter("isDefault")));

                    if (addressDAO.updateAddress(address)) {
                        response.sendRedirect("ProfileServlet?success=addressupdated");
                    } else {
                        response.sendRedirect("ProfileServlet?error=addressfailed");
                    }
                } else {
                    response.sendRedirect("ProfileServlet?error=invalidaddress");
                }
            }

        } else if ("delete".equals(action)) {
            String addressIdStr = request.getParameter("addressId");
            if (addressIdStr != null) {
                int addressId = Integer.parseInt(addressIdStr);
                Address address = addressDAO.getAddressById(addressId);
                
                if (address != null && address.getUserId() == userId) {
                    if (addressDAO.deleteAddress(addressId)) {
                        response.sendRedirect("ProfileServlet?success=addressdeleted");
                    } else {
                        response.sendRedirect("ProfileServlet?error=addressfailed");
                    }
                } else {
                    response.sendRedirect("ProfileServlet?error=invalidaddress");
                }
            }

        } else {
            response.sendRedirect("ProfileServlet");
        }
    }
}
