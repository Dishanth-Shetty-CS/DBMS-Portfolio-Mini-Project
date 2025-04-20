<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
    String userId = request.getParameter("userId");
    String username = request.getParameter("username");
    String userIdError = "";
    String usernameError = "";
    boolean loginSuccess = false;

    if (userId != null && username != null) {
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
            String sql = "SELECT USERNAME FROM USER WHERE UID = ? AND USERNAME = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Login successful: Set session and redirect
                session.setAttribute("loggedInUserName", rs.getString("USERNAME")); // Store username in session
                session.setAttribute("loggedInUserId", userId);
                loginSuccess = true;
            } else {
                // Login failed: Set error message
                // IMPORTANT:  Set individual error messages
                sql = "SELECT USERNAME FROM USER WHERE UID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, userId);
                rs = pstmt.executeQuery();
                if (!rs.next()) {
                    userIdError = "Invalid User ID. Please try again.";
                }

                sql = "SELECT USERNAME FROM USER WHERE USERNAME = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();
                if(!rs.next()) {
                    usernameError = "Invalid Username. Please try again.";
                }


            }
        } catch (Exception e) {
            e.printStackTrace();
            userIdError = "An error occurred: " + e.getMessage(); // Set to a field.
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

    if (loginSuccess) {
        // Redirect to a success page (e.g., dashboard)
        response.sendRedirect("customer-dashboard.jsp");
    } else {
        // Include the original login form page and display the error
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login - Financial Portfolio Manager</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap"
	rel="stylesheet">
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
        let userId = document.getElementById("userId");
        let username = document.getElementById("username");
        let isValid = true;

        // Clear previous errors
        document.getElementById("userId-error").innerHTML = "";
        document.getElementById("username-error").innerHTML = "";
        userId.classList.remove("invalid");
        username.classList.remove("invalid");

        // Validate User ID (must not be empty and only digits)
        if (userId.value.trim() === "") {
            userId.classList.add("invalid");
            document.getElementById("userId-error").innerHTML = "Please enter your User ID.";
            isValid = false;
        } else if (!/^\d+$/.test(userId.value.trim())) {
            userId.classList.add("invalid");
            document.getElementById("userId-error").innerHTML = "User ID must be a number.";
            isValid = false;
        }

        // Validate Username (must not be empty and only alphabetic characters)
        if (username.value.trim() === "") {
            username.classList.add("invalid");
            document.getElementById("username-error").innerHTML = "Please enter your username.";
            isValid = false;
        } else if (!/^[A-Za-z\s]+$/.test(username.value.trim())) {
            username.classList.add("invalid");
            document.getElementById("username-error").innerHTML = "Username must contain only letters.";
            isValid = false;
        }

        return isValid;
    }
</script>

</head>
<body>

	<section class="form-container">
		<h2>Login to Your Account</h2>
		<form onsubmit="return validateForm()" method="POST">
			<div class="form-group">
				<input type="text"
					class="form-control <%= !userIdError.isEmpty() ? "invalid" : "" %>"
					id="userId" name="userId" placeholder="User ID"
					value="<%= userId != null ? userId : "" %>">
				<div id="userId-error" class="invalid-feedback"><%= userIdError %></div>
			</div>
			<div class="form-group">
				<input type="text"
					class="form-control <%= !usernameError.isEmpty() ? "invalid" : "" %>"
					id="username" name="username" placeholder="Username"
					value="<%= username != null ? username : "" %>">
				<div id="username-error" class="invalid-feedback"><%= usernameError %></div>
			</div>
			<button type="submit" class="form-btn">Login</button>

		</form>
		<p class="mt-3">
			Don't have an account? <a href="register.jsp" style="color: #00bfff;">Sign
				up</a>
		</p>
	</section>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
    }
%>
