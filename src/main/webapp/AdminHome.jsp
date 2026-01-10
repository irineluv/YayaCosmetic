<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ===== ADMIN DASHBOARD PAGE LOGIC =====
    // This page displays sales reports and analytics for administrators
    
    // Define SalesData class to hold monthly sales information
    // Later: move to separate model class
    class SalesData {
        String month;
        int sales;
        SalesData(String month, int sales) {
            this.month = month;
            this.sales = sales;
        }
    }
    
    // Create sample sales data (hardcoded for demonstration)
    // Later with database: fetch using SalesDAO.getMonthlySales()
    List<SalesData> salesList = new ArrayList<>();
    salesList.add(new SalesData("January", 1200));
    salesList.add(new SalesData("February", 1500));
    salesList.add(new SalesData("March", 1800));
    
    // Pie chart data showing product sales distribution (percentages)
    // Later with database: calculate from actual sales data
    int product1Percent = 45; // Gold Palette - 45% of sales
    int product2Percent = 30; // Blue Palette - 30% of sales
    int product3Percent = 25; // Green Palette - 25% of sales
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Admin Dashboard</title>
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
        .dashboard-container {
            padding: 40px 5%;
            min-height: 60vh;
        }

        .report-section {
            background-color: #d4c4b0;
            padding: 40px;
            border-radius: 10px;
            border: 3px solid #333;
        }

        .report-title {
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            color: #fff;
            margin-bottom: 30px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .report-content {
            display: flex;
            gap: 40px;
            align-items: center;
        }

        /* Sales Table */
        .sales-table-container {
            flex: 1;
        }

        .sales-table {
            width: 100%;
            background-color: #fff;
            border-collapse: collapse;
            border: 2px solid #333;
        }

        .sales-table th,
        .sales-table td {
            border: 1px solid #333;
            padding: 15px;
            text-align: center;
        }

        .sales-table th {
            background-color: #333;
            color: white;
            font-weight: bold;
        }

        .sales-table td {
            background-color: #e8dcc8;
        }

        /* Pie Chart */
        .chart-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* CSS-based pie chart using conic-gradient */
        /* This creates a circular chart divided by percentages */
        .pie-chart {
            width: 250px;
            height: 250px;
            border-radius: 50%;
            /* Conic gradient creates pie slices based on percentages */
            background: conic-gradient(
                #87CEEB 0% <%= product1Percent %>%, 
                #4682B4 <%= product1Percent %>% <%= product1Percent + product2Percent %>%, 
                #1E90FF <%= product1Percent + product2Percent %>% 100%);
            position: relative;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .chart-legend {
            margin-top: 20px;
            text-align: center;
        }

        .legend-item {
            display: inline-block;
            margin: 0 15px;
            font-size: 14px;
        }

        .legend-color {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 5px;
            vertical-align: middle;
            border: 1px solid #333;
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
            .report-content {
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

    <div class="dashboard-container">
        <div class="report-section">
            <div class="report-title">REPORT ON SALES (MONTHLY)</div>
            
            <div class="report-content">
                <!-- Sales Table -->
                <div class="sales-table-container">
                    <table class="sales-table">
                        <thead>
                            <tr>
                                <th>MONTH</th>
                                <th>SALES (RM)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (SalesData data : salesList) { %>
                                <tr>
                                    <td><%= data.month %></td>
                                    <td><%= data.sales %></td>
                                </tr>
                            <% } %>
                            <tr>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pie Chart -->
                <div class="chart-container">
                    <div>
                        <div class="pie-chart"></div>
                        <div class="chart-legend">
                            <div class="legend-item">
                                <span class="legend-color" style="background-color: #87CEEB;"></span>
                                <%= product1Percent %>%
                            </div>
                            <div class="legend-item">
                                <span class="legend-color" style="background-color: #4682B4;"></span>
                                <%= product2Percent %>%
                            </div>
                            <div class="legend-item">
                                <span class="legend-color" style="background-color: #1E90FF;"></span>
                                <%= product3Percent %>%
                            </div>
                        </div>
                    </div>
                </div>
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

</body>
</html>
