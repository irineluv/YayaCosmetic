<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.User, java.text.SimpleDateFormat" %>
<%
    List<User> members = (List<User>) request.getAttribute("members");
    Integer totalMembers = (Integer) request.getAttribute("totalMembers");
    String searchQuery = (String) request.getAttribute("searchQuery");
    
    if (members == null) {
        response.sendRedirect("AdminMemberServlet");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String currentDate = new SimpleDateFormat("dd MMMM yyyy").format(new java.util.Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Member Management</title>
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

        .member-container {
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

        .stat-badge {
            padding: 10px 20px;
            background-color: #e3f2fd;
            color: #1565c0;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
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

        .print-btn {
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
            text-transform: uppercase;
        }

        .print-btn:hover {
            background-color: #218838;
        }

        .table-wrapper {
            overflow-x: auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .member-table {
            width: 100%;
            border-collapse: collapse;
        }

        .member-table thead {
            background-color: #7b0d1e;
            color: white;
        }

        .member-table th,
        .member-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .member-table th {
            font-weight: bold;
            text-transform: uppercase;
            font-size: 13px;
        }

        .member-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .member-id {
            font-weight: bold;
            color: #7b0d1e;
        }

        .member-name {
            font-weight: 600;
        }

        .orders-badge {
            display: inline-block;
            padding: 5px 12px;
            background-color: #e3f2fd;
            color: #1565c0;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .no-members {
            text-align: center;
            padding: 60px;
            color: #666;
        }

        @media print {
            body * { visibility: hidden; }
            #printArea, #printArea * { visibility: visible; }
            #printArea { position: absolute; left: 0; top: 0; width: 100%; }
            .no-print { display: none !important; }
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

        .print-report { display: none; }

        @media print {
            .print-report {
                display: block;
                padding: 40px;
            }
            .report-header {
                text-align: center;
                margin-bottom: 40px;
                border-bottom: 3px solid #7b0d1e;
                padding-bottom: 20px;
            }
            .report-header h1 { color: #7b0d1e; margin: 0 0 10px 0; font-size: 28px; }
            .report-header p { margin: 5px 0; color: #666; }
            .report-table { width: 100%; border-collapse: collapse; }
            .report-table th, .report-table td { border: 1px solid #ddd; padding: 12px; text-align: left; }
            .report-table th { background-color: #7b0d1e; color: white; }
        }
    </style>
</head>
<body>

    <header class="no-print">
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

    <div class="member-container no-print">
        <div class="page-header">
            <h1 class="page-title">MEMBER MANAGEMENT</h1>
            <div class="header-actions">
                <span class="stat-badge">Total Members: <%= totalMembers %></span>
                <form action="AdminMemberServlet" method="GET" class="search-box">
                    <input type="text" name="search" placeholder="Search members..." 
                           value="<%= searchQuery != null ? searchQuery : "" %>">
                    <button type="submit">Search</button>
                </form>
                <button class="print-btn" onclick="window.print()">Print Report</button>
            </div>
        </div>

        <% if (members.isEmpty()) { %>
            <div class="no-members">
                <h2>No Members Found</h2>
                <p>There are no members matching your search.</p>
            </div>
        <% } else { %>
            <div class="table-wrapper">
                <table class="member-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Join Date</th>
                            <th>Total Orders</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User member : members) { %>
                            <tr>
                                <td class="member-id">#<%= member.getUserId() %></td>
                                <td class="member-name"><%= member.getFullName() %></td>
                                <td><%= member.getEmail() %></td>
                                <td><%= member.getPhone() != null ? member.getPhone() : "-" %></td>
                                <td><%= member.getCreatedAt() != null ? sdf.format(member.getCreatedAt()) : "-" %></td>
                                <td><span class="orders-badge"><%= member.getOrderCount() %> orders</span></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <!-- Print Report Template -->
    <div id="printArea" class="print-report">
        <div class="report-header">
            <h1>YAYA COSMETIC</h1>
            <p><strong>Member Report</strong></p>
            <p>Generated on: <%= currentDate %></p>
        </div>
        
        <table class="report-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Join Date</th>
                    <th>Orders</th>
                </tr>
            </thead>
            <tbody>
                <% for (User member : members) { %>
                    <tr>
                        <td>#<%= member.getUserId() %></td>
                        <td><%= member.getFullName() %></td>
                        <td><%= member.getEmail() %></td>
                        <td><%= member.getPhone() != null ? member.getPhone() : "-" %></td>
                        <td><%= member.getCreatedAt() != null ? sdf.format(member.getCreatedAt()) : "-" %></td>
                        <td><%= member.getOrderCount() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <footer class="no-print">
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

</body>
</html>
