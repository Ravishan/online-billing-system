/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.DBConnection;

@WebServlet("/DeleteBillServlet")
public class DeleteBillServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int billId = Integer.parseInt(request.getParameter("bill_id"));

            try (Connection con = DBConnection.getConnection()) {
                // First delete bill_items
                PreparedStatement ps1 = con.prepareStatement("DELETE FROM bill_items WHERE bill_id = ?");
                ps1.setInt(1, billId);
                ps1.executeUpdate();

                // Then delete the bill
                PreparedStatement ps2 = con.prepareStatement("DELETE FROM bills WHERE id = ?");
                ps2.setInt(1, billId);
                ps2.executeUpdate();

                response.sendRedirect("billList.jsp?deleted=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("billList.jsp?error=1");
        }
    }
}

