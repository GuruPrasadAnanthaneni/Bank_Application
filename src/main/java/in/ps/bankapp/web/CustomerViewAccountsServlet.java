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

public class CustomerViewAccountsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        Customer c = (Customer) session.getAttribute("customer");

        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> accounts = adao.getAccountByCustomerId(c.getCid());

        req.setAttribute("accountsList", accounts);

        // highlight active sidebar
        req.setAttribute("activePage", "accounts");

        req.getRequestDispatcher("/CustomerViewAccounts.jsp")
           .forward(req, resp);
    }
}
