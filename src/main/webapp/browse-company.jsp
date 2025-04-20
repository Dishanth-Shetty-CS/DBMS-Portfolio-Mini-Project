<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Companies - Financial Portfolio Manager</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
    <h2>Browse Companies</h2>
</div>

<div class="container mt-4">
    <h4 class="section-title">Available Companies</h4>
    <div class="row">
        <%
            Connection conn = null;
            Statement st = null;
            ResultSet rsCompany = null;

            try {
                String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
                String user = "root";
                String pass = "trickortreat";
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, pass);
                st = conn.createStatement();
                rsCompany = st.executeQuery("SELECT CNAME, SECTOR, CAPITAL FROM COMPANY"); // Exclude PHONE

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
        <%
                }
            } catch(Exception e) {
        %>
                <script>
                    window.alert("Error: <%= e.getMessage() %>");
                </script>
        <%
            } finally {
                try {
                    if (rsCompany != null) rsCompany.close();
                    if (st != null) st.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</div>

<footer>
    <p>&copy; 2025 Financial Portfolio Manager. All Rights Reserved.</p>
</footer>

</body>
</html>