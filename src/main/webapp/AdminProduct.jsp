<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Store products in session for persistence (add/delete operations)
    Map<String, String[]> productsData = (Map<String, String[]>) session.getAttribute("adminProducts");
    
    if (productsData == null) {
        // Initialize with all 8 products: id -> [name, description, price, image]
        productsData = new LinkedHashMap<>();
        productsData.put("1", new String[]{"YAYA GOLD PALETTE", "Contain 12 shining color", "100", "pic product/3.png"});
        productsData.put("2", new String[]{"YAYA BLUE PALETTE", "Contain 12 blue shade color", "100", "pic product/4.png"});
        productsData.put("3", new String[]{"YAYA GREEN PALETTE", "Contain 12 earthy tone color", "100", "pic product/5.png"});
        productsData.put("4", new String[]{"YAYA BLACK PALETTE", "Contain 12 dark shade color", "100", "pic product/6.png"});
        productsData.put("5", new String[]{"YAYA PINK PALETTE", "Contain 12 pink shade color", "100", "pic product/7.png"});
        productsData.put("6", new String[]{"YAYA ORANGE PALETTE", "Contain 12 fruity shade color", "100", "pic product/8.png"});
        productsData.put("7", new String[]{"YAYA PURPLE PALETTE", "Contain 12 purple shade color", "100", "pic product/9.png"});
        productsData.put("8", new String[]{"YAYA RED PALETTE", "Contain 12 red shade color", "100", "pic product/10.png"});
        session.setAttribute("adminProducts", productsData);
    }
    
    // Handle delete action
    String deleteId = request.getParameter("delete");
    String successMessage = null;
    String errorMessage = null;
    
    if (deleteId != null && productsData.containsKey(deleteId)) {
        String[] deletedProduct = productsData.get(deleteId);
        String deletedName = deletedProduct[0];
        productsData.remove(deleteId);
        session.setAttribute("adminProducts", productsData);
        successMessage = "Product \"" + deletedName + "\" has been deleted successfully.";
    }
    
    // Check for success message from add product
    String addSuccess = request.getParameter("added");
    if ("true".equals(addSuccess)) {
        String addedName = request.getParameter("name");
        successMessage = "Product \"" + (addedName != null ? addedName : "New Product") + "\" has been added successfully.";
    }
    
    // Search functionality
    String searchQuery = request.getParameter("search");
    if (searchQuery == null) searchQuery = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Admin Products</title>
    <style>
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
        .product-container {
            padding: 40px 5%;
            min-height: 60vh;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
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
            align-items: center;
            gap: 15px;
        }

        .search-form {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .search-bar {
            padding: 10px 20px;
            border: 2px solid #ddd;
            border-radius: 25px;
            width: 200px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .search-bar:focus {
            outline: none;
            border-color: #7b0d1e;
        }

        .search-btn {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            padding: 5px;
        }

        .add-product-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.3s;
        }

        .add-product-btn:hover {
            background-color: #218838;
        }

        .add-product-btn::before {
            content: "+";
            font-size: 18px;
            font-weight: bold;
        }

        /* Stats Bar */
        .stats-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .stat-item {
            background-color: #f8f9fa;
            padding: 15px 25px;
            border-radius: 10px;
            border-left: 4px solid #7b0d1e;
        }

        .stat-item .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #7b0d1e;
        }

        .stat-item .stat-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
        }

        /* Messages */
        .success-message {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .success-message .close-btn {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #155724;
        }

        /* Product Grid */
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
            position: relative;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .product-id-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background-color: #7b0d1e;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: bold;
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .product-card h3 {
            font-size: 16px;
            margin: 10px 0;
            color: #333;
        }

        .product-card p {
            font-size: 13px;
            color: #666;
            margin: 5px 0;
        }

        .product-card .price {
            font-weight: bold;
            margin: 15px 0;
            font-size: 18px;
            color: #7b0d1e;
        }

        .product-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 15px;
        }

        .btn {
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            transition: all 0.3s;
        }

        .edit-btn {
            background-color: #001a72;
            color: white;
        }

        .edit-btn:hover {
            background-color: #000f45;
        }

        .delete-btn {
            background-color: #dc3545;
            color: white;
        }

        .delete-btn:hover {
            background-color: #c82333;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state h2 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #333;
        }

        .empty-state p {
            margin-bottom: 20px;
        }

        /* Delete Confirmation Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-content {
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .modal-content h3 {
            margin: 0 0 15px 0;
            color: #dc3545;
        }

        .modal-content p {
            color: #666;
            margin-bottom: 25px;
        }

        .modal-content .product-name {
            font-weight: bold;
            color: #333;
        }

        .modal-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .modal-actions .btn {
            padding: 12px 30px;
        }

        .cancel-btn {
            background-color: #6c757d;
            color: white;
        }

        .cancel-btn:hover {
            background-color: #545b62;
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
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .header-actions {
                width: 100%;
                flex-direction: column;
            }

            .search-bar {
                width: 100%;
            }

            .add-product-btn {
                width: 100%;
                justify-content: center;
            }

            .product-actions {
                flex-direction: column;
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

    <div class="product-container">
        <div class="page-header">
            <h1 class="page-title">PRODUCT MANAGEMENT</h1>
            <div class="header-actions">
                <form class="search-form" method="GET" action="AdminProduct.jsp">
                    <input type="text" name="search" class="search-bar" placeholder="Search products..." value="<%= searchQuery %>">
                    <button type="submit" class="search-btn">🔍</button>
                </form>
                <a href="AddProduct.jsp" class="add-product-btn">Add Product</a>
            </div>
        </div>

        <% if (successMessage != null) { %>
            <div class="success-message" id="successMsg">
                <span><strong>Success!</strong> <%= successMessage %></span>
                <button class="close-btn" onclick="document.getElementById('successMsg').style.display='none'">&times;</button>
            </div>
        <% } %>

        <!-- Stats Bar -->
        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-value"><%= productsData.size() %></div>
                <div class="stat-label">Total Products</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">RM 100</div>
                <div class="stat-label">Base Price</div>
            </div>
        </div>

        <!-- Product Grid -->
        <div class="product-grid">
            <% 
            int displayCount = 0;
            for (Map.Entry<String, String[]> entry : productsData.entrySet()) {
                String productId = entry.getKey();
                String[] data = entry.getValue();
                String name = data[0];
                String description = data[1];
                String price = data[2];
                String image = data[3];
                
                // Search filter
                if (!searchQuery.isEmpty() && 
                    !name.toLowerCase().contains(searchQuery.toLowerCase()) &&
                    !description.toLowerCase().contains(searchQuery.toLowerCase())) {
                    continue;
                }
                displayCount++;
            %>
                <div class="product-card">
                    <span class="product-id-badge">ID: <%= productId %></span>
                    <img src="<%= image %>" alt="<%= name %>">
                    <h3><%= name %></h3>
                    <p><%= description %></p>
                    <div class="price">RM <%= price %></div>
                    <div class="product-actions">
                        <button class="btn edit-btn" onclick="window.location.href='EditProduct.jsp?id=<%= productId %>'">Edit</button>
                        <button class="btn delete-btn" onclick="confirmDelete('<%= productId %>', '<%= name.replace("'", "\\'") %>')">Delete</button>
                    </div>
                </div>
            <% } %>
        </div>

        <% if (displayCount == 0) { %>
            <div class="empty-state">
                <h2>No Products Found</h2>
                <% if (!searchQuery.isEmpty()) { %>
                    <p>No products match your search "<%= searchQuery %>"</p>
                    <a href="AdminProduct.jsp" class="btn edit-btn" style="display: inline-block; padding: 12px 25px;">Clear Search</a>
                <% } else { %>
                    <p>Start by adding your first product.</p>
                    <a href="AddProduct.jsp" class="add-product-btn">Add Product</a>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-content">
            <h3>⚠️ Delete Product</h3>
            <p>Are you sure you want to delete<br><span class="product-name" id="deleteProductName"></span>?</p>
            <p style="font-size: 12px; color: #999;">This action cannot be undone.</p>
            <div class="modal-actions">
                <button class="btn cancel-btn" onclick="closeModal()">Cancel</button>
                <button class="btn delete-btn" id="confirmDeleteBtn">Delete</button>
            </div>
        </div>
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
        var deleteProductId = null;

        function confirmDelete(id, name) {
            deleteProductId = id;
            document.getElementById('deleteProductName').textContent = name;
            document.getElementById('deleteModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('deleteModal').classList.remove('active');
            deleteProductId = null;
        }

        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            if (deleteProductId) {
                window.location.href = 'AdminProduct.jsp?delete=' + deleteProductId;
            }
        });

        // Close modal when clicking outside
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        // Auto-hide success message
        setTimeout(function() {
            var msg = document.getElementById('successMsg');
            if (msg) {
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() { msg.style.display = 'none'; }, 500);
            }
        }, 5000);
    </script>

</body>
</html>
