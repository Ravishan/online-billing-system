package controller;

import model.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdateItemServlet")
public class UpdateItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam  = request.getParameter("id");
        String name     = request.getParameter("item_name");
        String priceStr = request.getParameter("unit_price");

        // Validate id
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("itemList.jsp?error=bad_id");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException nfe) {
            response.sendRedirect("itemList.jsp?error=bad_id");
            return;
        }

        // Validate name
        name = (name == null) ? "" : name.trim();
        if (name.isEmpty()) {
            response.sendRedirect("editItem.jsp?id=" + id + "&error=name_required");
            return;
        }

        // Validate price
        double unitPrice;
        try {
            unitPrice = Double.parseDouble(priceStr);
            if (unitPrice < 0) {
                response.sendRedirect("editItem.jsp?id=" + id + "&error=negative_price");
                return;
            }
        } catch (Exception e) {
            response.sendRedirect("editItem.jsp?id=" + id + "&error=invalid_price");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE items SET item_name = ?, unit_price = ? WHERE id = ?")) {

            ps.setString(1, name);
            ps.setDouble(2, unitPrice);
            ps.setInt(3, id);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                // flash for itemList.jsp
                HttpSession session = request.getSession(true);
                session.setAttribute("itemSuccess", "Item \"" + name + "\" updated.");
                response.sendRedirect("itemList.jsp?updated=1");
            } else {
                response.sendRedirect("itemList.jsp?notfound=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("editItem.jsp?id=" + id + "&error=1");
        }
    }
}
