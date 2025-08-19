/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.DashboardDao;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class DashboardService {
    private final DashboardDao dao = new DashboardDao();

    public BigDecimal todayRevenue() throws SQLException { return dao.getTodayRevenue(); }
    public int billsToday() throws SQLException { return dao.countBillsToday(); }
    public int totalCustomers() throws SQLException { return dao.countCustomers(); }
    public int activeItems() throws SQLException { return dao.countActiveItems(); }
    public List<DashboardDao.BillSummary> recentBills(int limit) throws SQLException { return dao.recentBills(limit); }
}

