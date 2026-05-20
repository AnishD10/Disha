package com.disha.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * PasswordUtil — Salted SHA-256 password hashing for DISHA.
 *
 * Storage format in DB:  BASE64(salt) + ":" + BASE64(SHA256(salt + password))
 * Example stored value:  "rW3kLp...==:Xh9mNq...=="
 */
public class PasswordUtil {

    private static final String ALGORITHM  = "SHA-256";
    private static final int    SALT_BYTES = 16;
    private static final String SEPARATOR  = ":";

    // ── Public API ────────────────────────────────────────────────────────────

    /**
     * Hash a plain-text password with a fresh random salt.
     * Call this once during registration — never during login.
     *
     * @param plainPassword raw password entered by user
     * @return "base64Salt:base64Hash" ready to store in DB
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password must not be empty.");
        }
        byte[] salt   = generateSalt();
        byte[] hashed = sha256(salt, plainPassword);
        return Base64.getEncoder().encodeToString(salt)
                + SEPARATOR
                + Base64.getEncoder().encodeToString(hashed);
    }

    /**
     * Verify a plain-text password against the stored hash.
     * Constant-time comparison prevents timing attacks.
     *
     * @param plainPassword password entered at login
     * @param storedHash    "salt:hash" string from the DB column
     * @return true if password is correct, false otherwise
     */
    public static boolean verify(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) return false;
        String[] parts = storedHash.split(SEPARATOR, 2);
        if (parts.length != 2) return false;
        try {
            byte[] salt         = Base64.getDecoder().decode(parts[0]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[1]);
            byte[] actualHash   = sha256(salt, plainPassword);
            return MessageDigest.isEqual(expectedHash, actualHash);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * Validate password strength rules.
     * Rules: min 8 chars, at least 1 letter, at least 1 digit.
     *
     * @return null if valid, or an error message string if invalid
     */
    public static String validateStrength(String password) {
        if (password == null || password.length() < 8)
            return "Password must be at least 8 characters long.";
        if (!password.matches(".*[A-Za-z].*"))
            return "Password must contain at least one letter.";
        if (!password.matches(".*[0-9].*"))
            return "Password must contain at least one number.";
        return null;
    }

    // ── Internal helpers ──────────────────────────────────────────────────────

    private static byte[] generateSalt() {
        byte[] salt = new byte[SALT_BYTES];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    private static byte[] sha256(byte[] salt, String password) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            md.update(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            return md.digest();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available.", e);
        }
    }
}
