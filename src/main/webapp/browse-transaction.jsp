<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Transactions - Financial Portfolio Manager</title>
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
        }
        .section-title {
            margin-top: 40px;
            margin-bottom: 20px;
            color: #00274D;
            font-weight: 600;
        }
        .table-container {
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        .table-responsive {
            overflow-x: auto;
            margin-bottom: 20px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            margin-bottom: 0;
        }
        .table thead th {
            background-color: #f8f9fa;
            color: #00274D;
            padding: 12px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
        }
        .table tbody tr:nth-child(odd) {
            background-color: #f2f2f2;
        }
        .table tbody tr:hover {
            background-color: #e0e0e0;
        }
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .table th, .table td {
            border-right: 1px solid #dee2e6;
        }
        .table th:last-child, .table td:last-child {
            border-right: none;
        }
        .no-data-message {
            text-align: center;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            margin-top: 20px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.05);
            color: #6c757d;
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
    <h2>Browse Transactions</h2>
</div>

<div class="container mt-4">
    <h4 class="section-title">Your Transactions</h4>
    <%
        Connection conn = null;
        Statement st = null;
        ResultSet rsTransactions = null;
        String loggedInUserName = (String) session.getAttribute("loggedInUserName"); // Get username from session

        if (loggedInUserName == null || loggedInUserName.isEmpty()) {
            // Redirect to login page if user is not logged in
            response.sendRedirect("login.jsp");
            return; // Stop further execution of this page
        }

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            st = conn.createStatement();
            // Use a prepared statement to prevent SQL injection and for efficiency
            String sql = "SELECT c.CNAME, t.RATE, t.QUANTITY, t.BUY_SELL " +
                         "FROM TRANSACTION t " +
                         "JOIN USER u ON t.UID = u.UID " +
                         "JOIN COMPANY c ON t.CID = c.CID " +
                         "WHERE u.USERNAME = ?"; // Filter by logged-in user

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loggedInUserName); // Set the username parameter
            rsTransactions = pstmt.executeQuery();

    %>
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Company Name</th>
                            <th>Rate</th>
                            <th>Quantity</th>
                            <th>Buy/Sell</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (rsTransactions != null && rsTransactions.isBeforeFirst()) {
                                while (rsTransactions.next()) {
                        %>
                                    <tr>
                                        <td><%= rsTransactions.getString("CNAME") %></td>
                                        <td><%= rsTransactions.getDouble("RATE") %></td>
                                        <td><%= rsTransactions.getInt("QUANTITY") %></td>
                                        <td><%= rsTransactions.getString("BUY_SELL") %></td>
                                    </tr>
                        <%
                                }
                            } else {
                        %>
                                <tr>
                                    <td colspan="4" class="text-center">No transactions available for you.</td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    <%
        } catch(Exception e) {
    %>
            <script>
                window.alert("Error: <%= e.getMessage() %>");
            </script>
    <%
        } finally {
            try {
                if (rsTransactions != null) rsTransactions.close();
                if (st != null) st.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</div>

<footer>
    <p>&copy; 2025 Financial Portfolio Manager. All Rights Reserved.</p>
</footer>

</body>
</html>
