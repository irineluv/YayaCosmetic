package com.yc.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {
    "/AdminHome.jsp",
    "/AdminProduct.jsp",
    "/AdminOrder.jsp",
    "/AdminMember.jsp",
    "/AdminProfile.jsp",
    "/AdminEditProfile.jsp",
    "/AddProduct.jsp",
    "/EditProduct.jsp",
    "/AdminDashboardServlet",
    "/AdminProductServlet",
    "/AdminOrderServlet",
    "/AdminMemberServlet",
    "/AdminProfileServlet",
    "/AddProductServlet",
    "/EditProductServlet",
    "/DeleteProductServlet",
    "/UpdateOrderStatusServlet",
    "/UpdateAdminProfileServlet"
})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("adminId") != null);

        if (isLoggedIn) {
            // Admin is logged in, continue with the request
            chain.doFilter(request, response);
        } else {
            // Admin is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/AdminLogin.jsp");
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
