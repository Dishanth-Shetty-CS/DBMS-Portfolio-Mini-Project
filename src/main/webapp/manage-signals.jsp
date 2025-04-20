<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Technical Signals - Financial Portfolio Manager</title>
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
    <h2>Manage Technical Signals</h2>
</div>

<div class="container mt-4">
    <h4 class="section-title">Technical Signal List</h4>

    <form action="manage-signals.jsp" method="POST" class="mb-4">
        <h5>Add New Signal</h5>
        <input type="number" name="adx" id="adx" placeholder="ADX" class="form-control mb-2"  required>
        <div  class="error-message">
            <% if (request.getAttribute("adxError") != null) { %>
                <%= request.getAttribute("adxError") %>
            <% } %>
        </div>
        <input type="number" name="volume" id="volume" placeholder="Volume" class="form-control mb-2"   required>
         <div  class="error-message">
            <% if (request.getAttribute("volumeError") != null) { %>
                <%= request.getAttribute("volumeError") %>
            <% } %>
        </div>
        <input type="number" name="macd" id="macd" placeholder="MACD" class="form-control mb-2"   required>
        <div  class="error-message">
            <% if (request.getAttribute("macdError") != null) { %>
                <%= request.getAttribute("macdError") %>
            <% } %>
        </div>
        <input type="number" name="cid" id="cid" placeholder="Company ID" class="form-control mb-2" required>
        <div  class="error-message">
            <% if (request.getAttribute("cidError") != null) { %>
                <%= request.getAttribute("cidError") %>
            <% } %>
        </div>
        <button type="submit" class="btn btn-success add-btn">Add Signal</button>
    </form>

    <%
    String message = (String) request.getAttribute("message");
    if (message != null && !message.isEmpty()) {
        if (message.startsWith("Success")) {
            String sweetAlertMessage = message.substring(8);
            out.println("<script>Swal.fire('Success', '" + sweetAlertMessage + "', 'success').then(function() {");
            out.println("  window.location.href = 'manage-signals.jsp';");
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
                        <th>Stock ID</th>
                        <th>ADX</th>
                        <th>Volume</th>
                        <th>MACD</th>
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
                        String sql = "SELECT STOCK_ID, ADX, VOLUME, MACD, CID FROM TECHNICAL_SIGNALS";
                        rs = st.executeQuery(sql);

                        if (!rs.isBeforeFirst()) {
                            out.println("<tr><td colspan='6' class='no-data-message'>No technical signals found.</td></tr>");
                        } else {
                            while (rs.next()) {
                                int stockId = rs.getInt("STOCK_ID");
                                double adx = rs.getDouble("ADX");
                                int volume = rs.getInt("VOLUME");
                                double macd = rs.getDouble("MACD");
                                int cid = rs.getInt("CID");
                    %>
                    <tr>
                        <td><%= stockId %></td>
                        <td><%= adx %></td>
                        <td><%= volume %></td>
                        <td><%= macd %></td>
                        <td><%= cid %></td>
                        <td>
                            <a href="manage-signals.jsp?stockId=<%= stockId %>&action=update" class="btn btn-warning update-btn">Update</a>
                            <a href="#" class="btn btn-danger delete-btn" onclick="showDeleteConfirmation(<%= stockId %>)">Delete</a>
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
    String adxStr = request.getParameter("adx");
    String volumeStr = request.getParameter("volume");
    String macdStr = request.getParameter("macd");
    String cidStr = request.getParameter("cid");
    boolean hasErrors = false;

    // Reset error attributes
    request.setAttribute("adxError", null);
    request.setAttribute("volumeError", null);
    request.setAttribute("macdError", null);
    request.setAttribute("cidError", null);

     if (adxStr == null || adxStr.trim().isEmpty() || !adxStr.matches("\\d{0,10}(\\.\\d{0,2})?")) {
        request.setAttribute("adxError", "Please enter a valid ADX (max 10 digits before and 2 after decimal).");
        hasErrors = true;
    }

    if (volumeStr == null || volumeStr.trim().isEmpty() || !volumeStr.matches("\\d+")) {
        request.setAttribute("volumeError", "Please enter a valid Volume (must be an integer).");
        hasErrors = true;
    }

    if (macdStr == null || macdStr.trim().isEmpty() || !macdStr.matches("\\d{0,10}(\\.\\d{0,2})?")) {
        request.setAttribute("macdError", "Please enter a valid MACD (max 10 digits before and 2 after decimal).");
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
        request.getRequestDispatcher("manage-signals.jsp").forward(request, response);
        return;
    }


    //try catch block for parsing
    try{
        double adx = Double.parseDouble(adxStr);
        int volume = Integer.parseInt(volumeStr);
        double macd = Double.parseDouble(macdStr);
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
             if (request.getParameter("stockId") == null || request.getParameter("stockId").isEmpty()) {
                sql = "INSERT INTO TECHNICAL_SIGNALS (ADX, VOLUME, MACD, CID) VALUES (?, ?, ?, ?)";
                ps = connInsert.prepareStatement(sql);
                ps.setDouble(1, adx);
                ps.setInt(2, volume);
                ps.setDouble(3, macd);
                ps.setInt(4, cid);
             }else{
                int stockId = Integer.parseInt(request.getParameter("stockId"));
                sql = "UPDATE TECHNICAL_SIGNALS SET ADX = ?, VOLUME = ?, MACD = ?, CID = ? WHERE STOCK_ID = ?";
                ps = connInsert.prepareStatement(sql);
                ps.setDouble(1, adx);
                ps.setInt(2, volume);
                ps.setDouble(3, macd);
                ps.setInt(4, cid);
                ps.setInt(5, stockId);
             }



            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                String messageType = (request.getParameter("stockId") == null || request.getParameter("stockId").isEmpty()) ? "Added" : "Updated";
                out.println("<script>Swal.fire('Success', 'Technical Signal " + messageType + " successfully!', 'success').then(() => { window.location.href = 'manage-signals.jsp'; });</script>");
                return;
            } else {
                String messageType = (request.getParameter("stockId") == null || request.getParameter("stockId").isEmpty()) ? "add" : "update";
                request.setAttribute("message", "Error: Failed to " + messageType + " technical signal.");
                out.println("<script>Swal.fire('Error', 'Failed to " + messageType + " technical signal!', 'error');</script>");
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
if ("GET".equals(request.getMethod()) && "delete".equals(request.getParameter("action")) && request.getParameter("stockId") != null) {
    int stockId = Integer.parseInt(request.getParameter("stockId"));
    Connection connDelete = null;
    PreparedStatement psDelete = null;

    try {
        String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
        String user = "root";
        String pass = "trickortreat";
        Class.forName("com.mysql.cj.jdbc.Driver");
        connDelete = DriverManager.getConnection(url, user, pass);
        String sql = "DELETE FROM TECHNICAL_SIGNALS WHERE STOCK_ID = ?";
        psDelete = connDelete.prepareStatement(sql);
        psDelete.setInt(1, stockId);
        int rowsDeleted = psDelete.executeUpdate();
        if (rowsDeleted > 0) {
            out.println("<script>Swal.fire('Success', 'Technical Signal deleted successfully!', 'success').then(() => { window.location.href = 'manage-signals.jsp'; });</script>");
            return;
        } else {
            request.setAttribute("message", "Error: Failed to delete Technical Signal.");
            out.println("<script>Swal.fire('Error', 'Failed to delete Technical Signal.', 'error');</script>");
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
    if ("GET".equals(request.getMethod()) && "update".equals(request.getParameter("action")) && request.getParameter("stockId") != null) {
        int stockId = Integer.parseInt(request.getParameter("stockId"));
        Connection connUpdate = null;
        PreparedStatement psUpdate = null;

        try {
            String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
            String user = "root";
            String pass = "trickortreat";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connUpdate = DriverManager.getConnection(url, user, pass);
            String sql = "SELECT ADX, VOLUME, MACD, CID FROM TECHNICAL_SIGNALS WHERE STOCK_ID = ?";
            psUpdate = connUpdate.prepareStatement(sql);
            psUpdate.setInt(1, stockId);
            ResultSet rsUpdate = psUpdate.executeQuery();
            if (rsUpdate.next()) {
                double adx = rsUpdate.getDouble("ADX");
                int volume = rsUpdate.getInt("VOLUME");
                double macd = rsUpdate.getDouble("MACD");
                int cid = rsUpdate.getInt("CID");
    %>
                <form action="manage-signals.jsp" method="POST" >
                    <h5>Update Technical Signal</h5>
                    <input type="hidden" name="stockId" value="<%= stockId %>">
                    <input type="number" name="adx" id="adx" value="<%= adx %>" class="form-control mb-2"   required>
                     <div  class="error-message">
                        <% if (request.getAttribute("adxError") != null) { %>
                            <%= request.getAttribute("adxError") %>
                        <% } %>
                    </div>
                    <input type="number" name="volume" id="volume" value="<%= volume %>" class="form-control mb-2"   required>
                    <div  class="error-message">
                        <% if (request.getAttribute("volumeError") != null) { %>
                            <%= request.getAttribute("volumeError") %>
                        <% } %>
                    </div>
                    <input type="number" name="macd" id="macd" value="<%= macd %>" class="form-control mb-2"   required>
                    <div  class="error-message">
                        <% if (request.getAttribute("macdError") != null) { %>
                            <%= request.getAttribute("macdError") %>
                        <% } %>
                    </div>
                    <input type="number" name="cid" id="cid" value="<%= cid %>" class="form-control mb-2" required>
                    <div  class="error-message">
                        <% if (request.getAttribute("cidError") != null) { %>
                            <%= request.getAttribute("cidError") %>
                        <% } %>
                    </div>
                    <button type="submit" class="btn btn-warning add-btn">Update Signal</button>
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
function showDeleteConfirmation(stockId) {
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
            window.location.href = "manage-signals.jsp?stockId=" + stockId + "&action=delete";
        }
    });
}
</script>
</body>
</html>
