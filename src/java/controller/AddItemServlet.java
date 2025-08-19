package controller;

import model.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AddItemServlet")
public class AddItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemName     = request.getParameter("item_name");
        String priceStr     = request.getParameter("unit_price");
        String redirectFlag = request.getParameter("redirect"); // optional: "dashboard" or "list"

        // Basic validation
        itemName = itemName == null ? "" : itemName.trim();
        if (itemName.isEmpty()) {
            response.sendRedirect("addItems.jsp?error=name_required");
            return;
        }

        double unitPrice;
        try {
            unitPrice = Double.parseDouble(priceStr);
            if (unitPrice < 0) {
                response.sendRedirect("addItems.jsp?error=negative_price");
                return;
            }
        } catch (Exception nfe) {
            response.sendRedirect("addItems.jsp?error=invalid_price");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO items (item_name, unit_price) VALUES (?, ?)")
        ) {
            ps.setString(1, itemName);
            ps.setDouble(2, unitPrice);
            ps.executeUpdate();

            // Flash message for UI
            HttpSession session = request.getSession(true);
            session.setAttribute("itemSuccess", "Item \"" + itemName + "\" added successfully.");

            // Redirect: default to Item List; allow optional dashboard redirect
            if ("dashboard".equalsIgnoreCase(redirectFlag)) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                response.sendRedirect("itemList.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addItems.jsp?error=1");
        }
    }
}
