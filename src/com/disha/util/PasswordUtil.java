package com.disha.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * PasswordUtil — Handles all password hashing and verification for DISHA.
 *
 * Strategy: SHA-256 with a random 16-byte salt, stored as "salt:hash" (Base64).
 * This is sufficient for the academic context of this project.
 * In production, BCrypt / Argon2 would be preferred.
 *
 * Format stored in DB: BASE64(salt) + ":" + BASE64(SHA256(salt + password))
 *
 * Author: Joyal Karki — Authentication Lead
 */
public class PasswordUtil {

    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_BYTES = 16;
    private static final String SEPARATOR = ":";

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Hash a plain-text password.
     * 
     * @param plainPassword the raw password entered by the user
     * @return a storable hash string: "base64Salt:base64Hash"
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password must not be null or empty.");
        }

        byte[] salt = generateSalt();
        byte[] hashed = sha256(salt, plainPassword);

        return Base64.getEncoder().encodeToString(salt)
                + SEPARATOR
                + Base64.getEncoder().encodeToString(hashed);
    }

    /**
     * Verify a plain-text password against a stored hash.
     * 
     * @param plainPassword the password entered at login
     * @param storedHash    the "salt:hash" value from the DB
     * @return true if the password matches, false otherwise
     */
    public static boolean verify(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null)
            return false;

        String[] parts = storedHash.split(SEPARATOR, 2);
        if (parts.length != 2)
            return false;

        try {
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[1]);
            byte[] actualHash = sha256(salt, plainPassword);

            // Constant-time comparison to prevent timing attacks
            return MessageDigest.isEqual(expectedHash, actualHash);
        } catch (IllegalArgumentException e) {
            // Malformed base64 in DB — should never happen in normal operation
            return false;
        }
    }

    /**
     * Validate password strength before hashing.
     * Rules: min 8 chars, at least one digit, at least one letter.
     * 
     * @param password the plain-text password to check
     * @return null if valid, or an error message string if invalid
     */
    public static String validateStrength(String password) {
        if (password == null || password.length() < 8) {
            return "Password must be at least 8 characters long.";
        }
        if (!password.matches(".*[A-Za-z].*")) {
            return "Password must contain at least one letter.";
        }
        if (!password.matches(".*[0-9].*")) {
            return "Password must contain at least one digit.";
        }
        return null; // valid
    }

    // ── Internal Helpers ──────────────────────────────────────────────────────

    private static byte[] generateSalt() {
        SecureRandom rng = new SecureRandom();
        byte[] salt = new byte[SALT_BYTES];
        rng.nextBytes(salt);
        return salt;
    }

    private static byte[] sha256(byte[] salt, String password) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            md.update(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            return md.digest();
        } catch (NoSuchAlgorithmException e) {
            // SHA-256 is guaranteed present in all Java SE implementations
            throw new RuntimeException("SHA-256 algorithm not available on this JVM.", e);
        }
    }
}
