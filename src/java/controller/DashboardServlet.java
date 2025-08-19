/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import service.DashboardService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private transient DashboardService svc;

    @Override
    public void init() {
        svc = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Always fetch fresh values (avoid browser/proxy caching)
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");

        try {
            // KPI counters
            req.setAttribute("todayRevenue",   svc.todayRevenue());     // BigDecimal
            req.setAttribute("billsToday",     svc.billsToday());       // int
            req.setAttribute("totalCustomers", svc.totalCustomers());   // int
            req.setAttribute("activeItems",    svc.activeItems());      // int

            // Recent bills list
            req.setAttribute("recentBills",    svc.recentBills(10));    // List<DashboardDao.BillSummary>
        } catch (Exception e) {
            // Log for debugging and show a friendly ribbon on the page
            e.printStackTrace();
            req.setAttribute("dashError", "Failed to load live stats: " + e.getMessage());
        }

        forward(req, resp, "/dashboard.jsp");
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }
}

