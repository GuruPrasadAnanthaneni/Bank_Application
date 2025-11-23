<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="in.ps.bankapp.dto.Customer" %>

<%
    Customer cust = (Customer) request.getAttribute("customer");

    in.ps.bankapp.dto.Customer adminUser =
        (in.ps.bankapp.dto.Customer) session.getAttribute("customer");

    String adminFirstName = (adminUser != null) ? adminUser.getFirst_name() : "Admin";

    // Check for success or error messages (UI enhancement, relies on servlet redirect)
    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Customer – NexusAdmin</title>

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
.sidebar-nav ul { list-style: none; }
.nav-item { margin-bottom: 4px; }

/* Renaming .sidebar .logo to .logo-area for consistency */
.sidebar .logo {
    font-size:1.5em;
    padding:0 25px 30px;
    font-weight:700;
    color:var(--primary-color);
}


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

/* --- FIX: Overrides for Specific Active Status Links (Crucial for Consistency) --- */
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

/* --- MAIN CONTENT & FORM STYLES --- */
.main {
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

.card {
    background: var(--surface-light);
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    max-width: 800px; 
    margin: 0 auto;
}

.card h2 { 
    font-size: 1.4em; 
    margin-bottom: 25px; 
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
}

/* Form Layout (Grid) */
.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 25px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group label {
    font-weight: 600;
    margin-bottom: 6px;
    color: var(--secondary-color);
    font-size: 0.95em;
}

.form-group input,
.form-group select {
    padding: 10px 15px;
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-size: 1em;
    transition: border-color 0.2s;
}

.form-group input:focus,
.form-group select:focus {
    border-color: var(--primary-color);
    outline: none;
    box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}

/* Submit Button */
.submit-btn {
    grid-column: 1 / -1; /* Span entire width */
    padding: 12px 20px;
    background-color: var(--primary-color);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 1.1em;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.2s, box-shadow 0.2s;
    margin-top: 10px;
}

.submit-btn:hover {
    background-color: #0056b3;
    box-shadow: 0 4px 10px rgba(0, 123, 255, 0.3);
}

.status-select-group {
    grid-column: 1 / -1; /* Full width for status */
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
        <div class="logo-area"><i class="fas fa-university"></i> <span>NexusAdmin</span></div> 

        <nav class="sidebar-nav">
            <ul>
                <li class="nav-item"><a href="<%=request.getContextPath()%>/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a></li>
                <li class="nav-item active"><a href="<%=request.getContextPath()%>/admin/customers"><i class="fas fa-users"></i> Customers</a></li>
                <li class="nav-item"><a href="<%=request.getContextPath()%>/admin/accounts"><i class="fas fa-wallet"></i> Accounts</a></li>
                <li class="nav-item"><a href="<%=request.getContextPath()%>/admin/transactions"><i class="fas fa-exchange-alt"></i> Transactions</a></li>

                <li class="nav-item separator"></li>

                <li class="nav-item pending"><a href="<%=request.getContextPath()%>/admin/pending-customers"><i class="fas fa-user-check"></i> Cust. Approval</a></li>
                <li class="nav-item pending"><a href="<%=request.getContextPath()%>/admin/pending-accounts"><i class="fas fa-clipboard-check"></i> Acc. Approval</a></li>
                <li class="nav-item danger"><a href="<%=request.getContextPath()%>/admin/blocked-customers"><i class="fas fa-user-slash"></i> Blocked Customers</a></li>
                <li class="nav-item danger"><a href="<%=request.getContextPath()%>/admin/blocked"><i class="fas fa-ban"></i> Blocked Accounts</a></li>

                <li class="nav-item separator"></li>

                <li class="nav-item"><a href="<%=request.getContextPath()%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </nav>
    </aside>

    <main class="main">

        <header class="main-header">
            <div>
                <h1><i class="fas fa-user-edit" style="color: var(--primary-color);"></i> Edit Customer Details</h1>
                <p class="sub-title">Update customer profile information for <%= cust.getFirst_name() %> <%= cust.getLast_name() %> (CID: <%= cust.getCid() %>).</p>
            </div>
            <div class="user-profile">
                <i class="fas fa-user-circle profile-icon"></i>
                <span>Hello, <%= adminFirstName %></span>
            </div>
        </header>
        
        <% if ("updated".equals(successMsg)) { %>
            <div class="message success-message">
                <i class="fas fa-check-circle"></i> Customer details updated successfully!
            </div>
        <% } else if ("1".equals(errorMsg)) { %>
            <div class="message error-message">
                <i class="fas fa-times-circle"></i> Error updating customer details. Please try again.
            </div>
        <% } %>

        <div class="card">
            <h2>Profile Information</h2>

            <form action="<%=request.getContextPath()%>/admin/edit-customer" method="post">

                <input type="hidden" name="cid" value="<%=cust.getCid()%>">
                
                <div class="form-grid">

                    <div class="form-group">
                        <label>First Name</label>
                        <input type="text" name="fname" value="<%=cust.getFirst_name()%>" required>
                    </div>

                    <div class="form-group">
                        <label>Last Name</label>
                        <input type="text" name="lname" value="<%=cust.getLast_name()%>" required>
                    </div>

                    <div class="form-group">
                        <label>Phone</label>
                        <input type="number" name="phone" value="<%=cust.getPhone()%>" required>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="mail" value="<%=cust.getMail()%>" required>
                    </div>

                    <div class="form-group">
                        <label>Password (PIN)</label>
                        <input type="number" name="password" value="<%=cust.getPassword()%>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Customer ID (CID)</label>
                        <input type="text" value="<%=cust.getCid()%>" disabled>
                    </div>

                    <div class="form-group status-select-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="ACTIVE" <%=cust.getStatus().equals("ACTIVE")?"selected":""%>>ACTIVE (Normal Access)</option>
                            <option value="PENDING" <%=cust.getStatus().equals("PENDING")?"selected":""%>>PENDING (Awaiting Approval)</option>
                            <option value="BLOCKED" <%=cust.getStatus().equals("BLOCKED")?"selected":""%>>BLOCKED (Access Denied)</option>
                            <option value="INACTIVE" <%=cust.getStatus().equals("INACTIVE")?"selected":""%>>INACTIVE (Account Closed)</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-save"></i> Update Customer
                </button>

            </form>

        </div>

    </main>

</div>

</body>
</html>