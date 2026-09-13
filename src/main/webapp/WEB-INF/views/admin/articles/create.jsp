<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Articles — Create" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Create Article</h1>
                        <p class="page-subtitle">New article will be saved as a Draft</p>
                    </div>
                    <a href="<c:url value='/admin/articles'/>" class="btn btn-secondary">← Back</a>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>

                <div class="card" style="max-width:760px">
                    <div class="card-header">Article Details</div>
                    <div class="card-body">
                        <form method="post" action="<c:url value='/admin/articles/create'/>"
                            enctype="multipart/form-data" novalidate>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <div class="form-group">
                                <label for="title" class="form-label">Title <span class="required">*</span></label>
                                <input type="text" id="title" name="title"
                                    value="${fn:escapeXml(articleCreateDTO.title)}" class="form-control" required />
                            </div>

                            <div class="form-group">
                                <label for="hospitalId" class="form-label">Hospital (optional)</label>
                                <select id="hospitalId" name="hospitalId" class="form-control">
                                    <option value="">System-wide</option>
                                    <c:forEach items="${hospitals}" var="h">
                                        <option value="${h.id}">${fn:escapeXml(h.name)}</option>
                                    </c:forEach>
                                </select>
                                <p class="text-muted text-sm mt-1">Leave blank for system-wide announcements.</p>
                            </div>

                            <div class="form-group">
                                <label for="content" class="form-label">Content <span class="required">*</span></label>
                                <textarea id="content" name="content" class="form-control" rows="12"
                                    placeholder="Write your article content here…"
                                    required>${fn:escapeXml(articleCreateDTO.content)}</textarea>
                            </div>

                            <div class="form-group">
                                <label for="coverImage" class="form-label">Cover Image</label>
                                <input type="file" id="coverImage" name="coverImage" class="form-control-file"
                                    accept="image/*" data-image-preview-target="coverImagePreview" />
                                <img id="coverImagePreview" class="preview-image image-preview"
                                    alt="Selected article cover preview" hidden />
                                <p class="text-muted text-sm mt-1">Upload Size: Max 10MB.</p>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Save as Draft</button>
                                <a href="<c:url value='/admin/articles'/>" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
