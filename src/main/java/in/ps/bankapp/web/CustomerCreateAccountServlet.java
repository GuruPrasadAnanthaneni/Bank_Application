package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CustomerCreateAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        req.getRequestDispatcher("/CustomerCreateAccount.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        Customer cust = (Customer) session.getAttribute("customer");
        String accType = req.getParameter("accType");

        // 🚫 CUSTOMER STATUS CHECK (NEW LOGIC)
        if (cust.getStatus().equalsIgnoreCase("Pending")) {
            req.setAttribute("msg",
                "⛔ Your customer profile is still pending. You cannot create any account until admin approves your profile.");
            req.getRequestDispatcher("/CustomerCreateAccount.jsp").forward(req, resp);
            return;
        }

        if (cust.getStatus().equalsIgnoreCase("Blocked")) {
            req.setAttribute("msg",
                "🚫 Your customer profile is blocked. You are not allowed to open any accounts.");
            req.getRequestDispatcher("/CustomerCreateAccount.jsp").forward(req, resp);
            return;
        }

        // FETCH ACCOUNTS
        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> accounts = adao.getAccountByCustomerId(cust.getCid());

        for (Account a : accounts) {
            if (a.getAccount_type().equalsIgnoreCase(accType)) {
                req.setAttribute("msg",
                    "⚠️ You already have a " + accType.toUpperCase() + " account.");
                req.getRequestDispatcher("/CustomerCreateAccount.jsp")
                        .forward(req, resp);
                return;
            }
        }

        long accNo = generateAccountNumber();

        Account acc = new Account();
        acc.setAccount_number(accNo);
        acc.setCustomer_id(cust.getCid());
        acc.setAccount_type(accType.toUpperCase());
        acc.setBalance(0.0);
        acc.setStatus("Pending");

        boolean created = adao.insertAccount(acc);

        if (created) {
            req.setAttribute("msg",
                "🎉 Your " + accType.toUpperCase() +
                " account request has been successfully submitted! Please wait for admin approval.");
        } else {
            req.setAttribute("msg",
                "⚠️ Something went wrong while creating your " + accType.toUpperCase() + " account.");
        }

        req.getRequestDispatcher("/CustomerCreateAccount.jsp")
                .forward(req, resp);
    }

    private long generateAccountNumber() {
        return 1000000000L + (long) (Math.random() * 9000000000L);
    }
}
