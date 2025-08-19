package controller;

import model.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String custIdStr = request.getParameter("customer_id");
        if (custIdStr == null || custIdStr.isBlank()) {
            response.sendRedirect("addBill.jsp?error=invalid_customer");
            return;
        }

        int customerId;
        try {
            customerId = Integer.parseInt(custIdStr.trim());
        } catch (NumberFormatException nfe) {
            response.sendRedirect("addBill.jsp?error=invalid_customer");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1) Ensure customer exists
            boolean customerExists = false;
            try (PreparedStatement chk = con.prepareStatement("SELECT 1 FROM customers WHERE id = ?")) {
                chk.setInt(1, customerId);
                try (ResultSet rs = chk.executeQuery()) {
                    customerExists = rs.next();
                }
            }
            if (!customerExists) {
                con.rollback();
                response.sendRedirect("addBill.jsp?error=invalid_customer");
                return;
            }

            // 2) Create bill shell (use NOW(); if your column is DATE, MySQL stores date part)
            int billId;
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO bills (customer_id, billing_date, total_amount) VALUES (?, NOW(), ?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.setBigDecimal(2, BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP));
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) {
                        con.rollback();
                        response.sendRedirect("addBill.jsp?error=1");
                        return;
                    }
                    billId = keys.getInt(1);
                }
            }

            // 3) Insert bill items for any quantity > 0
            BigDecimal grandTotal = BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
            int lines = 0;

            try (PreparedStatement allItems = con.prepareStatement(
                     "SELECT id, unit_price FROM items ORDER BY id");
                 ResultSet rsItems = allItems.executeQuery()) {

                while (rsItems.next()) {
                    int itemId = rsItems.getInt("id");
                    BigDecimal unitPrice = rsItems.getBigDecimal("unit_price");
                    if (unitPrice == null) unitPrice = BigDecimal.ZERO;
                    unitPrice = unitPrice.setScale(2, RoundingMode.HALF_UP);

                    String qParam = request.getParameter("quantity_" + itemId);
                    if (qParam == null || qParam.isBlank()) continue;

                    int qty;
                    try {
                        qty = Integer.parseInt(qParam.trim());
                    } catch (NumberFormatException ignored) {
                        continue;
                    }
                    if (qty <= 0) continue;

                    BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(qty))
                            .setScale(2, RoundingMode.HALF_UP);

                    try (PreparedStatement ins = con.prepareStatement(
                            "INSERT INTO bill_items (bill_id, item_id, quantity, line_total) VALUES (?, ?, ?, ?)")) {
                        ins.setInt(1, billId);
                        ins.setInt(2, itemId);
                        ins.setInt(3, qty);
                        ins.setBigDecimal(4, lineTotal);
                        ins.executeUpdate();
                    }

                    grandTotal = grandTotal.add(lineTotal).setScale(2, RoundingMode.HALF_UP);
                    lines++;
                }
            }

            // No items selected → delete shell and bounce back
            if (lines == 0) {
                try (PreparedStatement del = con.prepareStatement("DELETE FROM bills WHERE id = ?")) {
                    del.setInt(1, billId);
                    del.executeUpdate();
                }
                con.commit();
                response.sendRedirect("addBill.jsp?error=no_items");
                return;
            }

            // 4) Update bill total
            try (PreparedStatement upd = con.prepareStatement(
                    "UPDATE bills SET total_amount = ? WHERE id = ?")) {
                upd.setBigDecimal(1, grandTotal);
                upd.setInt(2, billId);
                upd.executeUpdate();
            }

            con.commit();

            // 5) Flash + redirect to list
            HttpSession session = request.getSession(true);
            session.setAttribute("billSuccess",
                    "Bill B" + String.format("%05d", billId) + " created (Rs. " + grandTotal + ").");
            response.sendRedirect("billList.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (Exception ignore) {}
            }
            response.sendRedirect("addBill.jsp?error=1");
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (Exception ignore) {}
            }
        }
    }
}
