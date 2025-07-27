package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.DBConnection;

@WebServlet("/UpdateItemServlet")
public class UpdateItemServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String itemName = request.getParameter("item_name");
            double unitPrice = Double.parseDouble(request.getParameter("unit_price"));

            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE items SET item_name = ?, unit_price = ? WHERE id = ?"
                );
                ps.setString(1, itemName);
                ps.setDouble(2, unitPrice);
                ps.setInt(3, id);
                ps.executeUpdate();

                // ✅ Redirect with success flag
                response.sendRedirect("itemList.jsp?updated=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

