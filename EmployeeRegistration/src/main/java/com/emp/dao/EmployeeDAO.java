package com.emp.dao;

import com.emp.model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * EmployeeDAO – Database Access Object
 *
 * ── Database Configuration ──
 * Currently wired to H2 (embedded, zero-install) so the app runs out of the box.
 * The DB file is stored at: ~/empdb (i.e. C:\Users\<you>\empdb.mv.db)
 *
 * To switch to MySQL:
 *   1. Comment the H2 block and uncomment the MySQL block below.
 *   2. Swap the dependency in pom.xml.
 *   3. Run database_setup.sql in MySQL.
 */
public class EmployeeDAO {

    // ── H2 Embedded (default – no installation required) ────────────────────────
    private static final String JDBC_URL  =
            "jdbc:h2:~/empdb;AUTO_SERVER=TRUE;DB_CLOSE_DELAY=-1";
    private static final String JDBC_USER = "sa";
    private static final String JDBC_PASS = "";

    // ── MySQL (uncomment to switch) ──────────────────────────────────────────────
    // private static final String JDBC_URL  =
    //         "jdbc:mysql://localhost:3306/empdb?useSSL=false&serverTimezone=UTC";
    // private static final String JDBC_USER = "root";
    // private static final String JDBC_PASS = "root";  // ← your password

    // ── Static Block: Load driver + initialise schema ───────────────────────────
    static {
        try {
            // H2 driver
            Class.forName("org.h2.Driver");
            // For MySQL, replace with: Class.forName("com.mysql.cj.jdbc.Driver");

            // Create table and seed data if not already present
            initDatabase();
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("JDBC Driver not found: " + e.getMessage());
        }
    }

    /** Creates the employees table and inserts sample rows (H2 compatible). */
    private static void initDatabase() {
        String createTable =
            "CREATE TABLE IF NOT EXISTS employees (" +
            "  id          INT AUTO_INCREMENT PRIMARY KEY," +
            "  name        VARCHAR(100) NOT NULL," +
            "  email       VARCHAR(100) NOT NULL UNIQUE," +
            "  department  VARCHAR(50)  DEFAULT 'General'," +
            "  salary      DOUBLE       DEFAULT 0," +
            "  phone       VARCHAR(15)  DEFAULT NULL," +
            "  joined_date DATE         DEFAULT NULL" +
            ")";

        String seedData =
            "MERGE INTO employees (name, email, department, salary, phone, joined_date) KEY(email) VALUES " +
            "('Aarav Sharma',  'aarav.sharma@company.com',  'Engineering',     75000, '9876543210', '2022-06-01')," +
            "('Priya Verma',   'priya.verma@company.com',   'Human Resources', 55000, '9123456789', '2021-03-15')," +
            "('Rohit Mehta',   'rohit.mehta@company.com',   'Finance',         82000, '9988776655', '2020-11-20')," +
            "('Sneha Patel',   'sneha.patel@company.com',   'Marketing',       60000, '9871234560', '2023-01-10')," +
            "('Vikram Singh',  'vikram.singh@company.com',  'Sales',           65000, '9765432109', '2019-08-05')," +
            "('Ananya Iyer',   'ananya.iyer@company.com',   'Product',         90000, '9654321098', '2022-09-12')," +
            "('Kiran Joshi',   'kiran.joshi@company.com',   'Design',          70000, '9543210987', '2021-07-22')," +
            "('Meera Nair',    'meera.nair@company.com',    'Operations',      58000, '9432109876', '2020-04-18')";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             Statement  stmt = conn.createStatement()) {
            stmt.execute(createTable);
            stmt.execute(seedData);
        } catch (SQLException e) {
            System.err.println("[EmployeeDAO] DB init error: " + e.getMessage());
        }
    }

    // ── Helper: Get Connection ──────────────────────────────────────────────────
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
    }

    // ── CREATE ──────────────────────────────────────────────────────────────────
    public boolean addEmployee(Employee emp) {
        String sql = "INSERT INTO employees (name, email, department, salary, phone, joined_date) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, emp.getName());
            ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getDepartment());
            ps.setDouble(4, emp.getSalary());
            ps.setString(5, emp.getPhone());
            ps.setDate  (6, emp.getJoinedDate());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── READ ALL ────────────────────────────────────────────────────────────────
    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY name";
        try (Connection conn = getConnection();
             Statement  stmt = conn.createStatement();
             ResultSet  rs   = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── READ ONE ────────────────────────────────────────────────────────────────
    public Employee getEmployeeById(int id) {
        String sql = "SELECT * FROM employees WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── UPDATE ──────────────────────────────────────────────────────────────────
    public boolean updateEmployee(Employee emp) {
        String sql = "UPDATE employees SET name=?, email=?, department=?, "
                   + "salary=?, phone=?, joined_date=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getName());
            ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getDepartment());
            ps.setDouble(4, emp.getSalary());
            ps.setString(5, emp.getPhone());
            ps.setDate  (6, emp.getJoinedDate());
            ps.setInt   (7, emp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── DELETE ──────────────────────────────────────────────────────────────────
    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM employees WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── SEARCH ──────────────────────────────────────────────────────────────────
    public List<Employee> searchEmployees(String keyword) {
        List<Employee> list = new ArrayList<>();
        String pattern = "%" + keyword.toLowerCase() + "%";
        String sql = "SELECT * FROM employees "
                   + "WHERE LOWER(name) LIKE ? OR LOWER(email) LIKE ? OR LOWER(department) LIKE ? "
                   + "ORDER BY name";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Private Helper ──────────────────────────────────────────────────────────
    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setId        (rs.getInt   ("id"));
        e.setName      (rs.getString("name"));
        e.setEmail     (rs.getString("email"));
        e.setDepartment(rs.getString("department"));
        e.setSalary    (rs.getDouble("salary"));
        e.setPhone     (rs.getString("phone"));
        e.setJoinedDate(rs.getDate  ("joined_date"));
        return e;
    }
}
