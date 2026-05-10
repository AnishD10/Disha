package com.disha.util;

/**
 * RoleConstants — Canonical string constants for all user roles in DISHA.
 *
 * Use these constants everywhere roles are compared as strings (JSP EL,
 * filter checks, etc.). For Java logic prefer the User.Role enum directly.
 *
 * Author: Joyal Karki — Authentication Lead
 */
public final class RoleConstants {

    // Prevent instantiation
    private RoleConstants() {
    }

    public static final String STUDENT = "STUDENT";
    public static final String PARENT = "PARENT";
    public static final String COUNSELOR = "COUNSELOR";
    public static final String ADMIN = "ADMIN";

    /**
     * Dashboard redirect paths per role.
     * Called by UserServlet after successful login.
     */
    public static String getDashboardPath(String role) {
        switch (role) {
            case STUDENT:
                return "/pages/student/dashboard.jsp";
            case PARENT:
                return "/pages/parent/dashboard.jsp";
            case COUNSELOR:
                return "/pages/counselor/dashboard.jsp";
            case ADMIN:
                return "/pages/admin/dashboard.jsp";
            default:
                return "/pages/auth/login.jsp";
        }
    }
}
