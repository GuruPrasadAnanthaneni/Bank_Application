package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.AccountDAO;
import in.ps.bankapp.dao.AccountDAOImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminApproveAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // ADMIN CHECK (cid = 1)
        in.ps.bankapp.dto.Customer admin =
                (in.ps.bankapp.dto.Customer) session.getAttribute("customer");

        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        int accId = Integer.parseInt(req.getParameter("accId"));

        AccountDAO dao = new AccountDAOImp();
        boolean status = dao.approveAccount(accId);

        if (status) {
            resp.sendRedirect(req.getContextPath() + "/admin/pending-accounts?success=approved");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/pending-accounts?error=db");
        }
    }
}
