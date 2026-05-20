package com.disha.util;

import com.disha.model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * SessionUtil — All session reads and writes go through this class.
 *
 * Key design decisions:
 *  - On login: old session is INVALIDATED and a brand-new one is created
 *    (prevents session fixation attacks).
 *  - On logout: session.invalidate() destroys the entire session object
 *    (prevents session reuse after logout).
 *  - Flash messages: stored in session, consumed once, then removed.
 *  - Timeout: 30 minutes of inactivity.
 */
public class SessionUtil {

    // ── Session Attribute Keys ────────────────────────────────────────────────
    /** Full User object */
    public static final String USER      = "loggedInUser";
    /** User.Role enum value */
    public static final String ROLE      = "userRole";
    /** Full name string — for display in JSPs */
    public static final String USER_NAME = "userName";
    /** Integer user_id — for DAO queries */
    public static final String USER_ID   = "userId";
    /** One-time flash message text */
    public static final String FLASH_MSG  = "flashMessage";
    /** One-time flash message type: success | error | warning | info */
    public static final String FLASH_TYPE = "flashType";

    /** Session idle timeout — 30 minutes */
    public static final int TIMEOUT_SECONDS = 30 * 60;

    // ── Login — create fresh session ──────────────────────────────────────────

    /**
     * Called immediately after successful password verification.
     *
     * Invalidates any existing session first (session fixation prevention),
     * then creates a brand-new session and stores all user attributes.
     *
     * @param request current HTTP request
     * @param user    the authenticated User object from UserDAO
     */
    public static void setLoggedInUser(HttpServletRequest request, User user) {
        // Step 1: Invalidate existing session to prevent session fixation
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        // Step 2: Create a fresh session with a new session ID
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(TIMEOUT_SECONDS);

        // Step 3: Store all user attributes
        session.setAttribute(USER,      user);
        session.setAttribute(ROLE,      user.getRole().name());
        session.setAttribute(USER_NAME, user.getFullName());
        session.setAttribute(USER_ID,   user.getUserId());
    }

    // ── Read helpers ──────────────────────────────────────────────────────────

    /**
     * Get the logged-in User object from the session.
     * Returns null if no session exists or user is not logged in.
     */
    public static User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute(USER);
    }

    /**
     * Check whether a valid authenticated session exists.
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    /**
     * Check whether the logged-in user has a specific role.
     */
    public static boolean hasRole(HttpServletRequest request, User.Role expectedRole) {
        User user = getLoggedInUser(request);
        return user != null && user.getRole() == expectedRole;
    }

    /**
     * Get the logged-in user's role as a string (e.g. "STUDENT").
     * Returns empty string if not logged in.
     */
    public static String getRoleName(HttpServletRequest request) {
        User user = getLoggedInUser(request);
        return (user != null) ? user.getRole().name() : "";
    }

    // ── Logout ────────────────────────────────────────────────────────────────

    /**
     * Completely destroy the session on logout.
     * session.invalidate() marks the session ID as invalid server-side,
     * so a captured cookie cannot be reused after logout.
     */
    public static void invalidate(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    // ── Flash Messages ────────────────────────────────────────────────────────

    /**
     * Store a one-time flash message to survive a redirect.
     * The message is consumed and cleared on the next read.
     *
     * @param type "success" | "error" | "warning" | "info"
     */
    public static void setFlash(HttpServletRequest request, String type, String message) {
        // Use existing session if present, otherwise create one
        HttpSession session = request.getSession(true);
        session.setAttribute(FLASH_MSG,  message);
        session.setAttribute(FLASH_TYPE, type);
    }

    /**
     * Read and immediately clear the flash message.
     * Returns null if no flash message is pending.
     */
    public static String consumeFlashMessage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        String msg = (String) session.getAttribute(FLASH_MSG);
        if (msg != null) {
            session.removeAttribute(FLASH_MSG);
            session.removeAttribute(FLASH_TYPE);
        }
        return msg;
    }

    /**
     * Read the flash message type without clearing it.
     * Always call consumeFlashMessage() to clear after reading.
     */
    public static String getFlashType(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return "info";
        String type = (String) session.getAttribute(FLASH_TYPE);
        return (type != null) ? type : "info";
    }
}
