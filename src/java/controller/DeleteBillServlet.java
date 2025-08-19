package controller;

import model.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteBillServlet")
public class DeleteBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Enforce POST-only
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect("billList.jsp?error=bad_method");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("bill_id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("billList.jsp?error=bad_id");
            return;
        }

        final int billId;
        try {
            billId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException nfe) {
            response.sendRedirect("billList.jsp?error=bad_id");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1) Ensure bill exists (and compute display bill no)
            boolean exists = false;
            try (PreparedStatement ps = con.prepareStatement("SELECT id FROM bills WHERE id = ?")) {
                ps.setInt(1, billId);
                try (ResultSet rs = ps.executeQuery()) {
                    exists = rs.next();
                }
            }
            if (!exists) {
                con.rollback();
                response.sendRedirect("billList.jsp?notfound=1");
                return;
            }

            // 2) Delete children then parent
            try (PreparedStatement delItems = con.prepareStatement(
                     "DELETE FROM bill_items WHERE bill_id = ?")) {
                delItems.setInt(1, billId);
                delItems.executeUpdate();
            }

            int deleted;
            try (PreparedStatement delBill = con.prepareStatement(
                     "DELETE FROM bills WHERE id = ?")) {
                delBill.setInt(1, billId);
                deleted = delBill.executeUpdate();
            }

            if (deleted == 0) {
                con.rollback();
                response.sendRedirect("billList.jsp?notfound=1");
                return;
            }

            con.commit();

            // 3) Flash + redirect
            HttpSession session = request.getSession(true);
            session.setAttribute("billSuccess", "Bill B" + String.format("%05d", billId) + " deleted.");
            response.sendRedirect("billList.jsp?deleted=1");

        } catch (SQLException e) {
            // FK violations etc.
            try { if (con != null) con.rollback(); } catch (Exception ignore) {}
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect("billList.jsp?blocked=1");
            } else {
                e.printStackTrace();
                response.sendRedirect("billList.jsp?error=1");
            }
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ignore) {}
            e.printStackTrace();
            response.sendRedirect("billList.jsp?error=1");
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (Exception ignore) {}
            }
        }
    }
}
