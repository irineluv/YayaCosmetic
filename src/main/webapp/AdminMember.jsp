<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ===== ADMIN MEMBER MANAGEMENT PAGE LOGIC =====
    // This page displays all registered members/customers for administrators
    
    // Define Member class to hold customer information
    // Later: move to com.mycompany.yayacosmetic.model.User
    class Member {
        String id;
        String name;
        String email;
        String password;
        String birthdate;
        String address;
        
        Member(String id, String name, String email, String password, String birthdate, String address) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.password = password;
            this.birthdate = birthdate;
            this.address = address;
        }
    }
    
    // Create sample member list (hardcoded for demonstration)
    // Later with database: fetch using UserDAO.getAllUsers()
    // Note: Passwords are masked (********) for security - never display actual passwords
    List<Member> members = new ArrayList<>();
    members.add(new Member("01", "ALYA MASARAH", "alya99@mail.com", "********", "09/09/1998", "Mount Height, Bukit Benar, Selangor"));
    members.add(new Member("02", "ANIS ZIRA", "aniszira@mail.com", "********", "21/08/2001", "Bukit Kumbang, Selayang, Selangor"));
    members.add(new Member("03", "VERONICA MALIS", "vero@mail.com", "********", "08/07/1999", "Jalan Timur Tengah, Pagoh, Perak"));
    members.add(new Member("04", "MONDY MONA", "mondy@mail.co", "********", "08/05/1989", "Jalan Bulan Terang, Klang, Selangor"));
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
        .member-container {
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
            background-color: #e8dcc8;
            padding: 20px;
            border-radius: 10px;
        }

        .member-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
        }

        .member-table thead {
            background-color: #7b0d1e;
            color: white;
        }

        .member-table th,
        .member-table td {
            padding: 15px;
            text-align: left;
            border: 1px solid #999;
        }

        .member-table th {
            font-weight: bold;
            text-transform: uppercase;
            font-size: 14px;
        }

        .member-table tbody tr {
            background-color: #f5f5f5;
        }

        .member-table tbody tr:hover {
            background-color: #e0e0e0;
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

    <div class="member-container">
        <h1 class="page-title">MEMBER</h1>

        <div class="table-wrapper">
            <table class="member-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>NAME</th>
                        <th>EMAIL</th>
                        <th>PASSWORD</th>
                        <th>BIRTHDATE</th>
                        <th>ADDRESS</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Member member : members) { %>
                        <tr>
                            <td><%= member.id %></td>
                            <td><%= member.name %></td>
                            <td><%= member.email %></td>
                            <td><%= member.password %></td>
                            <td><%= member.birthdate %></td>
                            <td><%= member.address %></td>
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
