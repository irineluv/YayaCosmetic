<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * Admin products are stored in session ("adminProducts") as:
     *   productId -> [name, description, price, imagePath]
     * This is NOT database-backed; changes reset when session resets.
     */
    Map<String, String[]> productsData = (Map<String, String[]>) session.getAttribute("adminProducts");
    
    // If products aren't initialized, force admin back to AdminProduct.jsp (which initializes them)
    if (productsData == null) {
        response.sendRedirect("AdminProduct.jsp");
        return;
    }
    
    // Product ID comes from URL query string (?id=...)
    String productId = request.getParameter("id");
    
    /*
     * Update flow:
     * - form posts to EditProduct.jsp?id=...&action=update
     * - request.getParameter("action") decides whether to validate + update
     */
    String action = request.getParameter("action");
    String errorMessage = null;
    
    if ("update".equals(action) && productId != null) {
        // Read form fields (name/description/price/image)
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String image = request.getParameter("image");
        
        // Basic validations (server-side)
        if (name == null || name.trim().isEmpty()) {
            errorMessage = "Product name is required.";
        } else if (description == null || description.trim().isEmpty()) {
            errorMessage = "Product description is required.";
        } else if (price == null || price.trim().isEmpty()) {
            errorMessage = "Product price is required.";
        } else {
            try {
                // Price validated as integer > 0
                int priceValue = Integer.parseInt(price.trim());
                if (priceValue <= 0) {
                    errorMessage = "Price must be greater than 0.";
                } else {
                    /*
                     * Image field is optional:
                     * - if blank, keep existing image
                     * - otherwise save the custom path
                     */
                    if (image == null || image.trim().isEmpty()) {
                        image = productsData.get(productId)[3]; // Keep existing image
                    }

                    // Update product data in session map
                    productsData.put(productId, new String[]{name.trim(), description.trim(), price.trim(), image.trim()});
                    session.setAttribute("adminProducts", productsData);
                    
                    /*
                     * Redirect back to AdminProduct.jsp with a success flag.
                     * AdminProduct.jsp must read updated=true and name=... if it wants to display success.
                     */
                    response.sendRedirect(
                        "AdminProduct.jsp?updated=true&name=" + java.net.URLEncoder.encode(name.trim(), "UTF-8")
                    );
                    return;
                }
            } catch (NumberFormatException e) {
                errorMessage = "Price must be a valid number.";
            }
        }
    }
    
    /*
     * If productId missing or invalid, redirect to AdminProduct.jsp.
     * Prevents direct access with invalid id.
     */
    if (productId == null || !productsData.containsKey(productId)) {
        response.sendRedirect("AdminProduct.jsp");
        return;
    }
    
    // Load current product data for initial form values + preview
    String[] productData = productsData.get(productId);
    String productName = productData[0];
    String productDesc = productData[1];
    String productPrice = productData[2];
    String productImage = productData[3];
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Yaya Cosmetic</title>
    <style>
        /* Basic page styling */
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        /* Header */
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

        /* Main Content */
        .edit-container {
            padding: 40px 10%;
            min-height: 60vh;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 10px 0;
        }

        .product-id-badge {
            display: inline-block;
            background-color: #7b0d1e;
            color: white;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .form-container {
            display: flex;
            gap: 40px;
            flex-wrap: wrap;
        }

        /* Left side: Form */
        .form-section {
            flex: 1;
            min-width: 350px;
            background-color: #f9f9f9;
            padding: 35px;
            border-radius: 15px;
        }

        .form-section h2 {
            font-size: 18px;
            margin: 0 0 25px 0;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
            color: #333;
        }

        /* Validation error display */
        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .form-group label .required {
            color: #dc3545;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 14px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            font-family: Arial, sans-serif;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #7b0d1e;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-group .hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        /* Price input with RM prefix */
        .price-input-wrapper {
            display: flex;
            align-items: center;
        }

        .price-prefix {
            background-color: #e9ecef;
            padding: 14px 15px;
            border: 2px solid #ddd;
            border-right: none;
            border-radius: 8px 0 0 8px;
            font-weight: bold;
            color: #666;
        }

        .price-input-wrapper input {
            border-radius: 0 8px 8px 0;
        }

        /* Right side: live preview card */
        .preview-section {
            flex: 0 0 300px;
            background-color: #f9f6f2;
            padding: 35px;
            border-radius: 15px;
            height: fit-content;
        }

        .preview-section h2 {
            font-size: 18px;
            margin: 0 0 25px 0;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
            color: #333;
        }

        .preview-card {
            background-color: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .preview-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .preview-card h3 {
            font-size: 16px;
            margin: 10px 0;
            color: #333;
        }

        .preview-card p {
            font-size: 13px;
            color: #666;
            margin: 5px 0;
        }

        .preview-card .price {
            font-size: 20px;
            font-weight: bold;
            color: #7b0d1e;
            margin-top: 15px;
        }

        /* Buttons */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            text-transform: uppercase;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: #001a72;
            color: white;
            flex: 1;
        }

        .btn-primary:hover {
            background-color: #000f45;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #545b62;
        }

        /* Image picker thumbnails */
        .image-options {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            margin-top: 10px;
        }

        .image-option {
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .image-option:hover {
            border-color: #7b0d1e;
        }

        .image-option.selected {
            border-color: #7b0d1e;
            background-color: #fff5f5;
        }

        .image-option img {
            width: 100%;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
        }

        /* Footer */
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
            line-height: 1.4;
        }

        @media (max-width: 768px) {
            .form-container {
                flex-direction: column;
            }

            .form-section,
            .preview-section {
                min-width: 100%;
            }

            .button-group {
                flex-direction: column;
            }

            .image-options {
                grid-template-columns: repeat(2, 1fr);
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
            <a href="AdminHome.jsp">HOME</a>
            <a href="AdminProduct.jsp">PRODUCT</a>
            <a href="AdminOrder.jsp">ORDER</a>
            <a href="AdminMember.jsp">MEMBER</a>
            <a href="AdminProfile.jsp">PROFILE</a>
        </nav>
    </header>

    <div class="edit-container">
        <div class="page-header">
            <h1 class="page-title">EDIT PRODUCT</h1>
            <span class="product-id-badge">Product ID: <%= productId %></span>
        </div>

        <% if (errorMessage != null) { %>
            <div class="error-message">
                <strong>Error:</strong> <%= errorMessage %>
            </div>
        <% } %>

        <!-- POST form. action carries id + action=update in the URL -->
        <form method="POST" action="EditProduct.jsp?id=<%= productId %>&action=update">
            <div class="form-container">
                <div class="form-section">
                    <h2>Product Information</h2>

                    <!-- Name: required. On input updates the preview -->
                    <div class="form-group">
                        <label>Product Name <span class="required">*</span></label>
                        <input type="text" name="name" id="productName" required 
                               value="<%= productName %>" maxlength="100"
                               oninput="updatePreview()">
                    </div>

                    <!-- Description: required. On input updates the preview -->
                    <div class="form-group">
                        <label>Description <span class="required">*</span></label>
                        <textarea name="description" id="productDesc" required 
                                  maxlength="500" oninput="updatePreview()"><%= productDesc %></textarea>
                    </div>

                    <!-- Price: number input with min/max. Still validated again server-side -->
                    <div class="form-group">
                        <label>Price (RM) <span class="required">*</span></label>
                        <div class="price-input-wrapper">
                            <span class="price-prefix">RM</span>
                            <input type="number" name="price" id="productPrice" required 
                                   value="<%= productPrice %>" min="1" max="9999"
                                   oninput="updatePreview()">
                        </div>
                    </div>

                    <!-- Image: can be typed manually or chosen from thumbnails -->
                    <div class="form-group">
                        <label>Product Image</label>
                        <input type="text" name="image" id="productImage" 
                               value="<%= productImage %>" 
                               onchange="updatePreview()">
                        <p class="hint">Select from existing images or enter custom path.</p>

                        <!-- Thumbnail picker. Selected class based on current productImage -->
                        <div class="image-options">
                            <div class="image-option <%= "pic product/3.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/3.png')">
                                <img src="pic product/3.png" alt="Gold">
                            </div>
                            <div class="image-option <%= "pic product/4.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/4.png')">
                                <img src="pic product/4.png" alt="Blue">
                            </div>
                            <div class="image-option <%= "pic product/5.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/5.png')">
                                <img src="pic product/5.png" alt="Green">
                            </div>
                            <div class="image-option <%= "pic product/6.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/6.png')">
                                <img src="pic product/6.png" alt="Black">
                            </div>
                            <div class="image-option <%= "pic product/7.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/7.png')">
                                <img src="pic product/7.png" alt="Pink">
                            </div>
                            <div class="image-option <%= "pic product/8.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/8.png')">
                                <img src="pic product/8.png" alt="Orange">
                            </div>
                            <div class="image-option <%= "pic product/9.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/9.png')">
                                <img src="pic product/9.png" alt="Purple">
                            </div>
                            <div class="image-option <%= "pic product/10.png".equals(productImage) ? "selected" : "" %>" onclick="selectImage('pic product/10.png')">
                                <img src="pic product/10.png" alt="Red">
                            </div>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Update Product</button>
                        <a href="AdminProduct.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </div>

                <!-- Live preview panel (client-side) -->
                <div class="preview-section">
                    <h2>Live Preview</h2>
                    <div class="preview-card">
                        <img src="<%= productImage %>" alt="Preview" id="previewImg">
                        <h3 id="previewName"><%= productName %></h3>
                        <p id="previewDesc"><%= productDesc %></p>
                        <div class="price" id="previewPrice">RM <%= productPrice %></div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <footer>
        <div class="footer-col">
            <h4>ABOUT YAYA</h4>
            <a href="#">HISTORY</a>
            <a href="#">BELABOUR</a>
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
            <p>yayacosmetic@hotline.com (official email)</p>
            <p>@yayacosmeticofficial (Instagram)</p>
        </div>
    </footer>

    <script>
        /*
         * Updates the preview card while admin edits fields.
         * This is purely visual; real update happens server-side on submit.
         */
        function updatePreview() {
            var name = document.getElementById('productName').value || 'Product Name';
            var desc = document.getElementById('productDesc').value || 'Product description';
            var price = document.getElementById('productPrice').value || '0';
            var image = document.getElementById('productImage').value;

            document.getElementById('previewName').textContent = name;
            document.getElementById('previewDesc').textContent = desc;
            document.getElementById('previewPrice').textContent = 'RM ' + price;

            if (image) {
                document.getElementById('previewImg').src = image;
            }
        }

        /*
         * Sets the image input field to a chosen thumbnail.
         * NOTE: This function relies on `event.currentTarget` but does NOT receive the `event` param.
         * In many browsers this will break because `event` may be undefined.
         */
        function selectImage(imagePath) {
            document.getElementById('productImage').value = imagePath;
            
            // Update selected state (visual highlight)
            document.querySelectorAll('.image-option').forEach(function(opt) {
                opt.classList.remove('selected');
            });

            // BUG RISK: `event` is not guaranteed to exist here
            event.currentTarget.classList.add('selected');
            
            updatePreview();
        }
    </script>

</body>
</html>
