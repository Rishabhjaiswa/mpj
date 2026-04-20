package com.emp.model;

import java.sql.Date;

/**
 * Employee Model (POJO)
 * Represents a single employee record in the system.
 */
public class Employee {

    private int id;
    private String name;
    private String email;
    private String department;
    private double salary;
    private String phone;
    private Date joinedDate;

    // ── Constructors ────────────────────────────────────────────────────────────

    public Employee() {}

    public Employee(int id, String name, String email,
                    String department, double salary,
                    String phone, Date joinedDate) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.department = department;
        this.salary = salary;
        this.phone = phone;
        this.joinedDate = joinedDate;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────────

    public int getId()                    { return id; }
    public void setId(int id)             { this.id = id; }

    public String getName()               { return name; }
    public void setName(String name)      { this.name = name; }

    public String getEmail()              { return email; }
    public void setEmail(String email)    { this.email = email; }

    public String getDepartment()                   { return department; }
    public void setDepartment(String department)    { this.department = department; }

    public double getSalary()             { return salary; }
    public void setSalary(double salary)  { this.salary = salary; }

    public String getPhone()              { return phone; }
    public void setPhone(String phone)    { this.phone = phone; }

    public Date getJoinedDate()                 { return joinedDate; }
    public void setJoinedDate(Date joinedDate)  { this.joinedDate = joinedDate; }

    @Override
    public String toString() {
        return "Employee [id=" + id + ", name=" + name + ", email=" + email
                + ", department=" + department + ", salary=" + salary
                + ", phone=" + phone + ", joinedDate=" + joinedDate + "]";
    }
}
