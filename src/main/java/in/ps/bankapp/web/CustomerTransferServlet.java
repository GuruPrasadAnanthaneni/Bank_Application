package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.*;
import in.ps.bankapp.dto.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class CustomerTransferServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect("SignIn.jsp");
            return;
        }

        Customer c = (Customer) session.getAttribute("customer");

        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> accounts = adao.getAccountByCustomerId(c.getCid());

        req.setAttribute("accountsList", accounts);
        req.setAttribute("activePage", "transfer");

        req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect("SignIn.jsp");
            return;
        }

        Customer customer = (Customer) session.getAttribute("customer");

        // -------------------- RULE 1 : CUSTOMER RESTRICTIONS --------------------
        if (customer.getStatus().equalsIgnoreCase("Pending")) {
            req.setAttribute("error", "⛔ Your profile is still pending approval. Transfers are not allowed.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        if (customer.getStatus().equalsIgnoreCase("Blocked")) {
            req.setAttribute("error", "❌ Your account is blocked. You cannot transfer money.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // -------------------- INPUT VALUES --------------------
        String senderAccStr = req.getParameter("senderAcc");
        String receiverAccStr = req.getParameter("receiverAcc");
        String amountStr = req.getParameter("amount");
        String pinStr = req.getParameter("pin");

        if (senderAccStr == null || receiverAccStr == null ||
                amountStr == null || pinStr == null ||
                senderAccStr.isEmpty() || receiverAccStr.isEmpty() ||
                amountStr.isEmpty() || pinStr.isEmpty()) {

            req.setAttribute("error", "⚠️ All fields are required.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        long senderAcc = Long.parseLong(senderAccStr);
        long receiverAcc = Long.parseLong(receiverAccStr);
        double amount = Double.parseDouble(amountStr);
        int pin = Integer.parseInt(pinStr);

        AccountDAO adao = new AccountDAOImp();
        TransactionDAO tdao = new TransactionDAOImp();

        // -------------------- PIN CHECK --------------------
        if (pin != customer.getPassword()) {
            req.setAttribute("error", "❌ Incorrect PIN!");
            req.setAttribute("senderAcc", senderAccStr);
            req.setAttribute("receiverAcc", receiverAccStr);
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // -------------------- FETCH SENDER ACCOUNT --------------------
        Account sender = adao.getAccount(senderAcc);

        if (sender == null) {
            req.setAttribute("error", "❌ Sender account not found.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // -------------------- RULE 2 : SENDER ACCOUNT STATUS RESTRICTION --------------------
        if (sender.getStatus().equalsIgnoreCase("Pending")) {
            req.setAttribute("error", "⛔ Your sender account is still pending approval.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        if (sender.getStatus().equalsIgnoreCase("Inactive")) {
            req.setAttribute("error", "⚠️ Your sender account is inactive. Please contact support.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        if (sender.getStatus().equalsIgnoreCase("Blocked")) {
            req.setAttribute("error", "❌ Your sender account is blocked. You cannot transfer money.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // -------------------- FETCH RECEIVER ACCOUNT --------------------
        Account receiver = adao.getAccount(receiverAcc);

        if (receiver == null) {
            req.setAttribute("error", "❌ Receiver account not found.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // Receiver must be ACTIVE
        if (!receiver.getStatus().equalsIgnoreCase("Active")) {
            req.setAttribute("error", "⚠️ Receiver account is not active. Transfer cannot be completed.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // -------------------- SENDER CANNOT SEND TO THEMSELVES --------------------
        if (senderAcc == receiverAcc) {
            req.setAttribute("error", "⚠️ Sender and Receiver account cannot be same.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // -------------------- BALANCE CHECK --------------------
        if (sender.getBalance() < amount) {
            req.setAttribute("error", "❌ Insufficient balance.");
            req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
            return;
        }

        // -------------------- FINAL SUCCESS → UPDATE BALANCE --------------------
        sender.setBalance(sender.getBalance() - amount);
        receiver.setBalance(receiver.getBalance() + amount);

        adao.updateAccount(sender);
        adao.updateAccount(receiver);

        // DEBIT ENTRY
        Transaction ts = new Transaction();
        ts.setTransaction_id(System.currentTimeMillis());
        ts.setSender_acc(senderAcc);
        ts.setReciever_acc(receiverAcc);
        ts.setAmount(amount);
        ts.setTran_type("DEBIT");
        ts.setBalance(sender.getBalance());
        tdao.insertTransaction(ts);

        // CREDIT ENTRY
        Transaction tr = new Transaction();
        tr.setTransaction_id(System.currentTimeMillis() + 1);
        tr.setSender_acc(senderAcc);
        tr.setReciever_acc(receiverAcc);
        tr.setAmount(amount);
        tr.setTran_type("CREDIT");
        tr.setBalance(receiver.getBalance());
        tdao.insertTransaction(tr);

        // SUCCESS MESSAGE
        req.setAttribute("success", "₹" + amount + " transferred successfully!");
        req.setAttribute("senderAcc", senderAcc);
        req.setAttribute("receiverAcc", receiverAcc);
        req.setAttribute("updatedBalance", sender.getBalance());

        req.getRequestDispatcher("/CustomerTransfer.jsp").forward(req, resp);
    }
}
