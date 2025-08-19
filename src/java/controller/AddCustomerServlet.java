/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

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

/**
 * Handles adding new customers.
 */
@WebServlet("/AddCustomerServlet")
public class AddCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String accountNumber = request.getParameter("accountNumber");
        String name          = request.getParameter("name");
        String address       = request.getParameter("address");
        String telephone     = request.getParameter("telephone");
        String redirectFlag  = request.getParameter("redirect"); // optional: "dashboard" or "list"

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO customers (account_number, name, address, telephone) VALUES (?, ?, ?, ?)"
             )) {

            ps.setString(1, accountNumber);
            ps.setString(2, name);
            ps.setString(3, address);
            ps.setString(4, telephone);
            ps.executeUpdate();

            // Flash success message
            HttpSession session = request.getSession(true);
            session.setAttribute("customerSuccess", "Customer \"" + name + "\" added successfully.");

            // Redirect: default -> Customer List; optional -> dashboard if redirect=dashboard
            if ("dashboard".equalsIgnoreCase(redirectFlag)) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                response.sendRedirect("customerList.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addCustomer.jsp?error=1");
        }
    }
}



