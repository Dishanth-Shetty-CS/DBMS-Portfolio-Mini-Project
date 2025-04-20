<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Reports - Financial Portfolio Manager</title>
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
        .error-message {
            color: red;
            font-size: 0.8rem;
        }

    </style>
</head>
<body>

<div class="header">
    <h2>Manage Reports</h2>
</div>

<div class="container mt-4">
    <h4 class="section-title">Report List</h4>

    <form action="manage-reports.jsp" method="POST" class="mb-4">
        <h5>Add New Report</h5>
        <input type="number" name="ltp" id="ltp" placeholder="LTP" class="form-control mb-2"  required>
        <div  class="error-message">
            <% if (request.getAttribute("ltpError") != null) { %>
                <%= request.getAttribute("ltpError") %>
            <% } %>
        </div>
        <input type="number" name="eps" id="eps" placeholder="EPS" class="form-control mb-2"   required>
         <div  class="error-message">
            <% if (request.getAttribute("epsError") != null) { %>
                <%= request.getAttribute("epsError") %>
            <% } %>
        </div>
        <input type="number" name="roe" id="roe" placeholder="ROE" class="form-control mb-2"   required>
        <div  class="error-message">
            <% if (request.getAttribute("roeError") != null) { %>
                <%= request.getAttribute("roeError") %>
            <% } %>
        </div>
        <input type="number" name="cid" id="cid" placeholder="Company ID" class="form-control mb-2" required>
        <div  class="error-message">
            <% if (request.getAttribute("cidError") != null) { %>
                <%= request.getAttribute("cidError") %>
            <% } %>
        </div>
        <button type="submit" class="btn btn-success add-btn">Add Report</button>
    </form>

    <%
    String message = (String) request.getAttribute("message");
    if (message != null && !message.isEmpty()) {
        if (message.startsWith("Success")) {
            String sweetAlertMessage = message.substring(8);
            out.println("<script>Swal.fire('Success', '" + sweetAlertMessage + "', 'success').then(function() {");
            out.println("  window.location.href = 'manage-reports.jsp';");
            out.println("});</script>");
        } else if (message.startsWith("Error")) {
            String sweetAlertMessage = message.substring(6);
            out.println("<script>Swal.fire('Error', '" + sweetAlertMessage + "', 'error');</script>");
        }
    }
    %>

    <div class="table-container">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Report ID</th>
                        <th>LTP</th>
                        <th>EPS</th>
                        <th>ROE</th>
                        <th>Company ID</th>
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
                        String sql = "SELECT REPORT_ID, LTP, EPS, ROE, CID FROM REPORT";
                        rs = st.executeQuery(sql);

                        if (!rs.isBeforeFirst()) {
                            out.println("<tr><td colspan='6' class='no-data-message'>No reports found.</td></tr>");
                        } else {
                            while (rs.next()) {
                                int reportId = rs.getInt("REPORT_ID");
                                double ltp = rs.getDouble("LTP");
                                double eps = rs.getDouble("EPS");
                                double roe = rs.getDouble("ROE");
                                int cid = rs.getInt("CID");
                    %>
                    <tr>
                        <td><%= reportId %></td>
                        <td><%= ltp %></td>
                        <td><%= eps %></td>
                        <td><%= roe %></td>
                        <td><%= cid %></td>
                        <td>
                            <a href="manage-reports.jsp?reportId=<%= reportId %>&action=update" class="btn btn-warning update-btn">Update</a>
                            <a href="#" class="btn btn-danger delete-btn" onclick="showDeleteConfirmation(<%= reportId %>)">Delete</a>
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
if ("POST".equals(request.getMethod())) {
    String ltpStr = request.getParameter("ltp");
    String epsStr = request.getParameter("eps");
    String roeStr = request.getParameter("roe");
    String cidStr = request.getParameter("cid");
    boolean hasErrors = false;

    // Reset error attributes
    request.setAttribute("ltpError", null);
    request.setAttribute("epsError", null);
    request.setAttribute("roeError", null);
    request.setAttribute("cidError", null);

     if (ltpStr == null || ltpStr.trim().isEmpty() || !ltpStr.matches("\\d{0,10}(\\.\\d{0,2})?")) {
        request.setAttribute("ltpError", "Please enter a valid LTP (max 10 digits before and 2 after decimal).");
        hasErrors = true;
    }

    if (epsStr == null || epsStr.trim().isEmpty() || !epsStr.matches("\\d{0,10}(\\.\\d{0,2})?")) {
        request.setAttribute("epsError", "Please enter a valid EPS (max 10 digits before and 2 after decimal).");
        hasErrors = true;
    }

    if (roeStr == null || roeStr.trim().isEmpty() || !roeStr.matches("\\d{0,10}(\\.\\d{0,2})?")) {
        request.setAttribute("roeError", "Please enter a valid ROE (max 10 digits before and 2 after decimal).");
        hasErrors = true;
    }


    if (cidStr == null || cidStr.trim().isEmpty()) {
        request.setAttribute("cidError", "Please enter the Company ID.");
        hasErrors = true;
    }else{
        try{
             Integer.parseInt(cidStr);
        }catch(NumberFormatException e){
             request.setAttribute("cidError", "Please enter a valid Company ID (number).");
             hasErrors = true;
        }
    }

    if (hasErrors) {
        // Forward back to the form with error messages
        request.getRequestDispatcher("manage-reports.jsp").forward(request, response);
        return;
    }


    //try catch block for parsing
    try{
        double ltp = Double.parseDouble(ltpStr);
        double eps = Double.parseDouble(epsStr);
        double roe = Double.parseDouble(roeStr);
        int cid = Integer.parseInt(cidStr);
        Connection connInsert = null;
        PreparedStatement ps = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connInsert = DriverManager.getConnection(url, user, pass);
            String sql;
             if (request.getParameter("reportId") == null || request.getParameter("reportId").isEmpty()) {
                sql = "INSERT INTO REPORT (LTP, EPS, ROE, CID) VALUES (?, ?, ?, ?)";
                ps = connInsert.prepareStatement(sql);
                ps.setDouble(1, ltp);
                ps.setDouble(2, eps);
                ps.setDouble(3, roe);
                ps.setInt(4, cid);
             }else{
                int reportId = Integer.parseInt(request.getParameter("reportId"));
                sql = "UPDATE REPORT SET LTP = ?, EPS = ?, ROE = ?, CID = ? WHERE REPORT_ID = ?";
                ps = connInsert.prepareStatement(sql);
                ps.setDouble(1, ltp);
                ps.setDouble(2, eps);
                ps.setDouble(3, roe);
                ps.setInt(4, cid);
                ps.setInt(5, reportId);
             }



            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                String messageType = (request.getParameter("reportId") == null || request.getParameter("reportId").isEmpty()) ? "Added" : "Updated";
                out.println("<script>Swal.fire('Success', 'Report " + messageType + " successfully!', 'success').then(() => { window.location.href = 'manage-reports.jsp'; });</script>");
                return;
            } else {
                String messageType = (request.getParameter("reportId") == null || request.getParameter("reportId").isEmpty()) ? "add" : "update";
                request.setAttribute("message", "Error: Failed to " + messageType + " report.");
                out.println("<script>Swal.fire('Error', 'Failed to " + messageType + " report!', 'error');</script>");
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
        request.setAttribute("message", "Error: Invalid input format. Please enter a valid number.");
        out.println("<script>Swal.fire('Error', 'Invalid input format. Please enter a valid number.', 'error');</script>");
    }
}

// Handle Delete report (GET)
if ("GET".equals(request.getMethod()) && "delete".equals(request.getParameter("action")) && request.getParameter("reportId") != null) {
    int reportId = Integer.parseInt(request.getParameter("reportId"));
    Connection connDelete = null;
    PreparedStatement psDelete = null;

    try {
        String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
        String user = "root";
        String pass = "trickortreat";
        Class.forName("com.mysql.cj.jdbc.Driver");
        connDelete = DriverManager.getConnection(url, user, pass);
        String sql = "DELETE FROM REPORT WHERE REPORT_ID = ?";
        psDelete = connDelete.prepareStatement(sql);
        psDelete.setInt(1, reportId);
        int rowsDeleted = psDelete.executeUpdate();
        if (rowsDeleted > 0) {
            out.println("<script>Swal.fire('Success', 'Report deleted successfully!', 'success').then(() => { window.location.href = 'manage-reports.jsp'; });</script>");
            return;
        } else {
            request.setAttribute("message", "Error: Failed to delete report.");
            out.println("<script>Swal.fire('Error', 'Failed to delete report.', 'error');</script>");
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

    // Handle Update report (GET)
    if ("GET".equals(request.getMethod()) && "update".equals(request.getParameter("action")) && request.getParameter("reportId") != null) {
        int reportId = Integer.parseInt(request.getParameter("reportId"));
        Connection connUpdate = null;
        PreparedStatement psUpdate = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connUpdate = DriverManager.getConnection(url, user, pass);
            String sql = "SELECT LTP, EPS, ROE, CID FROM REPORT WHERE REPORT_ID = ?";
            psUpdate = connUpdate.prepareStatement(sql);
            psUpdate.setInt(1, reportId);
            ResultSet rsUpdate = psUpdate.executeQuery();
            if (rsUpdate.next()) {
                double ltp = rsUpdate.getDouble("LTP");
                double eps = rsUpdate.getDouble("EPS");
                double roe = rsUpdate.getDouble("ROE");
                int cid = rsUpdate.getInt("CID");
    %>
                <form action="manage-reports.jsp" method="POST" >
                    <h5>Update Report</h5>
                    <input type="hidden" name="reportId" value="<%= reportId %>">
                    <input type="number" name="ltp" id="ltp" value="<%= ltp %>" class="form-control mb-2"   required>
                     <div  class="error-message">
                        <% if (request.getAttribute("ltpError") != null) { %>
                            <%= request.getAttribute("ltpError") %>
                        <% } %>
                    </div>
                    <input type="number" name="eps" id="eps" value="<%= eps %>" class="form-control mb-2"   required>
                    <div  class="error-message">
                        <% if (request.getAttribute("epsError") != null) { %>
                            <%= request.getAttribute("epsError") %>
                        <% } %>
                    </div>
                    <input type="number" name="roe" id="roe" value="<%= roe %>" class="form-control mb-2"   required>
                    <div  class="error-message">
                        <% if (request.getAttribute("roeError") != null) { %>
                            <%= request.getAttribute("roeError") %>
                        <% } %>
                    </div>
                    <input type="number" name="cid" id="cid" value="<%= cid %>" class="form-control mb-2" required>
                    <div  class="error-message">
                        <% if (request.getAttribute("cidError") != null) { %>
                            <%= request.getAttribute("cidError") %>
                        <% } %>
                    </div>
                    <button type="submit" class="btn btn-warning add-btn">Update Report</button>
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
function showDeleteConfirmation(reportId) {
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
            window.location.href = "manage-reports.jsp?reportId=" + reportId + "&action=delete";
        }
    });
}
</script>
</body>
</html>
