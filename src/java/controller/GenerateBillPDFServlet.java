/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/GenerateBillPDFServlet")
public class GenerateBillPDFServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billIdParam = request.getParameter("bill_id");
        if (billIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing bill_id parameter");
            return;
        }
        int billId = Integer.parseInt(billIdParam);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=bill_" + billId + ".pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_billing", "root", "");

            PreparedStatement billPs = con.prepareStatement("SELECT b.id, c.name, b.billing_date, b.total_amount FROM bills b INNER JOIN customers c ON b.customer_id = c.id WHERE b.id = ?");
            billPs.setInt(1, billId);
            ResultSet billRs = billPs.executeQuery();

            if (billRs.next()) {
                document.add(new Paragraph("Bill ID: " + billRs.getInt("id")));
                document.add(new Paragraph("Customer: " + billRs.getString("name")));
                document.add(new Paragraph("Billing Date: " + billRs.getString("billing_date")));
                document.add(new Paragraph("Total Amount: " + billRs.getDouble("total_amount")));
                document.add(new Paragraph(" "));

                PdfPTable table = new PdfPTable(4);
                table.addCell("Item Name");
                table.addCell("Unit Price");
                table.addCell("Quantity");
                table.addCell("Line Total");

                PreparedStatement itemsPs = con.prepareStatement("SELECT i.item_name, i.unit_price, bi.quantity, bi.line_total FROM bill_items bi INNER JOIN items i ON bi.item_id = i.id WHERE bi.bill_id = ?");
                itemsPs.setInt(1, billId);
                ResultSet itemsRs = itemsPs.executeQuery();

                while (itemsRs.next()) {
                    table.addCell(itemsRs.getString("item_name"));
                    table.addCell(String.valueOf(itemsRs.getDouble("unit_price")));
                    table.addCell(String.valueOf(itemsRs.getInt("quantity")));
                    table.addCell(String.valueOf(itemsRs.getDouble("line_total")));
                }

                document.add(table);
            }
            con.close();
            document.close();
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}

