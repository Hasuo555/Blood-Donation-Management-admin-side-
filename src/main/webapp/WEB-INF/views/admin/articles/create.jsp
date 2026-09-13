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

                <div class="card module-form-card" style="max-width:760px">
                    <div class="card-header">Article Details</div>
                    <div class="card-body">
                        <form method="post" action="<c:url value='/admin/articles/create'/>"
                            enctype="multipart/form-data" novalidate>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="hospitalId" value="" />

                            <div class="form-group">
                                <label for="title" class="form-label">Title <span class="required">*</span></label>
                                <input type="text" id="title" name="title"
                                    value="${fn:escapeXml(articleCreateDTO.title)}" class="form-control" required />
                            </div>

                            <div class="form-group">
                                <label for="content" class="form-label">Content <span class="required">*</span></label>
                                <textarea id="content" name="content" class="form-control article-editor" rows="12"
                                    placeholder="Write your article content here…"
                                    required>${fn:escapeXml(articleCreateDTO.content)}</textarea>
                            </div>

                            <div class="form-group article-cover-field">
                                <label for="coverImage" class="form-label">Cover Image</label>
                                <div class="article-dropzone">
                                    <input type="file" id="coverImage" name="coverImage" class="form-control-file"
                                        accept="image/*" data-image-preview-target="coverImagePreview" />
                                    <img id="coverImagePreview" class="preview-image image-preview" hidden />
                                    <button type="button" class="image-upload-clear"
                                        data-image-preview-clear="coverImage" aria-label="Clear article cover image"
                                        title="Clear image">×</button>
                                </div>
                                <p class="text-muted text-sm mt-1">Upload Size: Max 10MB.</p>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-outline-primary">Save as Draft</button>
                                <a href="<c:url value='/admin/articles'/>" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
