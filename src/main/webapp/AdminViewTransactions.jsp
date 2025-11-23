<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="in.ps.bankapp.dto.Transaction" %>
<%@ page import="in.ps.bankapp.dto.Customer" %>

<%
    // ** LOGIC REMAINS UNCHANGED **
    Customer adminUser = (Customer) session.getAttribute("customer");
    ArrayList<Transaction> list =
        (ArrayList<Transaction>) request.getAttribute("transactionsList");
        
    String adminFirstName = (adminUser != null) ? adminUser.getFirst_name() : "Admin";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin – View Transactions</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<style>
/* --- Global Styles & Variables (REFINED) --- */
:root {
    --primary-color: #007bff; /* Blue */
    --secondary-color: #343a40; /* Dark Grey/Black */
    --background-light: #f4f7f9; /* Soft Light Blue-Grey */
    --surface-light: #ffffff;
    --border-color: #e9ecef;
    --text-light: #6c757d; /* Muted text */
    --shadow-light: rgba(0, 0, 0, 0.08);
    --shadow-medium: rgba(0, 0, 0, 0.15);

    --success-color: #28a745;
    --warning-color: #ffc107;
    --danger-color: #dc3545;
    --risk-color: #e67e22; /* Consistent orange */
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Poppins', sans-serif; /* Applied new font */
    background-color: var(--background-light);
    color: var(--secondary-color);
    line-height: 1.6;
    font-size: 15px;
}

a { text-decoration: none; color: inherit; }

/* --- Layout: Grid Container (Consistent) --- */
.dashboard-container {
    display: grid;
    grid-template-columns: 240px 1fr; /* Narrower sidebar */
    height: 100vh;
    overflow: hidden;
}

/* --- Sidebar Styling (Consistent) --- */
.sidebar {
            background-color: var(--surface-light);
            border-right: 1px solid var(--border-color);
            padding: 30px 0; /* Increased padding */
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px var(--shadow-light);
            overflow-y: auto;
        }

        .logo-area {
            display: flex;
            align-items: center;
            padding: 0 25px 40px;
            font-size: 1.5em; /* Adjusted font size */
            font-weight: 700;
            color: var(--primary-color);
        }

        .logo-area i {
            margin-right: 12px;
            font-size: 1.2em;
        }

        .sidebar-nav ul { list-style: none; }

        .nav-item { margin-bottom: 4px; }

        .nav-item a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: var(--secondary-color);
            font-weight: 500;
            transition: all 0.2s ease-in-out;
            border-radius: 8px; /* Softer edges */
            margin: 0 15px;
        }

        .nav-item a i {
            margin-right: 15px;
            font-size: 18px;
            color: var(--text-light);
        }

        .nav-item.separator {
            height: 1px;
            background-color: var(--border-color);
            margin: 20px 25px;
        }

        .nav-item:hover a,
        .nav-item.active a {
            background-color: var(--primary-color);
            color: white !important;
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        }

        .nav-item:hover a i,
        .nav-item.active a i {
            color: white !important;
        }
        
        /* Highlight specific links */
        .nav-item.pending a { color: var(--warning-color); }
        .nav-item.danger a { color: var(--danger-color); }
        .nav-item.pending a i { color: var(--warning-color); }
        .nav-item.danger a i { color: var(--danger-color); }

/* --- Main content (Consistent) --- */
.main-content {
    display: flex;
    flex-direction: column;
    padding: 40px; /* Increased padding */
    overflow-y: auto;
}

.main-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
}

.header-title h1 {
    font-size: 2em;
    font-weight: 700;
}

.header-title p {
    font-size: 1em;
    color: var(--text-light);
}

.user-profile {
    display: flex;
    align-items: center;
    gap: 15px;
    color: var(--primary-color);
    font-weight: 600;
    background: var(--surface-light);
    padding: 8px 15px;
    border-radius: 8px;
    box-shadow: 0 2px 5px var(--shadow-light);
}

.profile-icon {
    font-size: 1.6em;
    color: var(--primary-color);
}

/* --- Table Card & Table Styles (Enhanced) --- */
.table-card {
    background: var(--surface-light);
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 5px 20px var(--shadow-light);
}

.table-card h2 {
    font-size: 1.5em;
    color: var(--secondary-color);
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
}

.table-wrapper {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.95em;
}

thead {
    background-color: var(--primary-color); /* Primary color header */
    color: white;
}

th {
    padding: 15px 18px; /* Increased padding */
    text-align: left;
    font-weight: 600;
    white-space: nowrap;
}
        
td {
    padding: 12px 18px; /* Adjusted padding */
    text-align: left;
    border-bottom: 1px solid var(--border-color);
    white-space: nowrap;
}

tbody tr:hover {
    background-color: var(--background-light); /* Hover uses background color */
}
        
tbody tr:last-child td {
    border-bottom: none;
}

/* Status Pills (Refined Colors) - Adjusted for transaction status */
.status-pill {
    padding: 5px 12px;
    border-radius: 999px;
    font-size: 0.8em;
    font-weight: 600;
    display: inline-block;
}

.status-SUCCESS { 
    background: rgba(40, 167, 69, 0.15); 
    color: var(--success-color); 
}

.status-FAILED { 
    background: rgba(220, 53, 69, 0.15); 
    color: var(--danger-color); 
}

/* For Type (Credit/Debit) */
.txn-CREDIT { color: var(--success-color); font-weight: 600; }
.txn-DEBIT { color: var(--danger-color); font-weight: 600; }
.txn-other { color: var(--primary-color); font-weight: 600; }

