package in.ps.bankapp.web;

import java.io.IOException;
import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class AdminToggleBlockCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int cid = Integer.parseInt(req.getParameter("cid"));
        String status = req.getParameter("status");

        String newStatus = status.equalsIgnoreCase("Active") ? "Blocked" : "Active";

        CustomerDAO cdao = new CustomerDAOImp();
        cdao.toggleBlockCustomer(cid, newStatus);

        resp.sendRedirect("customers");
    }
}
