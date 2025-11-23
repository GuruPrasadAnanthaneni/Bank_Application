package in.ps.bankapp.web;

import java.io.IOException;

import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminEditCustomerDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // ADMIN CHECK
        Customer admin = (Customer) session.getAttribute("customer");
        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // Get CID
        String cidParam = req.getParameter("cid");
        if (cidParam == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }

        int cid = Integer.parseInt(cidParam);

        CustomerDAO cdao = new CustomerDAOImp();
        Customer cust = cdao.getCustomer(cid);

        if (cust == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
            return;
        }

        req.setAttribute("customer", cust);
        req.getRequestDispatcher("/AdminEditCustomerDetails.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // LOGIN CHECK
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // ADMIN CHECK
        Customer admin = (Customer) session.getAttribute("customer");
        if (admin.getCid() != 1) {
            resp.sendRedirect(req.getContextPath() + "/SignIn.jsp");
            return;
        }

        // Read updated fields
        int cid = Integer.parseInt(req.getParameter("cid"));
        String fname = req.getParameter("fname");
        String lname = req.getParameter("lname");
        long phone = Long.parseLong(req.getParameter("phone"));
        String mail = req.getParameter("mail");
        int password = Integer.parseInt(req.getParameter("password"));
        String status = req.getParameter("status");

        // Create Customer object
        Customer c = new Customer();
        c.setCid(cid);
        c.setFirst_name(fname);
        c.setLast_name(lname);
        c.setPhone(phone);
        c.setMail(mail);
        c.setPassword(password);
        c.setStatus(status);

        CustomerDAO cdao = new CustomerDAOImp();
        boolean updated = cdao.updateCustomer(c);

        if (updated) {
            resp.sendRedirect(req.getContextPath() + "/admin/customers?success=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/edit-customer?cid=" + cid + "&error=1");
        }
    }
}
