<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.Product, com.yc.model.Category" %>
<%
    // Get data from servlet
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String searchQuery = (String) request.getAttribute("searchQuery");
    
    // Get success/error messages
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    if (products == null) {
        response.sendRedirect("AdminProductServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Product Management</title>
    <style>
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        header {
            background-color: #7b0d1e;
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-area { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
        }
        
        .logo-img { 
            height: 45px; 
            width: auto; 
        }
        
        .brand-name { 
            font-family: 'Times New Roman', serif; 
            font-size: 24px; 
            letter-spacing: 2px; 
            text-transform: uppercase; 
        }
        
        nav a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .product-container {
            padding: 40px 5%;
            min-height: 60vh;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .search-box {
            display: flex;
            gap: 10px;
        }

        .search-box input {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            width: 200px;
        }

        .search-box button {
            padding: 10px 20px;
            background-color: #001a72;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        .add-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            text-transform: uppercase;
        }

        .add-btn:hover {
            background-color: #218838;
        }

        .message {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .success-message {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .product-card {
            background-color: #f9f6f2;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .product-card h3 {
            font-size: 18px;
            margin: 10px 0;
            color: #333;
        }

        .product-card .description {
            font-size: 13px;
            color: #666;
            margin: 5px 0;
        }

        .product-card .price {
            font-weight: bold;
            font-size: 18px;
            color: #7b0d1e;
            margin: 10px 0;
        }

        .product-card .stock {
            font-size: 12px;
            color: #666;
            margin-bottom: 15px;
        }

        .card-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .btn-edit, .btn-delete {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            text-transform: uppercase;
        }

        .btn-edit {
            background-color: #001a72;
            color: white;
        }

        .btn-edit:hover {
            background-color: #000f45;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        .no-products {
            text-align: center;
            padding: 60px;
            color: #666;
        }

        footer {
            background-color: #7b0d1e;
            color: white;
            padding: 40px 60px;
            display: flex;
            justify-content: space-between;
            margin-top: 50px;
        }

        .footer-col {
            flex: 1;
        }

        .footer-col h4 {
            font-size: 16px;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        .footer-col p, .footer-col a {
            display: block;
            color: #ffffff;
            text-decoration: none;
            font-size: 13px;
            margin: 8px 0;
        }
    </style>
</head>
<body>

    <header>
        <div class="logo-area">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">Yaya Cosmetic</div>
        </div>
        <nav>
            <a href="AdminDashboardServlet">HOME</a>
            <a href="AdminProductServlet">PRODUCT</a>
            <a href="AdminOrderServlet">ORDER</a>
            <a href="AdminMemberServlet">MEMBER</a>
            <a href="AdminProfileServlet">PROFILE</a>
        </nav>
    </header>

    <div class="product-container">
        <div class="page-header">
            <h1 class="page-title">PRODUCT MANAGEMENT</h1>
            <div class="header-actions">
                <form action="AdminProductServlet" method="GET" class="search-box">
                    <input type="text" name="search" placeholder="Search products..." 
                           value="<%= searchQuery != null ? searchQuery : "" %>">
                    <button type="submit">Search</button>
                </form>
                <a href="AddProductServlet" class="add-btn">+ Add Product</a>
            </div>
        </div>

        <% if ("added".equals(success)) { %>
            <div class="message success-message">Product added successfully!</div>
        <% } else if ("updated".equals(success)) { %>
            <div class="message success-message">Product updated successfully!</div>
        <% } else if ("deleted".equals(success)) { %>
            <div class="message success-message">Product deleted successfully!</div>
        <% } %>

        <% if ("notfound".equals(error)) { %>
            <div class="message error-message">Product not found.</div>
        <% } else if ("deletefailed".equals(error)) { %>
            <div class="message error-message">Failed to delete product. It may be referenced in orders.</div>
        <% } %>

        <% if (products.isEmpty()) { %>
            <div class="no-products">
                <h2>No Products Found</h2>
                <p>Click "Add Product" to add your first product.</p>
            </div>
        <% } else { %>
            <div class="product-grid">
                <% for (Product product : products) { %>
                    <div class="product-card">
                        <img src="<%= product.getImage() != null ? product.getImage() : "pic product/default.png" %>" 
                             alt="<%= product.getName() %>">
                        <h3><%= product.getName() %></h3>
                        <p class="description"><%= product.getDescription() %></p>
                        <p class="price">RM <%= product.getPrice() %></p>
                        <p class="stock">Stock: <%= product.getStockQty() %> units</p>
                        <div class="card-actions">
                            <a href="EditProductServlet?id=<%= product.getProductId() %>" class="btn-edit">Edit</a>
                            <form action="DeleteProductServlet" method="POST" style="display:inline;" 
                                  onsubmit="return confirm('Are you sure you want to delete this product?');">
                                <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                <button type="submit" class="btn-delete">Delete</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <footer>
        <div class="footer-col">
            <h4>ABOUT YAYA</h4>
            <a href="#">HISTORY</a>
            <a href="#">WORK IN YAYA</a>
        </div>
        <div class="footer-col">
            <h4>ADDRESS</h4>
            <p>BANGI AVENUE HEIGHT</p>
            <p>DAMANSARA UTAMA</p>
            <p>96029 DAMANSARA</p>
            <p>SELANGOR</p>
        </div>
        <div class="footer-col">
            <h4>CONTACT</h4>
            <p>03-78279388 (OFFICE HOUR)</p>
            <p>yayacosmetic@hotline.com</p>
            <p>@yayacosmeticofficial (Instagram)</p>
        </div>
    </footer>

    <script>
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() { msg.style.display = 'none'; }, 500);
            });
        }, 5000);
    </script>

</body>
</html>
