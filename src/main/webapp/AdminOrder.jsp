<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ===== ADMIN ORDER MANAGEMENT PAGE LOGIC =====
    // This page displays all customer orders for administrators to monitor
    
    // Define Order class to hold order information
    // Later: move to com.mycompany.yayacosmetic.model.Order
    class Order {
        String id;
        String name;
        String product;
        String dateOrdered;
        String address;
        String subtotal;
        String status;
        
        Order(String id, String name, String product, String dateOrdered, String address, String subtotal, String status) {
            this.id = id;
            this.name = name;
            this.product = product;
            this.dateOrdered = dateOrdered;
            this.address = address;
            this.subtotal = subtotal;
            this.status = status;
        }
    }
    
    // Create sample order list (hardcoded for demonstration)
    // Later with database: fetch using OrderDAO.getAllOrders()
    List<Order> orders = new ArrayList<>();
    orders.add(new Order("01", "ALYA MASARAH", "YAYA GOLD PALLATE", "21/05/2024", "Mount Height, Bukit Benar, Selangor", "RM 100", "DELIVERED"));
    orders.add(new Order("02", "ANIS ZIRA", "YAYA WHITE PALLATE", "21/05/2024", "Bukit Kumbang, Selayang, Selangor", "RM 100", "DELIVERED"));
    orders.add(new Order("03", "VERONICA MALIS", "YAYA GREEN PALLATE", "08/05/2025", "Jalan Timur Tengah, Pagoh, Perak", "RM 100", "DELIVERED"));
    orders.add(new Order("04", "MONDY MONA", "YAYA BLUE PALLATE", "08/05/2025", "Jalan Bulan Terang, Klang, Selangor", "RM 100", "PENDING"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Order Management</title>
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
        .order-container {
            padding: 40px 5%;
            min-height: 60vh;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 30px 0;
        }

        /* Table */
        .table-wrapper {
            overflow-x: auto;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
        }

        .order-table thead {
            background-color: #7b0d1e;
            color: white;
        }

        .order-table th,
        .order-table td {
            padding: 15px;
            text-align: left;
            border: 1px solid #ddd;
        }

        .order-table th {
            font-weight: bold;
            text-transform: uppercase;
            font-size: 14px;
        }

        .order-table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .order-table tbody tr:hover {
            background-color: #f0f0f0;
        }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 5px;
            font-weight: bold;
            font-size: 12px;
            text-transform: uppercase;
        }

        .status-delivered {
            background-color: #28a745;
            color: white;
        }

        .status-pending {
            background-color: #007bff;
            color: white;
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
            .order-table {
                font-size: 12px;
            }
            
            .order-table th,
            .order-table td {
                padding: 10px 5px;
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

    <div class="order-container">
        <h1 class="page-title">ORDER</h1>

        <div class="table-wrapper">
            <table class="order-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>NAME</th>
                        <th>PRODUCT</th>
                        <th>DATE ORDERED</th>
                        <th>ADDRESS</th>
                        <th>SUBTOTAL</th>
                        <th>STATUS</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Loop through all orders and display in table rows -->
                    <% for (Order order : orders) { %>
                        <tr>
                            <td><%= order.id %></td>
                            <td><%= order.name %></td>
                            <td><%= order.product %></td>
                            <td><%= order.dateOrdered %></td>
                            <td><%= order.address %></td>
                            <td><%= order.subtotal %></td>
                            <td>
                                <!-- Display status with color-coded badge -->
                                <% if ("DELIVERED".equals(order.status)) { %>
                                    <!-- Green badge for delivered orders -->
                                    <span class="status-badge status-delivered"><%= order.status %></span>
                                <% } else { %>
                                    <!-- Blue badge for pending orders -->
                                    <span class="status-badge status-pending"><%= order.status %></span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
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

</body>
</html>
