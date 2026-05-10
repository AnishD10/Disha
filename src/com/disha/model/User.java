package com.disha.model;

/**
 * User model representing all system users.
 * Supports roles: STUDENT, PARENT, COUNSELOR, ADMIN
 */
public class User {

    public enum Role {
        STUDENT, PARENT, COUNSELOR, ADMIN
    }

    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private Role role;
    private String phone;
    private String address;
    private java.sql.Timestamp createdAt;
    private boolean isActive;

    // ── Constructors ──────────────────────────────────────────────────────────

    public User() {
    }

    public User(String fullName, String email, String passwordHash, Role role) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.isActive = true;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

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

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String hash) {
        this.passwordHash = hash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }

    @Override
    public String toString() {
        return "User{id=" + userId + ", name='" + fullName + "', email='" + email + "', role=" + role + "}";
    }
}

// End of User.java