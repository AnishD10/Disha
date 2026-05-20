<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav style="display: flex; justify-content: space-between; align-items: center; padding: 1.25rem 2rem; background: var(--color-surface); box-shadow: var(--shadow-sm); position: sticky; top: 0; z-index: 100;">
    <div>
        <a href="<%= request.getContextPath() %>/" style="font-weight: 800; font-size: 1.5rem; letter-spacing: 1px; color: var(--color-primary);">DISHA</a>
    </div>
    <div style="display: flex; gap: 1.5rem; align-items: center;">
        <a href="<%= request.getContextPath() %>/" style="font-weight: 500; color: var(--color-text);">Home</a>
        <a href="<%= request.getContextPath() %>/JSP/auth/login.jsp" class="btn btn-primary" style="padding: 0.5rem 1.25rem;">Login / Register</a>
    </div>
</nav>
