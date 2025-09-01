//
//  ForgotPasswordResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

/// Model to handle the response for Forgot Password API call
class ForgotPasswordResponse: Codable {
    /// Status of the response (e.g., success or failure)
    var response: Int?
    
    /// Text message describing the response (e.g., "Success" or error message)
    var responseText: String?
    
    /// Code representing the type of response (e.g., HTTP status code)
    var responseCode: Int?
    
    /// Initializer to create a `ForgotPasswordResponse` object
    /// - Parameters:
    ///   - responseText: Message describing the response
    ///   - response: Status of the response
    ///   - responseCode: Code representing the response type
    init(
        responseText: String?,
        response: Int?,
        responseCode: Int?
    ) {
        self.responseText = responseText
        self.response = response
        self.responseCode = responseCode
    }
    
    /// Convenience initializer to create a `ForgotPasswordResponse` object from a JSON dictionary
    /// - Parameter json: Dictionary containing the JSON response data
    convenience init(from json: [String: Any]) {
        // Initialize the object with default values if keys are missing in the JSON
        self.init(
            responseText: json["responseText"] as? String ?? "Unknown",
            response: json["response"] as? Int ?? 0,
            responseCode: json["responseCode"] as? Int ?? 0
        )
    }
}
