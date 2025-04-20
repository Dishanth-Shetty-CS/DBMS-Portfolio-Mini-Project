<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Companies - Financial Portfolio Manager</title>
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
    <h2>Manage Companies</h2>
</div>

<div class="container mt-4">
    <h4 class="section-title">Company List</h4>

    <form action="manage-companies.jsp" method="POST" class="mb-4">
        <h5>Add New Company</h5>
        <input type="text" name="companyName" placeholder="Company Name" class="form-control mb-2" required>
        <input type="number" name="capital" placeholder="Capital" class="form-control mb-2" required>
        <input type="text" name="sector" placeholder="Sector" class="form-control mb-2" required>
        <button type="submit" class="btn btn-success add-btn">Add Company</button>
    </form>

    <script>
        <%
        String message = (String) request.getAttribute("message");
        if (message != null && !message.isEmpty()) {
            if (message.startsWith("Success")) {
                String sweetAlertMessage = message.substring(8);
                out.println("Swal.fire('Success', '" + sweetAlertMessage + "', 'success').then(function() {");
                out.println("  window.location.href = 'manage-companies.jsp';");
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
                        <th>Company ID</th>
                        <th>Company Name</th>
                        <th>Capital</th>
                        <th>Sector</th>
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
                        String sql = "SELECT CID, CNAME, CAPITAL, SECTOR FROM COMPANY";
                        rs = st.executeQuery(sql);

                        if (!rs.isBeforeFirst()) {
                            out.println("<tr><td colspan='5' class='no-data-message'>No companies found.</td></tr>");
                        } else {
                            while (rs.next()) {
                                int cid = rs.getInt("CID");
                                String cname = rs.getString("CNAME");
                                double capital = rs.getDouble("CAPITAL");
                                String sector = rs.getString("SECTOR");
                    %>
                    <tr>
                        <td><%= cid %></td>
                        <td><%= cname %></td>
                        <td><%= capital %></td>
                        <td><%= sector %></td>
                        <td>
                            <a href="manage-companies.jsp?cid=<%= cid %>&action=update" class="btn btn-warning update-btn">Update</a>
                            <a href="#" class="btn btn-danger delete-btn" onclick="showDeleteConfirmation(<%= cid %>)">Delete</a>
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
if ("POST".equals(request.getMethod()) && request.getParameter("companyName") != null && request.getParameter("capital") != null && request.getParameter("sector") != null && request.getParameter("cid") == null) {
    String companyName = request.getParameter("companyName");
    String capitalStr = request.getParameter("capital");
    String sector = request.getParameter("sector");

    //try catch block for parsing
    try{
      double capital = Double.parseDouble(capitalStr);

      Connection connInsert = null;
      PreparedStatement ps = null;

      try {
          String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
          String user = "root";
          String pass = "trickortreat";
          Class.forName("com.mysql.cj.jdbc.Driver");
          connInsert = DriverManager.getConnection(url, user, pass);
          String sql = "INSERT INTO COMPANY (CNAME, CAPITAL, SECTOR) VALUES (?, ?, ?)";
          ps = connInsert.prepareStatement(sql);
          ps.setString(1, companyName);
          ps.setDouble(2, capital);
          ps.setString(3, sector);

          int rowsInserted = ps.executeUpdate();
          if (rowsInserted > 0) {
              out.println("<script>Swal.fire('Success', 'Company added successfully!', 'success').then(() => { window.location.href = 'manage-companies.jsp'; });</script>");
              return;
          } else {
              request.setAttribute("message", "Error: Failed to add company.");
              out.println("<script>Swal.fire('Error', 'Failed to add company!', 'error');</script>");
          }
      } catch (Exception e) {
          e.printStackTrace();
          request.setAttribute("message", "Error: " + e.getMessage());
           out.println("<script>Swal.fire('Error', 'Error: " + e.getMessage() + "', 'error');</script>");
      } finally {
          try {
              if (ps != null) ps.close();
              if (connInsert != null) connInsert.close();
          } catch (SQLException e) {
              e.printStackTrace();
          }
      }
    }catch(NumberFormatException e){
        e.printStackTrace();
        request.setAttribute("message", "Error: Invalid capital format. Please enter a valid number.");
        out.println("<script>Swal.fire('Error', 'Invalid capital format. Please enter a valid number.', 'error');</script>");
    }
}

// Handle Update Company (POST)
if ("POST".equals(request.getMethod()) && request.getParameter("companyName") != null && request.getParameter("capital") != null && request.getParameter("sector") != null && request.getParameter("cid") != null) {
    int companyId = Integer.parseInt(request.getParameter("cid"));
    String companyName = request.getParameter("companyName");
    String capitalStr = request.getParameter("capital");
    String sector = request.getParameter("sector");
    try{
        double capital = Double.parseDouble(capitalStr);
        Connection connUpdate = null;
        PreparedStatement psUpdate = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connUpdate = DriverManager.getConnection(url, user, pass);
            String sql = "UPDATE COMPANY SET CNAME = ?, CAPITAL = ?, SECTOR = ? WHERE CID = ?";
            psUpdate = connUpdate.prepareStatement(sql);
            psUpdate.setString(1, companyName);
            psUpdate.setDouble(2, capital);
            psUpdate.setString(3, sector);
            psUpdate.setInt(4, companyId);

            int rowsUpdated = psUpdate.executeUpdate();
            if (rowsUpdated > 0) {
                out.println("<script>Swal.fire('Success', 'Company updated successfully!', 'success').then(() => { window.location.href = 'manage-companies.jsp'; });</script>");
                return;
            } else {
                request.setAttribute("message", "Error: Failed to update company.");
                out.println("<script>Swal.fire('Error', 'Failed to update company.', 'error');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            out.println("<script>Swal.fire('Error', 'Error: " + e.getMessage() + "', 'error');</script>");
        } finally {
            try {
                if (psUpdate != null) psUpdate.close();
                if (connUpdate != null) connUpdate.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }catch(NumberFormatException e){
        e.printStackTrace();
        request.setAttribute("message", "Error: Invalid capital format. Please enter a valid number.");
        out.println("<script>Swal.fire('Error', 'Invalid capital format. Please enter a valid number.', 'error');</script>");
    }
}
    // Handle Delete Company (GET)
    if ("GET".equals(request.getMethod()) && "delete".equals(request.getParameter("action")) && request.getParameter("cid") != null) {
        int companyId = Integer.parseInt(request.getParameter("cid"));
        Connection connDelete = null;
        PreparedStatement psDelete = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connDelete = DriverManager.getConnection(url, user, pass);
            String sql = "DELETE FROM COMPANY WHERE CID = ?";
            psDelete = connDelete.prepareStatement(sql);
            psDelete.setInt(1, companyId);
            int rowsDeleted = psDelete.executeUpdate();
            if (rowsDeleted > 0) {
                out.println("<script>Swal.fire('Success', 'Company deleted successfully!', 'success').then(() => { window.location.href = 'manage-companies.jsp'; });</script>");
                return;
            } else {
                request.setAttribute("message", "Error: Failed to delete company.");
                out.println("<script>Swal.fire('Error', 'Failed to delete company.', 'error');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            out.println("<script>Swal.fire('Error', 'Error: " + e.getMessage() + "', 'error');</script>");
        } finally {
            try {
                if (psDelete != null) psDelete.close();
                if (connDelete != null) connDelete.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Handle Update Company (GET)
    if ("GET".equals(request.getMethod()) && "update".equals(request.getParameter("action")) && request.getParameter("cid") != null) {
        int companyId = Integer.parseInt(request.getParameter("cid"));
        Connection connUpdate = null;
        PreparedStatement psUpdate = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connUpdate = DriverManager.getConnection(url, user, pass);
            String sql = "SELECT CNAME, CAPITAL, SECTOR FROM COMPANY WHERE CID = ?";
            psUpdate = connUpdate.prepareStatement(sql);
            psUpdate.setInt(1, companyId);
            ResultSet rsUpdate = psUpdate.executeQuery();
            if (rsUpdate.next()) {
                String companyName = rsUpdate.getString("CNAME");
                double capital = rsUpdate.getDouble("CAPITAL");
                String sector = rsUpdate.getString("SECTOR");
    %>
                <form action="manage-companies.jsp" method="POST">
                    <h5>Update Company</h5>
                    <input type="hidden" name="cid" value="<%= companyId %>">
                    <input type="text" name="companyName" value="<%= companyName %>" class="form-control mb-2" required>
                    <input type="number" name="capital" value="<%= capital %>" class="form-control mb-2" required>
                    <input type="text" name="sector" value="<%= sector %>" class="form-control mb-2" required>
                    <button type="submit" class="btn btn-warning add-btn">Update Company</button>
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
function showDeleteConfirmation(companyId) {
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
            window.location.href = "manage-companies.jsp?cid=" + companyId + "&action=delete";
        }
    });
}
</script>
</body>
</html>
