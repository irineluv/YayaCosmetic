<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.Product, com.yc.model.Category" %>
<%
    Product product = (Product) request.getAttribute("product");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<String> availableImages = (List<String>) request.getAttribute("availableImages");
    String error = (String) request.getAttribute("error");
    
    if (product == null || categories == null) {
        response.sendRedirect("AdminProductServlet");
        return;
    }
    
    String currentImage = product.getImage() != null ? product.getImage() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Edit Product</title>
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

        .form-container {
            padding: 40px 5%;
            min-height: 60vh;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #7b0d1e;
            text-decoration: none;
            font-size: 14px;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 30px 0;
        }

        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .form-layout {
            display: flex;
            gap: 40px;
            align-items: flex-start;
        }

        .preview-section {
            flex: 0 0 300px;
            background-color: #f9f6f2;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
        }

        .preview-title {
            font-size: 14px;
            font-weight: bold;
            color: #666;
            margin-bottom: 15px;
            text-transform: uppercase;
        }

        .preview-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
            background-color: #eee;
        }

        .preview-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin: 10px 0;
        }

        .preview-price {
            font-size: 20px;
            font-weight: bold;
            color: #7b0d1e;
        }

        .form-card {
            flex: 1;
            background-color: #f9f6f2;
            padding: 40px;
            border-radius: 15px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .image-selection {
            margin-top: 10px;
        }

        .image-selection-title {
            font-size: 13px;
            color: #666;
            margin-bottom: 10px;
        }

        .image-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            max-height: 250px;
            overflow-y: auto;
            padding: 10px;
            background-color: #fff;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .image-option {
            position: relative;
            cursor: pointer;
        }

        .image-option input[type="radio"] {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }

        .image-option img {
            width: 100%;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 3px solid transparent;
            transition: all 0.2s;
        }

        .image-option input[type="radio"]:checked + img {
            border-color: #7b0d1e;
            box-shadow: 0 0 10px rgba(123, 13, 30, 0.3);
        }

        .image-option:hover img {
            border-color: #ddd;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background-color: #001a72;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
        }

        .btn-submit:hover {
            background-color: #000f45;
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

        @media (max-width: 800px) {
            .form-layout {
                flex-direction: column;
            }
            .preview-section {
                flex: none;
                width: 100%;
            }
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

    <div class="form-container">
        <a href="AdminProductServlet" class="back-link">← Back to Products</a>
        <h1 class="page-title">EDIT PRODUCT</h1>

        <% if (error != null) { %>
            <div class="error-message"><%= error %></div>
        <% } %>

        <div class="form-layout">
            <div class="preview-section">
                <div class="preview-title">Product Preview</div>
                <img id="previewImg" src="<%= currentImage %>" alt="Preview" class="preview-image">
                <div id="previewName" class="preview-name"><%= product.getName() %></div>
                <div id="previewPrice" class="preview-price">RM <%= product.getPrice() %></div>
            </div>

            <div class="form-card">
                <form action="EditProductServlet" method="POST">
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                    
                    <div class="form-group">
                        <label>Product Name *</label>
                        <input type="text" name="name" id="nameInput" required value="<%= product.getName() %>"
                               oninput="updatePreview()">
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description"><%= product.getDescription() != null ? product.getDescription() : "" %></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Price (RM) *</label>
                            <input type="number" name="price" id="priceInput" step="0.01" min="0" required 
                                   value="<%= product.getPrice() %>" oninput="updatePreview()">
                        </div>
                        <div class="form-group">
                            <label>Stock Quantity *</label>
                            <input type="number" name="stock" min="0" required 
                                   value="<%= product.getStockQty() %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Category *</label>
                        <select name="categoryId" required>
                            <% for (Category cat : categories) { %>
                                <option value="<%= cat.getCategoryId() %>" 
                                        <%= cat.getCategoryId() == product.getCategoryId() ? "selected" : "" %>>
                                    <%= cat.getName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Select Product Image *</label>
                        <div class="image-selection">
                            <div class="image-selection-title">Click to select an image:</div>
                            <div class="image-grid">
                                <% if (availableImages != null) {
                                    for (String img : availableImages) { 
                                        boolean isSelected = img.equals(currentImage);
                                %>
                                    <label class="image-option">
                                        <input type="radio" name="image" value="<%= img %>" 
                                               onchange="selectImage('<%= img %>')" <%= isSelected ? "checked" : "" %>>
                                        <img src="<%= img %>" alt="Product Image">
                                    </label>
                                <% }
                                } %>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">Update Product</button>
                </form>
            </div>
        </div>
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
        function selectImage(imgPath) {
            document.getElementById('previewImg').src = imgPath;
        }

        function updatePreview() {
            var name = document.getElementById('nameInput').value || 'Product Name';
            var price = document.getElementById('priceInput').value || '0.00';
            document.getElementById('previewName').textContent = name;
            document.getElementById('previewPrice').textContent = 'RM ' + parseFloat(price).toFixed(2);
        }
    </script>

</body>
</html>
