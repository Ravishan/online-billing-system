package controller;

import model.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteCustomerServlet")
public class DeleteCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws IOException { handle(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException { handle(req, resp); }

    private void handle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String accountNumber = request.getParameter("accountNumber");
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            response.sendRedirect("customerList.jsp?error=missing_key");
            return;
        }
        accountNumber = accountNumber.trim();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "DELETE FROM customers WHERE account_number = ?")) {

            ps.setString(1, accountNumber);
            int deleted = ps.executeUpdate();

            if (deleted > 0) {
                // success flash message
                HttpSession session = request.getSession(true);
                session.setAttribute("customerSuccess", "Customer \"" + accountNumber + "\" deleted.");
                response.sendRedirect("customerList.jsp?deleted=1");
            } else {
                response.sendRedirect("customerList.jsp?notfound=1");
            }

        } catch (SQLException e) {
            // If there’s a FK constraint (e.g., bills referencing this customer), MySQL uses SQLState 23000
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect("customerList.jsp?blocked=1");
            } else {
                e.printStackTrace();
                response.sendRedirect("customerList.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customerList.jsp?error=1");
        }
    }
}
