package com.disha.filter;

import com.disha.model.User;
import com.disha.util.RoleConstants;
import com.disha.util.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * SessionFilter — Intercepts all requests to protected areas of DISHA.
 *
 * Rules:
 * 1. Public paths (login, register, static assets) pass through freely.
 * 2. Any other path requires a valid session. No session → redirect to login.
 * 3. Role-based path guards: certain URL prefixes are restricted to specific
 * roles.
 * Accessing a role-restricted page with the wrong role → 403 Forbidden.
 *
 * This filter fires on every request to the application (urlPattern = "/*").
 * The public path whitelist is checked first to keep the fast path fast.
 *
 * Author: Joyal Karki — Authentication Lead
 */
@WebFilter(filterName = "SessionFilter", urlPatterns = { "/*" })
public class SessionFilter implements Filter {

    // ── Public Path Whitelist ─────────────────────────────────────────────────
    // These paths are accessible without a session.

    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
            "/pages/auth/login.jsp",
            "/pages/auth/register.jsp",
            "/auth/login",
            "/auth/register",
            "/index.jsp",
            "/css/",
            "/js/",
            "/images/",
            "/favicon.ico"));

    // ── Role-Restricted Path Prefixes ─────────────────────────────────────────
    // If a URL starts with any of these prefixes, only the specified role is
    // allowed.

    private static final String[][] ROLE_RESTRICTIONS = {
            { "/pages/admin/", RoleConstants.ADMIN },
            { "/pages/counselor/", RoleConstants.COUNSELOR },
            { "/pages/parent/", RoleConstants.PARENT },
            { "/pages/student/", RoleConstants.STUDENT },
            { "/decision/", RoleConstants.STUDENT },
    };

    // ── Filter Lifecycle ──────────────────────────────────────────────────────

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialisation needed
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }

    // ── Core Filter Logic ─────────────────────────────────────────────────────

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String requestURI = req.getRequestURI();
        // Strip context path to get the path relative to the app root
        String relativePath = requestURI.substring(contextPath.length());

        // ── 1. Allow public paths through immediately ──────────────────────────
        if (isPublicPath(relativePath)) {
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Check authentication ───────────────────────────────────────────
        User loggedInUser = SessionUtil.getLoggedInUser(req);

        if (loggedInUser == null) {
            // No valid session — save intended destination and redirect to login
            SessionUtil.setFlash(req, "warning",
                    "Please log in to access that page.");
            resp.sendRedirect(contextPath + "/pages/auth/login.jsp");
            return;
        }

        // ── 3. Check role-based restrictions ──────────────────────────────────
        for (String[] restriction : ROLE_RESTRICTIONS) {
            String prefix = restriction[0];
            String requiredRole = restriction[1];

            if (relativePath.startsWith(prefix)) {
                if (!loggedInUser.getRole().name().equals(requiredRole)) {
                    // Authenticated but wrong role
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                            "You do not have permission to access this page. " +
                                    "Required role: " + requiredRole);
                    return;
                }
                break; // Only one restriction can match — no need to continue
            }
        }

        // ── 4. All checks passed — allow the request through ──────────────────
        chain.doFilter(request, response);
    }

    // ── Private Helpers ───────────────────────────────────────────────────────

    /**
     * Check if the given relative path is in the public whitelist.
     * Supports exact matches and prefix matches (for static asset directories).
     */
    private boolean isPublicPath(String relativePath) {
        for (String publicPath : PUBLIC_PATHS) {
            if (publicPath.endsWith("/")) {
                // Directory prefix match (e.g., /css/, /js/)
                if (relativePath.startsWith(publicPath))
                    return true;
            } else {
                // Exact path match
                if (relativePath.equals(publicPath))
                    return true;
            }
        }
        return false;
    }
}
