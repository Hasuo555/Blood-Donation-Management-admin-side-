<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="asset" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Article — Edit" scope="request"/>
<%@ include file="../../layout/header.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Edit Article</h1>
        <p class="page-subtitle">${fn:escapeXml(article.title)}</p>
    </div>
    <a href="<c:url value='/admin/articles/${article.id}'/>" class="btn btn-secondary">← Back</a>
</div>

<div class="card" style="max-width:760px">
    <div class="card-header">Edit Article Details</div>
    <div class="card-body">
        <form method="post" action="<c:url value='/admin/articles/${article.id}/edit'/>"
              enctype="multipart/form-data" novalidate>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <label for="title" class="form-label">Title <span class="required">*</span></label>
                <input type="text" id="title" name="title"
                       value="${fn:escapeXml(articleUpdateDTO.title)}"
                       class="form-control" required/>
            </div>

            <div class="form-group">
                <label for="content" class="form-label">Content <span class="required">*</span></label>
                <textarea id="content" name="content" class="form-control" rows="12"
                          required>${fn:escapeXml(articleUpdateDTO.content)}</textarea>
            </div>

            <div class="form-group">
                <label for="coverImage" class="form-label">Replace Cover Image</label>
                <c:if test="${not empty article.coverImage}">
                    <img src="<asset:asset-url value="${article.coverImage}"/>" alt="Current cover"
                         class="preview-image mb-2"/>
                </c:if>
                <input type="file" id="coverImage" name="coverImage"
                       class="form-control-file" accept="image/*"/>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <a href="<c:url value='/admin/articles/${article.id}'/>" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="../../layout/footer.jsp" %>
