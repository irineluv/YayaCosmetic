<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Store orders in session so status changes persist
    Map<String, String[]> ordersData = (Map<String, String[]>) session.getAttribute("adminOrders");
    
    if (ordersData == null) {
        // Initialize with sample data: id -> [name, product, date, address, subtotal, status]
        ordersData = new LinkedHashMap<>();
        ordersData.put("01", new String[]{"ALYA MASARAH", "YAYA GOLD PALETTE", "21/05/2024", "Mount Height, Bukit Benar, Selangor", "RM 100", "DELIVERED"});
        ordersData.put("02", new String[]{"ANIS ZIRA", "YAYA WHITE PALETTE", "21/05/2024", "Bukit Kumbang, Selayang, Selangor", "RM 100", "DELIVERED"});
        ordersData.put("03", new String[]{"VERONICA MALIS", "YAYA GREEN PALETTE", "08/05/2025", "Jalan Timur Tengah, Pagoh, Perak", "RM 100", "SHIPPED"});
        ordersData.put("04", new String[]{"MONDY MONA", "YAYA BLUE PALETTE", "08/05/2025", "Jalan Bulan Terang, Klang, Selangor", "RM 100", "PROCESSING"});
        ordersData.put("05", new String[]{"SARAH AHMAD", "YAYA PINK PALETTE", "10/05/2025", "Taman Melati, Gombak, Selangor", "RM 200", "PENDING"});
        session.setAttribute("adminOrders", ordersData);
    }
    
    // Handle status update
    String updateId = request.getParameter("updateId");
    String newStatus = request.getParameter("newStatus");
    String successMessage = null;
    
    if (updateId != null && newStatus != null && ordersData.containsKey(updateId)) {
        String[] orderData = ordersData.get(updateId);
        String oldStatus = orderData[5];
        orderData[5] = newStatus;
        ordersData.put(updateId, orderData);
        session.setAttribute("adminOrders", ordersData);
        successMessage = "Order #" + updateId + " status updated from " + oldStatus + " to " + newStatus;
    }
    
    // Status options for dropdown
    String[] statusOptions = {"PENDING", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED"};
    
    // Get filter parameter
    String filterStatus = request.getParameter("filter");
    if (filterStatus == null) filterStatus = "ALL";
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

        .header-controls {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .filter-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-section label {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }

        .filter-dropdown {
            padding: 10px 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            min-width: 150px;
        }

        .filter-dropdown:focus {
            outline: none;
            border-color: #7b0d1e;
        }

        .order-stats {
            display: flex;
            gap: 15px;
        }

        .stat-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        /* Success Message */
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

        /* Table */
        .table-wrapper {
            overflow-x: auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-table thead {
            background-color: #7b0d1e;
            color: white;
        }

        .order-table th,
        .order-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .order-table th {
            font-weight: bold;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }

        .order-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .order-table td {
            font-size: 14px;
        }

        .order-id {
            font-weight: bold;
            color: #7b0d1e;
        }

        .customer-name {
            font-weight: 600;
        }

        .address-cell {
            max-width: 200px;
            font-size: 13px;
            color: #666;
        }

        /* Status Dropdown Styling */
        .status-cell {
            min-width: 180px;
        }

        .status-dropdown-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-dropdown {
            padding: 8px 12px;
            border-radius: 6px;
            border: 2px solid #ddd;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            min-width: 130px;
            transition: all 0.3s;
        }

        .status-dropdown:focus {
            outline: none;
            border-color: #7b0d1e;
        }

        /* Status-specific dropdown colors */
        .status-dropdown.status-pending {
            background-color: #fff3cd;
            border-color: #ffc107;
            color: #856404;
        }

        .status-dropdown.status-processing {
            background-color: #cce5ff;
            border-color: #007bff;
            color: #004085;
        }

        .status-dropdown.status-shipped {
            background-color: #e2d5f1;
            border-color: #6f42c1;
            color: #4a2c7a;
        }

        .status-dropdown.status-delivered {
            background-color: #d4edda;
            border-color: #28a745;
            color: #155724;
        }

        .status-dropdown.status-cancelled {
            background-color: #f8d7da;
            border-color: #dc3545;
            color: #721c24;
        }

        /* Update Button */
        .update-btn {
            padding: 8px 15px;
            background-color: #001a72;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 11px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            text-transform: uppercase;
        }

        .update-btn:hover {
            background-color: #000f45;
            transform: translateY(-1px);
        }

        .update-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        /* Status Legend */
        .status-legend {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
        }

        .legend-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        .legend-dot.pending { background-color: #ffc107; }
        .legend-dot.processing { background-color: #007bff; }
        .legend-dot.shipped { background-color: #6f42c1; }
        .legend-dot.delivered { background-color: #28a745; }
        .legend-dot.cancelled { background-color: #dc3545; }

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
                padding: 10px 8px;
            }

            .status-dropdown {
                min-width: 100px;
                padding: 6px 8px;
            }

            .update-btn {
                padding: 6px 10px;
                font-size: 10px;
            }

            .page-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
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
        <div class="page-header">
            <h1 class="page-title">ORDER MANAGEMENT</h1>
            <div class="header-controls">
                <div class="filter-section">
                    <label>Filter by Status:</label>
                    <select class="filter-dropdown" onchange="filterOrders(this.value)">
                        <option value="ALL" <%= "ALL".equals(filterStatus) ? "selected" : "" %>>All Orders</option>
                        <option value="PENDING" <%= "PENDING".equals(filterStatus) ? "selected" : "" %>>Pending</option>
                        <option value="PROCESSING" <%= "PROCESSING".equals(filterStatus) ? "selected" : "" %>>Processing</option>
                        <option value="SHIPPED" <%= "SHIPPED".equals(filterStatus) ? "selected" : "" %>>Shipped</option>
                        <option value="DELIVERED" <%= "DELIVERED".equals(filterStatus) ? "selected" : "" %>>Delivered</option>
                        <option value="CANCELLED" <%= "CANCELLED".equals(filterStatus) ? "selected" : "" %>>Cancelled</option>
                    </select>
                </div>
                <div class="order-stats">
                    <span class="stat-badge" style="background-color: #e3f2fd; color: #1565c0;">
                        Total Orders: <%= ordersData.size() %>
                    </span>
                </div>
            </div>
        </div>

        <% if (successMessage != null) { %>
            <div class="success-message" id="successMsg">
                <span><strong>Success!</strong> <%= successMessage %></span>
                <button class="close-btn" onclick="document.getElementById('successMsg').style.display='none'">&times;</button>
            </div>
        <% } %>

        <!-- Status Legend -->
        <div class="status-legend">
            <div class="legend-item"><span class="legend-dot pending"></span> Pending</div>
            <div class="legend-item"><span class="legend-dot processing"></span> Processing</div>
            <div class="legend-item"><span class="legend-dot shipped"></span> Shipped</div>
            <div class="legend-item"><span class="legend-dot delivered"></span> Delivered</div>
            <div class="legend-item"><span class="legend-dot cancelled"></span> Cancelled</div>
        </div>

        <div class="table-wrapper">
            <table class="order-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Product</th>
                        <th>Date</th>
                        <th>Address</th>
                        <th>Amount</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    for (Map.Entry<String, String[]> entry : ordersData.entrySet()) {
                        String orderId = entry.getKey();
                        String[] data = entry.getValue();
                        String name = data[0];
                        String product = data[1];
                        String date = data[2];
                        String address = data[3];
                        String subtotal = data[4];
                        String status = data[5];
                        
                        // Skip if filter is active and status doesn't match
                        if (!"ALL".equals(filterStatus) && !filterStatus.equals(status)) {
                            continue;
                        }
                        
                        String statusClass = "status-" + status.toLowerCase();
                    %>
                        <tr>
                            <td class="order-id">#<%= orderId %></td>
                            <td class="customer-name"><%= name %></td>
                            <td><%= product %></td>
                            <td><%= date %></td>
                            <td class="address-cell"><%= address %></td>
                            <td><strong><%= subtotal %></strong></td>
                            <td class="status-cell">
                                <form method="GET" action="AdminOrder.jsp" class="status-dropdown-wrapper">
                                    <input type="hidden" name="updateId" value="<%= orderId %>">
                                    <select name="newStatus" class="status-dropdown <%= statusClass %>" 
                                            onchange="this.className='status-dropdown status-' + this.value.toLowerCase(); this.form.querySelector('.update-btn').disabled = (this.value === '<%= status %>');">
                                        <% for (String opt : statusOptions) { %>
                                            <option value="<%= opt %>" <%= opt.equals(status) ? "selected" : "" %>><%= opt %></option>
                                        <% } %>
                                    </select>
                                    <button type="submit" class="update-btn" disabled>Update</button>
                                </form>
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

    <script>
        // Auto-hide success message after 5 seconds
        // Auto-hide success message after 5 seconds
        setTimeout(function() {
            var msg = document.getElementById('successMsg');
            if (msg) {
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() { msg.style.display = 'none'; }, 500);
            }
        }, 5000);
        
        // Filter orders by status
        function filterOrders(status) {
            window.location.href = 'AdminOrder.jsp?filter=' + status;
        }
    </script>

</body>
</html>
