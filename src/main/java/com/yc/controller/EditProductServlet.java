package com.yc.controller;

import com.yc.dao.ProductDAO;
import com.yc.dao.CategoryDAO;
import com.yc.model.Product;
import com.yc.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {

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

        // Get product ID
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("AdminProductServlet");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendRedirect("AdminProductServlet?error=notfound");
                return;
            }

            // Get categories for dropdown
            List<Category> categories = categoryDAO.getAllCategories();
            
            // Get available product images
            List<String> availableImages = getAvailableImages();

            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.setAttribute("availableImages", availableImages);
            request.getRequestDispatcher("EditProduct.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("AdminProductServlet");
        }
    }
    
    private List<String> getAvailableImages() {
        List<String> images = new ArrayList<>();
        String imagePath = getServletContext().getRealPath("/pic product/");
        
        if (imagePath != null) {
            File imageDir = new File(imagePath);
            if (imageDir.exists() && imageDir.isDirectory()) {
                File[] files = imageDir.listFiles();
                if (files != null) {
                    for (File file : files) {
                        String name = file.getName().toLowerCase();
                        // Only include product images (not DETAIL images)
                        if ((name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".jpeg")) 
                            && !name.startsWith("detail")) {
                            images.add("pic product/" + file.getName());
                        }
                    }
                }
            }
        }
        return images;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("AdminLogin.jsp");
            return;
        }

        try {
            // Get form data
            String idStr = request.getParameter("productId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String categoryIdStr = request.getParameter("categoryId");
            String image = request.getParameter("image");

            // Validate required fields
            if (idStr == null || name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Product ID and name are required");
                doGet(request, response);
                return;
            }

            int productId = Integer.parseInt(idStr);

            // Get existing product
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect("AdminProductServlet?error=notfound");
                return;
            }

            // Update product object
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : "");
            double price = 0.0;

            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = Double.parseDouble(priceStr);
            }

            product.setPrice(price);

            product.setStockQty(stockStr != null ? Integer.parseInt(stockStr) : 0);
            product.setCategoryId(categoryIdStr != null ? Integer.parseInt(categoryIdStr) : 1);
            product.setImage(image != null ? image.trim() : product.getImage());
            product.setUpdatedBy((Integer) session.getAttribute("adminId"));

            // Save to database
            boolean success = productDAO.updateProduct(product);

            if (success) {
                response.sendRedirect("AdminProductServlet?success=updated");
            } else {
                request.setAttribute("error", "Failed to update product");
                request.setAttribute("product", product);
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("EditProduct.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            doGet(request, response);
        }
    }
}
