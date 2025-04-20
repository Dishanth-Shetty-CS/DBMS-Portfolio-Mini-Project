<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - Financial Portfolio Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-container {
            padding: 50px 20px;
            text-align: center;
            max-width: 600px;
            width: 100%;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .form-container h2 {
            font-size: 2rem;
            color: #003366;
            margin-bottom: 30px;
        }

        .form-control {
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #00bfff;
            box-shadow: 0 0 5px rgba(0, 191, 255, 0.5);
        }

        .form-btn {
            background-color: #00bfff;
            border: none;
            padding: 15px 30px;
            color: white;
            font-size: 1rem;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .form-btn:hover {
            background-color: #009acd;
        }

        footer {
            background-color: #00274D;
            color: white;
            padding: 20px 0;
            text-align: center;
            margin-top: 100px;
        }

        .error {
            color: red;
            font-size: 0.9rem;
        }

        .invalid {
            border: 2px solid red !important;
        }

        .invalid-feedback {
            display: block;
            font-size: 0.8rem;
            color: red;
        }
    </style>
    <script>
        function validateForm() {
            let username = document.getElementById("username");
            let phone = document.getElementById("phone");
            let isValid = true;

            // Reset validation messages and styles
            document.getElementById("username-error").innerHTML = "";
            document.getElementById("phone-error").innerHTML = "";
            username.classList.remove("invalid");
            phone.classList.remove("invalid");

            // Validate username
            if (username.value.trim() == "") {
                username.classList.add("invalid");
                document.getElementById("username-error").innerHTML = "Please enter your username.";
                isValid = false;
            }

            // Validate username: Only characters are allowed
            const usernameRegex = /^[a-zA-Z]+$/;
            if(!usernameRegex.test(username.value.trim())){
                username.classList.add("invalid");
                document.getElementById("username-error").innerHTML = "Username must contain only characters.";
                isValid = false;
            }

            // Validate phone number (exactly 10 digits)
            const phoneRegex = /^[0-9]{10}$/;
            if (phone.value.trim() == "") {
                phone.classList.add("invalid");
                document.getElementById("phone-error").innerHTML = "Please enter your phone number.";
                isValid = false;
            } else if (!phoneRegex.test(phone.value.trim())) {
                phone.classList.add("invalid");
                document.getElementById("phone-error").innerHTML = "Phone number must be exactly 10 digits.";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>
<body>

    <section class="form-container">
        <h2>Create an Account</h2>
        <%
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String errorMessage = "";
            int generatedUserId = -1; // Initialize to an invalid value

            if (username != null && phone != null) { // Check if parameters are not null
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
                    String user = "root";
                    String pass = "trickortreat";
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, user, pass);

                    // Use a prepared statement to prevent SQL injection
                    String sql = "INSERT INTO USER (USERNAME, PHONE) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); // Get generated keys
                    pstmt.setString(1, username);
                    pstmt.setString(2, phone);
                    int rowsInserted = pstmt.executeUpdate();

                    if (rowsInserted > 0) {
                        // Get the generated user ID
                        rs = pstmt.getGeneratedKeys();
                        if (rs.next()) {
                            generatedUserId = rs.getInt(1);
                        }

                        if (generatedUserId != -1) {
                            // Display SweetAlert with the user ID and then redirect
                            %>
                            <script>
                                Swal.fire({
                                    title: 'Your User ID',
                                    text: 'Your User ID is: <%= generatedUserId %>',
                                    icon: 'success',
                                    confirmButtonText: 'OK'
                                }).then(() => {
                                    window.location.href = 'login.jsp';
                                });
                            </script>
                            <%
                            return; // Stop further execution of this page
                        }
                        else{
                             errorMessage = "Failed to retrieve User ID. Please contact support.";
                        }

                       
                    } else {
                        errorMessage = "Failed to create account. Please try again.";
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    errorMessage = "An error occurred: " + e.getMessage();
                } finally {
                    // Close database resources
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        <form onsubmit="return validateForm()" method="POST">
            <div class="form-group">
                <input type="text" class="form-control <%= errorMessage.contains("Username") ? "invalid" : "" %>" id="username" name="username" placeholder="Username" value="<%= username != null ? username : "" %>">
                <div id="username-error" class="invalid-feedback"></div>
                 <% if (errorMessage.contains("Username")) { %>
                    <p class="error"><%= errorMessage %></p>
                <% } %>
            </div>
            <div class="form-group">
                <input type="text" class="form-control <%= errorMessage.contains("Phone") ? "invalid" : "" %>" id="phone" name="phone" placeholder="Phone Number" value="<%= phone != null ? phone : "" %>">
                <div id="phone-error" class="invalid-feedback"></div>
                 <% if (errorMessage.contains("Phone")) { %>
                    <p class="error"><%= errorMessage %></p>
                <% } %>
            </div>
            <button type="submit" class="form-btn">Sign Up</button>
             <% if (errorMessage != null && !errorMessage.contains("Username") && !errorMessage.contains("Phone")) { %>
                    <p class="error"><%= errorMessage %></p>
                <% } %>
        </form>
        <p class="mt-3">Already have an account? <a href="login.jsp" style="color: #00bfff;">Login</a></p>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
