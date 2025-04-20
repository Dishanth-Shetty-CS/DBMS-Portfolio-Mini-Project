<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard - Financial Portfolio Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #00274D;
            color: white;
            padding: 15px;
            display: flex; /* Use flexbox for layout */
            justify-content: space-between; /* Space items between start and end */
            align-items: center; /* Vertically center items */
        }
        .header h2 {
          margin-bottom: 0;
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

        .section-title {
            margin-top: 40px;
            margin-bottom: 20px;
            color: #00274D;
            font-weight: 600;
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
        }
        footer {
            background-color: #00274D;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<div class="header">
    <h2>Customer Dashboard</h2>
    <a href="login.jsp" class="logout-button">Logout</a> </div>

<div class="container mt-4">

    <%
        String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
        String user = "root";
        String pass = "trickortreat";
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);

            //  Retrieve user ID from the session,  defaulting to 1 if not found
            int uid = 1; // Default value.
            if (session.getAttribute("loggedInUserId") != null) {
                try {
                    uid = Integer.parseInt(session.getAttribute("loggedInUserId").toString());
                } catch (NumberFormatException e) {
                    out.println("<p style='color:red;'>Error: Invalid User ID in session. Please log in again.</p>");
                    session.invalidate();
                    response.sendRedirect("login.jsp");
                    return;
                }
            }

            PreparedStatement psUser = conn.prepareStatement("SELECT * FROM USER WHERE UID = ?");
            psUser.setInt(1, uid);
            ResultSet rsUser = psUser.executeQuery();
            if(rsUser.next()) {
    %>
    <h4 class="section-title">Welcome, <%= rsUser.getString("USERNAME") %>!</h4>
    <p><strong>Phone:</strong> <%= rsUser.getString("PHONE") %></p>
    <% } %>

    <h4 class="section-title">Available Companies</h4>
    <div class="row">
    <%
        Statement st = conn.createStatement();
        ResultSet rsCompany = st.executeQuery("SELECT * FROM COMPANY");
        while(rsCompany.next()) {
    %>
        <div class="col-md-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title"><%= rsCompany.getString("CNAME") %></h5>
                    <p class="card-text">Sector: <%= rsCompany.getString("SECTOR") %></p>
                    <p class="card-text">Capital: ₹<%= rsCompany.getDouble("CAPITAL") %></p>
                </div>
            </div>
        </div>
    <% } %>
    </div>
    <a href="browse-company.jsp" class="btn btn-primary">Browse Companies</a>

    <h4 class="section-title">Company Reports</h4>
    <%
        ResultSet rsReport = st.executeQuery("SELECT r.*, c.CNAME FROM REPORT r JOIN COMPANY c ON r.CID = c.CID");
        while(rsReport.next()) {
    %>
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"><%= rsReport.getString("CNAME") %></h5>
                <p>LTP: ₹<%= rsReport.getDouble("LTP") %>, EPS: <%= rsReport.getDouble("EPS") %>, ROE: <%= rsReport.getDouble("ROE") %>%</p>
            </div>
        </div>
    <% } %>
    <a href="browse-reports.jsp" class="btn btn-primary">Browse Reports</a>

    <h4 class="section-title">Technical Signals</h4>
    <%
        ResultSet rsSignal = st.executeQuery("SELECT t.*, c.CNAME FROM TECHNICAL_SIGNALS t JOIN COMPANY c ON t.CID = c.CID");
        while(rsSignal.next()) {
    %>
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"><%= rsSignal.getString("CNAME") %></h5>
                <p>ADX: <%= rsSignal.getDouble("ADX") %>, MACD: <%= rsSignal.getDouble("MACD") %>, Volume: <%= rsSignal.getInt("VOLUME") %></p>
            </div>
        </div>
    <% } %>
    <a href="browse-signals.jsp" class="btn btn-primary">Browse Signals</a>

    <h4 class="section-title">Your Transactions</h4>
    <%
        PreparedStatement psTrans = conn.prepareStatement(
            "SELECT t.*, c.CNAME FROM TRANSACTION t JOIN COMPANY c ON t.CID = c.CID WHERE t.UID = ?");
        psTrans.setInt(1, uid);
        ResultSet rsTrans = psTrans.executeQuery();
        while(rsTrans.next()) {
    %>
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"><%= rsTrans.getString("CNAME") %> - <%= rsTrans.getString("BUY_SELL") %></h5>
                <p>Rate: ₹<%= rsTrans.getDouble("RATE") %>, Quantity: <%= rsTrans.getInt("QUANTITY") %></p>
            </div>
        </div>
    <% } %>
    <a href="browse-transaction.jsp" class="btn btn-primary">Browse Transactions</a>

    <%
        conn.close();
        } catch(Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    %>

</div>

<footer>
    <p>&copy; 2025 Financial Portfolio Manager. All Rights Reserved.</p>
</footer>

</body>
</html>