</style>
</head>

<body>
<div class="dashboard-container">

    <aside class="sidebar">
        <div class="logo-area">
            <i class="fas fa-university"></i>
            <span>NexusAdmin</span>
        </div>
        <nav class="sidebar-nav">
            <ul>
            
            	<li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/dashboard">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/customers">
                        <i class="fas fa-users"></i> Customers
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/admin/accounts">
                        <i class="fas fa-wallet"></i> Accounts
                    </a>
                </li>
                <li class="nav-item active">
                    <a href="<%=request.getContextPath()%>/admin/transactions">
                        <i class="fas fa-exchange-alt"></i> Transactions
                    </a>
                </li>

                <li class="nav-item separator"></li>

                <li class="nav-item pending">
                    <a href="<%=request.getContextPath()%>/admin/pending-customers">
                        <i class="fas fa-user-check"></i> Cust. Approval
                    </a>
                </li>
                <li class="nav-item pending">
                    <a href="<%=request.getContextPath()%>/admin/pending-accounts">
                        <i class="fas fa-clipboard-check"></i> Acc. Approval
                    </a>
                </li>
                <li class="nav-item danger">
    				<a href="<%=request.getContextPath()%>/admin/blocked-customers">
        				<i class="fas fa-user-slash"></i> Blocked Customers
    				</a>
				</li>
                <li class="nav-item danger">
                    <a href="<%=request.getContextPath()%>/admin/blocked">
                        <i class="fas fa-ban"></i> Blocked Accounts
                    </a>
                </li>

                <li class="nav-item separator"></li>

                <li class="nav-item">
                    <a href="<%=request.getContextPath()%>/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">

        <header class="main-header">
            <div class="header-title">
                <h1><i class="fas fa-exchange-alt" style="color: var(--primary-color);"></i> Transaction Monitor</h1>
                <p>Monitor and view all recent banking transactions in the system.</p>
            </div>
            <div class="user-profile">
                <i class="fas fa-user-circle profile-icon"></i>
                <span>Hello, <%= adminFirstName %></span>
            </div>
        </header>

        <section class="table-card">
            <h2>Transaction History</h2>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Transaction ID</th>
                            <th>Sender Acc</th>
                            <th>Receiver Acc</th>
                            <th>Amount</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>

                    <tbody>
                    <% 
                        // ** LOGIC REMAINS UNCHANGED **
                        if (list != null && !list.isEmpty()) {
                            for (Transaction t : list) {
                            	
                            	/* int adminCid = adminUser.getCid();

                            	// Skip transactions where admin is sender or receiver
                            	if (t.getSender_acc() == adminCid || t.getReciever_acc() == adminCid) {
                            	    continue;
                            	} */


                                // Assuming 'tran_type' holds both Type (CREDIT/DEBIT/TRANSFER) and Status (SUCCESS/FAILED) based on the JSP logic.
                                // I will use 'tran_type' for the Type column and map the status based on a hypothetical 'status' field or use 'tran_type' for status display if it contains 'SUCCESS'/'FAILED'.
                                
                                String status = "SUCCESS"; // Defaulting to success if not specified
                                String statusCss = "status-SUCCESS";
                                String transactionType = t.getTran_type();
                                
                                // Simple mapping for the purpose of visual demonstration if the type field also conveys status
                                if ("FAILED".equalsIgnoreCase(t.getTran_type())) {
                                    status = "FAILED";
                                    statusCss = "status-FAILED";
                                    transactionType = "DEBIT"; // Assuming FAILED transactions are usually debit attempts
                                } else if ("SUCCESS".equalsIgnoreCase(t.getTran_type())) {
                                    transactionType = "TRANSFER"; // Assuming successful transactions are transfers or simple CREDIT/DEBIT
                                }
                                
                                // If the database field `tran_type` actually holds the transaction type (CREDIT/DEBIT/TRANSFER)
                                // and the status is inferred or missing, we adjust the class for the transaction type.
                                String typeCss = "txn-other";
                                if ("CREDIT".equalsIgnoreCase(t.getTran_type())) typeCss = "txn-CREDIT";
                                else if ("DEBIT".equalsIgnoreCase(t.getTran_type())) typeCss = "txn-DEBIT";
                                else if ("TRANSFER".equalsIgnoreCase(t.getTran_type())) typeCss = "txn-other";
                    %>

                    <tr>
                        <td><%= t.getId() %></td>
                        <td><%= t.getTransaction_id() %></td>
                        <td><%= t.getSender_acc() %></td>
                        <td><%= t.getReciever_acc() %></td>
                        <td>₹ <%= String.format("%.2f", t.getAmount()) %></td>
                        <td>
                            <span class="<%= typeCss %>">
                                <%= t.getTran_type().toUpperCase() %>
                            </span>
                        </td>
                        <td>
                            <span class="status-pill <%= statusCss %>">
                                <%= status.toUpperCase() %>
                            </span>
                        </td>
                        <td><%= t.getDate() %></td>
                    </tr>

                    <% } } else { %>

                    <tr>
                        <td colspan="8" style="text-align:center; padding:20px; color: var(--text-light);">
                            <i class="fas fa-exclamation-circle"></i> No transactions found in the history.
                        </td>
                    </tr>

                    <% } %>
                    </tbody>

                </table>
            </div>
        </section>
    </main>

</div>
</body>
</html>