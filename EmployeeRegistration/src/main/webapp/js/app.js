/* ================================================================
   app.js – Client-Side Logic for EmpReg
   • Delete confirmation modal
   • Form validation with real-time feedback
   • Live preview on registration form
   ================================================================ */

// ── Utilities ────────────────────────────────────────────────────
const $ = id => document.getElementById(id);

// ── Delete Confirmation Modal ─────────────────────────────────────
let pendingDeleteHref = null;

/**
 * Called by the delete anchor's onclick.
 * Shows the confirmation modal instead of navigating immediately.
 */
function confirmDelete(name) {
  const modal   = $('confirmModal');
  const message = $('modalMessage');
  const btn     = $('confirmDeleteBtn');

  // This function is invoked from the anchor's href attribute —
  // we need to capture the href via the event target.
  // We'll set the href on the confirm button instead.
  message.textContent = `Are you sure you want to permanently delete "${name}"? This action cannot be undone.`;
  modal.style.display = 'flex';

  // Grab the href of the clicked element from the event
  btn.onclick = () => {
    if (pendingDeleteHref) window.location.href = pendingDeleteHref;
  };

  return false; // prevent default navigation
}

function closeModal() {
  $('confirmModal').style.display = 'none';
  pendingDeleteHref = null;
}

// Close modal when clicking outside
document.addEventListener('DOMContentLoaded', () => {
  const overlay = $('confirmModal');
  if (overlay) {
    overlay.addEventListener('click', e => {
      if (e.target === overlay) closeModal();
    });
  }

  // Wire up delete buttons — capture href at click time
  document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', function (e) {
      e.preventDefault();
      pendingDeleteHref = this.href;
      const name = this.closest('tr')?.querySelector('.emp-name')?.textContent?.trim() || 'this employee';
      confirmDelete(name);
    });
  });

  // Escape key closes modal
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') closeModal();
  });

  // ── Form Live Preview ─────────────────────────────────────────
  initFormPreview();

  // ── Form Validation ───────────────────────────────────────────
  initFormValidation();

  // ── Auto-dismiss alerts ───────────────────────────────────────
  document.querySelectorAll('.alert').forEach(alert => {
    setTimeout(() => {
      alert.style.transition = 'opacity .5s ease, transform .5s ease';
      alert.style.opacity    = '0';
      alert.style.transform  = 'translateY(-8px)';
      setTimeout(() => alert.remove(), 500);
    }, 4000);
  });
});

// ── Live Form Preview ─────────────────────────────────────────────
function initFormPreview() {
  const nameInput = $('name');
  const deptInput = $('department');
  const previewAvatar = $('previewAvatar');
  const previewName   = $('previewName');
  const previewDept   = $('previewDept');

  if (!nameInput || !previewAvatar) return;

  function updatePreview() {
    const name = nameInput.value.trim();
    const dept = deptInput ? deptInput.value : '';

    previewAvatar.textContent = name ? name.charAt(0).toUpperCase() : '?';
    previewName.textContent   = name || 'New Employee';
    if (previewDept) previewDept.textContent = dept || 'Department';
  }

  nameInput.addEventListener('input', updatePreview);
  if (deptInput) deptInput.addEventListener('change', updatePreview);
}

// ── Form Validation ───────────────────────────────────────────────
function initFormValidation() {
  const form = $('employeeForm');
  if (!form) return;

  // Real-time field validation
  const validators = {
    name: val => {
      if (!val) return 'Full name is required.';
      if (val.length < 2) return 'Name must be at least 2 characters.';
      return '';
    },
    email: val => {
      if (!val) return 'Email address is required.';
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) return 'Please enter a valid email address.';
      return '';
    },
    department: val => {
      if (!val) return 'Please select a department.';
      return '';
    },
    salary: val => {
      if (!val) return 'Salary is required.';
      if (isNaN(val) || Number(val) < 0) return 'Enter a valid non-negative salary.';
      return '';
    },
    phone: val => {
      if (val && !/^\d{10,15}$/.test(val)) return 'Phone must be 10–15 digits.';
      return '';
    }
  };

  Object.keys(validators).forEach(fieldId => {
    const field = $(fieldId);
    if (!field) return;

    field.addEventListener('blur',  () => validateField(fieldId, field, validators[fieldId]));
    field.addEventListener('input', () => {
      if (field.classList.contains('is-invalid')) {
        validateField(fieldId, field, validators[fieldId]);
      }
    });
    if (field.tagName === 'SELECT') {
      field.addEventListener('change', () => validateField(fieldId, field, validators[fieldId]));
    }
  });

  // Full validation on submit
  form.addEventListener('submit', e => {
    let hasError = false;
    Object.keys(validators).forEach(fieldId => {
      const field = $(fieldId);
      if (!field) return;
      const err = validateField(fieldId, field, validators[fieldId]);
      if (err) hasError = true;
    });
    if (hasError) {
      e.preventDefault();
      // Scroll to first error
      const firstError = form.querySelector('.is-invalid');
      if (firstError) firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
    } else {
      // Show loading state
      const submitBtn = $('submitBtn');
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = `<svg viewBox="0 0 24 24" class="spin" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10" stroke-dasharray="60" stroke-dashoffset="0"/></svg> Saving…`;
      }
    }
  });
}

function validateField(fieldId, field, validator) {
  const errorEl = $(fieldId + 'Error');
  const msg     = validator(field.value.trim());

  if (msg) {
    field.classList.add('is-invalid');
    field.classList.remove('is-valid');
    if (errorEl) errorEl.textContent = msg;
  } else {
    field.classList.remove('is-invalid');
    if (field.value.trim()) field.classList.add('is-valid');
    if (errorEl) errorEl.textContent = '';
  }
  return msg;
}

// ── Spinner CSS (injected) ────────────────────────────────────────
const style = document.createElement('style');
style.textContent = `
  @keyframes spin { to { transform: rotate(360deg); } }
  .spin { animation: spin .8s linear infinite; }
`;
document.head.appendChild(style);
