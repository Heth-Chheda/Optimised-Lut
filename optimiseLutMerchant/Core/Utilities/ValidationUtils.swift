//
//  ValidationUtils.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

/// A utility class for various validation and formatting functions.
class ValidationUtils {
    
    // MARK: - Email Validation
    /// Validates the format of an email address.
    /// - Parameter email: The email address to validate.
    /// - Returns: A `ValidationResult` indicating whether the email is valid and an optional error message.
    static func isValidEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return ValidationResult(isValid: false, errorMessage: "Please enter your username to proceed.")
        }

        let emailRegex = "^[\\w.-]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
            ? ValidationResult(isValid: true)
            : ValidationResult(isValid: false, errorMessage: "Please enter a valid email.")
    }

    // MARK: - Password Validation
    /// Validates the format and strength of a password.
    /// - Parameter password: The password to validate.
    /// - Returns: An optional error message if the password is invalid; otherwise, returns nil.
    static func isValidPassword(_ password: String) -> String? {
        if password.isEmpty {
            return "Please enter your password to proceed."
        }
        
        if password.count < 8 {
            return "The username or password you entered is incorrect. Please try again."
        }
        if password.count > 16 {
            return "The username or password you entered is incorrect. Please try again."
        }
        
        if !password.contains(where: { "!@#$%^&*(),.?\":{}|<>".contains($0) }) {
            return "The username or password you entered is incorrect. Please try again."
        }
        
        if !password.contains(where: { $0.isUppercase }) {
            return "The username or password you entered is incorrect. Please try again."
        }
        
        if !password.contains(where: { $0.isLowercase }) {
            return "The username or password you entered is incorrect. Please try again."
        }
        
        if !password.contains(where: { $0.isNumber }) {
            return "The username or password you entered is incorrect. Please try again."
        }
        
        return nil
    }
    
    static func validatePassword(_ password: String) -> Bool {
        let passwordRegex =
            "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    // MARK: - Capitalize First Letter of Each Word
    /// Capitalizes the first letter of each word in a string.
    /// - Parameter input: The input string.
    /// - Returns: A string with the first letter of each word capitalized.
    static func capitalizeFirstLetterOfEachWord(_ input: String) -> String {
        return input.split(separator: " ").map { word in
            word.isEmpty ? "" : word.prefix(1).uppercased() + word.dropFirst()
        }.joined(separator: " ")
    }

    // MARK: - Phone Number Formatting
    /// Formats a phone number into a standard format.
    /// - Parameter phone: The phone number to format.
    /// - Returns: A formatted phone number string.
    static func formatPhoneNumber(_ phone: String) -> String {
        let cleanedPhone = phone.filter { "0123456789".contains($0) }
        let regex = try! NSRegularExpression(pattern: "(\\d{3})(\\d{3})(\\d{4})")
        let range = NSRange(location: 0, length: cleanedPhone.utf16.count)

        return regex.stringByReplacingMatches(in: cleanedPhone, options: [], range: range, withTemplate: "$1-$2-$3")
    }

    // MARK: - Get App Version
    /// Retrieves the current app version.
    /// - Returns: A string representing the app version, or "Unknown version" if not found.
    static func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown version"
    }
    
    static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\(?[0-9]{3}\\)?[-.\\s]?[0-9]{3}[-.\\s]?[0-9]{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}
