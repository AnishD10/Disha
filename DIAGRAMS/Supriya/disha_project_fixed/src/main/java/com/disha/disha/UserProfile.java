package com.disha.disha;

/**
 * UserProfile — holds data for the logged-in student's profile.
 * Populated by PersonalDashboardServlet from the 'users' table.
 */
public class UserProfile {

    private int    id;
    private String fullName;
    private String email;
    private String phone;
    private String educationLevel;
    private String preferredCareer;
    private String memberSince;

    public UserProfile() {}

    public int    getId()                       { return id; }
    public void   setId(int id)                 { this.id = id; }

    public String getFullName()                       { return fullName; }
    public void   setFullName(String fullName)         { this.fullName = fullName; }

    public String getEmail()                          { return email; }
    public void   setEmail(String email)               { this.email = email; }

    public String getPhone()                          { return phone; }
    public void   setPhone(String phone)               { this.phone = phone; }

    public String getEducationLevel()                  { return educationLevel; }
    public void   setEducationLevel(String v)          { this.educationLevel = v; }

    public String getPreferredCareer()                 { return preferredCareer; }
    public void   setPreferredCareer(String v)         { this.preferredCareer = v; }

    public String getMemberSince()                     { return memberSince; }
    public void   setMemberSince(String memberSince)   { this.memberSince = memberSince; }
}
