package com.disha.model.auth;

/**
 * Represents a user in the DISHA portal.
 * This can be a Student, Counselor, Parent, or Admin.
 * The object is used for authentication and profile display.
 * 
 * @author Ashmit
 */
public class User {

    private int userId;
    private String fullName;
    private String email;
    private String password;
    /** Role of the user: STUDENT, COUNSELOR, ADMIN, or PARENT */
    private String role;           
    /** Whether the student is flagged for counselor intervention */
    private boolean flagged;       
    /** Feedback or observations left by the counselor */
    private String counselorNote;  

    public User() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isFlagged() {
        return flagged;
    }

    public void setFlagged(boolean flagged) {
        this.flagged = flagged;
    }

    public String getCounselorNote() {
        return counselorNote;
    }

    public void setCounselorNote(String counselorNote) {
        this.counselorNote = counselorNote;
    }
}
