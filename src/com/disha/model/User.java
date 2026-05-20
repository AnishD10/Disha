package com.disha.model;

import java.sql.Timestamp;

/**
 * User model representing a user in the Disha system.
 * Maps to the 'users' table in the database.
 */
public class User {

    public enum Role {
        STUDENT, ADMIN, COUNSELOR, PARENT
    }

    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private Role role;
    private String firstName;
    private String lastName;
    private String phone;
    private String address;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;

    // ── Constructors ──────────────────────────────────────
    public User() {
        this.role = Role.STUDENT;
        this.isActive = true;
    }

    public User(String firstName, String email, Role role) {
        this.firstName = firstName;
        this.email = email;
        this.role = role == null ? Role.STUDENT : role;
        this.isActive = true;
    }

    public User(String fullName, String email, String passwordHash, Role role) {
        setFullName(fullName);
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role == null ? Role.STUDENT : role;
        this.isActive = true;
    }

    // ── Getters & Setters ─────────────────────────────────
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public Role getRole() { return role == null ? Role.STUDENT : role; }
    public void setRole(Role role) { this.role = role; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    /** Convenience: returns "FirstName LastName" */
    public String getFullName() {
        String fn = (firstName != null ? firstName : "");
        String ln = (lastName != null ? lastName : "");
        String full = (fn + " " + ln).trim();
        return full.isEmpty() ? "Guest User" : full;
    }

    /** For backwards-compatibility with old JSP code */
    public void setFullName(String fullName) {
        if (fullName != null && !fullName.isBlank()) {
            String[] parts = fullName.trim().split("\\s+", 2);
            this.firstName = parts[0];
            this.lastName = parts.length > 1 ? parts[1] : "";
        }
    }

    /** Backwards compat: return userId as Long */
    public Long getId() { return (long) userId; }
    public void setId(Long id) { this.userId = id != null ? id.intValue() : 0; }
}
