<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Donors — Create" scope="request" />
<%@ include file="../../layout/header.jsp" %>
<script src="https://cdn.tailwindcss.com"></script>

<%-- ============================================================
     Inline styles specific to the Create Donor page.
     Extends the existing admin.css design system.
     ============================================================ --%>
<style>
  /* ── Page layout ──────────────────────────────────────────── */
  .create-donor-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1.5rem;
    align-items: start;
    max-width: 920px;
  }

  /* ── Section card ─────────────────────────────────────────── */
  .form-section {
    background: var(--card-bg, #1e2232);
    border: 1px solid var(--border-color, rgba(255,255,255,.08));
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 1.25rem;
  }
  .form-section-header {
    display: flex;
    align-items: center;
    gap: .65rem;
    padding: 1rem 1.25rem;
    border-bottom: 1px solid var(--border-color, rgba(255,255,255,.08));
    background: rgba(255,255,255,.03);
  }
  .form-section-header .section-icon {
    width: 32px; height: 32px;
    border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    background: rgba(229, 62, 62, .15);
    flex-shrink: 0;
  }
  .form-section-header .section-icon svg { fill: #e53e3e; width: 16px; height: 16px; }
  .form-section-header h3 {
    font-size: .9rem; font-weight: 600;
    color: var(--text-primary, #e2e8f0);
    margin: 0;
  }
  .form-section-body { padding: 1.25rem; }

  /* ── Two-column field grid ────────────────────────────────── */
  .field-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
  }
  @media (max-width: 640px) { .field-row { grid-template-columns: 1fr; } }

  /* ── Field wrapper ────────────────────────────────────────── */
  .field-group { display: flex; flex-direction: column; gap: .3rem; margin-bottom: .9rem; }
  .field-group:last-child { margin-bottom: 0; }
  .field-label {
    font-size: .78rem; font-weight: 600;
    color: var(--text-secondary, #a0aec0);
    text-transform: uppercase; letter-spacing: .04em;
  }
  .field-label .req { color: #e53e3e; margin-left: 2px; }
  .field-label .opt {
    font-size: .72rem; font-weight: 400;
    color: var(--text-secondary, #a0aec0);
    text-transform: none; letter-spacing: 0;
    margin-left: 4px;
  }

  /* ── Inputs ───────────────────────────────────────────────── */
  .field-input,
  .field-select {
    width: 100%; box-sizing: border-box;
    padding: .55rem .85rem;
    border: 1.5px solid var(--border-color, rgba(255,255,255,.12));
    border-radius: 8px;
    background: var(--input-bg, rgba(255,255,255,.05));
    color: var(--text-primary, #e2e8f0);
    font-size: .875rem;
    transition: border-color .2s, box-shadow .2s;
    outline: none;
    font-family: inherit;
  }
  .field-input:focus, .field-select:focus {
    border-color: #e53e3e;
    box-shadow: 0 0 0 3px rgba(229, 62, 62, .18);
  }
  .field-input.is-error, .field-select.is-error {
    border-color: #e53e3e;
    background: rgba(229, 62, 62, .06);
  }
  .field-select option { background: #1a1f2e; color: #e2e8f0; }

  /* ── File upload ──────────────────────────────────────────── */
  .file-upload-area {
    border: 2px dashed var(--border-color, rgba(255,255,255,.15));
    border-radius: 10px;
    padding: 1.1rem 1rem;
    text-align: center;
    cursor: pointer;
    transition: border-color .2s, background .2s;
    position: relative;
  }
  .file-upload-area:hover { border-color: #e53e3e; background: rgba(229,62,62,.04); }
  .file-upload-area input[type="file"] {
    position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%;
  }
  .file-upload-icon { font-size: 1.5rem; margin-bottom: .25rem; }
  .file-upload-label {
    font-size: .8rem; color: var(--text-secondary, #a0aec0);
    display: block; pointer-events: none;
  }
  .file-upload-label span { color: #e53e3e; font-weight: 600; }
  .file-preview {
    margin-top: .5rem; font-size: .75rem; color: #68d391;
    display: none;
  }
  .file-upload-area.is-error { border-color: #e53e3e; }

  /* ── Validation error text ────────────────────────────────── */
  .field-error {
    font-size: .75rem; color: #fc8181;
    display: flex; align-items: center; gap: .3rem;
  }
  .field-error::before { content: "⚠"; font-size: .7rem; }

  /* ── Alert banners ────────────────────────────────────────── */
  .alert-banner {
    border-radius: 10px;
    padding: .85rem 1rem;
    font-size: .85rem;
    display: flex; align-items: flex-start; gap: .6rem;
    margin-bottom: 1.25rem;
  }
  .alert-banner-error {
    background: rgba(229,62,62,.12);
    border: 1px solid rgba(229,62,62,.3);
    color: #feb2b2;
  }
  .alert-banner-info {
    background: rgba(66,153,225,.1);
    border: 1px solid rgba(66,153,225,.25);
    color: #90cdf4;
  }
  .alert-icon { flex-shrink: 0; font-size: 1rem; margin-top: 1px; }

  /* ── Submit actions ───────────────────────────────────────── */
  .form-actions-bar {
    display: flex; align-items: center;
    justify-content: flex-end;
    gap: .75rem;
    padding: 1rem 1.25rem;
    border-top: 1px solid var(--border-color, rgba(255,255,255,.08));
    background: rgba(255,255,255,.02);
    border-radius: 0 0 12px 12px;
  }
  .btn-create {
    background: linear-gradient(135deg, #e53e3e, #c53030);
    color: #fff; border: none;
    padding: .65rem 1.5rem;
    border-radius: 8px; font-size: .875rem; font-weight: 600;
    cursor: pointer; display: flex; align-items: center; gap: .4rem;
    transition: opacity .2s, transform .15s;
  }
  .btn-create:hover { opacity: .9; transform: translateY(-1px); }
  .btn-create:active { transform: translateY(0); }
  .btn-cancel {
    background: transparent;
    color: var(--text-secondary, #a0aec0);
    border: 1.5px solid var(--border-color, rgba(255,255,255,.12));
    padding: .65rem 1.25rem;
    border-radius: 8px; font-size: .875rem;
    cursor: pointer; text-decoration: none;
    transition: border-color .2s, color .2s;
    display: inline-flex; align-items: center;
  }
  .btn-cancel:hover { border-color: rgba(255,255,255,.3); color: var(--text-primary, #e2e8f0); }

  /* ── Credentials Modal ────────────────────────────────────── */
  .modal-overlay {
    position: fixed; inset: 0; z-index: 1000;
    background: rgba(0,0,0,.65); backdrop-filter: blur(4px);
    display: flex; align-items: center; justify-content: center;
    padding: 1rem;
    animation: fadeIn .25s ease;
  }
  .modal-overlay.hidden { display: none; }
  @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

  .cred-modal {
    background: #1a1f2e;
    border: 1px solid rgba(255,255,255,.12);
    border-radius: 16px;
    width: 100%; max-width: 460px;
    box-shadow: 0 25px 60px rgba(0,0,0,.6);
    animation: slideUp .3s ease;
    overflow: hidden;
  }
  @keyframes slideUp {
    from { transform: translateY(30px); opacity: 0; }
    to   { transform: translateY(0);    opacity: 1; }
  }
  .cred-modal-header {
    background: linear-gradient(135deg, rgba(229,62,62,.2), rgba(197,48,48,.1));
    border-bottom: 1px solid rgba(229,62,62,.25);
    padding: 1.25rem 1.5rem;
    display: flex; align-items: center; gap: .75rem;
  }
  .cred-modal-icon {
    width: 44px; height: 44px; border-radius: 12px;
    background: rgba(229,62,62,.2);
    display: flex; align-items: center; justify-content: center;
    font-size: 1.3rem; flex-shrink: 0;
  }
  .cred-modal-title { font-size: 1rem; font-weight: 700; color: #e2e8f0; margin: 0; }
  .cred-modal-subtitle { font-size: .78rem; color: #a0aec0; margin: .15rem 0 0; }

  .cred-modal-body { padding: 1.5rem; }
  .cred-warning {
    background: rgba(246,173,85,.1);
    border: 1px solid rgba(246,173,85,.3);
    border-radius: 8px;
    padding: .75rem 1rem;
    font-size: .8rem;
    color: #fbd38d;
    margin-bottom: 1.25rem;
    display: flex; gap: .5rem;
  }

  .cred-field { margin-bottom: 1rem; }
  .cred-label {
    font-size: .72rem; font-weight: 700;
    color: #a0aec0; text-transform: uppercase; letter-spacing: .06em;
    margin-bottom: .4rem; display: block;
  }
  .cred-value-box {
    display: flex; align-items: center;
    background: rgba(255,255,255,.05);
    border: 1.5px solid rgba(255,255,255,.12);
    border-radius: 8px;
    overflow: hidden;
  }
  .cred-value {
    flex: 1; padding: .65rem .9rem;
    font-family: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
    font-size: .95rem; font-weight: 600;
    color: #68d391; letter-spacing: .05em;
    word-break: break-all;
    background: transparent; border: none; outline: none;
    cursor: text; user-select: all;
  }
  .cred-copy-btn {
    padding: .65rem .85rem;
    background: transparent;
    border: none; border-left: 1px solid rgba(255,255,255,.08);
    color: #a0aec0; cursor: pointer;
    font-size: .8rem; font-weight: 500;
    transition: background .2s, color .2s;
    white-space: nowrap;
    display: flex; align-items: center; gap: .3rem;
  }
  .cred-copy-btn:hover { background: rgba(255,255,255,.07); color: #e2e8f0; }
  .cred-copy-btn.copied { color: #68d391; }

  .cred-modal-footer {
    padding: 1rem 1.5rem;
    border-top: 1px solid rgba(255,255,255,.08);
    display: flex; gap: .75rem; justify-content: flex-end;
  }
  .btn-print {
    background: rgba(255,255,255,.06);
    color: #e2e8f0; border: 1.5px solid rgba(255,255,255,.12);
    padding: .55rem 1.1rem; border-radius: 8px;
    font-size: .825rem; font-weight: 600; cursor: pointer;
    display: flex; align-items: center; gap: .4rem;
    transition: background .2s;
  }
  .btn-print:hover { background: rgba(255,255,255,.1); }
  .btn-done {
    background: linear-gradient(135deg, #48bb78, #2f855a);
    color: #fff; border: none;
    padding: .55rem 1.25rem; border-radius: 8px;
    font-size: .825rem; font-weight: 600; cursor: pointer;
    display: flex; align-items: center; gap: .4rem;
    transition: opacity .2s;
  }
  .btn-done:hover { opacity: .9; }

  /* ── Print slip ───────────────────────────────────────────── */
  @media print {
    body * { visibility: hidden; }
    #printSlip, #printSlip * { visibility: visible; }
    #printSlip {
      position: absolute; inset: 0;
      background: #fff; color: #000;
      padding: 2cm; font-family: sans-serif;
    }
  }
</style>

<%-- ============================================================
     Page Header
     ============================================================ --%>
<div class="page-header">
  <div>
    <h1 class="page-title">Create Donor Account</h1>
    <p class="page-subtitle">Register a donor who cannot use the mobile app independently</p>
  </div>
  <a href="<c:url value='/admin/donors'/>" class="btn btn-secondary">← Back to Donors</a>
</div>

<%-- ============================================================
     Credentials Modal (shown after successful creation)
     ============================================================ --%>
<c:if test="${not empty credPassword}">
  <div class="modal-overlay" id="credModal" role="dialog" aria-modal="true"
       aria-labelledby="credModalTitle">
    <div class="cred-modal" id="printSlip">
      <div class="cred-modal-header">
        <div class="cred-modal-icon">🎉</div>
        <div>
          <p class="cred-modal-title" id="credModalTitle">Donor Account Created!</p>
          <p class="cred-modal-subtitle">Share these login credentials securely with the donor.</p>
        </div>
      </div>
      <div class="cred-modal-body">
        <div class="cred-warning">
          <span>⚠️</span>
          <span>This is the <strong>only time</strong> the temporary password will be shown.
                Please copy or print the slip before closing.</span>
        </div>

        <div class="cred-field">
          <label class="cred-label">Username / Phone Number</label>
          <div class="cred-value-box">
            <span class="cred-value" id="credUsername">${fn:escapeXml(credUsername)}</span>
            <button class="cred-copy-btn" type="button"
                    onclick="copyToClipboard('credUsername', this)">
              📋 Copy
            </button>
          </div>
        </div>

        <div class="cred-field">
          <label class="cred-label">Temporary Password</label>
          <div class="cred-value-box">
            <span class="cred-value" id="credPassword">${fn:escapeXml(credPassword)}</span>
            <button class="cred-copy-btn" type="button"
                    onclick="copyToClipboard('credPassword', this)">
              📋 Copy
            </button>
          </div>
        </div>

        <div class="cred-field" style="margin-bottom:0">
          <label class="cred-label">Both credentials (one click)</label>
          <div class="cred-value-box">
            <span class="cred-value" id="credBoth">
              Phone: ${fn:escapeXml(credUsername)} / Password: ${fn:escapeXml(credPassword)}</span>
            <button class="cred-copy-btn" type="button"
                    onclick="copyToClipboard('credBoth', this)">
              📋 Copy Credentials
            </button>
          </div>
        </div>
      </div>
      <div class="cred-modal-footer">
        <button class="btn-print" type="button" onclick="window.print()">
          🖨️ Print Temporary Slip
        </button>
        <button class="btn-done" type="button" onclick="closeCredModal()">
          ✓ Done
        </button>
      </div>
    </div>
  </div>
</c:if>

<%-- ============================================================
     Global success / error banners
     ============================================================ --%>
<c:if test="${not empty successMessage}">
  <div class="alert-banner alert-banner-info">
    <span class="alert-icon">✔</span>
    <span>${fn:escapeXml(successMessage)}</span>
  </div>
</c:if>
<c:if test="${not empty errorMessage}">
  <div class="alert-banner alert-banner-error" role="alert">
    <span class="alert-icon">✕</span>
    <span>${fn:escapeXml(errorMessage)}</span>
  </div>
</c:if>

<%-- ============================================================
     Main form (single column)
     ============================================================ --%>
<div class="create-donor-grid">
  <div>
    <form method="post"
          action="<c:url value='/admin/donors/create'/>"
          enctype="multipart/form-data"
          id="createDonorForm"
          novalidate>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <%-- §1 Personal Information ──────────────────────────── --%>
      <div class="form-section">
        <div class="form-section-header">
          <div class="section-icon">
            <svg viewBox="0 0 24 24"><path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v2h20v-2c0-3.3-6.7-5-10-5z"/></svg>
          </div>
          <h3>Personal Information</h3>
        </div>
        <div class="form-section-body">

          <div class="field-row">
            <div class="field-group">
              <label class="field-label" for="name">
                Full Name <span class="req">*</span>
              </label>
              <input id="name" name="name" type="text"
                     class="field-input ${not empty fieldErrors.name ? 'is-error' : ''}"
                     value="<c:out value='${donorCreateDTO.name}'/>"
                     placeholder="e.g. Mg Mg" maxlength="255" required />
              <c:if test="${not empty fieldErrors.name}"><span class="field-error">${fn:escapeXml(fieldErrors.name)}</span></c:if>
            </div>
            <div class="field-group">
              <label class="field-label" for="phone">
                Phone Number <span class="req">*</span>
              </label>
              <input id="phone" name="phone" type="tel"
                     class="field-input ${not empty fieldErrors.phone ? 'is-error' : ''}"
                     value="<c:out value='${donorCreateDTO.phone}'/>"
                     placeholder="e.g. 09791234567" maxlength="20" required />
              <c:if test="${not empty fieldErrors.phone}"><span class="field-error">${fn:escapeXml(fieldErrors.phone)}</span></c:if>
            </div>
          </div>

          <div class="field-row">
            <div class="field-group">
              <label class="field-label" for="dateOfBirth">
                Date of Birth <span class="req">*</span>
              </label>
              <input id="dateOfBirth" name="dateOfBirth" type="date"
                     class="field-input ${not empty fieldErrors.dateOfBirth ? 'is-error' : ''}"
                     value="${donorCreateDTO.dateOfBirth}" required />
              <c:if test="${not empty fieldErrors.dateOfBirth}"><span class="field-error">${fn:escapeXml(fieldErrors.dateOfBirth)}</span></c:if>
            </div>
            <div class="field-group">
              <label class="field-label" for="gender">
                Gender <span class="req">*</span>
              </label>
              <select id="gender" name="gender" class="field-select ${not empty fieldErrors.gender ? 'is-error' : ''}" required>
                <option value="">— Select Gender —</option>
                <option value="MALE"   ${donorCreateDTO.gender == 'MALE'   ? 'selected' : ''}>Male</option>
                <option value="FEMALE" ${donorCreateDTO.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                <option value="OTHER"  ${donorCreateDTO.gender == 'OTHER'  ? 'selected' : ''}>Other</option>
              </select>
              <c:if test="${not empty fieldErrors.gender}"><span class="field-error">${fn:escapeXml(fieldErrors.gender)}</span></c:if>
            </div>
          </div>

          <div class="field-row">
            <div class="field-group">
              <label class="field-label" for="email">
                Email Address <span class="opt">(optional)</span>
              </label>
              <input id="email" name="email" type="email"
                     class="field-input"
                     value="<c:out value='${donorCreateDTO.email}'/>"
                     placeholder="donor@example.com" maxlength="255" />
            </div>
            <div class="field-group">
              <label class="field-label" for="bloodTypeId">
                Initial Blood Type <span class="opt">(optional — UNVERIFIED)</span>
              </label>
              <select id="bloodTypeId" name="bloodTypeId" class="field-select">
                <option value="">— Unknown —</option>
                <c:forEach items="${bloodTypes}" var="bt">
                  <option value="${bt.id}"
                          ${donorCreateDTO.bloodTypeId == bt.id ? 'selected' : ''}>
                    ${fn:escapeXml(bt.displayName)}
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>

        </div>
      </div>

      <%-- §2 Identity Document (NRC) ───────────────────────── --%>
      <div class="form-section">
        <div class="form-section-header">
          <div class="section-icon">
            <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H4V6h16v12zM6 10h12v2H6zm0 4h8v2H6z"/></svg>
          </div>
          <h3>NRC Identity Document <span class="req" style="color:#e53e3e">*</span></h3>
        </div>
        <div class="form-section-body">

          <div class="field-group">
            <label class="field-label" for="nrcNumber">
              NRC Number <span class="req">*</span>
            </label>
            <input id="nrcNumber" name="nrcNumber" type="text"
                   class="field-input ${not empty fieldErrors.nrcNumber ? 'is-error' : ''}"
                   value="<c:out value='${donorCreateDTO.nrcNumber}'/>"
                   placeholder="e.g. 12/KAMAYU(N)012345" maxlength="50" required />
            <c:if test="${not empty fieldErrors.nrcNumber}"><span class="field-error">${fn:escapeXml(fieldErrors.nrcNumber)}</span></c:if>
          </div>

          <div class="field-row">
            <div class="field-group">
              <label class="field-label" for="nrcFront">
                NRC Front Photo <span class="req">*</span>
              </label>
              <div class="file-upload-area ${not empty fieldErrors.nrcFront ? 'is-error' : ''}" id="nrcFrontArea">
                <input type="file" id="nrcFront" name="nrcFront"
                       accept="image/jpeg,image/png,image/webp"
                       onchange="handleFileSelect(this, 'nrcFrontArea', 'nrcFrontPreview')" />
                <div class="file-upload-icon">🪪</div>
                <span class="file-upload-label">
                  <span>Click to upload</span> or drag & drop<br>
                  JPEG · PNG · WebP — max 5 MB
                </span>
                <span class="file-preview" id="nrcFrontPreview"></span>
              </div>
              <c:if test="${not empty fieldErrors.nrcFront}"><span class="field-error">${fn:escapeXml(fieldErrors.nrcFront)}</span></c:if>
            </div>
            <div class="field-group">
              <label class="field-label" for="nrcBack">
                NRC Back Photo <span class="req">*</span>
              </label>
              <div class="file-upload-area ${not empty fieldErrors.nrcBack ? 'is-error' : ''}" id="nrcBackArea">
                <input type="file" id="nrcBack" name="nrcBack"
                       accept="image/jpeg,image/png,image/webp"
                       onchange="handleFileSelect(this, 'nrcBackArea', 'nrcBackPreview')" />
                <div class="file-upload-icon">🔄</div>
                <span class="file-upload-label">
                  <span>Click to upload</span> or drag & drop<br>
                  JPEG · PNG · WebP — max 5 MB
                </span>
                <span class="file-preview" id="nrcBackPreview"></span>
              </div>
              <c:if test="${not empty fieldErrors.nrcBack}"><span class="field-error">${fn:escapeXml(fieldErrors.nrcBack)}</span></c:if>
            </div>
          </div>

        </div>
      </div>

      <%-- §3 Address ───────────────────────────────────────── --%>
      <div class="form-section">
        <div class="form-section-header">
          <div class="section-icon">
            <svg viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
          </div>
          <h3>Address</h3>
        </div>
        <div class="form-section-body">

          <div class="field-group">
            <label class="field-label" for="detailAddress">
              Detail Address <span class="req">*</span>
            </label>
            <input id="detailAddress" name="detailAddress" type="text"
                   class="field-input ${not empty fieldErrors.detailAddress ? 'is-error' : ''}"
                   value="<c:out value='${donorCreateDTO.detailAddress}'/>"
                   placeholder="Street / House number" maxlength="500" required />
            <c:if test="${not empty fieldErrors.detailAddress}"><span class="field-error">${fn:escapeXml(fieldErrors.detailAddress)}</span></c:if>
          </div>

          <div class="field-row">
            <div class="field-group">
              <label class="field-label" for="township">Township <span class="req">*</span></label>
              <input id="township" name="township" type="text"
                     class="field-input ${not empty fieldErrors.township ? 'is-error' : ''}"
                     value="<c:out value='${donorCreateDTO.township}'/>"
                     placeholder="e.g. Kamayut" maxlength="100" required />
              <c:if test="${not empty fieldErrors.township}"><span class="field-error">${fn:escapeXml(fieldErrors.township)}</span></c:if>
            </div>
            <div class="field-group">
              <label class="field-label" for="division">Division / Region <span class="req">*</span></label>
              <input id="division" name="division" type="text"
                     class="field-input ${not empty fieldErrors.division ? 'is-error' : ''}"
                     value="<c:out value='${donorCreateDTO.division}'/>"
                     placeholder="e.g. Yangon Region" maxlength="100" required />
              <c:if test="${not empty fieldErrors.division}"><span class="field-error">${fn:escapeXml(fieldErrors.division)}</span></c:if>
            </div>
          </div>

          <div class="field-row">
            <div class="field-group">
              <label class="field-label" for="country">Country</label>
              <input id="country" name="country" type="text"
                     class="field-input"
                     value="<c:if test='${not empty donorCreateDTO.country}'><c:out value='${donorCreateDTO.country}'/></c:if><c:if test='${empty donorCreateDTO.country}'>Myanmar</c:if>"
                     placeholder="Myanmar" maxlength="100" />
            </div>
          </div>

        </div>
      </div>

      <%-- §4 Credentials ───────────────────────────────────── --%>
      <div class="form-section">
        <div class="form-section-header">
          <div class="section-icon">
            <svg viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>
          </div>
          <h3>Account Password</h3>
        </div>
        <div class="form-section-body">
          <div class="alert-banner alert-banner-info" style="margin-bottom:1rem">
            <span class="alert-icon">ℹ</span>
            <span>Leave both fields empty to <strong>auto-generate</strong> a secure 10-character
                  temporary password. The password will be shown once on creation.</span>
          </div>

          <div class="field-row">
            <div class="field-group">
              <label class="field-label" for="password">
                Password <span class="opt">(optional)</span>
              </label>
              <input id="password" name="password" type="password"
                     class="field-input"
                     placeholder="Leave blank to auto-generate" autocomplete="new-password" />
            </div>
            <div class="field-group">
              <label class="field-label" for="confirmPassword">Confirm Password</label>
              <input id="confirmPassword" name="confirmPassword" type="password"
                     class="field-input"
                     placeholder="Repeat password" autocomplete="new-password" />
            </div>
          </div>

        </div>

        <div class="form-actions-bar">
          <a href="<c:url value='/admin/donors'/>" class="btn-cancel">Cancel</a>
          <button type="submit" class="btn-create" id="submitBtn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" style="flex-shrink:0">
              <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
            </svg>
            Create Donor Account
          </button>
        </div>
      </div>

    </form>
  </div>
</div><%-- end grid --%>

<%-- ============================================================
     JavaScript
     ============================================================ --%>
<script>
  // ── File picker feedback ─────────────────────────────────────
  function handleFileSelect(input, areaId, previewId) {
    const area    = document.getElementById(areaId);
    const preview = document.getElementById(previewId);
    const file    = input.files[0];
    if (!file) { preview.style.display = 'none'; return; }

    const allowed = ['image/jpeg', 'image/png', 'image/webp'];
    const maxSize = 5 * 1024 * 1024;

    if (!allowed.includes(file.type)) {
      area.classList.add('is-error');
      preview.textContent = '✕ Invalid type. Use JPEG, PNG, or WebP.';
      preview.style.color  = '#fc8181';
      preview.style.display = 'block';
      input.value = '';
      return;
    }
    if (file.size > maxSize) {
      area.classList.add('is-error');
      preview.textContent = '✕ File too large (max 5 MB).';
      preview.style.color  = '#fc8181';
      preview.style.display = 'block';
      input.value = '';
      return;
    }

    area.classList.remove('is-error');
    preview.textContent  = '✓ ' + file.name + ' (' + (file.size / 1024).toFixed(1) + ' KB)';
    preview.style.color  = '#68d391';
    preview.style.display = 'block';
  }

  // ── Submit feedback ──────────────────────────────────────────
  document.getElementById('createDonorForm').addEventListener('submit', function () {
    const btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<span>⏳ Creating account…</span>';
  });

  // ── Credentials modal ────────────────────────────────────────
  function closeCredModal() {
    const overlay = document.getElementById('credModal');
    if (overlay) {
      overlay.style.opacity = '0';
      overlay.style.transition = 'opacity .25s';
      setTimeout(function () { overlay.classList.add('hidden'); }, 250);
    }
  }

  function copyToClipboard(elementId, btn) {
    const el = document.getElementById(elementId);
    const text = el ? el.textContent.trim() : '';
    if (!text) return;
    navigator.clipboard.writeText(text).then(function () {
      const orig = btn.innerHTML;
      btn.innerHTML = '✓ Copied!';
      btn.classList.add('copied');
      setTimeout(function () {
        btn.innerHTML = orig;
        btn.classList.remove('copied');
      }, 2000);
    }).catch(function () {
      // Fallback for older browsers
      const range = document.createRange();
      range.selectNode(el);
      window.getSelection().removeAllRanges();
      window.getSelection().addRange(range);
      document.execCommand('copy');
      window.getSelection().removeAllRanges();
    });
  }

  // Close modal on Escape
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeCredModal();
  });
</script>

<%@ include file="../../layout/footer.jsp" %>