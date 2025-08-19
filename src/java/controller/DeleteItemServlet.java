package controller;

import model.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Enforce POST-only deletes
    @Override protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect("itemList.jsp?error=bad_method");
    }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
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

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // 1) Get item name (and existence check)
            String itemName = null;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT item_name FROM items WHERE id = ?")) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) itemName = rs.getString("item_name");
                }
            }
            if (itemName == null) {
                con.rollback();
                response.sendRedirect("itemList.jsp?notfound=1");
                return;
            }

            // 2) Check references in bill_items
            int used = 0;
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM bill_items WHERE item_id = ?")) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) used = rs.getInt(1);
                }
            }
            if (used > 0) {
                con.rollback();
                response.sendRedirect("itemList.jsp?blocked=1");
                return;
            }

            // 3) Safe to delete
            int deleted;
            try (PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM items WHERE id = ?")) {
                ps.setInt(1, id);
                deleted = ps.executeUpdate();
            }

            con.commit();

            if (deleted > 0) {
                HttpSession session = request.getSession(true);
                session.setAttribute("itemSuccess", "Item \"" + itemName + "\" deleted.");
                response.sendRedirect("itemList.jsp?deleted=1");
            } else {
                response.sendRedirect("itemList.jsp?notfound=1");
            }

        } catch (SQLException e) {
            // Foreign key violation (if FK exists) → SQLState 23000
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect("itemList.jsp?blocked=1");
            } else {
                e.printStackTrace();
                response.sendRedirect("itemList.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("itemList.jsp?error=1");
        }
    }
}
