package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.TransactionDAO;
import in.ps.bankapp.dao.TransactionDAOImp;
import in.ps.bankapp.dto.Customer;
import in.ps.bankapp.dto.Transaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminViewTransactionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        Customer admin = (Customer) session.getAttribute("customer");
        if (admin.getCid() != 1) {    // Only admin allowed
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        TransactionDAO tdao = new TransactionDAOImp();
        ArrayList<Transaction> list = tdao.getTransaction();

        req.setAttribute("transactionsList", list);

        req.getRequestDispatcher("/AdminViewTransactions.jsp")
           .forward(req, resp);
    }
}
