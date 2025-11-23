package in.ps.bankapp.web;

import java.io.IOException;
import java.util.ArrayList;

import in.ps.bankapp.dao.CustomerDAO;
import in.ps.bankapp.dao.CustomerDAOImp;
import in.ps.bankapp.dto.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminViewCustomersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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

        CustomerDAO cdao = new CustomerDAOImp();
        ArrayList<Customer> list = cdao.getCustomer();

        req.setAttribute("customersList", list);

        req.getRequestDispatcher("/AdminViewCustomers.jsp")
                .forward(req, resp);
    }
}
