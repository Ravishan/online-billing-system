package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.DBConnection;

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int customerId = Integer.parseInt(request.getParameter("customer_id"));
        double totalAmount = 0;

        try (Connection con = DBConnection.getConnection()) {
            // 1. Insert initial bill record
            PreparedStatement billPs = con.prepareStatement(
                "INSERT INTO bills (customer_id, billing_date, total_amount) VALUES (?, NOW(), ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            billPs.setInt(1, customerId);
            billPs.setDouble(2, 0); // temporary
            billPs.executeUpdate();

            ResultSet generatedKeys = billPs.getGeneratedKeys();
            int billId = 0;
            if (generatedKeys.next()) {
                billId = generatedKeys.getInt(1);
            }

            // 2. Loop through items and insert bill items
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT id, unit_price FROM items");

            while (rs.next()) {
                int itemId = rs.getInt("id");
                double unitPrice = rs.getDouble("unit_price");
                String quantityParam = request.getParameter("quantity_" + itemId);

                if (quantityParam != null && !quantityParam.isEmpty()) {
                    int quantity = Integer.parseInt(quantityParam);
                    if (quantity > 0) {
                        double lineTotal = quantity * unitPrice;
                        totalAmount += lineTotal;

                        PreparedStatement itemPs = con.prepareStatement(
                            "INSERT INTO bill_items (bill_id, item_id, quantity, line_total) VALUES (?, ?, ?, ?)"
                        );
                        itemPs.setInt(1, billId);
                        itemPs.setInt(2, itemId);
                        itemPs.setInt(3, quantity);
                        itemPs.setDouble(4, lineTotal);
                        itemPs.executeUpdate();
                    }
                }
            }

            // 3. Update total amount in bill
            PreparedStatement updateTotalPs = con.prepareStatement(
                "UPDATE bills SET total_amount = ? WHERE id = ?"
            );
            updateTotalPs.setDouble(1, totalAmount);
            updateTotalPs.setInt(2, billId);
            updateTotalPs.executeUpdate();

            // ✅ Redirect to bill list with success message
            response.sendRedirect("billList.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("billList.jsp?error=1");
        }
    }
}
