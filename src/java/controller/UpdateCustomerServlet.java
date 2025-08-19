package controller;

import model.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdateCustomerServlet")
public class UpdateCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String accountNumber = request.getParameter("accountNumber");
        String name          = request.getParameter("name");
        String address       = request.getParameter("address");
        String telephone     = request.getParameter("telephone");

        // Basic guard: need a key to update
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            response.sendRedirect("customerList.jsp?error=missing_key");
            return;
        }

        // Normalize inputs
        accountNumber = accountNumber.trim();
        name      = name == null ? "" : name.trim();
        address   = address == null ? "" : address.trim();
        telephone = telephone == null ? "" : telephone.trim();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "UPDATE customers SET name = ?, address = ?, telephone = ? WHERE account_number = ?")) {

            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, telephone);
            ps.setString(4, accountNumber);

            int updated = ps.executeUpdate();

            HttpSession session = request.getSession(true);
            if (updated > 0) {
                session.setAttribute("customerSuccess", "Customer \"" + accountNumber + "\" updated successfully.");
                response.sendRedirect("customerList.jsp?updated=1");
            } else {
                session.setAttribute("customerSuccess", "Customer \"" + accountNumber + "\" was not found.");
                response.sendRedirect("customerList.jsp?notfound=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String acc = URLEncoder.encode(accountNumber, StandardCharsets.UTF_8.name());
            response.sendRedirect("editCustomer.jsp?accountNumber=" + acc + "&error=1");
        }
    }
}
