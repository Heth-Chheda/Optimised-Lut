//
//  ValidateCodeResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

/// Model to handle the response for Validate Code API call
class ValidateCodeResponse: Codable {
    
    /// Status of the response (e.g., success or failure)
    var response: Int?
    
    /// Text message describing the response (e.g., "Invalid Code" or success message)
    var responseText: String?
    
    /// Code representing the type of response (e.g., HTTP status code)
    var responseCode: Int?
    
    /// Additional object related to the response (can be nil)
    var responseObject: String?
    
    /// Initializer to create a `ValidateCodeResponse` object
    /// - Parameters:
    ///   - responseText: Message describing the response
    ///   - response: Status of the response
    ///   - responseCode: Code representing the response type
    ///   - responseObject: Additional object related to the response
    init(
        responseText: String?,
        response: Int?,
        responseCode: Int?,
        responseObject: String?
    ) {
        self.responseText = responseText
        self.response = response
        self.responseCode = responseCode
        self.responseObject = responseObject
    }
    
    /// Convenience initializer to create a `ValidateCodeResponse` object from a JSON dictionary
    /// - Parameter json: Dictionary containing the JSON response data
    convenience init(from json: [String: Any]) {
        self.init(
            responseText: json["responseText"] as? String ?? "Unknown",      // Default to "Unknown" if responseText is missing
            response: json["response"] as? Int ?? 0,                         // Default to 0 if response is missing
            responseCode: json["responseCode"] as? Int ?? 0,                 // Default to 0 if responseCode is missing
            responseObject: json["responseObject"] as? String                // Can be nil if responseObject is missing
        )
    }
}
