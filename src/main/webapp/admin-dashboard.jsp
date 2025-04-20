<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - Financial Portfolio Manager</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
<style>
body {
	font-family: 'Poppins', sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f2f2f2;
}
.header {
	background-color: #00274D;
	color: white;
	padding: 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	z-index: 100; /* Add z-index to header */
	position: relative; /* Needed for z-index to work */
}
.header h1 {
	font-size: 1.8rem;
}
.logout-button {
	color: red;
	text-decoration: none;
	font-weight: bold;
	transition: color 0.3s ease;
	background-color: red;
	border-radius: 10px;
	color: white;
	font-weight: bolder;
	width: 80px;
	height: 40px;
	padding: 8px;
}
.content {
	padding: 50px 20px;
	position: relative; /* Changed from absolute to relative */
	margin-top: 60px; /* Add margin to avoid overlap with fixed header */
}
.card {
	border-radius: 10px;
	background-color: white;
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
	margin-bottom: 30px;
	transition: transform 0.3s ease;
	cursor: pointer;
}
.card:hover {
	transform: scale(1.03);
}
.card-body {
	padding: 20px;
	text-align: center;
}
.btn-custom {
	background-color: #00bfff;
	color: white;
	border-radius: 5px;
	transition: background-color 0.3s;
	width: 100%;
}
.btn-custom:hover {
	background-color: #009acd;
	color: #fff;
}
footer {
	background-color: #00274D;
	color: white;
	text-align: center;
	padding: 15px;
	position: fixed;
	bottom: 0;
	width: 100%;
	z-index: 100; /* Add z-index to footer */
}
</style>
</head>
<body>

<div class="header">
	<h1>Admin Dashboard</h1>
	<a href="admin-login.jsp" class="logout-button">Logout</a>
</div>

<div class="content container">
	<%
		String adminName = (String) session.getAttribute("loggedInAdminName");
		if (adminName != null && !adminName.isEmpty()) {
	%>
		<h2 class="text-center mb-4">Welcome, <%= adminName %></h2>
	<%
		} else {
			out.println("<p style='color:red;'>Admin not logged in. Please log in.</p>");
			response.sendRedirect("admin-login.jsp");
			return;
		}
	%>
	<div class="row">
		<div class="col-md-4">
			<div class="card">
				<div class="card-body">
					<h5 class="card-title">Manage Users</h5>
					<p class="card-text">View and edit user information.</p>
					<a href="manage-users.jsp" class="btn btn-custom">Manage Users</a>
				</div>
			</div>
		</div>

		<div class="col-md-4">
			<div class="card">
				<div class="card-body">
					<h5 class="card-title">Manage Companies</h5>
					<p class="card-text">Add, update or delete company details.</p>
					<a href="manage-companies.jsp" class="btn btn-custom">Manage Companies</a>
				</div>
			</div>
		</div>

		<div class="col-md-4">
			<div class="card">
				<div class="card-body">
					<h5 class="card-title">Manage Reports</h5>
					<p class="card-text">Control LTP, EPS, ROE and more.</p>
					<a href="manage-reports.jsp" class="btn btn-custom">Manage Reports</a>
				</div>
			</div>
		</div>

		<div class="col-md-6">
			<div class="card">
				<div class="card-body">
					<h5 class="card-title">Manage Technical Signals</h5>
					<p class="card-text">ADX, MACD, Volume stats for companies.</p>
					<a href="manage-signals.jsp" class="btn btn-custom">Manage Signals</a>
				</div>
			</div>
		</div>

		<div class="col-md-6">
			<div class="card">
				<div class="card-body">
					<h5 class="card-title">Manage Transactions</h5>
					<p class="card-text">Buy/Sell transactions for users.</p>
					<a href="manage-transactions.jsp" class="btn btn-custom">Manage Transactions</a>
				</div>
			</div>
		</div>
	</div>
</div>

<footer>
	<p>&copy; 2025 Financial Portfolio Manager. All Rights Reserved.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
