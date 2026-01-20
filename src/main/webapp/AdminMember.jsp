<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * VIEW MODEL (DEMO):
     * Member is defined here for quick prototyping.
     * Real-world: move this into a proper Java class (e.g., com.yaya.model.Member)
     * and fetch members from DB via Servlet/DAO instead of hardcoding in JSP.
     */
    class Member {
        String id;
        String name;
        String email;
        String phone;
        String joinDate;
        String totalOrders;

        Member(String id, String name, String email, String phone, String joinDate, String totalOrders) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.phone = phone;
            this.joinDate = joinDate;
            this.totalOrders = totalOrders;
        }
    }

    /*
     * DATA SOURCE (DEMO):
     * Hardcoded sample member list for UI display.
     * Real-world: populate this list from DB and store it in request scope (request.setAttribute)
     * before forwarding to this JSP.
     */
    List<Member> members = new ArrayList<>();
    members.add(new Member("01", "ALYA MASARAH", "alya99@mail.com", "012-3456789", "09/09/2024", "5"));
    members.add(new Member("02", "ANIS ZIRA", "aniszira@mail.com", "019-8765432", "21/08/2024", "3"));
    members.add(new Member("03", "VERONICA MALIS", "vero@mail.com", "011-2233445", "08/07/2024", "8"));
    members.add(new Member("04", "MONDY MONA", "mondy@mail.com", "013-9988776", "08/05/2024", "2"));
    members.add(new Member("05", "SARAH AHMAD", "sarah@mail.com", "016-5544332", "15/10/2024", "12"));

    // Report timestamp for print template header
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMMM yyyy");
    String currentDate = sdf.format(new java.util.Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - Member Management</title>
    <style>
        /* Base page styling */
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        /* Header / navigation (hidden in print via .no-print) */
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

        /* Main page content wrapper */
        .member-container {
            padding: 40px 5%;
            min-height: 60vh;
        }

        /* Header section: title + stats + print action */
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

        /* Quick stat indicator (total members) */
        .stat-badge {
            padding: 10px 20px;
            background-color: #e3f2fd;
            color: #1565c0;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }

        /* Trigger window.print() */
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
            transition: background-color 0.3s;
        }

        .print-btn:hover {
            background-color: #218838;
        }

        .print-btn::before {
            content: "🖨️";
            font-size: 16px;
        }

        /* Table wrapper enables horizontal scroll on smaller screens */
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

        /* Small badge style for total orders per member */
        .orders-badge {
            display: inline-block;
            padding: 5px 12px;
            background-color: #e3f2fd;
            color: #1565c0;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        /*
         * PRINT MODE RULES:
         * Hide everything by default, then show only the #printArea report section.
         * This avoids printing nav/footer/buttons and ensures clean report formatting.
         */
        @media print {
            body * {
                visibility: hidden;
            }
            
            #printArea, #printArea * {
                visibility: visible;
            }
            
            #printArea {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
            
            .no-print {
                display: none !important;
            }
        }

        /* Footer (hidden in print via .no-print) */
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

        /*
         * PRINT REPORT TEMPLATE:
         * Hidden during normal view. Only displayed when printing.
         */
        .print-report {
            display: none;
        }

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

            .report-header h1 {
                color: #7b0d1e;
                margin: 0 0 10px 0;
                font-size: 28px;
            }

            .report-header p {
                margin: 5px 0;
                color: #666;
            }

            .report-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }

            .report-table th,
            .report-table td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            .report-table th {
                background-color: #7b0d1e;
                color: white;
            }

            .report-table tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .report-footer {
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid #ddd;
                text-align: center;
                font-size: 12px;
                color: #666;
            }

            /* Summary cards displayed at the top of the report for quick stats */
            .report-summary {
                display: flex;
                justify-content: space-between;
                margin-bottom: 30px;
                padding: 20px;
                background-color: #f5f5f5;
            }

            .summary-item {
                text-align: center;
            }

            .summary-item .value {
                font-size: 24px;
                font-weight: bold;
                color: #7b0d1e;
            }

            .summary-item .label {
                font-size: 12px;
                color: #666;
            }
        }

        /* Mobile-friendly adjustments for table readability */
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .member-table {
                font-size: 12px;
            }
            
            .member-table th,
            .member-table td {
                padding: 10px 5px;
            }
        }
    </style>
</head>
<body>

    <!-- Normal screen header (excluded from printing) -->
    <header class="no-print">
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

    <!-- Main member list view (excluded from printing) -->
    <div class="member-container no-print">
        <div class="page-header">
            <h1 class="page-title">MEMBER MANAGEMENT</h1>
            <div class="header-actions">
                <!-- Count is derived directly from list size -->
                <span class="stat-badge">Total Members: <%= members.size() %></span>

                <!-- Prints the hidden report template (#printArea) -->
                <button class="print-btn" onclick="printReport()">Print Report</button>
            </div>
        </div>

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
                    <!-- Render each member row -->
                    <% for (Member member : members) { %>
                        <tr>
                            <td class="member-id">#<%= member.id %></td>
                            <td class="member-name"><%= member.name %></td>
                            <td><%= member.email %></td>
                            <td><%= member.phone %></td>
                            <td><%= member.joinDate %></td>
                            <td><span class="orders-badge"><%= member.totalOrders %> orders</span></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Print-only report layout (hidden in normal view, visible only in @media print) -->
    <div id="printArea" class="print-report">
        <div class="report-header">
            <h1>YAYA COSMETIC</h1>
            <p><strong>Member Report</strong></p>
            <p>Generated on: <%= currentDate %></p>
        </div>

        <div class="report-summary">
            <div class="summary-item">
                <div class="value"><%= members.size() %></div>
                <div class="label">Total Members</div>
            </div>

            <div class="summary-item">
                <!-- Total orders aggregated from all members -->
                <div class="value"><%
                    int totalOrders = 0;
                    for (Member m : members) {
                        totalOrders += Integer.parseInt(m.totalOrders);
                    }
                    out.print(totalOrders);
                %></div>
                <div class="label">Total Orders</div>
            </div>

            <div class="summary-item">
                <div class="value"><%= currentDate %></div>
                <div class="label">Report Date</div>
            </div>
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
                <% for (Member member : members) { %>
                    <tr>
                        <td>#<%= member.id %></td>
                        <td><%= member.name %></td>
                        <td><%= member.email %></td>
                        <td><%= member.phone %></td>
                        <td><%= member.joinDate %></td>
                        <td><%= member.totalOrders %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <div class="report-footer">
            <p>Yaya Cosmetic Sdn Bhd | Bangi Avenue Height, Damansara Utama, 96029 Damansara, Selangor</p>
            <p>Tel: 03-78279388 | Email: yayacosmetic@hotline.com</p>
            <p>This is a computer-generated report. No signature required.</p>
        </div>
    </div>

    <!-- Normal screen footer (excluded from printing) -->
    <footer class="no-print">
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
         * Print entry point:
         * window.print() triggers the browser print dialog.
         * CSS @media print ensures only #printArea gets printed.
         */
        function printReport() {
            window.print();
        }
    </script>

</body>
</html>
