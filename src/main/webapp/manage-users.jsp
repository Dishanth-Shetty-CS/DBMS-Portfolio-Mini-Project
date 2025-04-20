<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Financial Portfolio Manager</title>
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
        .table-container {
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .table-responsive {
            overflow-x: auto;
            margin-bottom: 20px;
        }
        .table {
            width: 80%;
            border-collapse: collapse;
            background-color: white;
            margin: 0 auto;
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
        .action-btn {
            padding: 8px 16px;
            border-radius: 5px;
            transition: background-color 0.3s;
            color: white;
            text-decoration: none;
        }
        .update-btn {
            background-color: #007bff;
            color: #fff;
        }
        .update-btn:hover {
            background-color: #0056b3;
            color: #fff;
        }

        .delete-btn {
            background-color: #dc3545;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
        .add-btn {
            background-color: #28a745;
            color: #fff;
        }
        .add-btn:hover {
            background-color: #218838;
            color: #fff;
        }
        .text-center.mt-4 {
            width: 100%;
            display: flex;
            justify-content: center;
            margin-bottom: 10px;
        }
        
    </style>
</head>
<body>

<div class="header">
    <h2>Manage Users</h2>
</div>

<div class="container mt-4">
    <h4 class="section-title">Customer List</h4>

    <form action="manage-users.jsp" method="POST" class="mb-4">
        <h5>Add New User</h5>
        <input type="text" name="username" placeholder="Username" class="form-control mb-2" required>
        <input type="text" name="phone" placeholder="Phone" class="form-control mb-2" required>
        <button type="submit" class="btn btn-success add-btn">Add User</button>
    </form>

    <script>
        <%
        String message = (String) request.getAttribute("message");
        if (message != null && !message.isEmpty()) {
            if (message.startsWith("Success")) {
                String sweetAlertMessage = message.substring(8);
                out.println("Swal.fire('Success', '" + sweetAlertMessage + "', 'success').then(function() {");
                out.println("  window.location.href = 'manage-users.jsp';");
                out.println("});");
            } else if (message.startsWith("Error")) {
                String sweetAlertMessage = message.substring(6);
                out.println("Swal.fire('Error', '" + sweetAlertMessage + "', 'error');");
            }
        }
        %>
    </script>

    <div class="table-container">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Connection conn = null;
                    Statement st = null;
                    ResultSet rs = null;
                    try {
                        String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
                        String user = "root";
                        String pass = "trickortreat";
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, user, pass);
                        st = conn.createStatement();
                        String sql = "SELECT UID, USERNAME, PHONE FROM USER";
                        rs = st.executeQuery(sql);

                        if (!rs.isBeforeFirst()) {
                            out.println("<tr><td colspan='4' class='no-data-message'>No users found.</td></tr>");
                        } else {
                            while (rs.next()) {
                                int uid = rs.getInt("UID");
                                String username = rs.getString("USERNAME");
                                String phone = rs.getString("PHONE");
                    %>
                    <tr>
                        <td><%= uid %></td>
                        <td><%= username %></td>
                        <td><%= phone %></td>
                        <td>
                            <a href="manage-users.jsp?uid=<%= uid %>&action=update" class="btn btn-warning update-btn">Update</a>
                            <a href="#" class="btn btn-danger delete-btn" onclick="showDeleteConfirmation(<%= uid %>)">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("message", "Error: " + e.getMessage());
                        out.println("<script>Swal.fire('Error', 'Error retrieving data: " + e.getMessage() + "', 'error');</script>");

                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (st != null) st.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>

   <%
if ("POST".equals(request.getMethod()) && request.getParameter("username") != null && request.getParameter("phone") != null && request.getParameter("uid") == null) {
    String username = request.getParameter("username");
    String phone = request.getParameter("phone");

    Connection connInsert = null;
    PreparedStatement ps = null;

    try {
        String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
        String user = "root";
        String pass = "trickortreat";
        Class.forName("com.mysql.cj.jdbc.Driver");
        connInsert = DriverManager.getConnection(url, user, pass);
        String sql = "INSERT INTO USER (USERNAME, PHONE) VALUES (?, ?)";
        ps = connInsert.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, phone);

        int rowsInserted = ps.executeUpdate();
        if (rowsInserted > 0) {
            // Use a script to show success message and reload the page.
            out.println("<script>Swal.fire('Success', 'User added successfully!', 'success').then(() => { window.location.href = 'manage-users.jsp'; });</script>");
            return;

        } else {
            request.setAttribute("message", "Error: Failed to add user.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "Error: " + e.getMessage());
    } finally {
        try {
            if (ps != null) ps.close();
            if (connInsert != null) connInsert.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

// Handle Update User (POST)
if ("POST".equals(request.getMethod()) && request.getParameter("username") != null && request.getParameter("phone") != null && request.getParameter("uid") != null) {
    int userId = Integer.parseInt(request.getParameter("uid"));
    String username = request.getParameter("username");
    String phone = request.getParameter("phone");

    Connection connUpdate = null;
    PreparedStatement psUpdate = null;

    try {
        String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
        String user = "root";
        String pass = "trickortreat";
        Class.forName("com.mysql.cj.jdbc.Driver");
        connUpdate = DriverManager.getConnection(url, user, pass);
        String sql = "UPDATE USER SET USERNAME = ?, PHONE = ? WHERE UID = ?";
        psUpdate = connUpdate.prepareStatement(sql);
        psUpdate.setString(1, username);
        psUpdate.setString(2, phone);
        psUpdate.setInt(3, userId);

        int rowsUpdated = psUpdate.executeUpdate();
        if (rowsUpdated > 0) {
             // Use a script to show success message and reload the page.
            out.println("<script>Swal.fire('Success', 'User updated successfully!', 'success').then(() => { window.location.href = 'manage-users.jsp'; });</script>");
            return;
        } else {
            request.setAttribute("message", "Error: Failed to update user.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "Error: " + e.getMessage());
    } finally {
        try {
            if (psUpdate != null) psUpdate.close();
            if (connUpdate != null) connUpdate.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
    // Handle Delete User (GET)
    if ("GET".equals(request.getMethod()) && "delete".equals(request.getParameter("action")) && request.getParameter("uid") != null) {
        int userId = Integer.parseInt(request.getParameter("uid"));
        Connection connDelete = null;
        PreparedStatement psDelete = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connDelete = DriverManager.getConnection(url, user, pass);
            String sql = "DELETE FROM USER WHERE UID = ?";
            psDelete = connDelete.prepareStatement(sql);
            psDelete.setInt(1, userId);
            int rowsDeleted = psDelete.executeUpdate();
            if (rowsDeleted > 0) {
                // Use a script to show success message and reload the page.
                out.println("<script>Swal.fire('Success', 'User deleted successfully!', 'success').then(() => { window.location.href = 'manage-users.jsp'; });</script>");
                return;
            } else {
                request.setAttribute("message", "Error: Failed to delete user.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
        } finally {
            try {
                if (psDelete != null) psDelete.close();
                if (connDelete != null) connDelete.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Handle Update User (GET)
    if ("GET".equals(request.getMethod()) && "update".equals(request.getParameter("action")) && request.getParameter("uid") != null) {
        int userId = Integer.parseInt(request.getParameter("uid"));
        Connection connUpdate = null;
        PreparedStatement psUpdate = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connUpdate = DriverManager.getConnection(url, user, pass);
            String sql = "SELECT USERNAME, PHONE FROM USER WHERE UID = ?";
            psUpdate = connUpdate.prepareStatement(sql);
            psUpdate.setInt(1, userId);
            ResultSet rsUpdate = psUpdate.executeQuery();
            if (rsUpdate.next()) {
                String username = rsUpdate.getString("USERNAME");
                String phone = rsUpdate.getString("PHONE");
    %>
                <form action="manage-users.jsp" method="POST">
                    <h5>Update User</h5>
                    <input type="hidden" name="uid" value="<%= userId %>">
                    <input type="text" name="username" value="<%= username %>" class="form-control mb-2" required>
                    <input type="text" name="phone" value="<%= phone %>" class="form-control mb-2" required>
                    <button type="submit" class="btn btn-warning add-btn">Update User</button>
                </form>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
        } finally {
            try {
                if (psUpdate != null) psUpdate.close();
                if (connUpdate != null) connUpdate.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    %>
</div>

<footer>
    <p>&copy; 2025 Financial Portfolio Manager</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function showDeleteConfirmation(userId) {
    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {
            // Use window.location.href for redirection after confirmation
            window.location.href = "manage-users.jsp?uid=" + userId + "&action=delete";
        }
    });
}
</script>
</body>
</html>
