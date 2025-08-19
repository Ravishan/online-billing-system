package dao;

import model.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardDao {

    /** Open a connection using your existing DBConnection helper.
     *  Works whether DBConnection.getConnection() throws SQLException only
     *  or also ClassNotFoundException. */
    private Connection open() throws SQLException {
        try {
            return DBConnection.getConnection();
        } catch (Exception e) {                 // catch both SQLException / ClassNotFoundException
            if (e instanceof SQLException) {
                throw (SQLException) e;         // rethrow as-is
            }
            throw new SQLException("Failed to open DB connection", e);
        }
    }

    /** Row model for the Recent Bills table. */
    public static class BillSummary {
        public final String billNo;
        public final String customerName;
        public final Date billingDate;
        public final BigDecimal total;

        public BillSummary(String billNo, String customerName, Date billingDate, BigDecimal total) {
            this.billNo = billNo;
            this.customerName = customerName;
            this.billingDate = billingDate;
            this.total = total;
        }
    }

    /** Today’s revenue from bills.total_amount (billing_date is DATE in your schema). */
    public BigDecimal getTodayRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount),0) AS revenue " +
                     "FROM bills WHERE billing_date = CURDATE()";
        try (Connection c = open();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getBigDecimal("revenue");
        }
    }

    /** Count of bills created today. */
    public int countBillsToday() throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM bills WHERE billing_date = CURDATE()";
        try (Connection c = open();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt("cnt");
        }
    }

    /** Total customers. */
    public int countCustomers() throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM customers";
        try (Connection c = open();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt("cnt");
        }
    }

    /** Items count (no status column in your schema). */
    public int countActiveItems() throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM items";
        try (Connection c = open();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt("cnt");
        }
    }

    /** Latest N bills (formats id as B00001 for display). */
    public List<BillSummary> recentBills(int limit) throws SQLException {
        String sql =
            "SELECT CONCAT('B', LPAD(b.id, 5, '0')) AS bill_no, " +
            "       c.name AS customer_name, " +
            "       b.billing_date, " +
            "       b.total_amount AS total " +
            "FROM bills b " +
            "JOIN customers c ON c.id = b.customer_id " +
            "ORDER BY b.billing_date DESC, b.id DESC " +
            "LIMIT ?";

        try (Connection c = open();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<BillSummary> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(new BillSummary(
                        rs.getString("bill_no"),
                        rs.getString("customer_name"),
                        rs.getDate("billing_date"),
                        rs.getBigDecimal("total")
                    ));
                }
                return out;
            }
        }
    }
}
