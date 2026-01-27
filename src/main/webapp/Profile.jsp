<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.yc.model.User, com.yc.model.Address" %>
<%
    User user = (User) request.getAttribute("user");
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    if (user == null) {
        response.sendRedirect("ProfileServlet");
        return;
    }
    
    if (cartCount == null) cartCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yaya Cosmetic - My Profile</title>
    <style>
        body { margin: 0; font-family: 'Arial', sans-serif; background-color: #fcfcfc; }
        header { background-color: #7b0d1e; color: white; padding: 10px 50px; display: flex; justify-content: space-between; align-items: center; }
        .logo-container { display: flex; align-items: center; gap: 15px; }
        .logo-img { height: 50px; width: auto; }
        .brand-name { font-family: 'Times New Roman', serif; font-size: 26px; letter-spacing: 2px; text-transform: uppercase; }
        nav { display: flex; align-items: center; gap: 25px; }
        nav a { color: white; text-decoration: none; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; }
        .cart-icon { position: relative; }
        .cart-badge { position: absolute; top: -8px; right: -8px; background-color: #ffc107; color: #000; font-size: 10px; font-weight: bold; padding: 2px 6px; border-radius: 50%; }

        .profile-section { padding: 40px 60px; min-height: 60vh; }
        .section-title { font-size: 32px; font-weight: bold; margin: 0 0 30px 0; }

        .message { padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; }
        .success-message { background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
        .error-message { background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }

        .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .profile-card { background: #fff; border-radius: 10px; padding: 25px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .card-title { font-size: 18px; font-weight: bold; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #f0f0f0; }

        .profile-field { margin-bottom: 20px; }
        .field-label { font-size: 12px; color: #666; text-transform: uppercase; margin-bottom: 5px; }
        .field-value { font-size: 16px; font-weight: 500; }

        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-size: 13px; font-weight: bold; margin-bottom: 5px; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; box-sizing: border-box; }

        .btn-save { padding: 10px 25px; background-color: #7b0d1e; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-save:hover { background-color: #5a0a15; }

        .address-card { background: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 10px; }
        .address-label { font-weight: bold; margin-bottom: 5px; }
        .address-text { font-size: 14px; color: #666; }
        .address-default { display: inline-block; padding: 3px 10px; background-color: #7b0d1e; color: white; font-size: 10px; border-radius: 10px; margin-left: 10px; }
        .address-actions { margin-top: 10px; }
        .address-actions button { padding: 5px 15px; font-size: 12px; margin-right: 10px; cursor: pointer; border-radius: 3px; }
        .btn-delete { background: #dc3545; color: white; border: none; }

        .btn-add-address { display: inline-block; padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; margin-top: 15px; }

        .add-address-form { display: none; margin-top: 20px; padding: 20px; background: #f9f9f9; border-radius: 8px; }
        .add-address-form.show { display: block; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }

        footer { background-color: #7b0d1e; color: white; padding: 40px 60px; display: flex; justify-content: space-between; margin-top: 50px; }
        .footer-col { flex: 1; }
        .footer-col h4 { font-size: 16px; margin-bottom: 20px; text-transform: uppercase; }
        .footer-col p, .footer-col a { display: block; color: #ffffff; text-decoration: none; font-size: 13px; margin: 8px 0; }

        @media (max-width: 800px) { .profile-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <span class="brand-name">Yaya Cosmetic</span>
        </div>
        <nav>
            <a href="HomePage.jsp">Home</a>
            <a href="ProductListServlet">Products</a>
            <a href="OrderHistoryServlet">History</a>
            <a href="ProfileServlet">Profile</a>
            <a href="LogoutServlet">Logout</a>
            <a href="CartServlet" class="cart-icon">🛒<% if (cartCount > 0) { %><span class="cart-badge"><%= cartCount %></span><% } %></a>
        </nav>
    </header>

    <section class="profile-section">
        <h2 class="section-title">MY PROFILE</h2>

        <% if (success != null) { %>
            <div class="message success-message">
                <% if ("profile".equals(success)) { %>Profile updated successfully!
                <% } else if ("password".equals(success)) { %>Password changed successfully!
                <% } else if ("addressadded".equals(success)) { %>Address added successfully!
                <% } else if ("addressdeleted".equals(success)) { %>Address deleted successfully!
                <% } else { %>Changes saved successfully!<% } %>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="message error-message">
                <% if ("wrongpassword".equals(error)) { %>Current password is incorrect.
                <% } else if ("passwordmismatch".equals(error)) { %>New passwords do not match.
                <% } else { %>An error occurred. Please try again.<% } %>
            </div>
        <% } %>

        <div class="profile-grid">
            <div class="profile-card">
                <div class="card-title">Personal Information</div>
                <form action="UpdateProfileServlet" method="POST">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" value="<%= user.getFullName() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Email (cannot be changed)</label>
                        <input type="email" value="<%= user.getEmail() %>" disabled>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                    </div>
                    <button type="submit" class="btn-save">Save Changes</button>
                </form>
            </div>

            <div class="profile-card">
                <div class="card-title">Change Password</div>
                <form action="UpdateProfileServlet" method="POST">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="form-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" required minlength="6">
                    </div>
                    <button type="submit" class="btn-save">Change Password</button>
                </form>
            </div>

            <div class="profile-card" style="grid-column: span 2;">
                <div class="card-title">My Addresses</div>
                
                <% if (addresses == null || addresses.isEmpty()) { %>
                    <p style="color:#666;">You don't have any saved addresses yet.</p>
                <% } else { 
                    for (Address addr : addresses) { %>
                    <div class="address-card">
                        <div class="address-label">
                            <%= addr.getLabel() != null ? addr.getLabel() : "Address" %>
                            <% if (addr.isDefault()) { %><span class="address-default">Default</span><% } %>
                        </div>
                        <div class="address-text">
                            <%= addr.getAddressLine() %><br>
                            <%= addr.getCity() %>, <%= addr.getState() %> <%= addr.getPostalCode() %><br>
                            Phone: <%= addr.getPhone() %>
                        </div>
                        <div class="address-actions">
                            <form action="AddressServlet" method="POST" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="addressId" value="<%= addr.getAddressId() %>">
                                <button type="submit" class="btn-delete" onclick="return confirm('Delete this address?')">Delete</button>
                            </form>
                        </div>
                    </div>
                <% } 
                } %>

                <button class="btn-add-address" onclick="document.getElementById('addAddressForm').classList.toggle('show')">+ Add New Address</button>

                <div id="addAddressForm" class="add-address-form">
                    <form action="AddressServlet" method="POST">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label>Label (e.g., Home, Office)</label>
                            <input type="text" name="label" placeholder="Home">
                        </div>
                        <div class="form-group">
                            <label>Address Line</label>
                            <input type="text" name="addressLine" required placeholder="Street address">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>City</label>
                                <input type="text" name="city" required>
                            </div>
                            <div class="form-group">
                                <label>State</label>
                                <input type="text" name="state" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Postal Code</label>
                                <input type="text" name="postalCode" required>
                            </div>
                            <div class="form-group">
                                <label>Country</label>
                                <input type="text" name="country" value="Malaysia">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="text" name="phone" required>
                        </div>
                        <div class="form-group">
                            <label><input type="checkbox" name="isDefault"> Set as default address</label>
                        </div>
                        <button type="submit" class="btn-save">Add Address</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <footer>
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
