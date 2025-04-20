<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
    String adminId = request.getParameter("adminid");
    String adminName = request.getParameter("adminname");
    String adminIdError = "";
    String adminNameError = "";
    boolean loginSuccess = false;

    if (adminId != null && adminName != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT ADMINNAME FROM ADMIN WHERE ADMINID = ? AND ADMINNAME = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, adminId);
            pstmt.setString(2, adminName);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("loggedInAdminName", rs.getString("ADMINNAME"));
                session.setAttribute("loggedInAdminId", adminId);
                loginSuccess = true;
            } else {
                sql = "SELECT ADMINNAME FROM ADMIN WHERE ADMINID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, adminId);
                rs = pstmt.executeQuery();
                if (!rs.next()) {
                    adminIdError = "Invalid Admin ID. Please try again.";
                }

                sql = "SELECT ADMINID FROM ADMIN WHERE ADMINNAME = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, adminName);
                rs = pstmt.executeQuery();
                if (!rs.next()) {
                    adminNameError = "Invalid Admin Name. Please try again.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            adminIdError = "An error occurred: " + e.getMessage();
        } finally {
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
        response.sendRedirect("admin-dashboard.jsp");
    } else {
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Login - Financial Portfolio Manager</title>
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
        let adminId = document.getElementById("adminid");
        let adminName = document.getElementById("adminname");
        let isValid = true;

        // Clear previous errors
        document.getElementById("adminid-error").innerHTML = "";
        document.getElementById("adminname-error").innerHTML = "";
        adminId.classList.remove("invalid");
        adminName.classList.remove("invalid");

        // Admin ID validation (must be all digits)
        if (adminId.value.trim() === "") {
            adminId.classList.add("invalid");
            document.getElementById("adminid-error").innerHTML = "Please enter your Admin ID.";
            isValid = false;
        } else if (!/^\d+$/.test(adminId.value.trim())) {
            adminId.classList.add("invalid");
            document.getElementById("adminid-error").innerHTML = "Admin ID must be numeric (digits only).";
            isValid = false;
        }

        // Admin Name validation (must be only letters and spaces)
        if (adminName.value.trim() === "") {
            adminName.classList.add("invalid");
            document.getElementById("adminname-error").innerHTML = "Please enter your Admin Name.";
            isValid = false;
        } else if (!/^[A-Za-z\s]+$/.test(adminName.value.trim())) {
            adminName.classList.add("invalid");
            document.getElementById("adminname-error").innerHTML = "Admin Name must contain only letters (no digits or symbols).";
            isValid = false;
        }

        return isValid;
    }
</script>

</head>
<body>
	<section class="form-container">
		<h2>Admin Login</h2>
		<form onsubmit="return validateForm()" method="POST">
			<div class="form-group">
				<input type="text"
					class="form-control <%= !adminIdError.isEmpty() ? "invalid" : "" %>"
					id="adminid" name="adminid" placeholder="Admin ID"
					value="<%= adminId != null ? adminId : "" %>">
				<div id="adminid-error" class="invalid-feedback"><%= adminIdError %></div>
			</div>
			<div class="form-group">
				<input type="text"
					class="form-control <%= !adminNameError.isEmpty() ? "invalid" : "" %>"
					id="adminname" name="adminname" placeholder="Admin Name"
					value="<%= adminName != null ? adminName : "" %>">
				<div id="adminname-error" class="invalid-feedback"><%= adminNameError %></div>
			</div>
			<button type="submit" class="form-btn">Login</button>
		</form>
	</section>
</body>
</html>
<%
    }
%>
