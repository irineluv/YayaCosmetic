<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * Cart badge count:
     * Cart is stored in session as Map<productId, quantity>.
     * We sum quantities to show total item count (not number of unique products).
     */
    Map<String, Integer> cartItems = (Map<String, Integer>) session.getAttribute("cartItems");
    int cartCount = 0;
    if (cartItems != null) {
        for (Integer qty : cartItems.values()) {
            cartCount += qty;
        }
    }

    /*
     * User profile data is stored in session as Map<field, value>.
     * This is demo storage (not DB). A default profile is created if missing.
     */
    Map<String, String> userProfile = (Map<String, String>) session.getAttribute("userProfile");
    
    if (userProfile == null) {
        userProfile = new LinkedHashMap<>();
        userProfile.put("name", "Aiya Mala Johan");
        userProfile.put("email", "aiyamala@gmail.com");
        userProfile.put("phone", "012-3456789");

        // Demo-only password stored in session (plain text). Real app MUST hash in database.
        userProfile.put("password", "user123");

        session.setAttribute("userProfile", userProfile);
    }
    
    // Which field is being edited comes from URL: ?field=name | phone | password
    String field = request.getParameter("field");
    
    /*
     * Update flow:
     * - form posts to EditProfile.jsp?field=...&action=update
     * - action=update triggers server-side validation & session update
     */
    String action = request.getParameter("action");
    String errorMsg = null;
    
    if ("update".equals(action)) {

        // Update "name"
        if ("name".equals(field)) {
            String newName = request.getParameter("name");

            if (newName != null && !newName.trim().isEmpty()) {
                userProfile.put("name", newName.trim());
                session.setAttribute("userProfile", userProfile);

                // Redirect back to Profile.jsp with a success indicator
                response.sendRedirect("Profile.jsp?success=true&updated=name");
                return;
            } else {
                errorMsg = "Name cannot be empty.";
            }

        // Update "phone"
        } else if ("phone".equals(field)) {
            String newPhone = request.getParameter("phone");

            if (newPhone != null && !newPhone.trim().isEmpty()) {
                userProfile.put("phone", newPhone.trim());
                session.setAttribute("userProfile", userProfile);

                response.sendRedirect("Profile.jsp?success=true&updated=phone");
                return;
            } else {
                errorMsg = "Phone number cannot be empty.";
            }

        // Update "password"
        } else if ("password".equals(field)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            /*
             * Server-side validation for password change:
             * - must match current password
             * - new password length >= 6
             * - newPassword must match confirmPassword
             */
            if (!userProfile.get("password").equals(currentPassword)) {
                errorMsg = "Current password is incorrect.";
            } else if (newPassword == null || newPassword.length() < 6) {
                errorMsg = "New password must be at least 6 characters.";
            } else if (!newPassword.equals(confirmPassword)) {
                errorMsg = "New passwords do not match.";
            } else {
                userProfile.put("password", newPassword);
                session.setAttribute("userProfile", userProfile);

                response.sendRedirect("Profile.jsp?success=true&updated=password");
                return;
            }
        }
    }
    
    // Current values used to prefill the form fields
    String currentName = userProfile.get("name");
    String currentPhone = userProfile.get("phone");

    // NOTE: currentPasswordValue is never used in the HTML (dead variable)
    String currentPasswordValue = userProfile.get("password");
    
    // Page title varies by field type
    String pageTitle = "Edit Profile";
    if ("name".equals(field)) {
        pageTitle = "Edit Full Name";
    } else if ("phone".equals(field)) {
        pageTitle = "Edit Phone Number";
    } else if ("password".equals(field)) {
        pageTitle = "Change Password";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - Yaya Cosmetic</title>
    <style>
        /* ... (CSS is presentation-only) ... */
    </style>
</head>
<body>

    <header>
        <div class="logo-container">
            <img src="LOGO.png" alt="Yaya Logo" class="logo-img">
            <div class="brand-name">YAYA COSMETIC</div>
        </div>
        <nav>
            <a href="HomePage.jsp">HOME</a>
            <a href="Product.jsp">PRODUCT</a>

            <!-- Cart badge shows total cart quantity -->
            <a href="Cart.jsp" class="cart-link">CART
                <% if (cartCount > 0) { %>
                    <span class="cart-badge"><%= cartCount > 99 ? "99+" : cartCount %></span>
                <% } %>
            </a>

            <a href="History.jsp">HISTORY</a>
            <a href="Profile.jsp">PROFILE</a>
        </nav>
    </header>

    <div class="edit-container">
        <h1 class="page-title"><%= pageTitle.toUpperCase() %></h1>

        <div class="edit-form">
            <!-- Show server-side validation error if any -->
            <% if (errorMsg != null) { %>
                <div class="error-message">
                    <strong>Error:</strong> <%= errorMsg %>
                </div>
            <% } %>

            <% if ("name".equals(field)) { %>
                <!-- Edit name -->
                <form method="POST" action="EditProfile.jsp?field=name&action=update">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="name" value="<%= currentName %>" required 
                               placeholder="Enter your full name" maxlength="100">
                        <p class="hint">This name will be displayed on your profile.</p>
                    </div>
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="Profile.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>

            <% } else if ("phone".equals(field)) { %>
                <!-- Edit phone -->
                <form method="POST" action="EditProfile.jsp?field=phone&action=update">
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="tel" name="phone" value="<%= currentPhone %>" required 
                               placeholder="e.g., 012-3456789" maxlength="15">
                        <p class="hint">Enter your phone number with area code.</p>
                    </div>
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="Profile.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>

            <% } else if ("password".equals(field)) { %>
                <!-- Change password -->
                <form method="POST" action="EditProfile.jsp?field=password&action=update" onsubmit="return validatePassword()">
                    <div class="form-group">
                        <label>Current Password</label>
                        <div class="password-input-wrapper">
                            <input type="password" name="currentPassword" id="currentPassword" required 
                                   placeholder="Enter your current password">
                            <button type="button" class="eye-toggle" onclick="togglePasswordVisibility('currentPassword', this)">👁️</button>
                        </div>
                        <p class="hint">Your current password is required to make changes.</p>
                    </div>
                    
                    <div class="form-group">
                        <label>New Password</label>
                        <div class="password-input-wrapper">
                            <input type="password" name="newPassword" id="newPassword" required 
                                   placeholder="Enter new password" oninput="checkPasswordStrength()">
                            <button type="button" class="eye-toggle" onclick="togglePasswordVisibility('newPassword', this)">👁️</button>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <div class="password-input-wrapper">
                            <input type="password" name="confirmPassword" id="confirmPassword" required 
                                   placeholder="Confirm new password" oninput="checkPasswordMatch()">
                            <button type="button" class="eye-toggle" onclick="togglePasswordVisibility('confirmPassword', this)">👁️</button>
                        </div>
                    </div>

                    <!-- Visual-only requirements indicators; server validation still enforces these rules -->
                    <div class="password-requirements">
                        <h4>Password Requirements:</h4>
                        <div class="requirement" id="req-length">At least 6 characters</div>
                        <div class="requirement" id="req-match">Passwords match</div>
                    </div>
                    
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Change Password</button>
                        <a href="Profile.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>

            <% } else { %>
                <!-- Field param not recognized -->
                <p>Invalid field specified.</p>
                <a href="Profile.jsp" class="btn btn-secondary">Back to Profile</a>
            <% } %>
        </div>
    </div>

    <footer>
        <!-- Footer is static content -->
    </footer>

    <script>
        /*
         * Show/hide password fields for better UX.
         * Changes input type between password <-> text.
         */
        function togglePasswordVisibility(inputId, btn) {
            var input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
                btn.textContent = '🙈';
            } else {
                input.type = 'password';
                btn.textContent = '👁️';
            }
        }

        /*
         * Checks new password minimum length for UI indicator only.
         * Real enforcement is in server-side JSP logic.
         */
        function checkPasswordStrength() {
            var password = document.getElementById('newPassword').value;
            var reqLength = document.getElementById('req-length');
            
            if (password.length >= 6) reqLength.classList.add('valid');
            else reqLength.classList.remove('valid');
            
            checkPasswordMatch();
        }

        /*
         * Checks if confirm password matches new password (UI indicator only).
         */
        function checkPasswordMatch() {
            var password = document.getElementById('newPassword').value;
            var confirm = document.getElementById('confirmPassword').value;
            var reqMatch = document.getElementById('req-match');
            
            if (password && confirm && password === confirm) reqMatch.classList.add('valid');
            else reqMatch.classList.remove('valid');
        }

        /*
         * Client-side guard to prevent obvious invalid submit.
         * Server-side logic still validates everything again.
         */
        function validatePassword() {
            var password = document.getElementById('newPassword').value;
            var confirm = document.getElementById('confirmPassword').value;
            
            if (password.length < 6) {
                alert('Password must be at least 6 characters long.');
                return false;
            }
            if (password !== confirm) {
                alert('Passwords do not match.');
                return false;
            }
            return true;
        }
    </script>

</body>
</html>
