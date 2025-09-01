//
//  Formatter.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

// MARK: - FORMATTER CLASS
/// Class delcaring all the format functions for the app.
///  - Parameter Formatter: format functions
class Formatter {

    // MARK: - Phone Number Formatting
    /// Formats a phone number to the pattern 123-123-1234.
    /// - Parameter number: The phone number as a string.
    /// - Returns: The formatted phone number or the original number if invalid.
    static func formatPhoneNumber(_ number: String) -> String {
        // Remove any non-numeric characters
        var cleanedNumber = number.filter { $0.isNumber }

        // Limit to 10 digits
        if cleanedNumber.count > 10 {
            cleanedNumber = String(cleanedNumber.prefix(10))
        }

        // Format the number as 123-123-1234
        if cleanedNumber.count > 6 {
            cleanedNumber.insert(
                "-",
                at: cleanedNumber.index(cleanedNumber.startIndex, offsetBy: 6))
        }
        if cleanedNumber.count > 3 {
            cleanedNumber.insert(
                "-",
                at: cleanedNumber.index(cleanedNumber.startIndex, offsetBy: 3))
        }

        return cleanedNumber
    }

    /// Converts a UTC ISO8601 timestamp string into the local time of a given timezone.
    /// - Parameters:
    ///   - timestamp: The timestamp in ISO8601 format (e.g. "2025-05-29T16:03:08.000+00:00")
    ///   - timezoneIdentifier: Any valid IANA timezone string (e.g. "Asia/Karachi", "Asia/Kolkata", "America/New_York")
    /// - Returns: A formatted string like "April 6, 2020 12:34 PM" in the specified timezone.
    static func convertTimestamp(
        _ timestamp: String, to timezoneIdentifier: String
    ) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withFullDate,
            .withTime,
            .withTimeZone,  // Required for handling +00:00
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withFractionalSeconds,
        ]

        guard let date = isoFormatter.date(from: timestamp) else {
            print("❌ Invalid timestamp: \(timestamp)")
            return nil
        }

        guard let timeZone = TimeZone(identifier: timezoneIdentifier) else {
            print("❌ Invalid timezone identifier: \(timezoneIdentifier)")
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        outputFormatter.timeZone = timeZone
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        return outputFormatter.string(from: date)
    }

    // MARK: - API Phone Number Format Conversion
    /// Converts a phone number to the API format (XXX) XXX-XXXX.
    /// - Parameter number: The phone number as a string.
    /// - Returns: The formatted phone number or the original number if not exactly 10 digits.
    // Converts phone number to (XXX) XXX-XXXX format
    static func convertNumberToApiFormat(_ number: String) -> String {
        // Remove any non-numeric characters
        var cleanedNumber = number.filter { $0.isNumber }

        // Limit to 10 digits
        if cleanedNumber.count > 10 {
            cleanedNumber = String(cleanedNumber.prefix(10))
        }

        // Ensure it's exactly 10 digits
        guard cleanedNumber.count == 10 else {
            return number  // Return the original if it's not 10 digits
        }

        // Extract area code, first three digits, and last four digits
        let areaCode = cleanedNumber.prefix(3)
        let middle = cleanedNumber.dropFirst(3).prefix(3)
        let last = cleanedNumber.suffix(4)

        // Return formatted string
        return "(\(areaCode)) \(middle)-\(last)"
    }

    // MARK: - Email Masking
    /// Masks an email address by partially hiding the username and domain.
    /// - Parameter email: The email address as a string.
    /// - Returns: The masked email address or the original email if invalid.
    // Function to mask the email !
    static func formatEmailMasking(_ email: String) -> String {
        // Split the email into username and domain parts
        let parts = email.split(separator: "@")
        guard parts.count == 2 else {
            return email  // Return the original email if it's not valid
        }

        let username = String(parts[0])
        let domain = String(parts[1])

        // Mask the username part
        let maskedUsername: String
        if username.count > 2 {
            let prefix = username.prefix(2)
            maskedUsername = "\(prefix)*********"
        } else {
            maskedUsername = username
        }

        // Mask the domain part
        let domainParts = domain.split(separator: ".")
        guard domainParts.count >= 2 else {
            return email  // Return the original email if the domain is not valid
        }

        let domainName = String(domainParts[0])
        let domainExtension = String(domainParts[1])
        let maskedDomain = "***.\(domainExtension)"

        // Combine the masked parts
        return "\(maskedUsername)@\(maskedDomain)"
    }

    // MARK: - Date Formatting
    /// Formats a date string into a readable format (e.g., "January 18, 2025 4:30 PM").
    /// Supports multiple input date formats.
    /// - Parameter dateString: The date string to format.
    /// - Returns: The formatted date string or "Invalid Date" if parsing fails.
    static func FormatDate(_ dateString: String) -> String {
        let inputFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",  // 24-hour format with milliseconds and timezone
            "yyyy-MM-dd HH:mm:ss",  // 24-hour format without timezone
            "yyyy-MM-dd h:mm a",  // 12-hour format with AM/PM
            "yyyy-MM-dd'T'h:mm a",  // 12-hour format with AM/PM and 'T'
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",  // 24-hour format with timezone but without milliseconds
            "yyyy-MM-dd'T'HH:mm:ss",  // 24-hour format without timezone
        ]

        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        var date: Date? = nil
        for format in inputFormats {
            inputFormatter.dateFormat = format
            if let parsedDate = inputFormatter.date(from: dateString) {
                date = parsedDate
                break
            }
        }

        guard let validDate = date else {
            return "Invalid Date"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")  // Ensure 12-hour format
        outputFormatter.dateFormat = "MMMM d, yyyy h:mm a"  // Force 12-hour format
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"

        return outputFormatter.string(from: validDate)
    }
    
    // MARK: DATE AND TIME SEPARATE
    static func formatDateAndTime(_ dateString: String) -> (
        date: String, time: String
    )? {
        let inputFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd h:mm a",
            "yyyy-MM-dd'T'h:mm a",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss",
        ]

        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        var date: Date? = nil
        for format in inputFormats {
            inputFormatter.dateFormat = format
            if let parsedDate = inputFormatter.date(from: dateString) {
                date = parsedDate
                break
            }
        }

        guard let validDate = date else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d, yyyy"

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "h:mma"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"

        return (
            date: dateFormatter.string(from: validDate),
            time: timeFormatter.string(from: validDate)
        )
    }

    // MARK: TRANSACTION DATE
    static func FormatDateTransaction(_ dateString: String) -> String {
        let inputFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",  // 24-hour format with milliseconds and timezone
            "yyyy-MM-dd HH:mm:ss",  // 24-hour format without timezone
            "yyyy-MM-dd h:mm a",  // 12-hour format with AM/PM
            "yyyy-MM-dd'T'h:mm a",  // 12-hour format with AM/PM and 'T'
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",  // 24-hour format with timezone but without milliseconds
            "yyyy-MM-dd'T'HH:mm:ss",  // 24-hour format without timezone
        ]

        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        var date: Date? = nil
        for format in inputFormats {
            inputFormatter.dateFormat = format
            if let parsedDate = inputFormatter.date(from: dateString) {
                date = parsedDate
                break
            }
        }

        guard let validDate = date else {
            return "Invalid Date"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")  // Ensure 12-hour format
        outputFormatter.dateFormat = "MMMM d, yyyy "  // Force 12-hour format

        return outputFormatter.string(from: validDate)
    }

    // MARK: - UTC to Local Time Conversion
    /// Converts a UTC date string to the local time zone and formats it as "MMMM dd, yyyy".
    /// Supports multiple ISO 8601 date formats.
    /// - Parameter dateString: The UTC date string to convert.
    /// - Returns: The formatted local date string or the original string if parsing fails.
    static func convertUtcToLocalTime(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()

        // Define the possible formats for parsing ISO 8601 with timezone
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",  // Format with Z (e.g. 2024-11-25T14:08:03Z)
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  // Format with milliseconds and Z (e.g. 2024-11-25T14:08:03.000+00:00)
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",  // Format with milliseconds and offset (e.g. 2024-11-25T14:08:03.000+00:00)
        ]

        var utcDateTime: Date?
        for format in formats {
            dateFormatter.dateFormat = format
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")  // Ensure UTC time zone for parsing
            utcDateTime = dateFormatter.date(from: dateString)
            if utcDateTime != nil {
                break
            }
        }

        // If parsing fails, return the original string
        guard let parsedDateTime = utcDateTime else {
            return dateString
        }

        // Convert to local time
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "MMMM dd, yyyy"  // Format the output to "January 18, 2025"
        localDateFormatter.timeZone = TimeZone.current  // Use the local time zone

        return localDateFormatter.string(from: parsedDateTime)  // Return formatted date
    }

    //MARK: URL FORMATTER
    /// - Parameter url : format the url
    static func formatUrl(_ urlString: String) -> String? {
        if let url = URL(string: urlString) {
            return "\(url.scheme ?? "")://\(url.host ?? "")"
        }
        return nil
    }
}

