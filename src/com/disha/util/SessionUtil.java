package com.disha.util;

import com.disha.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * SessionUtil — Centralised session key constants and helper methods.
 *
 * NEVER hardcode session attribute names as strings outside this class.
 * All session reads/writes must go through these helpers to ensure
 * consistency and make future changes easy to apply across the system.
 *
 * Author: Joyal Karki — Authentication Lead
 */
public class SessionUtil {

    // ── Session Attribute Keys ────────────────────────────────────────────────

    /** The currently logged-in User object */
    public static final String USER = "loggedInUser";

    /** The role of the logged-in user (User.Role enum) */
    public static final String ROLE = "userRole";

    /** The user's full name — convenience shortcut for JSP display */
    public static final String USER_NAME = "userName";

    /** The user's database ID — frequently needed in DAO queries */
    public static final String USER_ID = "userId";

    /** Flash message key — set before redirect, read once and cleared */
    public static final String FLASH_MSG = "flashMessage";

    /** Flash message type: "success", "error", "warning", "info" */
    public static final String FLASH_TYPE = "flashType";

    // ── Session Timeout ───────────────────────────────────────────────────────

    /** Session idle timeout in seconds (30 minutes) */
    public static final int SESSION_TIMEOUT_SECONDS = 30 * 60;

    // ── Helper Methods ────────────────────────────────────────────────────────

    /**
     * Store the authenticated user in the session after successful login.
     * 
     * @param request the current HTTP request
     * @param user    the User object returned by UserDAO
     */
    public static void setLoggedInUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);

        session.setAttribute(USER, user);
        session.setAttribute(ROLE, user.getRole());
        session.setAttribute(USER_NAME, user.getFullName());
        session.setAttribute(USER_ID, user.getUserId());
    }

    /**
     * Retrieve the logged-in user from the session.
     * 
     * @return the User object, or null if not logged in
     */
    public static User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return null;
        return (User) session.getAttribute(USER);
    }

    /**
     * Check whether a valid authenticated session exists.
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    /**
     * Check whether the current session belongs to a user with the given role.
     */
    public static boolean hasRole(HttpServletRequest request, User.Role expectedRole) {
        User user = getLoggedInUser(request);
        return user != null && user.getRole() == expectedRole;
    }

    /**
     * Invalidate the current session entirely (logout).
     */
    public static void invalidate(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * Store a one-time flash message to be displayed after the next redirect.
     * 
     * @param type "success" | "error" | "warning" | "info"
     */
    public static void setFlash(HttpServletRequest request, String type, String message) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute(FLASH_MSG, message);
            session.setAttribute(FLASH_TYPE, type);
        }
    }

    /**
     * Retrieve and CLEAR the flash message (so it only shows once).
     * 
     * @return the message string, or null if none pending
     */
    public static String consumeFlashMessage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return null;
        String msg = (String) session.getAttribute(FLASH_MSG);
        session.removeAttribute(FLASH_MSG);
        session.removeAttribute(FLASH_TYPE);
        return msg;
    }

    /**
     * Get the flash message type without clearing it.
     */
    public static String getFlashType(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return "info";
        String type = (String) session.getAttribute(FLASH_TYPE);
        return (type != null) ? type : "info";
    }
}
