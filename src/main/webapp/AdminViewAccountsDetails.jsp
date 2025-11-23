<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="in.ps.bankapp.dto.*" %>

<%!
    // JSP DECLARATION BLOCK: Helper methods for dynamic styling (Status Pills, Transaction Colors)

    // Helper for Status Pill coloring
    String getStatusClass(String status) {
        if (status == null) return "status-default";
        String s = status.toUpperCase();
        if (s.equals("ACTIVE") || s.equals("APPROVED")) return "status-active";
        if (s.equals("BLOCKED") || s.equals("REJECTED")) return "status-danger";
        if (s.equals("PENDING")) return "status-pending";
        return "status-default";
    }

    // Helper for Transaction Type coloring
    String getTransactionClass(String type) {
        if (type == null) return "text-muted";
        String t = type.toUpperCase();
        if (t.contains("DEPOSIT") || t.contains("CREDIT")) return "text-success";
        if (t.contains("WITHDRAW") || t.contains("DEBIT") || t.contains("TRANSFER")) return "text-danger";
        return "text-muted";
    }
%>

<%
    Account acc = (Account) request.getAttribute("account");
    Customer cust = (Customer) request.getAttribute("customer");
    ArrayList<Transaction> txns = (ArrayList<Transaction>) request.getAttribute("txnList");

    Customer adminUser = (Customer) session.getAttribute("customer");
    String adminFirstName = adminUser != null ? adminUser.getFirst_name() : "Admin";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>NexusAdmin – Account Details</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<style>
    /* --- Global Styles & Variables (Unified) --- */
    :root {
        --primary-color: #007bff;
        --secondary-color: #343a40;
        --background-light: #f4f7f9;
        --surface-light: #ffffff;
        --border-color: #e9ecef;
        --text-light: #6c757d;
        --shadow-light: rgba(0,0,0,0.08);
        
        --success-color: #28a745;
        --warning-color: #ffc107;
        --danger-color: #dc3545;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    a { text-decoration: none; color: inherit; }

    body {
        font-family: 'Poppins', sans-serif;
        background: var(--background-light);
        color: var(--secondary-color);
        font-size: 15px;
    }

    .layout {
        display: grid;
        grid-template-columns: 240px 1fr;
        height: 100vh;
        overflow: hidden;
    }

    /* --- Sidebar Styling (Consistent & Fixed) --- */
    .sidebar {
        background-color: var(--surface-light);
        border-right: 1px solid var(--border-color);
        padding: 30px 0;
        display: flex;
        flex-direction: column;
        box-shadow: 2px 0 10px var(--shadow-light);
        overflow-y: auto;
    }

    .logo-area {
        display: flex; align-items: center; padding: 0 25px 40px;
        font-size: 1.5em; font-weight: 700; color: var(--primary-color);
    }
    .logo-area i { margin-right: 12px; font-size: 1.2em; }
    .sidebar-nav ul { list-style: none; padding: 0; }
    .nav-item { margin-bottom: 4px; }

    .nav-item a {
        display: flex; align-items: center; padding: 12px 25px;
        color: var(--secondary-color); font-weight: 500;
        transition: all 0.2s ease-in-out; border-radius: 8px; margin: 0 15px;
    }
    .nav-item a i { margin-right: 15px; font-size: 18px; color: var(--text-light); }
    .nav-item.separator { height: 1px; background-color: var(--border-color); margin: 20px 25px; }

    /* General Hover/Active State (Blue) */
    .nav-item:hover a,
    .nav-item.active a {
        background-color: var(--primary-color);
        color: white !important;
        box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        text-decoration: none !important;
    }
    .nav-item:hover a i,
    .nav-item.active a i { color: white !important; }

    /* Highlight specific links (Inactive state color) */
    .nav-item.pending a { color: var(--warning-color); }
    .nav-item.danger a { color: var(--danger-color); }
    .nav-item.pending a i { color: var(--warning-color); }
    .nav-item.danger a i { color: var(--danger-color); }

    /* --- FIX: Overrides for Specific Active Status Links --- */
    .nav-item.pending.active a {
        background-color: var(--warning-color) !important;
        color: var(--secondary-color) !important; 
        box-shadow: 0 4px 8px rgba(255, 193, 7, 0.5) !important;
        text-decoration: none !important;
    }
    .nav-item.pending.active a i {
        color: var(--secondary-color) !important;
    }
    .nav-item.danger.active a {
        background-color: var(--danger-color) !important;
        color: white !important;
        box-shadow: 0 4px 8px rgba(220, 53, 69, 0.5) !important;
        text-decoration: none !important;
    }
    .nav-item.danger.active a i {
        color: white !important;
    }


    /* --- MAIN CONTENT & CARDS --- */
    .main { padding: 40px; overflow-y: auto; }

    .main-header {
        display: flex; justify-content: space-between; align-items: center;
        padding-bottom: 15px; margin-bottom: 30px; border-bottom: 1px solid var(--border-color);
    }
    .main-header h1 { font-size: 2em; font-weight: 700; }
    .sub-title { color: var(--text-light); margin-top: 5px; }

    .user-profile {
        display: flex; align-items: center; gap: 15px;
        color: var(--primary-color); font-weight: 600;
        background: var(--surface-light); padding: 8px 15px;
        border-radius: 8px; box-shadow: 0 2px 5px var(--shadow-light);
    }
    .profile-icon { font-size: 1.6em; color: var(--primary-color); }

    .card {
        background: var(--surface-light);
        padding: 25px;
        border-radius: 12px;
        margin-bottom: 30px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    }

    .card h2 { 
        font-size: 1.4em; 
        margin-bottom: 20px; 
        padding-bottom: 10px;
        border-bottom: 1px solid var(--border-color);
    }

    /* Details Grid (New Structure) */
    .details-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 15px 30px;
    }
    .detail-item {
        font-size: 0.95em;
    }
    .detail-item strong {
        display: block;
        font-weight: 600;
        color: var(--text-light);
        font-size: 0.85em;
        margin-bottom: 2px;
    }
    .detail-value {
        color: var(--secondary-color);
        font-weight: 500;
    }
    
    /* Table Styles */
    table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 0.9em; }
    thead { background: var(--primary-color); color: #fff; }
    th, td { padding: 12px 18px; border-bottom: 1px solid var(--border-color); text-align: left; }
    tbody tr:hover { background: var(--background-light); }
    tbody tr:last-child td { border-bottom: none; }
    
    /* Status Pills */
    .status-pill {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 4px;
        font-size: 0.75em;
        font-weight: 600;
        text-transform: uppercase;
    }
    .status-active { background-color: rgba(40, 167, 69, 0.15); color: var(--success-color); }
    .status-danger { background-color: rgba(220, 53, 69, 0.15); color: var(--danger-color); }
    .status-pending { background-color: rgba(255, 193, 7, 0.15); color: var(--warning-color); }
    .status-default { background-color: rgba(108, 117, 125, 0.15); color: var(--text-light); }

    /* Transaction Colors */
    .text-success { color: var(--success-color); font-weight: 600; }
    .text-danger { color: var(--danger-color); font-weight: 600; }

</style>
</head>

<body>

<div class="layout">

    <aside class="sidebar">
        <div class="logo-area">
            <i class="fas fa-university"></i> <span>NexusAdmin</span>
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

                <li class="nav-item active">
                    <a href="<%=request.getContextPath()%>/admin/accounts">
                        <i class="fas fa-wallet"></i> Accounts
                    </a>
                </li>

                <li class="nav-item">
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

    <main class="main">
        
        <header class="main-header">
            <div>
                <h1><i class="fas fa-wallet" style="color: var(--primary-color);"></i> Account Details</h1>
                <p class="sub-title">Detailed information for Account <%= acc.getAccount_number() %>.</p>
            </div>
            <div class="user-profile">
                <i class="fas fa-user-circle profile-icon"></i>
                <span>Hello, <%= adminFirstName %></span>
            </div>
        </header>

        <div class="card">
            <h2>Account Information</h2>
            
            <div class="details-grid">
                <div class="detail-item">
                    <strong>Account Number</strong>
                    <span class="detail-value"><%=acc.getAccount_number()%></span>
                </div>
                <div class="detail-item">
                    <strong>Current Balance</strong>
                    <span class="detail-value">₹ <%=String.format("%,.2f", acc.getBalance())%></span>
                </div>
                <div class="detail-item">
                    <strong>Account Type</strong>
                    <span class="detail-value"><%=acc.getAccount_type()%></span>
                </div>
                <div class="detail-item">
                    <strong>Account Status</strong>
                    <span class="status-pill <%= getStatusClass(acc.getStatus()) %>"><%=acc.getStatus().toUpperCase()%></span>
                </div>
                <div class="detail-item">
                    <strong>Created On</strong>
                    <span class="detail-value"><%=acc.getDate()%></span>
                </div>
                <div class="detail-item">
                    <strong>Account ID (Internal)</strong>
                    <span class="detail-value"><%=acc.getAccount_id()%></span>
                </div>
            </div>
        </div>

        <div class="card">
            <h2>Customer Information</h2>
            
            <div class="details-grid">
                <div class="detail-item">
                    <strong>Customer Name</strong>
                    <span class="detail-value"><%=cust.getFirst_name()%> <%=cust.getLast_name()%></span>
                </div>
                <div class="detail-item">
                    <strong>Customer ID (CID)</strong>
                    <span class="detail-value"><%=cust.getCid()%></span>
                </div>
                <div class="detail-item">
                    <strong>Email</strong>
                    <span class="detail-value"><%=cust.getMail()%></span>
                </div>
                <div class="detail-item">
                    <strong>Phone</strong>
                    <span class="detail-value"><%=cust.getPhone()%></span>
                </div>
                <div class="detail-item">
                    <strong>Customer Status</strong>
                    <span class="status-pill <%= getStatusClass(cust.getStatus()) %>"><%=cust.getStatus().toUpperCase()%></span>
                </div>
                <div class="detail-item">
                    <a href="<%=request.getContextPath()%>/admin/view-customer?cid=<%=cust.getCid()%>" style="font-weight: 600; color: var(--primary-color);">
                        <i class="fas fa-external-link-alt"></i> View Full Customer Profile
                    </a>
                </div>
            </div>
        </div>

        <div class="card">
            <h2>Recent Transactions</h2>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sender Acc</th>
                        <th>Receiver Acc</th>
                        <th>Type</th>
                        <th>Amount</th>
                        <th>Post-Balance</th>
                        <th>Date</th>
                    </tr>
                </thead>

                <tbody>
                <% 
                    if (txns != null && !txns.isEmpty()) {
                        for (Transaction t : txns) {
                %>
                <tr>
                    <td><%=t.getId()%></td>
                    <td><%=t.getSender_acc()%></td>
                    <td><%=t.getReciever_acc()%></td>
                    <td><%=t.getTran_type()%></td>
                    <td class="<%= getTransactionClass(t.getTran_type()) %>">₹ <%=String.format("%,.2f", t.getAmount())%></td>
                    <td>₹ <%=String.format("%,.2f", t.getBalance())%></td>
                    <td><%=t.getDate()%></td>
                </tr>
                <%  } } else { %>
                <tr>
                    <td colspan="7" style="text-align:center; color:var(--text-light); padding:20px;">
                        <i class="fas fa-history"></i> No recent transactions found for this account.
                    </td>
                </tr>
                <% } %>
                </tbody>

            </table>
        </div>

    </main>

</div>

</body>
</html>