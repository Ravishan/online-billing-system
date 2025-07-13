/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import model.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddCustomerServlet")
public class AddCustomerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String accountNumber = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO customers (account_number, name, address, telephone) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, accountNumber);
            ps.setString(2, name);
            ps.setString(3, address);
            ps.setString(4, telephone);

            ps.executeUpdate();
            response.sendRedirect("customerList.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addCustomer.jsp?error=1");
        }
    }
}

