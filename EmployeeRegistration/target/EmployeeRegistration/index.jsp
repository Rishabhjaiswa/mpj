<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Employee Registry | Dashboard</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>

<!-- ── Sidebar Navigation ────────────────────────────────────────── -->
<aside class="sidebar">
  <div class="sidebar-brand">
    <div class="brand-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
        <circle cx="9" cy="7" r="4"/>
        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
      </svg>
    </div>
    <div>
      <div class="brand-name">EmpReg</div>
      <div class="brand-sub">HR Portal</div>
    </div>
  </div>
  <nav class="sidebar-nav">
    <a href="${pageContext.request.contextPath}/employee?action=list" class="nav-item active">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
      Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/employee?action=new" class="nav-item">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></svg>
      Add Employee
    </a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-avatar">A</div>
    <div>
      <div class="user-name">Admin</div>
      <div class="user-role">HR Manager</div>
    </div>
  </div>
</aside>

<!-- ── Main Content ──────────────────────────────────────────────── -->
<main class="main-content">

  <!-- Header -->
  <header class="page-header">
    <div>
      <h1 class="page-title">Employee Directory</h1>
      <p class="page-subtitle">Manage your workforce records</p>
    </div>
    <a href="${pageContext.request.contextPath}/employee?action=new" class="btn btn-primary">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      Add Employee
    </a>
  </header>

  <!-- Flash Messages -->
  <c:if test="${not empty sessionScope.flashMessage}">
    <div class="alert alert-success">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      ${sessionScope.flashMessage}
    </div>
    <c:remove var="flashMessage" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.flashError}">
    <div class="alert alert-danger">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      ${sessionScope.flashError}
    </div>
    <c:remove var="flashError" scope="session"/>
  </c:if>

  <!-- Stats Cards -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-icon purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
      <div class="stat-info">
        <div class="stat-value">${totalCount}</div>
        <div class="stat-label">Total Employees</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg></div>
      <div class="stat-info">
        <div class="stat-value">
          <c:set var="deptCount" value="0"/>
          <%-- Count distinct departments via JSTL workaround --%>
          <c:forEach var="emp" items="${employees}" varStatus="loop">
            <c:if test="${loop.first}"><c:set var="deptCount" value="1"/></c:if>
          </c:forEach>
          ${totalCount gt 0 ? 'Active' : '—'}
        </div>
        <div class="stat-label">Status</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
      <div class="stat-info">
        <div class="stat-value">
          <c:set var="totalSal" value="0"/>
          <c:forEach var="emp" items="${employees}">
            <c:set var="totalSal" value="${totalSal + emp.salary}"/>
          </c:forEach>
          <fmt:formatNumber value="${totalSal}" type="number" maxFractionDigits="0"/>
        </div>
        <div class="stat-label">Total Payroll (₹)</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon orange"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg></div>
      <div class="stat-info">
        <div class="stat-value">Multiple</div>
        <div class="stat-label">Departments</div>
      </div>
    </div>
  </div>

  <!-- Search Bar -->
  <div class="search-section">
    <form action="${pageContext.request.contextPath}/employee" method="get" class="search-form">
      <input type="hidden" name="action" value="search"/>
      <div class="search-input-wrap">
        <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        <input type="text" name="keyword" id="searchInput"
               placeholder="Search by name, email or department…"
               value="${not empty searchKeyword ? searchKeyword : ''}"
               class="search-input" autocomplete="off"/>
        <button type="submit" class="btn btn-search">Search</button>
        <c:if test="${not empty searchKeyword}">
          <a href="${pageContext.request.contextPath}/employee?action=list" class="btn btn-clear">Clear</a>
        </c:if>
      </div>
    </form>
  </div>

  <!-- Employee Table -->
  <div class="table-card">
    <div class="table-header">
      <h2 class="table-title">
        <c:choose>
          <c:when test="${not empty searchKeyword}">
            Results for "<em>${fn:escapeXml(searchKeyword)}</em>"
          </c:when>
          <c:otherwise>All Employees</c:otherwise>
        </c:choose>
      </h2>
      <span class="badge">${totalCount} records</span>
    </div>

    <c:choose>
      <c:when test="${empty employees}">
        <div class="empty-state">
          <div class="empty-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          </div>
          <h3>No employees found</h3>
          <p>Get started by adding your first employee.</p>
          <a href="${pageContext.request.contextPath}/employee?action=new" class="btn btn-primary">Add Employee</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="table-responsive">
          <table class="data-table" id="employeeTable">
            <thead>
              <tr>
                <th>#</th>
                <th>Name</th>
                <th>Email</th>
                <th>Department</th>
                <th>Phone</th>
                <th>Salary (₹)</th>
                <th>Joined</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="emp" items="${employees}" varStatus="loop">
                <tr class="table-row" data-id="${emp.id}">
                  <td class="row-num">${loop.index + 1}</td>
                  <td>
                    <div class="emp-name-cell">
                      <div class="emp-avatar">${fn:substring(emp.name, 0, 1)}</div>
                      <span class="emp-name">${fn:escapeXml(emp.name)}</span>
                    </div>
                  </td>
                  <td><a href="mailto:${emp.email}" class="email-link">${fn:escapeXml(emp.email)}</a></td>
                  <td><span class="dept-badge">${fn:escapeXml(emp.department)}</span></td>
                  <td>${fn:escapeXml(emp.phone)}</td>
                  <td class="salary-cell">
                    <fmt:formatNumber value="${emp.salary}" type="number" maxFractionDigits="2"/>
                  </td>
                  <td>
                    <c:if test="${not empty emp.joinedDate}">
                      <fmt:formatDate value="${emp.joinedDate}" pattern="dd MMM yyyy"/>
                    </c:if>
                  </td>
                  <td class="actions-cell">
                    <a href="${pageContext.request.contextPath}/employee?action=edit&id=${emp.id}"
                       class="action-btn edit-btn" title="Edit">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                      Edit
                    </a>
                    <a href="${pageContext.request.contextPath}/employee?action=delete&id=${emp.id}"
                       class="action-btn delete-btn"
                       onclick="return confirmDelete('${fn:escapeXml(emp.name)}')"
                       title="Delete">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                      Delete
                    </a>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

</main>

<!-- Delete Confirm Modal -->
<div id="confirmModal" class="modal-overlay" style="display:none">
  <div class="modal">
    <div class="modal-icon danger">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
    </div>
    <h3 class="modal-title">Delete Employee</h3>
    <p class="modal-body" id="modalMessage">Are you sure you want to delete this employee?</p>
    <div class="modal-actions">
      <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
      <button class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
