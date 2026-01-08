<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ===== ADMIN PRODUCT MANAGEMENT PAGE LOGIC =====
    // This page allows administrators to view and edit products
    
    // Define Product class to hold product information
    // Later: move to com.mycompany.yayacosmetic.model.Product
    class Product {
        String id;
        String name;
        String description;
        String price;
        String image;
        
        Product(String id, String name, String description, String price, String image) {
            this.id = id;
            this.name = name;
            this.description = description;
            this.price = price;
            this.image = image;
        }
    }
    
    // Create sample product list (hardcoded for demonstration)
    // Later with database: fetch using ProductDAO.getAllProducts()
    List<Product> products = new ArrayList<>();
    products.add(new Product("3", "YAYA GOLD PALLATE", "Contain 12 shining color", "RM 100", "pic product/3.png"));
    products.add(new Product("4", "YAYA BLUE PALLATE", "Contain 12 blue shade color", "RM 100", "pic product/4.png"));
    products.add(new Product("5", "YAYA GREEN PALLATE", "Contain 12 earthy tone color", "RM 100", "pic product/5.png"));
    products.add(new Product("6", "YAYA BLACK PALLATE", "Contain 12 dark shade color", "RM 100", "pic product/6.png"));
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
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0;
        }

        .search-bar {
            padding: 8px 15px;
            border: 1px solid #ccc;
            border-radius: 20px;
            width: 250px;
        }

        /* Product Grid */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .product-card {
            background-color: #f9f6f2;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
        }

        .product-card img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .product-card h3 {
            font-size: 18px;
            margin: 10px 0;
        }

        .product-card p {
            font-size: 13px;
            color: #666;
            margin: 5px 0;
        }

        .product-card .price {
            font-weight: bold;
            margin: 10px 0;
            font-size: 16px;
        }

        .edit-btn {
            background-color: #001a72;
            color: white;
            border: none;
            padding: 10px 30px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            margin-top: 10px;
        }

        .edit-btn:hover {
            background-color: #000f45;
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
                gap: 15px;
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
            <h1 class="page-title">PRODUCTS</h1>
            <input type="text" class="search-bar" placeholder="SEARCH">
        </div>

        <!-- Product grid displaying all products -->
        <div class="product-grid">
            <% for (Product product : products) { %>
                <!-- Each product card shows product info and edit button -->
                <div class="product-card">
                    <img src="<%= product.image %>" alt="<%= product.name %>">
                    <h3><%= product.name %></h3>
                    <p><%= product.description %></p>
                    <div class="price"><%= product.price %></div>
                    <!-- Edit button redirects to EditProduct.jsp with product ID -->
                    <button class="edit-btn" onclick="editProduct('<%= product.id %>', '<%= product.name %>')">EDIT</button>
                </div>
            <% } %>
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
        // JavaScript function to handle product editing
        function editProduct(id, name) {
            // Redirect to edit page with product ID as URL parameter
            window.location.href = 'EditProduct.jsp?id=' + id;
            
            // Later with backend: EditProduct.jsp form will submit to UpdateProductServlet
        }
    </script>

</body>
</html>
