package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;
import in.ps.bankapp.dto.Account;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/select-account")
public class SelectAccountTypeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String mail = req.getParameter("mail");
        String type = req.getParameter("accType");

        // BASIC VALIDATION
        if (mail == null || mail.isEmpty() || type == null || type.equals("Select Account Type")) {
            req.setAttribute("msg", "⚠️ Please enter email and select an account type.");
            req.getRequestDispatcher("AccountType.jsp").forward(req, resp);
            return;
        }

        // FETCH CUSTOMER USING EMAIL
        CustomerDAO cdao = new CustomerDAOImp();
        Customer customer = cdao.getCustomer(mail);

        if (customer == null) {
            req.setAttribute("msg", "❌ Email not registered. Please register first.");
            req.getRequestDispatcher("AccountType.jsp").forward(req, resp);
            return;
        }

        // 🚫 CUSTOMER STATUS CHECK (NEW LOGIC)
        if (customer.getStatus().equalsIgnoreCase("Pending")) {
            req.setAttribute("msg",
                "⛔ Your customer profile is still under verification. You cannot create an account until admin approves you.");
            req.getRequestDispatcher("AccountType.jsp").forward(req, resp);
            return;
        }

        if (customer.getStatus().equalsIgnoreCase("Blocked")) {
            req.setAttribute("msg",
                "🚫 Your customer profile is blocked. You cannot open any new accounts.");
            req.getRequestDispatcher("AccountType.jsp").forward(req, resp);
            return;
        }

        // FETCH CUSTOMER ACCOUNTS
        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> accounts = adao.getAccountByCustomerId(customer.getCid());

        boolean alreadyExists = false;

        for (Account a : accounts) {
            if (a.getAccount_type().equalsIgnoreCase(type)) {
                alreadyExists = true;
                break;
            }
        }

        // ACCOUNT ALREADY EXISTS
        if (alreadyExists) {
            req.setAttribute("msg",
                "⚠️ You already have a " + type.toUpperCase() + " account.");
            req.getRequestDispatcher("AccountType.jsp").forward(req, resp);
            return;
        }

        // CREATE NEW ACCOUNT REQUEST
        long accNo = generateAccountNumber();

        Account acc = new Account();
        acc.setAccount_number(accNo);
        acc.setCustomer_id(customer.getCid());
        acc.setAccount_type(type.toUpperCase());
        acc.setBalance(0.00);
        acc.setStatus("Pending"); // waiting for admin approval

        boolean result = adao.insertAccount(acc);

        if (result) {
            req.setAttribute("msg",
                "🎉 Your " + type.toUpperCase() +
                " account request has been submitted! Please wait for admin approval.");
        } else {
            req.setAttribute("msg",
                "⚠️ Something went wrong while creating your account. Please try again.");
        }

        req.getRequestDispatcher("AccountType.jsp").forward(req, resp);
    }

    // Generate 10-digit account number
    private long generateAccountNumber() {
        return 1000000000L + (long) (Math.random() * 9000000000L);
    }
}
