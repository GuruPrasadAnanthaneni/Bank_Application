<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="in.ps.bankapp.dto.Account" %>
<%@ page import="in.ps.bankapp.dto.Customer" %>

<%
    Account acc = (Account) request.getAttribute("acc");
    Customer adminUser = (Customer) session.getAttribute("customer");

    // The logic below ensures the page requires admin login. No change here.
    if (adminUser == null || adminUser.getCid() != 1) {
        response.sendRedirect(request.getContextPath() + "/SignIn.jsp");
        return;
    }

    String adminFirstName = adminUser.getFirst_name();
    
    // UI Enhancements: Check for messages passed via redirect
    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Account – NexusAdmin</title>

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
    margin: 0; 
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
nav ul { list-style: none; padding: 0; }
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

/* Placeholder for remaining sidebar items (assuming existence from previous files) */
.nav-item.pending a { color: var(--warning-color); }
.nav-item.danger a { color: var(--danger-color); }
.nav-item.pending a i { color: var(--warning-color); }
.nav-item.danger a i { color: var(--danger-color); }

/* --- MAIN CONTENT & FORM STYLES --- */
.main-content { 
    padding: 40px; 
    overflow-y: auto; 
}

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

.form-card {
    background: var(--surface-light);
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    max-width: 750px; 
    margin: 0 auto; /* Center the card */
}

.form-card h2 { 
    font-size: 1.4em; 
    margin-bottom: 25px; 
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
}

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

label {
    font-weight: 600;
    margin-bottom: 6px;
    color: var(--secondary-color);
    font-size: 0.95em;
}

input, select {
    padding: 10px 15px;
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-size: 1em;
    transition: border-color 0.2s;
    margin-bottom: 0; /* Removed default margin from previous style */
}

input:focus, select:focus {
    border-color: var(--primary-color);
    outline: none;
    box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}

/* Make Status field full width */
.full-width {
    grid-column: 1 / -1; 
}

button[type="submit"] {
    grid-column: 1 / -1;
    padding: 12px 20px;
    background-color: var(--primary-color);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 1.1em;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.2s, box-shadow 0.2s;
    margin-top: 20px;
}

button[type="submit"]:hover {
    background-color: #0056b3;
    box-shadow: 0 4px 10px rgba(0, 123, 255, 0.3);
}

/* Message Alerts */
.message {
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-weight: 600;
    text-align: center;
}
.success-message {
    background-color: rgba(40, 167, 69, 0.1);
    color: var(--success-color);
    border: 1px solid var(--success-color);
}
.error-message {
    background-color: rgba(220, 53, 69, 0.1);
    color: var(--danger-color);
    border: 1px solid var(--danger-color);
}
</style>
</head>

<body>

<div class="layout">

    <aside class="sidebar">
        <div class="logo-area">
            <i class="fas fa-university"></i> <span>NexusAdmin</span>
        </div>

        <nav>
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


    <main class="main-content">
        
        <header class="main-header">
            <div>
                <h1><i class="fas fa-edit" style="color: var(--primary-color);"></i> Edit Account Details</h1>
                <p class="sub-title">Modify the details for Account Number: <%= acc.getAccount_number() %>.</p>
            </div>
            <div class="user-profile">
                <i class="fas fa-user-circle profile-icon"></i>
                <span>Hello, <%= adminFirstName %></span>
            </div>
        </header>

        <% if ("success".equals(successMsg)) { %>
            <div class="message success-message">
                <i class="fas fa-check-circle"></i> Account details updated successfully!
            </div>
        <% } else if ("error".equals(errorMsg)) { %>
            <div class="message error-message">
                <i class="fas fa-times-circle"></i> Error updating account details. Please try again.
            </div>
        <% } %>


        <div class="form-card">
            <h2>Account Information</h2>

            <form method="post" action="<%=request.getContextPath()%>/admin/edit-account-details">

                <input type="hidden" name="accId" value="<%=acc.getAccount_id()%>">
                
                <div class="form-grid">

                    <div class="form-group">
                        <label>Account Number</label>
                        <input type="number" name="accNo" value="<%=acc.getAccount_number()%>" required>
                    </div>

                    <div class="form-group">
                        <label>Customer ID</label>
                        <input type="number" name="cid" value="<%=acc.getCustomer_id()%>" readonly>
                    </div>

                    <div class="form-group">
                        <label>Account Type</label>
                        <select name="type">
                            <option value="SAVINGS" <%= acc.getAccount_type().equals("SAVINGS") ? "selected" : "" %>>SAVINGS</option>
                            <option value="CURRENT" <%= acc.getAccount_type().equals("CURRENT") ? "selected" : "" %>>CURRENT</option>
                            <option value="FD" <%= acc.getAccount_type().equals("FD") ? "selected" : "" %>>FIXED DEPOSIT (FD)</option>
                            <option value="LOAN" <%= acc.getAccount_type().equals("LOAN") ? "selected" : "" %>>LOAN</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Balance</label>
                        <div style="display: flex; align-items: center; gap: 5px;">
                            <span style="font-size: 1.1em; font-weight: 600;">₹</span>
                            <input type="number" step="0.01" name="balance" value="<%=String.format("%.2f", acc.getBalance())%>" required style="width: 100%;">
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label>Status</label>
                        <select name="status">
                            <option value="ACTIVE" <%= acc.getStatus().toUpperCase().equals("ACTIVE") ? "selected" : "" %>>ACTIVE (Normal)</option>
                            <option value="INACTIVE" <%= acc.getStatus().toUpperCase().equals("INACTIVE") ? "selected" : "" %>>INACTIVE (Closed)</option>
                            <option value="PENDING" <%= acc.getStatus().toUpperCase().equals("PENDING") ? "selected" : "" %>>PENDING (Awaiting Approval)</option>
                            <option value="BLOCKED" <%= acc.getStatus().toUpperCase().equals("BLOCKED") ? "selected" : "" %>>BLOCKED (Suspended)</option>
                        </select>
                    </div>

                    <button type="submit">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>

    </main>

</div>

</body>
</html>