package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.*;
import in.ps.bankapp.dto.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class CustomerDepositServlet extends HttpServlet {

    // --- Generate 13-digit Transaction ID ---
    private long generateTransactionId() {
        long min = 1000000000000L;  // 13 digits
        long max = 9999999999999L;
        return min + (long)(Math.random() * (max - min));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        req.setAttribute("activePage", "deposit");
        req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        req.setAttribute("activePage", "deposit");

        String accNoStr = req.getParameter("accNo");
        String amountStr = req.getParameter("amount");
        String pinStr = req.getParameter("pin");

        Customer cust = (Customer) session.getAttribute("customer");

        CustomerDAO cdao = new CustomerDAOImp();
        Customer dbCust = cdao.getCustomer(cust.getMail()); // latest data

        // --- RULE: Customer Status Check ---
        if (dbCust.getStatus().equalsIgnoreCase("Pending")) {
            req.setAttribute("error", "⛔ Your customer profile is still pending. Deposits are not allowed.");
            req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
            return;
        }

        if (dbCust.getStatus().equalsIgnoreCase("Blocked")) {
            req.setAttribute("error", "🚫 Your customer profile is blocked. You cannot deposit to any account.");
            req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
            return;
        }

        // Validate PIN
        if (!String.valueOf(dbCust.getPassword()).equals(pinStr)) {
            req.setAttribute("error", "❌ Invalid PIN");
            req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
            return;
        }

        long accNo;
        double amount;

        try {
            accNo = Long.parseLong(accNoStr);
            amount = Double.parseDouble(amountStr);
        } catch (Exception e) {
            req.setAttribute("error", "⚠️ Invalid input format.");
            req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
            return;
        }

        AccountDAO adao = new AccountDAOImp();
        Account acc = adao.getAccount(accNo);

        if (acc == null || acc.getCustomer_id() != dbCust.getCid()) {
            req.setAttribute("error", "❌ Account not found or does not belong to you.");
            req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
            return;
        }

        // --- Account status checks ---
        if (!acc.getStatus().equalsIgnoreCase("Active")) {
            req.setAttribute("error", "🚫 This account is not active. Deposit not allowed.");
            req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
            return;
        }

        // --- Deposit Logic ---
        double newBalance = acc.getBalance() + amount;
        acc.setBalance(newBalance);
        adao.updateAccount(acc);

        // --- Create Transaction (with 13-digit TRAN_ID) ---
        long tranId = generateTransactionId();

        Transaction t = new Transaction();
        t.setTransaction_id(tranId);
        t.setSender_acc(accNo);
        t.setReciever_acc(accNo);
        t.setAmount(amount);
        t.setTran_type("SELF");
        t.setBalance(newBalance);

        TransactionDAO tdao = new TransactionDAOImp();
        tdao.insertTransaction(t);

        // send confirmation to JSP
        req.setAttribute("tranId", tranId);
        req.setAttribute("success", "₹" + amount + " deposited successfully!");
        req.setAttribute("accNo", accNo);
        req.setAttribute("balance", newBalance);

        req.getRequestDispatcher("/CustomerDeposit.jsp").forward(req, resp);
    }
}
