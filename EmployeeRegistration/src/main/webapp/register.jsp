<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<c:set var="isEdit" value="${not empty employee and employee.id ne 0}"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${isEdit ? 'Edit Employee' : 'Register Employee'} | EmpReg</title>
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
    <a href="${pageContext.request.contextPath}/employee?action=list" class="nav-item">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
      Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/employee?action=new" class="nav-item active">
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

  <header class="page-header">
    <div>
      <h1 class="page-title">${isEdit ? 'Edit Employee' : 'Register New Employee'}</h1>
      <p class="page-subtitle">${isEdit ? 'Update the employee record below' : 'Fill in the details to register a new employee'}</p>
    </div>
    <a href="${pageContext.request.contextPath}/employee?action=list" class="btn btn-secondary">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
      Back to List
    </a>
  </header>

  <!-- Server-side validation error -->
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      ${errorMessage}
    </div>
  </c:if>

  <!-- Registration / Edit Form Card -->
  <div class="form-card">

    <div class="form-hero">
      <div class="form-hero-avatar" id="previewAvatar">
        <c:choose>
          <c:when test="${isEdit}">${fn:substring(employee.name, 0, 1)}</c:when>
          <c:otherwise>?</c:otherwise>
        </c:choose>
      </div>
      <div class="form-hero-info">
        <h2 class="form-hero-name" id="previewName">
          ${isEdit ? employee.name : 'New Employee'}
        </h2>
        <span class="dept-badge form-hero-dept" id="previewDept">
          ${isEdit ? employee.department : 'Department'}
        </span>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/employee" method="post"
          id="employeeForm" novalidate>
      <input type="hidden" name="action" value="save"/>
      <input type="hidden" name="id"     value="${isEdit ? employee.id : '0'}"/>

      <!-- ── Personal Info ─────────────────────────────────── -->
      <fieldset class="form-section">
        <legend class="section-legend">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          Personal Information
        </legend>
        <div class="form-grid">
          <div class="form-group">
            <label for="name" class="form-label">Full Name <span class="required">*</span></label>
            <input type="text" id="name" name="name"
                   class="form-control" placeholder="e.g. Priya Sharma"
                   value="${isEdit ? employee.name : ''}"
                   required minlength="2" maxlength="100" autocomplete="name"/>
            <span class="form-error" id="nameError"></span>
          </div>
          <div class="form-group">
            <label for="email" class="form-label">Email Address <span class="required">*</span></label>
            <input type="email" id="email" name="email"
                   class="form-control" placeholder="e.g. priya@company.com"
                   value="${isEdit ? employee.email : ''}"
                   required maxlength="100" autocomplete="email"/>
            <span class="form-error" id="emailError"></span>
          </div>
          <div class="form-group">
            <label for="phone" class="form-label">Phone Number</label>
            <input type="tel" id="phone" name="phone"
                   class="form-control" placeholder="e.g. 9876543210"
                   value="${isEdit ? employee.phone : ''}"
                   pattern="[0-9]{10}" maxlength="15" autocomplete="tel"/>
            <span class="form-error" id="phoneError"></span>
          </div>
        </div>
      </fieldset>

      <!-- ── Job Details ───────────────────────────────────── -->
      <fieldset class="form-section">
        <legend class="section-legend">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
          Job Details
        </legend>
        <div class="form-grid">
          <div class="form-group">
            <label for="department" class="form-label">Department <span class="required">*</span></label>
            <select id="department" name="department" class="form-control" required>
              <option value="">-- Select Department --</option>
              <c:set var="depts" value="Engineering,Human Resources,Finance,Marketing,Sales,Operations,Legal,Product,Design,Support"/>
              <c:forTokens items="${depts}" delims="," var="dept">
                <option value="${dept}"
                  ${isEdit and employee.department eq dept ? 'selected' : ''}>
                  ${dept}
                </option>
              </c:forTokens>
            </select>
            <span class="form-error" id="departmentError"></span>
          </div>
          <div class="form-group">
            <label for="salary" class="form-label">Salary (₹) <span class="required">*</span></label>
            <div class="input-prefix-wrap">
              <span class="input-prefix">₹</span>
              <input type="number" id="salary" name="salary"
                     class="form-control has-prefix"
                     placeholder="e.g. 50000"
                     value="${isEdit ? employee.salary : ''}"
                     min="0" step="0.01" required/>
            </div>
            <span class="form-error" id="salaryError"></span>
          </div>
          <div class="form-group">
            <label for="joinedDate" class="form-label">Joining Date</label>
            <input type="date" id="joinedDate" name="joinedDate"
                   class="form-control"
                   value="${isEdit and not empty employee.joinedDate
                     ? employee.joinedDate : ''}"/>
          </div>
        </div>
      </fieldset>

      <!-- ── Submit ────────────────────────────────────────── -->
      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/employee?action=list"
           class="btn btn-secondary btn-lg">Cancel</a>
        <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v14a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
          ${isEdit ? 'Update Employee' : 'Register Employee'}
        </button>
      </div>
    </form>
  </div>

</main>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
