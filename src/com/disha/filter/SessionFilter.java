package com.disha.filter;

import com.disha.model.User;
import com.disha.util.RoleConstants;
import com.disha.util.SessionUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * SessionFilter — Protects every URL in the application.
 *
 * Design: DENY BY DEFAULT.
 * Every path requires a valid session UNLESS it is on the PUBLIC whitelist.
 * Adding a new JSP page is automatically protected — no manual registration needed.
 *
 * Role restrictions:
 *   /pages/admin/      → ADMIN only
 *   /pages/counselor/  → COUNSELOR only
 *   /pages/parent/     → PARENT only
 *   /pages/student/    → STUDENT only
 *   /decision/         → STUDENT only
 */
@WebFilter(filterName = "SessionFilter", urlPatterns = {"/*"})
public class SessionFilter implements Filter {

    // Paths anyone can access without being logged in
    private static final Set<String> PUBLIC_EXACT = new HashSet<>(Arrays.asList(
            "/pages/auth/login.jsp",
            "/pages/auth/register.jsp",
            "/auth/login",
            "/auth/register",
            "/",
            "/favicon.ico"
    ));

    // Path PREFIXES anyone can access without being logged in (static assets)
    private static final String[] PUBLIC_PREFIXES = {
            "/css/", "/js/", "/images/", "/fonts/", "/pages/error/"
    };

    // Role-restricted path prefixes: { path_prefix, required_role }
    private static final String[][] ROLE_RESTRICTIONS = {
            {"/pages/admin/",     RoleConstants.ADMIN},
            {"/pages/counselor/", RoleConstants.COUNSELOR},
            {"/pages/parent/",    RoleConstants.PARENT},
            {"/pages/student/",   RoleConstants.STUDENT},
            {"/decision/",        RoleConstants.STUDENT},
    };

    @Override public void init(FilterConfig fc) throws ServletException {}
    @Override public void destroy() {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String fullURI     = req.getRequestURI();
        String path        = fullURI.substring(contextPath.length()); // strip /disha prefix

        // ── 1. Public paths — let through immediately ─────────────────────────
        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Must be logged in ──────────────────────────────────────────────
        User user = SessionUtil.getLoggedInUser(req);
        if (user == null) {
            // Save intended destination so we can redirect after login (optional enhancement)
            req.getSession(true).setAttribute("redirectAfterLogin", path);
            SessionUtil.setFlash(req, "warning", "Please log in to access that page.");
            resp.sendRedirect(contextPath + "/pages/auth/login.jsp");
            return;
        }

        // ── 3. Role-based restriction check ───────────────────────────────────
        for (String[] rule : ROLE_RESTRICTIONS) {
            String prefix       = rule[0];
            String requiredRole = rule[1];
            if (path.startsWith(prefix)) {
                if (!user.getRole().name().equals(requiredRole)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                            "Access denied. This section is for " + requiredRole + " accounts only.");
                    return;
                }
                break;
            }
        }

        // ── 4. All checks passed ──────────────────────────────────────────────
        chain.doFilter(request, response);
    }

    private boolean isPublic(String path) {
        if (PUBLIC_EXACT.contains(path)) return true;
        for (String prefix : PUBLIC_PREFIXES) {
            if (path.startsWith(prefix)) return true;
        }
        return false;
    }
}
