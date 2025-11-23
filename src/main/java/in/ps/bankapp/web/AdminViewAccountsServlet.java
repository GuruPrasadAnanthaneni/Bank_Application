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

public class AdminViewAccountsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("AdminViewAccountsServlet CALLED");

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        Customer admin = (Customer) session.getAttribute("customer");

        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        AccountDAO adao = new AccountDAOImp();
        ArrayList<Account> list = adao.getAccount();  // Make sure this returns all accounts

        req.setAttribute("accountsList", list);

        req.getRequestDispatcher("/AdminViewAccounts.jsp").forward(req, resp);
    }
}
