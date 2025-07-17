/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.DBConnection;

@WebServlet("/UpdateCustomerServlet")
public class UpdateCustomerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String accountNumber = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "UPDATE customers SET name = ?, address = ?, telephone = ? WHERE account_number = ?"
            );
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, telephone);
            ps.setString(4, accountNumber);
            ps.executeUpdate();

            response.sendRedirect("customerList.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("Error updating customer.");
        }
    }
}