//
//  CurrencyFormatter.swift
//  lut-terminal
//
//  Currency formatting utility for consistent number formatting across the app
//
// MARK: CURRENCY FORMATTER
struct CurrencyFormatter {
    
    // MARK: - Static Properties
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    // MARK: - Public Methods
    
    /// Formats a Double amount with commas and 2 decimal places
    /// - Parameter amount: The amount to format
    /// - Returns: Formatted string (e.g., "100,000.00")
    static func formatAmount(_ amount: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: amount)) ?? String(format: "%.2f", amount)
    }
    
    /// Formats a Double amount with dollar sign, commas and 2 decimal places
    /// - Parameter amount: The amount to format
    /// - Returns: Formatted currency string (e.g., "$100,000.00")
    static func formatCurrency(_ amount: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: amount)) ?? "$\(String(format: "%.2f", amount))"
    }
    
    /// Formats a String amount with commas and 2 decimal places
    /// - Parameter amount: The amount string to format
    /// - Returns: Formatted string (e.g., "100,000.00")
    static func formatAmount(_ amount: String) -> String {
        guard let doubleAmount = Double(amount) else {
            return amount
        }
        return formatAmount(doubleAmount)
    }
    
    /// Formats a String amount with dollar sign, commas and 2 decimal places
    /// - Parameter amount: The amount string to format
    /// - Returns: Formatted currency string (e.g., "$100,000.00")
    static func formatCurrency(_ amount: String) -> String {
        guard let doubleAmount = Double(amount) else {
            return amount.hasPrefix("$") ? amount : "$\(amount)"
        }
        return formatCurrency(doubleAmount)
    }
}
