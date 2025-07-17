package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.DBConnection;

@WebServlet("/AddItemServlet")
public class AddItemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemName = request.getParameter("item_name");
        double unitPrice = Double.parseDouble(request.getParameter("unit_price"));

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO items (item_name, unit_price) VALUES (?, ?)");
            ps.setString(1, itemName);
            ps.setDouble(2, unitPrice);
            ps.executeUpdate();
            response.sendRedirect("itemList.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
