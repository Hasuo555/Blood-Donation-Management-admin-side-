<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="asset" tagdir="/WEB-INF/tags" %>
                <c:set var="pageTitle" value="Donors — Edit" scope="request" />
                <%@ include file="../../layout/header.jsp" %>

                    <style>
                        .nrc-photo-field {
                            flex: 1;
                            min-width: 0;
                        }

                        .nrc-photo-dropzone {
                            position: relative;
                            min-height: 180px;
                            padding: 16px;
                            border: 2px dashed #e1caca;
                            border-radius: 12px;
                            background: #fffafa;
                            text-align: center;
                            overflow: hidden;
                            transition: border-color .2s, background .2s;
                        }

                        .nrc-photo-dropzone:hover,
                        .nrc-photo-dropzone.is-dragover {
                            border-color: #880808;
                            background: #fff5f5;
                        }

                        .nrc-photo-input {
                            position: relative;
                            z-index: 2;
                            width: 100%;
                            cursor: pointer;
                        }

                        .nrc-photo-preview {
                            position: relative;
                            z-index: 2;
                            display: block;
                            width: 100%;
                            max-height: 140px;
                            object-fit: contain;
                            margin: 0 auto 8px;
                            border-radius: 8px;
                        }

                        .nrc-photo-placeholder {
                            position: relative;
                            z-index: 2;
                            padding: 28px 8px;
                            color: #667085;
                            pointer-events: none;
                        }

                        .nrc-photo-dropzone.has-saved-photo .nrc-photo-placeholder {
                            display: none;
                        }

                        .nrc-photo-placeholder-icon {
                            display: block;
                            font-size: 1.8rem;
                            margin-bottom: 6px;
                        }

                        .nrc-photo-placeholder strong {
                            color: #880808;
                        }

                        .nrc-photo-status {
                            margin: 6px 0 0;
                            color: #667085;
                            font-size: .8rem;
                        }

                        .nrc-new-preview {
                            display: none;
                            margin-top: 10px;
                            padding: 8px;
                            border: 1px solid #e1caca;
                            border-radius: 8px;
                            background: #fff;
                        }

                        .nrc-new-preview img {
                            display: block;
                            max-width: 100%;
                            max-height: 140px;
                            object-fit: contain;
                            margin: 6px auto 0;
                            border-radius: 6px;
                        }

                        .nrc-new-preview-label {
                            color: #667085;
                            font-size: .78rem;
                        }

                        .nrc-photo-dropzone.has-new-photo .nrc-photo-preview,
                        .nrc-photo-dropzone.has-new-photo .nrc-photo-status,
                        .nrc-photo-dropzone.has-new-photo .nrc-photo-placeholder {
                            display: none;
                        }

                        .nrc-photo-dropzone.has-new-photo .nrc-new-preview {
                            display: block;
                            margin: 0;
                            padding: 0;
                            border: 0;
                            background: transparent;
                        }

                        .nrc-photo-dropzone.has-new-photo .nrc-new-preview-label {
                            display: block;
                            margin-bottom: 6px;
                        }

                        .nrc-photo-dropzone.has-new-photo .nrc-new-preview img {
                            width: 100%;
                            max-height: 140px;
                            margin: 0 auto;
                        }

                        .nrc-photo-dropzone.has-new-photo .nrc-photo-input {
                            display: none;
                        }

                        .nrc-photo-clear {
                            display: none;
                            position: absolute;
                            top: 8px;
                            right: 8px;
                            z-index: 3;
                            width: 28px;
                            height: 28px;
                            border: 1px solid #e1caca;
                            border-radius: 50%;
                            background: #fff;
                            color: #880808;
                            font-size: 18px;
                            line-height: 1;
                            cursor: pointer;
                        }

                        .nrc-photo-dropzone.has-new-photo .nrc-photo-clear {
                            display: block;
                        }
                    </style>

                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Edit: ${fn:escapeXml(donor.name)}</h1>
                            <p class="page-subtitle">Update donor profile and account fields</p>
                        </div>
                        <a href="<c:url value='/admin/donors/${donor.id}'/>" class="btn btn-secondary">← Back</a>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                    </c:if>

                    <div class="card" style="max-width:640px">
                        <div class="card-header">Donor Information</div>
                        <div class="card-body">
                            <form method="post" action="<c:url value='/admin/donors/${donor.id}/edit'/>"
                                enctype="multipart/form-data" novalidate>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="form-group">
                                    <label for="name" class="form-label">Full Name <span
                                            class="required">*</span></label>
                                    <input type="text" id="name" name="name"
                                        value="${fn:escapeXml(donorUpdateDTO.name)}" class="form-control"
                                        maxlength="255" required />
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="phone" class="form-label">Phone <span
                                                class="required">*</span></label>
                                        <input type="tel" id="phone" name="phone"
                                            value="${fn:escapeXml(donorUpdateDTO.phone)}" class="form-control"
                                            maxlength="20" required />
                                    </div>
                                    <div class="form-group">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" id="email" name="email"
                                            value="${fn:escapeXml(donorUpdateDTO.email)}" class="form-control"
                                            maxlength="255" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="dateOfBirth" class="form-label">Date of Birth <span
                                                class="required">*</span></label>
                                        <input type="date" id="dateOfBirth" name="dateOfBirth"
                                            value="${donorUpdateDTO.dateOfBirth}" class="form-control" required />
                                    </div>
                                    <div class="form-group">
                                        <label for="gender" class="form-label">Gender <span
                                                class="required">*</span></label>
                                        <select id="gender" name="gender" class="form-control" required>
                                            <option value="MALE" ${donorUpdateDTO.gender=='MALE' ? 'selected' : '' }>
                                                Male</option>
                                            <option value="FEMALE" ${donorUpdateDTO.gender=='FEMALE' ? 'selected' : ''
                                                }>Female</option>
                                            <option value="OTHER" ${donorUpdateDTO.gender=='OTHER' ? 'selected' : '' }>
                                                Other</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="accountStatus" class="form-label">Account Status <span
                                            class="required">*</span></label>
                                    <select id="accountStatus" name="accountStatus" class="form-control" required>
                                        <c:forEach items="${accountStatuses}" var="st">
                                            <option value="${st}" ${donorUpdateDTO.accountStatus==st.toString()
                                                ? 'selected' : '' }>${st}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="bloodTypeId" class="form-label">Blood Type</label>
                                    <select id="bloodTypeId" name="bloodTypeId" class="form-control">
                                        <option value="">— Unknown / Clear —</option>
                                        <c:forEach items="${bloodTypes}" var="bt">
                                            <option value="${bt.id}" ${donorUpdateDTO.bloodTypeId==bt.id ? 'selected'
                                                : '' }>${fn:escapeXml(bt.displayName)}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <hr class="form-divider" />
                                <h3 class="form-section-title">NRC Photos</h3>
                                <div class="form-row">
                                    <div class="form-group nrc-photo-field">
                                        <label for="nrcFront" class="form-label">NRC Front Photo</label>
                                        <div class="nrc-photo-dropzone ${not empty nrcDocument and not empty nrcDocument.frontImage ? 'has-saved-photo' : ''}"
                                            id="nrcFrontDropzone">
                                            <c:choose>
                                                <c:when
                                                    test="${not empty nrcDocument and not empty nrcDocument.frontImage}">
                                                    <img class="nrc-photo-preview" src="<asset:asset-url value="
                                                        ${nrcDocument.frontImage}" />"
                                                    alt="Current NRC front photo" />
                                                    <p id="nrcFrontStatus" class="nrc-photo-status">Current front photo
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p id="nrcFrontStatus" class="nrc-photo-status">No front photo
                                                        uploaded.</p>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="nrc-photo-placeholder" id="nrcFrontPlaceholder" ${not empty
                                                nrcDocument and not empty nrcDocument.frontImage ? 'hidden' : '' }>
                                                <span class="nrc-photo-placeholder-icon">🪪</span>
                                                <strong>Choose front photo</strong> or drag &amp; drop<br />
                                                JPEG, PNG, or WebP
                                            </div>
                                            <input type="file" id="nrcFront" name="nrcFront" class="nrc-photo-input"
                                                accept="image/*" />
                                            <button type="button" class="nrc-photo-clear" id="nrcFrontClear"
                                                aria-label="Clear new NRC front photo" title="Clear photo">×</button>
                                            <div id="nrcFrontNewPreview" class="nrc-new-preview">
                                                <span class="nrc-new-preview-label">New photo selected preview:</span>
                                                <img id="nrcFrontPreview" alt="New NRC front photo preview" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group nrc-photo-field">
                                        <label for="nrcBack" class="form-label">NRC Back Photo</label>
                                        <div class="nrc-photo-dropzone ${not empty nrcDocument and not empty nrcDocument.backImage ? 'has-saved-photo' : ''}"
                                            id="nrcBackDropzone">
                                            <c:choose>
                                                <c:when
                                                    test="${not empty nrcDocument and not empty nrcDocument.backImage}">
                                                    <img class="nrc-photo-preview" src="<asset:asset-url value="
                                                        ${nrcDocument.backImage}" />"
                                                    alt="Current NRC back photo" />
                                                    <p id="nrcBackStatus" class="nrc-photo-status">Current back photo
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p id="nrcBackStatus" class="nrc-photo-status">No back photo
                                                        uploaded.</p>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="nrc-photo-placeholder" id="nrcBackPlaceholder" ${not empty
                                                nrcDocument and not empty nrcDocument.backImage ? 'hidden' : '' }>
                                                <span class="nrc-photo-placeholder-icon">🔄</span>
                                                <strong>Choose back photo</strong> or drag &amp; drop<br />
                                                JPEG, PNG, or WebP
                                            </div>
                                            <input type="file" id="nrcBack" name="nrcBack" class="nrc-photo-input"
                                                accept="image/*" />
                                            <button type="button" class="nrc-photo-clear" id="nrcBackClear"
                                                aria-label="Clear new NRC back photo" title="Clear photo">×</button>
                                            <div id="nrcBackNewPreview" class="nrc-new-preview">
                                                <span class="nrc-new-preview-label">New photo selected preview:</span>
                                                <img id="nrcBackPreview" alt="New NRC back photo preview" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <span class="text-muted text-sm">Leave either field to keep that current photo.</span>

                                <hr class="form-divider" />
                                <h3 class="form-section-title">Address</h3>
                                <div class="form-group">
                                    <label for="detailAddress" class="form-label">Street Address <span
                                            class="required">*</span></label>
                                    <input type="text" id="detailAddress" name="detailAddress"
                                        value="${fn:escapeXml(donorUpdateDTO.detailAddress)}" class="form-control"
                                        required />
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="township" class="form-label">Township <span
                                                class="required">*</span></label>
                                        <input type="text" id="township" name="township"
                                            value="${fn:escapeXml(donorUpdateDTO.township)}" class="form-control"
                                            required />
                                    </div>
                                    <div class="form-group">
                                        <label for="division" class="form-label">Division / Region <span
                                                class="required">*</span></label>
                                        <input type="text" id="division" name="division"
                                            value="${fn:escapeXml(donorUpdateDTO.division)}" class="form-control"
                                            required />
                                    </div>
                                </div>
                                <%-- Country is always Myanmar; not user-editable --%>
                                    <input type="hidden" name="country" value="Myanmar" />

                                    <div class="form-actions">
                                        <a href="<c:url value='/admin/donors/${donor.id}'/>"
                                            class="btn btn-secondary">Cancel</a>
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                    </div>
                            </form>
                        </div>
                    </div>

                    <script>
                        function previewNrcPhoto(input) {
                            const file = input.files && input.files[0];
                            const dropzone = document.getElementById(input.id + 'Dropzone');
                            const previewContainer = document.getElementById(input.id + 'NewPreview');
                            const previewImage = document.getElementById(input.id + 'Preview');
                            const clearButton = document.getElementById(input.id + 'Clear');
                            if (!file || !file.type.startsWith('image/')) {
                                previewContainer.style.display = 'none';
                                previewImage.removeAttribute('src');
                                dropzone.classList.remove('has-new-photo');
                                clearButton.hidden = true;
                                return;
                            }

                            const reader = new FileReader();
                            reader.onload = function (event) {
                                previewImage.src = event.target.result;
                                previewContainer.style.display = 'block';
                                dropzone.classList.add('has-new-photo');
                                clearButton.hidden = false;
                            };
                            reader.readAsDataURL(file);
                        }

                        function clearNrcPhoto(inputId) {
                            const input = document.getElementById(inputId);
                            const dropzone = document.getElementById(inputId + 'Dropzone');
                            const previewContainer = document.getElementById(inputId + 'NewPreview');
                            const previewImage = document.getElementById(inputId + 'Preview');
                            input.value = '';
                            previewImage.removeAttribute('src');
                            previewContainer.style.display = 'none';
                            dropzone.classList.remove('has-new-photo');
                        }

                        ['nrcFront', 'nrcBack'].forEach(function (inputId) {
                            document.getElementById(inputId).addEventListener('change', function () {
                                previewNrcPhoto(this);
                            });
                            document.getElementById(inputId + 'Clear').addEventListener('click', function () {
                                clearNrcPhoto(inputId);
                            });
                        });
                    </script>

                    <%@ include file="../../layout/footer.jsp" %>