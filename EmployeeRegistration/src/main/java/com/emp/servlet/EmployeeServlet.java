package com.emp.servlet;

import com.emp.dao.EmployeeDAO;
import com.emp.model.Employee;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * EmployeeServlet – Front Controller
 *
 * URL pattern : /employee
 * Query param  action values:
 *   list    → show all employees (default)
 *   new     → show blank registration form
 *   edit    → show pre-filled edit form  (requires ?id=N)
 *   save    → insert or update employee  (POST)
 *   delete  → delete employee            (requires ?id=N)
 *   search  → keyword search             (requires ?keyword=...)
 */
@WebServlet("/employee")
public class EmployeeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final EmployeeDAO dao = new EmployeeDAO();

    // ── GET ─────────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":    showNewForm(req, resp);      break;
            case "edit":   showEditForm(req, resp);     break;
            case "delete": deleteEmployee(req, resp);   break;
            case "search": searchEmployees(req, resp);  break;
            default:       listEmployees(req, resp);    break;
        }
    }

    // ── POST ─────────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // All form submissions go through save
        saveEmployee(req, resp);
    }

    // ── Action Handlers ──────────────────────────────────────────────────────────

    /** List all employees */
    private void listEmployees(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Employee> employees = dao.getAllEmployees();
        req.setAttribute("employees", employees);
        req.setAttribute("totalCount", employees.size());
        forward(req, resp, "/index.jsp");
    }

    /** Show blank registration form */
    private void showNewForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("employee", new Employee());
        forward(req, resp, "/register.jsp");
    }

    /** Pre-fill form for editing an existing employee */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = parseId(req);
        Employee emp = dao.getEmployeeById(id);
        if (emp == null) {
            req.setAttribute("errorMessage", "Employee with ID " + id + " not found.");
            forward(req, resp, "/error.jsp");
            return;
        }
        req.setAttribute("employee", emp);
        forward(req, resp, "/register.jsp");
    }

    /** Insert or update an employee (determined by presence of hidden 'id' field) */
    private void saveEmployee(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        boolean isNew  = (idParam == null || idParam.isBlank() || "0".equals(idParam));

        Employee emp = buildEmployeeFromRequest(req);

        boolean success;
        if (isNew) {
            success = dao.addEmployee(emp);
        } else {
            emp.setId(Integer.parseInt(idParam));
            success = dao.updateEmployee(emp);
        }

        if (success) {
            req.getSession().setAttribute("flashMessage",
                    isNew ? "Employee registered successfully!" : "Employee updated successfully!");
            resp.sendRedirect(req.getContextPath() + "/employee?action=list");
        } else {
            req.setAttribute("errorMessage", "Operation failed. Please check your input and try again.");
            req.setAttribute("employee", emp);
            forward(req, resp, "/register.jsp");
        }
    }

    /** Delete an employee by ID */
    private void deleteEmployee(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = parseId(req);
        boolean success = dao.deleteEmployee(id);

        if (success) {
            req.getSession().setAttribute("flashMessage", "Employee deleted successfully.");
        } else {
            req.getSession().setAttribute("flashError", "Failed to delete employee with ID " + id + ".");
        }
        resp.sendRedirect(req.getContextPath() + "/employee?action=list");
    }

    /** Keyword search */
    private void searchEmployees(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        List<Employee> employees = (keyword != null && !keyword.isBlank())
                ? dao.searchEmployees(keyword.trim())
                : dao.getAllEmployees();

        req.setAttribute("employees", employees);
        req.setAttribute("totalCount", employees.size());
        req.setAttribute("searchKeyword", keyword);
        forward(req, resp, "/index.jsp");
    }

    // ── Utility Methods ──────────────────────────────────────────────────────────

    private Employee buildEmployeeFromRequest(HttpServletRequest req) {
        Employee emp = new Employee();
        emp.setName      (req.getParameter("name"));
        emp.setEmail     (req.getParameter("email"));
        emp.setDepartment(req.getParameter("department"));
        emp.setPhone     (req.getParameter("phone"));

        String salStr = req.getParameter("salary");
        try {
            emp.setSalary(salStr != null && !salStr.isBlank()
                    ? Double.parseDouble(salStr) : 0.0);
        } catch (NumberFormatException ignored) {
            emp.setSalary(0.0);
        }

        String dateStr = req.getParameter("joinedDate");
        if (dateStr != null && !dateStr.isBlank()) {
            try { emp.setJoinedDate(Date.valueOf(dateStr)); }
            catch (IllegalArgumentException ignored) {}
        }
        return emp;
    }

    private int parseId(HttpServletRequest req) {
        try { return Integer.parseInt(req.getParameter("id")); }
        catch (NumberFormatException e) { return 0; }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher(path);
        rd.forward(req, resp);
    }
}
