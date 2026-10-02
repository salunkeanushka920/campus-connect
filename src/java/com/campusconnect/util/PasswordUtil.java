package com.campusconnect.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility for hashing and verifying passwords using SHA-256.
 * Beginner-friendly and standard for viva explanation.
 */
public class PasswordUtil {

    /**
     * Hashes a plain password using SHA-256.
     * @param plainText plain string
     * @return 64-character hexadecimal SHA-256 string
     */
    public static String hashPassword(String plainText) {
        if (plainText == null) return "";
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(plainText.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
            return plainText; // fallback
        }
    }

    /**
     * Verifies plain text password against stored password.
     * Accepts either SHA-256 hashed password or plain text (for easy viva demo / Workbench testing).
     */
    public static boolean verifyPassword(String inputPassword, String storedPassword) {
        if (inputPassword == null || storedPassword == null) {
            return false;
        }
        // Direct plain match
        if (inputPassword.equals(storedPassword)) {
            return true;
        }
        // Hash comparison
        String hashedInput = hashPassword(inputPassword);
        return hashedInput.equalsIgnoreCase(storedPassword);
    }
}
