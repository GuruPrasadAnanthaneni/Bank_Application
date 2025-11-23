package in.ps.bankapp.web;

import java.io.IOException;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@WebServlet("/sendMessage")
public class SendMessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Read form data
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String subject = req.getParameter("subject");
        String message = req.getParameter("message");

        // Gmail used to send mail
        String from = "nexusbankhelpdesk@gmail.com";
        String password = "ppur yzjw yctk aqod"; // App password

        // Receiver (your own inbox)
        String to = "nexusbankhelpdesk@gmail.com";

        // Gmail SMTP Settings
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Authenticate Gmail
        Session session = Session.getInstance(props,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                }
        );

        try {
            // Construct email
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, "NexusBank Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject("Contact Form Message: " + subject);

            String emailBody =
                "New message received from Contact Form:\n\n" +
                "-----------------------------------------\n" +
                "Name    : " + name + "\n" +
                "Email   : " + email + "\n" +
                "Subject : " + subject + "\n\n" +
                "Message:\n" + message +
                "\n-----------------------------------------\n";

            msg.setText(emailBody);

            // Send Email
            Transport.send(msg);

            req.setAttribute("mailStatus", "success");
            req.setAttribute("msg", "Message Sent Successfully!");

        } catch (MessagingException e) {
            e.printStackTrace();

            req.setAttribute("mailStatus", "fail");
            req.setAttribute("msg", "Failed to send message. Please try again.");
        }

        // Forward back to same contact page
        req.getRequestDispatcher("BankDashboard.jsp").forward(req, resp);
    }
}
