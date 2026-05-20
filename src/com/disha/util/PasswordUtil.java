package com.disha.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Password hashing and verification utilities.
 *
 * New registrations use salted SHA-256 in "base64Salt:base64Hash" format.
 * Verification also accepts the shared DB's existing formats:
 * "iterations:base64Salt:base64Hash" and legacy unsalted SHA-256 hex.
 */
public class PasswordUtil {

    private static final String SHA_ALGORITHM = "SHA-256";
    private static final String PBKDF2_ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int SALT_BYTES = 16;
    private static final String SEPARATOR = ":";

    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password must not be empty.");
        }
        byte[] salt = generateSalt();
        byte[] hashed = sha256(salt, plainPassword);
        return Base64.getEncoder().encodeToString(salt)
                + SEPARATOR
                + Base64.getEncoder().encodeToString(hashed);
    }

    public static boolean verify(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) return false;
        String[] parts = storedHash.split(SEPARATOR);
        try {
            if (parts.length == 2) {
                return verifySha256(plainPassword, parts);
            }
            if (parts.length == 3) {
                return verifyPbkdf2(plainPassword, parts);
            }
            if (storedHash.matches("(?i)^[0-9a-f]{64}$")) {
                return verifyLegacySha256Hex(plainPassword, storedHash);
            }
            return false;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public static String validateStrength(String password) {
        if (password == null || password.length() < 8) {
            return "Password must be at least 8 characters long.";
        }
        if (!password.matches(".*[A-Za-z].*")) {
            return "Password must contain at least one letter.";
        }
        if (!password.matches(".*[0-9].*")) {
            return "Password must contain at least one number.";
        }
        return null;
    }

    private static boolean verifySha256(String plainPassword, String[] parts) {
        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[1]);
        byte[] actualHash = sha256(salt, plainPassword);
        return MessageDigest.isEqual(expectedHash, actualHash);
    }

    private static boolean verifyPbkdf2(String plainPassword, String[] parts) {
        int iterations = Integer.parseInt(parts[0]);
        byte[] salt = Base64.getDecoder().decode(parts[1]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[2]);
        byte[] actualHash = pbkdf2(plainPassword, salt, iterations, expectedHash.length * 8);
        return MessageDigest.isEqual(expectedHash, actualHash);
    }

    private static boolean verifyLegacySha256Hex(String plainPassword, String storedHash) {
        byte[] actualHash = sha256(plainPassword.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        return MessageDigest.isEqual(hexToBytes(storedHash), actualHash);
    }

    private static byte[] generateSalt() {
        byte[] salt = new byte[SALT_BYTES];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    private static byte[] sha256(byte[] salt, String password) {
        try {
            MessageDigest md = MessageDigest.getInstance(SHA_ALGORITHM);
            md.update(salt);
            md.update(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            return md.digest();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available.", e);
        }
    }

    private static byte[] sha256(byte[] value) {
        try {
            return MessageDigest.getInstance(SHA_ALGORITHM).digest(value);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available.", e);
        }
    }

    private static byte[] hexToBytes(String hex) {
        byte[] bytes = new byte[hex.length() / 2];
        for (int i = 0; i < bytes.length; i++) {
            int index = i * 2;
            bytes[i] = (byte) Integer.parseInt(hex.substring(index, index + 2), 16);
        }
        return bytes;
    }

    private static byte[] pbkdf2(String password, byte[] salt, int iterations, int keyLengthBits) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, keyLengthBits);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(PBKDF2_ALGORITHM);
            return factory.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("PBKDF2 password verification failed.", e);
        }
    }
}
