<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    /*
     * DATA SOURCE (TEMP):
     * Admin profile is stored in session under "adminProfile".
     * Map keys: name, email, phone, password
     * NOTE: This is demo-level storage (not persistent / not secure for real apps).
     */
    Map<String, String> adminProfile = (Map<String, String>) session.getAttribute("adminProfile");

    // Initialize default profile if session is empty (prevents NPE and supports demo/testing)
    if (adminProfile == null) {
        adminProfile = new LinkedHashMap<>();
        adminProfile.put("name", "Aiya Johan");
        adminProfile.put("email", "aiyaJo@mail.com");
        adminProfile.put("phone", "012-3456789");
        adminProfile.put("password", "admin123");
        session.setAttribute("adminProfile", adminProfile);
    }

    /*
     * ROUTING (FIELD-DRIVEN):
     * The "field" URL parameter decides which edit form to show:
     * - field=name     -> edit name form
     * - field=phone    -> edit phone form
     * - field=password -> change password form
     */
    String field = request.getParameter("field");

    /*
     * REQUEST FLOW:
     * - Default: display form based on "field"
     * - When submitted: POST to same page with action=update
     * - On success: redirect to AdminProfile.jsp (PRG pattern to prevent resubmission)
     */
    String action = request.getParameter("action");
    String errorMsg = null;

    if ("update".equals(action)) {

        // Update: Full Name
        if ("name".equals(field)) {
            String newName = request.getParameter("name");

            // Server-side validation (do not rely on HTML required alone)
            if (newName != null && !newName.trim().isEmpty()) {
                adminProfile.put("name", newName.trim());
                session.setAttribute("adminProfile", adminProfile);

                // Redirect after POST (PRG pattern)
                response.sendRedirect("AdminProfile.jsp?success=true&updated=name");
                return;
            } else {
                errorMsg = "Name cannot be empty.";
            }

        // Update: Phone Number
        } else if ("phone".equals(field)) {
            String newPhone = request.getParameter("phone");

            if (newPhone != null && !newPhone.trim().isEmpty()) {
                adminProfile.put("phone", newPhone.trim());
                session.setAttribute("adminProfile", adminProfile);

                response.sendRedirect("AdminProfile.jsp?success=true&updated=phone");
                return;
            } else {
                errorMsg = "Phone number cannot be empty.";
            }

        // Update: Password (requires current password + confirm check)
        } else if ("password".equals(field)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate current password before allowing changes
            if (!adminProfile.get("password").equals(currentPassword)) {
                errorMsg = "Current password is incorrect.";

            // Basic policy: minimum length
            } else if (newPassword == null || newPassword.length() < 6) {
                errorMsg = "New password must be at least 6 characters.";

            // Confirm new password matches
            } else if (!newPassword.equals(confirmPassword)) {
                errorMsg = "New passwords do not match.";

            } else {
                // Store updated password in session (demo approach only)
                adminProfile.put("password", newPassword);
                session.setAttribute("adminProfile", adminProfile);

                response.sendRedirect("AdminProfile.jsp?success=true&updated=password");
                return;
            }
        }
    }

    // Current values used to prefill the form inputs
    String currentName = adminProfile.get("name");
    String currentPhone = adminProfile.get("phone");

    // Dynamic title based on what is being edited
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
    <title><%= pageTitle %> - Yaya Cosmetic Admin</title>
    <style>
        /* Base page styling */
        body { 
            margin: 0; 
            font-family: Arial, sans-serif; 
            background-color: #ffffff; 
        }
        
        /* Header / navigation */
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

        /* Main Content container */
        .edit-container {
            padding: 40px 10%;
            min-height: 60vh;
        }

        .page-title {
            font-size: 36px;
            font-weight: bold;
            margin: 0 0 30px 0;
        }

        /* Form card */
        .edit-form {
            max-width: 500px;
            background-color: #f9f9f9;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        /* Server-side error message */
        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        /* Form controls */
        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 14px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            font-family: Arial, sans-serif;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #7b0d1e;
        }

        .form-group .hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        /* Password input: adds eye toggle button to show/hide */
        .password-input-wrapper {
            position: relative;
        }

        .password-input-wrapper input {
            padding-right: 50px;
        }

        .eye-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
            color: #666;
        }

        .eye-toggle:hover {
            color: #333;
        }

        /* Password requirements feedback box (UI-only validation helper) */
        .password-requirements {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }

        .password-requirements h4 {
            margin: 0 0 10px 0;
            font-size: 13px;
            color: #666;
        }

        .requirement {
            font-size: 12px;
            color: #666;
            margin: 5px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .requirement.valid {
            color: #28a745;
        }

        .requirement::before {
            content: "○";
            font-size: 10px;
        }

        .requirement.valid::before {
            content: "●";
            color: #28a745;
        }

        /* Primary/secondary actions */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            text-transform: uppercase;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: #001a72;
            color: white;
            flex: 1;
        }

        .btn-primary:hover {
            background-color: #000f45;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
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

        /* Responsive tweak: stack buttons and reduce padding on small screens */
        @media (max-width: 768px) {
            .button-group {
                flex-direction: column;
            }
            
            .edit-form {
                padding: 25px;
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
        <!-- Admin navigation -->
        <nav>
            <a href="AdminHome.jsp">HOME</a>
            <a href="AdminProduct.jsp">PRODUCT</a>
            <a href="AdminOrder.jsp">ORDER</a>
            <a href="AdminMember.jsp">MEMBER</a>
            <a href="AdminProfile.jsp">PROFILE</a>
        </nav>
    </header>

    <div class="edit-container">
        <h1 class="page-title"><%= pageTitle.toUpperCase() %></h1>

        <div class="edit-form">
            <!-- Server-side validation feedback -->
            <% if (errorMsg != null) { %>
                <div class="error-message">
                    <strong>Error:</strong> <%= errorMsg %>
                </div>
            <% } %>

            <% if ("name".equals(field)) { %>
                <!-- Edit Name Form -->
                <form method="POST" action="AdminEditProfile.jsp?field=name&action=update">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="name" value="<%= currentName %>" required 
                               placeholder="Enter your full name" maxlength="100">
                        <p class="hint">This name will be displayed on your profile.</p>
                    </div>
                    
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="AdminProfile.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>

            <% } else if ("phone".equals(field)) { %>
                <!-- Edit Phone Form -->
                <form method="POST" action="AdminEditProfile.jsp?field=phone&action=update">
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="tel" name="phone" value="<%= currentPhone %>" required 
                               placeholder="e.g., 012-3456789" maxlength="15">
                        <p class="hint">Enter your phone number with area code.</p>
                    </div>
                    
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="AdminProfile.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>

            <% } else if ("password".equals(field)) { %>
                <!-- Change Password Form -->
                <form method="POST" action="AdminEditProfile.jsp?field=password&action=update" onsubmit="return validatePassword()">
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

                    <!-- UI-only: gives live feedback before submit (server still validates) -->
                    <div class="password-requirements">
                        <h4>Password Requirements:</h4>
                        <div class="requirement" id="req-length">At least 6 characters</div>
                        <div class="requirement" id="req-match">Passwords match</div>
                    </div>
                    
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">Change Password</button>
                        <a href="AdminProfile.jsp" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>

            <% } else { %>
                <!-- Fallback: invalid / missing field parameter -->
                <p>Invalid field specified.</p>
                <a href="AdminProfile.jsp" class="btn btn-secondary">Back to Profile</a>
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
        /*
         * Password visibility toggle:
         * Switches input type between password/text and updates button icon.
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
         * Password requirement checks (UI helper):
         * Updates visual status while the user types.
         * Server-side still enforces these rules.
         */
        function checkPasswordStrength() {
            var password = document.getElementById('newPassword').value;
            var reqLength = document.getElementById('req-length');

            // Requirement: minimum length 6
            if (password.length >= 6) {
                reqLength.classList.add('valid');
            } else {
                reqLength.classList.remove('valid');
            }

            // Also refresh match indicator whenever password changes
            checkPasswordMatch();
        }

        // Requirement: newPassword and confirmPassword must match
        function checkPasswordMatch() {
            var password = document.getElementById('newPassword').value;
            var confirm = document.getElementById('confirmPassword').value;
            var reqMatch = document.getElementById('req-match');

            if (password && confirm && password === confirm) {
                reqMatch.classList.add('valid');
            } else {
                reqMatch.classList.remove('valid');
            }
        }

        /*
         * Client-side blocking validation:
         * Prevents form submit if basic rules fail (UX improvement).
         * Server-side validation still exists and is the source of truth.
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
