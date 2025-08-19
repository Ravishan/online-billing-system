package controller;

import model.DBConnection;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/GenerateBillPDFServlet")
public class GenerateBillPDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final DecimalFormat MONEY = new DecimalFormat("#,##0.00");
    private static final SimpleDateFormat DTS   = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    /** Wrap DB helper so this servlet only deals with SQLException. */
    private Connection open() throws SQLException {
        try {
            return DBConnection.getConnection();  // whether it throws ClassNotFoundException or not, we’re safe
        } catch (Exception e) {                  // ClassNotFoundException OR any other
            if (e instanceof SQLException) throw (SQLException) e;
            throw new SQLException("Error opening DB connection", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Parse & validate bill_id
        String billIdParam = request.getParameter("bill_id");
        int billId;
        try {
            billId = Integer.parseInt(billIdParam);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid bill_id");
            return;
        }
        final String billNo = "B" + String.format("%05d", billId);

        // --- Fetch bill header BEFORE opening the PDF stream
        String customerName = null, customerId = null, customerAddr = null, customerTel = null;
        String billedAtStr  = null;
        BigDecimal totalAmount = null;

        try (Connection con = open()) {
            con.setReadOnly(true);

            String hSql =
                "SELECT b.id, b.billing_date, b.total_amount, " +
                "       c.account_number, c.name AS customer_name, c.address, c.telephone " +
                "FROM bills b JOIN customers c ON c.id = b.customer_id " +
                "WHERE b.id = ?";
            try (PreparedStatement ps = con.prepareStatement(hSql)) {
                ps.setInt(1, billId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
                        return;
                    }
                    customerId   = rs.getString("account_number");
                    customerName = rs.getString("customer_name");
                    customerAddr = rs.getString("address");
                    customerTel  = rs.getString("telephone");
                    totalAmount  = rs.getBigDecimal("total_amount");

                    // Handle DATE or TIMESTAMP
                    Date billedAt = null;
                    try {
                        Timestamp ts = rs.getTimestamp("billing_date");
                        if (ts != null) billedAt = new Date(ts.getTime());
                    } catch (Exception ignored) {}
                    if (billedAt == null) {
                        java.sql.Date d = rs.getDate("billing_date");
                        if (d != null) billedAt = new Date(d.getTime());
                    }
                    billedAtStr = (billedAt != null) ? DTS.format(billedAt) : rs.getString("billing_date");
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            return;
        }

        // --- Now stream the PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + billNo + ".pdf");

        Document doc = new Document(PageSize.A4, 36, 36, 54, 36);
        try {
            PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();

            // ====== Branding header ======
            Font title  = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLACK);
            Font h2     = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.BLACK);
            Font body   = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.DARK_GRAY);
            Font small  = new Font(Font.FontFamily.HELVETICA, 9,  Font.NORMAL, BaseColor.GRAY);
            Font badgeF = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BaseColor.WHITE);

            PdfPTable band = new PdfPTable(new float[]{2f, 1f});
            band.setWidthPercentage(100);

            PdfPCell left = new PdfPCell();
            left.setBorder(Rectangle.NO_BORDER);
            left.addElement(new Paragraph("Pahana Edu Bookshop", title));
            left.addElement(new Paragraph("Online Billing System", small));

            PdfPCell right = new PdfPCell();
            right.setBorder(Rectangle.NO_BORDER);
            right.setHorizontalAlignment(Element.ALIGN_RIGHT);

            PdfPCell badge = new PdfPCell(new Phrase("INVOICE  " + billNo, badgeF));
            badge.setHorizontalAlignment(Element.ALIGN_CENTER);
            badge.setVerticalAlignment(Element.ALIGN_MIDDLE);
            badge.setBackgroundColor(new BaseColor(53,70,167));
            badge.setBorder(Rectangle.NO_BORDER);
            badge.setPadding(8f);

            PdfPTable badgeWrap = new PdfPTable(1);
            badgeWrap.setWidthPercentage(100);
            badgeWrap.addCell(badge);

            right.addElement(badgeWrap);
            band.addCell(left);
            band.addCell(right);
            doc.add(band);

            doc.add(Chunk.NEWLINE);

            // Invoice meta + Customer details
            PdfPTable meta = new PdfPTable(new float[]{1f, 1f});
            meta.setWidthPercentage(100);

            PdfPCell metaL = new PdfPCell();
            metaL.setBorder(Rectangle.NO_BORDER);
            metaL.addElement(new Paragraph("Billed On", h2));
            metaL.addElement(new Paragraph(billedAtStr, body));
            metaL.addElement(new Paragraph("Generated", h2));
            metaL.addElement(new Paragraph(DTS.format(new Date()), body));

            PdfPCell metaR = new PdfPCell();
            metaR.setBorder(Rectangle.NO_BORDER);
            metaR.addElement(new Paragraph("Bill To", h2));

            StringBuilder cust = new StringBuilder();
            cust.append(customerName != null ? customerName : "-");
            if (customerId != null && !customerId.isEmpty()) cust.append("  (").append(customerId).append(")");
            metaR.addElement(new Paragraph(cust.toString(), body));
            if (customerAddr != null && !customerAddr.isEmpty())
                metaR.addElement(new Paragraph(customerAddr, body));
            if (customerTel != null && !customerTel.isEmpty())
                metaR.addElement(new Paragraph("Tel: " + customerTel, body));

            meta.addCell(metaL);
            meta.addCell(metaR);
            doc.add(meta);

            doc.add(Chunk.NEWLINE);

            // ====== Items table ======
            PdfPTable tbl = new PdfPTable(new float[]{4f, 2f, 1f, 2f});
            tbl.setWidthPercentage(100);

            addTh(tbl, "Item");
            addTh(tbl, "Unit Price (Rs.)");
            addTh(tbl, "Qty");
            addTh(tbl, "Line Total (Rs.)");

            int rows = 0;
            try (Connection con = open();
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT i.item_name, i.unit_price, bi.quantity, bi.line_total " +
                     "FROM bill_items bi JOIN items i ON i.id = bi.item_id " +
                     "WHERE bi.bill_id = ? ORDER BY i.item_name")) {
                ps.setInt(1, billId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        rows++;
                        String itemName = rs.getString("item_name");
                        BigDecimal up    = rs.getBigDecimal("unit_price");
                        int qty          = rs.getInt("quantity");
                        BigDecimal lt    = rs.getBigDecimal("line_total");

                        addTd(tbl, itemName, Element.ALIGN_LEFT);
                        addTd(tbl, "Rs. " + MONEY.format(up), Element.ALIGN_RIGHT);
                        addTd(tbl, String.valueOf(qty), Element.ALIGN_CENTER);
                        addTd(tbl, "Rs. " + MONEY.format(lt), Element.ALIGN_RIGHT);
                    }
                }
            } catch (SQLException e) {
                addTdSpan(tbl, "Error loading line items: " + e.getMessage(), 4);
            }

            if (rows == 0) addTdSpan(tbl, "No items for this bill.", 4);

            doc.add(tbl);
            doc.add(Chunk.NEWLINE);

            // ====== Totals ======
            PdfPTable totals = new PdfPTable(new float[]{3f, 1f});
            totals.setWidthPercentage(50);
            totals.setHorizontalAlignment(Element.ALIGN_RIGHT);

            PdfPCell k = new PdfPCell(new Phrase("Grand Total",
                    new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD)));
            k.setBorder(Rectangle.NO_BORDER);
            k.setHorizontalAlignment(Element.ALIGN_RIGHT);

            PdfPCell v = new PdfPCell(new Phrase("Rs. " + MONEY.format(totalAmount),
                    new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD)));
            v.setBorder(Rectangle.NO_BORDER);
            v.setHorizontalAlignment(Element.ALIGN_RIGHT);

            totals.addCell(k);
            totals.addCell(v);
            doc.add(totals);

            doc.add(Chunk.NEWLINE);
            doc.add(new Paragraph("Thank you for your purchase from Pahana Edu Bookshop.", small));

        } catch (Exception e) {
            // If iText already started streaming, headers are sent; best effort logging only.
            e.printStackTrace();
        } finally {
            if (doc.isOpen()) doc.close();
        }
    }

    // ---------- Helpers ----------
    private static void addTh(PdfPTable t, String text) {
        Font f = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.BLACK);
        PdfPCell c = new PdfPCell(new Phrase(text, f));
        c.setHorizontalAlignment(Element.ALIGN_LEFT);
        c.setBackgroundColor(new BaseColor(243, 246, 255));
        c.setPadding(6f);
        t.addCell(c);
    }

    private static void addTd(PdfPTable t, String text, int align) {
        Font f = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);
        PdfPCell c = new PdfPCell(new Phrase(text, f));
        c.setHorizontalAlignment(align);
        c.setPadding(6f);
        t.addCell(c);
    }

    private static void addTdSpan(PdfPTable t, String text, int span) {
        Font f = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.GRAY);
        PdfPCell c = new PdfPCell(new Phrase(text, f));
        c.setColspan(span);
        c.setHorizontalAlignment(Element.ALIGN_CENTER);
        c.setPadding(8f);
        t.addCell(c);
    }
}
