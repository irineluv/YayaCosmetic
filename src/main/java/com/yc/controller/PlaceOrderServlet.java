package com.yc.controller;

import com.yc.dao.CartDAO;
import com.yc.dao.OrderDAO;
import com.yc.dao.ProductDAO;
import com.yc.dao.AddressDAO;
import com.yc.model.CartItem;
import com.yc.model.Order;
import com.yc.model.OrderItem;
import com.yc.model.Address;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();
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
        int cartId = cartDAO.getOrCreateCart(userId);
        
        // Get form data
        String addressIdStr = request.getParameter("addressId");
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Validate
        if (addressIdStr == null || paymentMethod == null) {
            response.sendRedirect("CheckoutServlet?error=missing");
            return;
        }

        try {
            int addressId = Integer.parseInt(addressIdStr);
            
            // Verify address belongs to user
            Address address = addressDAO.getAddressById(addressId);
            if (address == null || address.getUserId() != userId) {
                response.sendRedirect("CheckoutServlet?error=invalidaddress");
                return;
            }
            
            // Get cart items
            List<CartItem> cartItems = cartDAO.getCartItems(cartId);
            if (cartItems.isEmpty()) {
                response.sendRedirect("CartServlet");
                return;
            }
            
            BigDecimal cartTotal = cartDAO.getCartTotal(cartId);
            
            // Create order
            Order order = new Order();
            order.setUserId(userId);
            order.setAddressId(addressId);
            order.setTotalAmount(cartTotal);
            order.setStatus("pending");
            order.setPaymentMethod(paymentMethod);
            order.setPaymentStatus("unpaid");
            
            int orderId = orderDAO.createOrder(order);
            
            if (orderId > 0) {
                // Add order items
                for (CartItem item : cartItems) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setProductId(item.getProductId());
                    orderItem.setQuantity(item.getQuantity());
                    orderItem.setUnitPrice(item.getProductPrice());
                    orderItem.setTotalPrice(item.getSubtotal());
                    orderDAO.addOrderItem(orderItem);
                    
                    // Update product stock
                    // productDAO.updateStock(item.getProductId(), -item.getQuantity());
                }
                
                // Store order info in session for payment page
                session.setAttribute("pendingOrderId", orderId);
                session.setAttribute("pendingOrderTotal", cartTotal);
                session.setAttribute("pendingPaymentMethod", paymentMethod);
                
                // Redirect based on payment method
                if ("bank".equals(paymentMethod)) {
                    response.sendRedirect("BankPayment.jsp");
                } else {
                    // For COD, mark as processing and go to confirmation
                    orderDAO.updatePaymentStatus(orderId, "cod");
                    orderDAO.updateOrderStatus(orderId, "processing", 0);
                    cartDAO.clearCart(cartId);
                    session.removeAttribute("pendingOrderId");
                    response.sendRedirect("OrderConfirmationServlet?orderId=" + orderId);
                }
            } else {
                response.sendRedirect("CheckoutServlet?error=orderfailed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("CheckoutServlet?error=invalid");
        }
    }
}
