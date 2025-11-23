package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import in.ps.bankapp.dao.TransactionDAO;
import in.ps.bankapp.dao.TransactionDAOImp;
import in.ps.bankapp.dto.Account;
import in.ps.bankapp.dto.Customer;
import in.ps.bankapp.dto.Transaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CustomerPassbookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Customer c = (session != null)
                ? (Customer) session.getAttribute("customer")
                : null;

        if (c == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> accounts = adao.getAccountByCustomerId(c.getCid());
        req.setAttribute("accountsList", accounts);

        // if user has selected accountNo, fetch transactions
        String accNoStr = req.getParameter("accNo");
        if (accNoStr != null && !accNoStr.isEmpty()) {
            long accNo = Long.parseLong(accNoStr);
            TransactionDAO tdao = new TransactionDAOImp();
            ArrayList<Transaction> txns = tdao.getTransactionByCustomerAccno(accNo);
            req.setAttribute("txnList", txns);
            req.setAttribute("selectedAccNo", accNoStr);
        }

        req.getRequestDispatcher("/CustomerPassbook.jsp")
           .forward(req, resp);
    }
}
