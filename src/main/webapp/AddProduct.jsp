<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * DATA SOURCE (TEMP):
     * Products are stored in session under "adminProducts".
     * Map<productId, String[]{ name, description, price, imagePath }>
     * NOTE: This is not persistent (resets when session expires / server restarts).
     */
    Map<String, String[]> productsData = (Map<String, String[]>) session.getAttribute("adminProducts");

    // Ensure session storage exists so the page can run without NullPointerException
    if (productsData == null) {
        productsData = new LinkedHashMap<>(); // LinkedHashMap keeps insertion order (useful for consistent listing)
        session.setAttribute("adminProducts", productsData);
    }

    /*
     * REQUEST FLOW:
     * - Default: show form
     * - POST to AddProduct.jsp?action=add triggers "add" branch below
     * - On success: redirect back to AdminProduct.jsp with query params
     */
    String action = request.getParameter("action");
    String errorMessage = null;

    if ("add".equals(action)) {
        // Read user input from form fields
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String image = request.getParameter("image");

        // Basic server-side validation (do not rely on HTML "required" alone)
        if (name == null || name.trim().isEmpty()) {
            errorMessage = "Product name is required.";
        } else if (description == null || description.trim().isEmpty()) {
            errorMessage = "Product description is required.";
        } else if (price == null || price.trim().isEmpty()) {
            errorMessage = "Product price is required.";
        } else {
            try {
                // Validate numeric price and business rule: must be > 0
                int priceValue = Integer.parseInt(price.trim());
                if (priceValue <= 0) {
                    errorMessage = "Price must be greater than 0.";
                } else {
                    /*
                     * ID GENERATION (SESSION-BASED):
                     * Find the highest numeric key currently in the map, then +1.
                     * NOTE: Works only if IDs are numeric strings.
                     */
                    int maxId = 0;
                    for (String id : productsData.keySet()) {
                        try {
                            int idNum = Integer.parseInt(id);
                            if (idNum > maxId) maxId = idNum;
                        } catch (NumberFormatException e) {
                            // Ignore non-numeric keys to avoid breaking ID generation
                        }
                    }
                    String newId = String.valueOf(maxId + 1);

                    // Default image fallback if admin leaves it empty
                    if (image == null || image.trim().isEmpty()) {
                        image = "pic product/default.png";
                    }

                    // Store product in session (trim to keep data clean)
                    productsData.put(newId, new String[]{name.trim(), description.trim(), price.trim(), image.trim()});
                    session.setAttribute("adminProducts", productsData);

                    // PRG pattern: redirect after POST to prevent duplicate form resubmission on refresh
                    response.sendRedirect(
                        "AdminProduct.jsp?added=true&name=" +
                        java.net.URLEncoder.encode(name.trim(), "UTF-8")
                    );
                    return;
                }
            } catch (NumberFormatException e) {
                // Handles cases like "abc" or decimals if your UI expects integers only
                errorMessage = "Price must be a valid number.";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - Yaya Cosmetic Admin</title>
    <style>
        /* Page-level base styles */
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }

        /* Header / navigation bar */
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

        /* Main layout container */
        .add-container {
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

        .page-subtitle {
            color: #666;
            font-size: 14px;
        }

        /* Two-column layout: form (left) + live preview (right) */
        .form-container {
            display: flex;
            gap: 40px;
            flex-wrap: wrap;
        }

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

        /* Server-side validation message */
        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
        }

        /* Form controls */
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
        .form-group textarea,
        .form-group select {
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
        .form-group textarea:focus,
        .form-group select:focus {
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

        /* Price input: "RM" prefix + numeric input */
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

        /* Live preview card: mirrors the form input using JS */
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

        .preview-card .preview-image {
            width: 100%;
            height: 150px;
            background-color: #e9ecef;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 14px;
            margin-bottom: 15px;
            overflow: hidden;
        }

        .preview-card .preview-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
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

        /* Primary/secondary actions */
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
            background-color: #28a745;
            color: white;
            flex: 1;
        }

        .btn-primary:hover {
            background-color: #218838;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #545b62;
        }

        /* Image picker grid (quick selection of predefined images) */
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

        /* Responsive: stack form + preview on smaller screens */
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
        <!-- Admin navigation -->
        <nav>
            <a href="AdminHome.jsp">HOME</a>
            <a href="AdminProduct.jsp">PRODUCT</a>
            <a href="AdminOrder.jsp">ORDER</a>
            <a href="AdminMember.jsp">MEMBER</a>
            <a href="AdminProfile.jsp">PROFILE</a>
        </nav>
    </header>

    <div class="add-container">
        <div class="page-header">
            <h1 class="page-title">ADD NEW PRODUCT</h1>
            <p class="page-subtitle">Fill in the details below to add a new product to your catalog.</p>
        </div>

        <!-- Render server-side validation errors (if any) -->
        <% if (errorMessage != null) { %>
            <div class="error-message">
                <strong>Error:</strong> <%= errorMessage %>
            </div>
        <% } %>

        <!-- POST form: triggers server-side "add" logic (action=add) -->
        <form method="POST" action="AddProduct.jsp?action=add" id="addProductForm">
            <div class="form-container">
                <!-- Form Section (Admin input) -->
                <div class="form-section">
                    <h2>Product Information</h2>

                    <div class="form-group">
                        <label>Product Name <span class="required">*</span></label>
                        <input type="text" name="name" id="productName" required 
                               placeholder="e.g., YAYA GOLD PALETTE" maxlength="100"
                               oninput="updatePreview()">
                    </div>

                    <div class="form-group">
                        <label>Description <span class="required">*</span></label>
                        <textarea name="description" id="productDesc" required 
                                  placeholder="e.g., Contain 12 shining color" maxlength="500"
                                  oninput="updatePreview()"></textarea>
                        <p class="hint">Describe the product features and contents.</p>
                    </div>

                    <div class="form-group">
                        <label>Price (RM) <span class="required">*</span></label>
                        <div class="price-input-wrapper">
                            <span class="price-prefix">RM</span>
                            <input type="number" name="price" id="productPrice" required 
                                   placeholder="100" min="1" max="9999"
                                   oninput="updatePreview()">
                        </div>
                        <p class="hint">Enter price in Malaysian Ringgit.</p>
                    </div>

                    <div class="form-group">
                        <label>Product Image</label>
                        <input type="text" name="image" id="productImage" 
                               placeholder="pic product/3.png" 
                               onchange="updatePreview()">
                        <p class="hint">Select from existing images or enter custom path.</p>

                        <!-- Quick pick predefined images -->
                        <div class="image-options">
                            <div class="image-option" onclick="selectImage('pic product/3.png')">
                                <img src="pic product/3.png" alt="Gold">
                            </div>
                            <div class="image-option" onclick="selectImage('pic product/4.png')">
                                <img src="pic product/4.png" alt="Blue">
                            </div>
                            <div class="image-option" onclick="selectImage('pic product/5.png')">
                                <img src="pic product/5.png" alt="Green">
                            </div>
                            <div class="image-option" onclick="selectImage('pic product/6.png')">
                                <img src="pic product/6.png" alt="Black">
                            </div>
                            <div class="image-option" onclick="selectImage('pic product/7.png')">
                                <img src="pic product/7.png" alt="Pink">
                            </div>
                            <div class="image-option" onclick="selectImage('pic product/8.png')">
                                <img src="pic product/8.png" alt="Orange">
                            </div>
                            <div class="image-option" onclick="selectImage('pic product/9.png')">
                                <img src="pic product/9.png" alt="Purple">
                            </div>
                            <div class="image-option" onclick="selectImage('pic product/10.png')">
                                <img src="pic product/10.png" alt="Red">
                            </div>
                        </div>
                    </div>

                    <!-- Primary action submits; cancel returns to listing -->
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Add Product</button>
                        <a href="AdminProduct.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </div>

                <!-- Preview Section (Client-side only) -->
                <div class="preview-section">
                    <h2>Live Preview</h2>
                    <div class="preview-card">
                        <div class="preview-image" id="previewImage">
                            <span>No image selected</span>
                        </div>
                        <h3 id="previewName">Product Name</h3>
                        <p id="previewDesc">Product description will appear here</p>
                        <div class="price" id="previewPrice">RM 0</div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <footer>
        <div class="footer-col">
            <h4>ABOUT YAYA</h4>
            <a href="#">HISTORY</a>
            <a href="#">WORK IN YAYA</a>
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
         * Live preview sync:
         * Mirrors the form inputs into the preview card in real-time.
         * This is UI-only and does NOT affect server-side validation/storage.
         */
        function updatePreview() {
            var name = document.getElementById('productName').value || 'Product Name';
            var desc = document.getElementById('productDesc').value || 'Product description will appear here';
            var price = document.getElementById('productPrice').value || '0';
            var image = document.getElementById('productImage').value;

            document.getElementById('previewName').textContent = name;
            document.getElementById('previewDesc').textContent = desc;
            document.getElementById('previewPrice').textContent = 'RM ' + price;

            // Render image preview; fallback if path is invalid
            var previewImageDiv = document.getElementById('previewImage');
            if (image) {
                previewImageDiv.innerHTML =
                    '<img src="' + image + '" alt="Preview" ' +
                    'onerror="this.parentElement.innerHTML=\'<span>Image not found</span>\'">';
            } else {
                previewImageDiv.innerHTML = '<span>No image selected</span>';
            }
        }

        /*
         * Image option click handler:
         * Sets the image path into the input, highlights the selected thumbnail,
         * then refreshes the live preview.
         */
        function selectImage(imagePath) {
            document.getElementById('productImage').value = imagePath;

            // Clear previous selected state, then set current selection
            document.querySelectorAll('.image-option').forEach(function(opt) {
                opt.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');

            updatePreview();
        }
    </script>

</body>
</html>
