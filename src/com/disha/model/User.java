package com.disha.model;

public class User {

    public enum Role {
        STUDENT,
        ADMIN,
        COUNSELOR,
        PARENT
    }

    private String fullName;
    private String email;
    private Role role;

    public User() {
        this.fullName = "Guest User";
        this.role = Role.STUDENT;
    }

    public User(String fullName, String email, Role role) {
        this.fullName = fullName;
        this.email = email;
        this.role = role == null ? Role.STUDENT : role;
    }

    public String getFullName() {
        return fullName == null || fullName.isBlank() ? "Guest User" : fullName;
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

    public Role getRole() {
        return role == null ? Role.STUDENT : role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}