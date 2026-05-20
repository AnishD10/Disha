package com.disha.util;

/**
 * RoleConstants — Single source of truth for all role names and
 * their dashboard redirect paths.
 *
 * Use these constants everywhere. Never hardcode role strings.
 */
public final class RoleConstants {

    private RoleConstants() {}

    public static final String STUDENT   = "STUDENT";
    public static final String PARENT    = "PARENT";
    public static final String COUNSELOR = "COUNSELOR";
    public static final String ADMIN     = "ADMIN";

    /**
     * Returns the dashboard URL path for a given role string.
     * Called by UserServlet after successful login.
     */
    public static String getDashboardPath(String role) {
        switch (role) {
            case STUDENT:   return "/pages/student/dashboard.jsp";
            case PARENT:    return "/pages/parent/dashboard.jsp";
            case COUNSELOR: return "/pages/counselor/dashboard.jsp";
            case ADMIN:     return "/pages/admin/dashboard.jsp";
            default:        return "/pages/auth/login.jsp";
        }
    }
}
