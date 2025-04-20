<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Transactions - Financial Portfolio Manager</title>
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
        <h2>Manage Transactions</h2>
    </div>

    <div class="container mt-4">
        <h4 class="section-title">Transaction List</h4>

        <form action="manage-transactions.jsp" method="POST" class="mb-4">
            <h5>Add New Transaction</h5>
            <input type="number" name="uid" id="uid" placeholder="User ID" class="form-control mb-2" required>
             <div  class="error-message">
                <% if (request.getAttribute("uidError") != null) { %>
                    <%= request.getAttribute("uidError") %>
                <% } %>
            </div>
            <input type="number" name="cid" id="cid" placeholder="Company ID" class="form-control mb-2" required>
             <div  class="error-message">
                <% if (request.getAttribute("cidError") != null) { %>
                    <%= request.getAttribute("cidError") %>
                <% } %>
            </div>
            <input type="number" name="rate" id="rate" placeholder="Rate" class="form-control mb-2" required>
             <div  class="error-message">
                <% if (request.getAttribute("rateError") != null) { %>
                    <%= request.getAttribute("rateError") %>
                <% } %>
            </div>
            <input type="number" name="quantity" id="quantity" placeholder="Quantity" class="form-control mb-2" required>
             <div  class="error-message">
                <% if (request.getAttribute("quantityError") != null) { %>
                    <%= request.getAttribute("quantityError") %>
                <% } %>
            </div>
            <select name="buy_sell" id="buy_sell" class="form-select mb-2" required>
                <option value="">Select Buy/Sell</option>
                <option value="BUY">BUY</option>
                <option value="SELL">SELL</option>
            </select>
             <div  class="error-message">
                <% if (request.getAttribute("buy_sellError") != null) { %>
                    <%= request.getAttribute("buy_sellError") %>
                <% } %>
            </div>
            <button type="submit" class="btn btn-success add-btn">Add Transaction</button>
        </form>

        <%
        String message = (String) request.getAttribute("message");
        if (message != null && !message.isEmpty()) {
            if (message.startsWith("Success")) {
                String sweetAlertMessage = message.substring(8);
                out.println("<script>Swal.fire('Success', '" + sweetAlertMessage + "', 'success').then(function() {");
                out.println("  window.location.href = 'manage-transactions.jsp';");
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
                            <th>Transaction ID</th>
                            <th>User ID</th>
                            <th>Company ID</th>
                            <th>Rate</th>
                            <th>Quantity</th>
                            <th>Buy/Sell</th>
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
                            String sql = "SELECT TID, UID, CID, RATE, QUANTITY, BUY_SELL FROM TRANSACTION";
                            rs = st.executeQuery(sql);

                            if (!rs.isBeforeFirst()) {
                                out.println("<tr><td colspan='7' class='no-data-message'>No transactions found.</td></tr>");
                            } else {
                                while (rs.next()) {
                                    int tid = rs.getInt("TID");
                                    int uid = rs.getInt("UID");
                                    int cid = rs.getInt("CID");
                                    double rate = rs.getDouble("RATE");
                                    int quantity = rs.getInt("QUANTITY");
                                    String buySell = rs.getString("BUY_SELL");
                        %>
                        <tr>
                            <td><%= tid %></td>
                            <td><%= uid %></td>
                            <td><%= cid %></td>
                            <td><%= rate %></td>
                            <td><%= quantity %></td>
                            <td><%= buySell %></td>
                            <td>
                                <a href="manage-transactions.jsp?tid=<%= tid %>&action=update" class="btn btn-warning update-btn">Update</a>
                                <a href="#" class="btn btn-danger delete-btn" onclick="showDeleteConfirmation(<%= tid %>)">Delete</a>
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
            String uidStr = request.getParameter("uid");
            String cidStr = request.getParameter("cid");
            String rateStr = request.getParameter("rate");
            String quantityStr = request.getParameter("quantity");
            String buySell = request.getParameter("buy_sell");
            boolean hasErrors = false;

            // Reset error attributes
            request.setAttribute("uidError", null);
            request.setAttribute("cidError", null);
            request.setAttribute("rateError", null);
            request.setAttribute("quantityError", null);
            request.setAttribute("buy_sellError", null);

            if (uidStr == null || uidStr.trim().isEmpty()) {
                request.setAttribute("uidError", "Please enter User ID.");
                hasErrors = true;
            }else{
                 try{
                    Integer.parseInt(uidStr);
                }catch(NumberFormatException e){
                     request.setAttribute("uidError", "Please enter a valid User ID (number).");
                      hasErrors = true;
                }
            }
            if (cidStr == null || cidStr.trim().isEmpty()) {
                request.setAttribute("cidError", "Please enter Company ID.");
                hasErrors = true;
            }else{
                 try{
                    Integer.parseInt(cidStr);
                }catch(NumberFormatException e){
                     request.setAttribute("cidError", "Please enter a valid Company ID (number).");
                      hasErrors = true;
                }
            }

            if (rateStr == null || rateStr.trim().isEmpty() || !rateStr.matches("\\d{0,10}(\\.\\d{0,2})?")) {
                request.setAttribute("rateError", "Please enter a valid Rate (max 10 digits before and 2 after decimal).");
                hasErrors = true;
            }

            if (quantityStr == null || quantityStr.trim().isEmpty() || !quantityStr.matches("\\d+")) {
                request.setAttribute("quantityError", "Please enter a valid Quantity (must be an integer).");
                hasErrors = true;
            }

            if (buySell == null || buySell.trim().isEmpty() || (!"BUY".equals(buySell) && !"SELL".equals(buySell))) {
                request.setAttribute("buy_sellError", "Please select either 'BUY' or 'SELL'.");
                hasErrors = true;
            }

            if (hasErrors) {
                // Forward back to the form with error messages
                request.getRequestDispatcher("manage-transactions.jsp").forward(request, response);
                return;
            }

            try {
                int uid = Integer.parseInt(uidStr);
                int cid = Integer.parseInt(cidStr);
                double rate = Double.parseDouble(rateStr);
                int quantity = Integer.parseInt(quantityStr);
                Connection connInsert = null;
                PreparedStatement ps = null;

                try {
                    String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
                    String user = "root";
                    String pass = "trickortreat";
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connInsert = DriverManager.getConnection(url, user, pass);
                    String sql;
                    if (request.getParameter("tid") == null || request.getParameter("tid").isEmpty()) {
                        sql = "INSERT INTO TRANSACTION (UID, CID, RATE, QUANTITY, BUY_SELL) VALUES (?, ?, ?, ?, ?)";
                        ps = connInsert.prepareStatement(sql);
                        ps.setInt(1, uid);
                        ps.setInt(2, cid);
                        ps.setDouble(3, rate);
                        ps.setInt(4, quantity);
                        ps.setString(5, buySell);
                    } else {
                        int tid = Integer.parseInt(request.getParameter("tid"));
                        sql = "UPDATE TRANSACTION SET UID = ?, CID = ?, RATE = ?, QUANTITY = ?, BUY_SELL = ? WHERE TID = ?";
                        ps = connInsert.prepareStatement(sql);
                        ps.setInt(1, uid);
                        ps.setInt(2, cid);
                        ps.setDouble(3, rate);
                        ps.setInt(4, quantity);
                        ps.setString(5, buySell);
                        ps.setInt(6, tid);
                    }

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        String messageType = (request.getParameter("tid") == null || request.getParameter("tid").isEmpty()) ? "Added" : "Updated";
                        out.println("<script>Swal.fire('Success', 'Transaction " + messageType + " successfully!', 'success').then(() => { window.location.href = 'manage-transactions.jsp'; });</script>");
                        return;
                    } else {
                         String messageType = (request.getParameter("tid") == null || request.getParameter("tid").isEmpty()) ? "add" : "update";
                        request.setAttribute("message", "Error: Failed to " + messageType + " transaction.");
                        out.println("<script>Swal.fire('Error', 'Failed to " + messageType + " transaction!', 'error');</script>");
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
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("message", "Error: Invalid input format. Please enter a valid number.");
                out.println("<script>Swal.fire('Error', 'Invalid input format. Please enter a valid number.', 'error');</script>");
            }
        }

        // Handle Delete report (GET)
        if ("GET".equals(request.getMethod()) && "delete".equals(request.getParameter("action")) && request.getParameter("tid") != null) {
            int tid = Integer.parseInt(request.getParameter("tid"));
            Connection connDelete = null;
            PreparedStatement psDelete = null;

            try {
                String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
                String user = "root";
                String pass = "trickortreat";
                Class.forName("com.mysql.cj.jdbc.Driver");
                connDelete = DriverManager.getConnection(url, user, pass);
                String sql = "DELETE FROM TRANSACTION WHERE TID = ?";
                psDelete = connDelete.prepareStatement(sql);
                psDelete.setInt(1, tid);
                int rowsDeleted = psDelete.executeUpdate();
                if (rowsDeleted > 0) {
                    out.println("<script>Swal.fire('Success', 'Transaction deleted successfully!', 'success').then(() => { window.location.href = 'manage-transactions.jsp'; });</script>");
                    return;
                } else {
                    request.setAttribute("message", "Error: Failed to delete transaction.");
                    out.println("<script>Swal.fire('Error', 'Failed to delete transaction.', 'error');</script>");
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
        if ("GET".equals(request.getMethod()) && "update".equals(request.getParameter("action")) && request.getParameter("tid") != null) {
            int tid = Integer.parseInt(request.getParameter("tid"));
            Connection connUpdate = null;
            PreparedStatement psUpdate = null;

            try {
                String url = "jdbc:mysql://localhost:3306/FINANCIAL_DB";
                String user = "root";
                String pass = "trickortreat";
                Class.forName("com.mysql.cj.jdbc.Driver");
                connUpdate = DriverManager.getConnection(url, user, pass);
                String sql = "SELECT UID, CID, RATE, QUANTITY, BUY_SELL FROM TRANSACTION WHERE TID = ?";
                psUpdate = connUpdate.prepareStatement(sql);
                psUpdate.setInt(1, tid);
                ResultSet rsUpdate = psUpdate.executeQuery();
                if (rsUpdate.next()) {
                    int uid = rsUpdate.getInt("UID");
                    int cid = rsUpdate.getInt("CID");
                    double rate = rsUpdate.getDouble("RATE");
                    int quantity = rsUpdate.getInt("QUANTITY");
                    String buySell = rsUpdate.getString("BUY_SELL");
        %>
                <form action="manage-transactions.jsp" method="POST" class="mb-4">
                    <h5>Update Transaction</h5>
                    <input type="hidden" name="tid" value="<%= tid %>">
                    <input type="number" name="uid" id="uid" value="<%= uid %>" class="form-control mb-2" required>
                     <div  class="error-message">
                        <% if (request.getAttribute("uidError") != null) { %>
                            <%= request.getAttribute("uidError") %>
                        <% } %>
                    </div>
                    <input type="number" name="cid" id="cid" value="<%= cid %>" class="form-control mb-2" required>
                    <div  class="error-message">
                        <% if (request.getAttribute("cidError") != null) { %>
                            <%= request.getAttribute("cidError") %>
                        <% } %>
                    </div>
                    <input type="number" name="rate" id="rate" value="<%= rate %>" class="form-control mb-2" required>
                     <div  class="error-message">
                        <% if (request.getAttribute("rateError") != null) { %>
                            <%= request.getAttribute("rateError") %>
                        <% } %>
                    </div>
                    <input type="number" name="quantity" id="quantity" value="<%= quantity %>" class="form-control mb-2" required>
                     <div  class="error-message">
                        <% if (request.getAttribute("quantityError") != null) { %>
                            <%= request.getAttribute("quantityError") %>
                        <% } %>
                    </div>
                    <select name="buy_sell" id="buy_sell" class="form-select mb-2" required>
                        <option value="">Select Buy/Sell</option>
                        <option value="BUY" <%= "BUY".equals(buySell) ? "selected" : "" %>>BUY</option>
                        <option value="SELL" <%= "SELL".equals(buySell) ? "selected" : "" %>>SELL</option>
                    </select>
                     <div  class="error-message">
                        <% if (request.getAttribute("buy_sellError") != null) { %>
                            <%= request.getAttribute("buy_sellError") %>
                        <% } %>
                    </div>
                    <button type="submit" class="btn btn-warning update-btn">Update Transaction</button>
                </form>
        <%
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
        }
        %>
    </div>

    <footer>
        <p>&copy; 2025 Financial Portfolio Manager</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showDeleteConfirmation(tid) {
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
                    window.location.href = "manage-transactions.jsp?tid=" + tid + "&action=delete";
                }
            });
        }
    </script>
</body>
</html>
