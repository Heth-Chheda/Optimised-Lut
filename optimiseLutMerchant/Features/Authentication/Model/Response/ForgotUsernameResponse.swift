//
//  ForgotUsernameResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

// MARK: - ForgotUsernameResponse
/// Model for handling the response of the forgot username API.
class ForgotUsernameResponse: Codable {
    var response: Int?
    var responseText: String?
    var responseCode: Int?
    var object: String?

    /// Custom initializer for manual creation (if needed)
    init(
        responseText: String?,
        response: Int?,
        responseCode: Int?,
        object: String?
    ) {
        self.responseText = responseText
        self.response = response
        self.responseCode = responseCode
        self.object = object
    }

    /// Convenience initializer that parses the JSON dictionary manually
    ///
    /// - Parameter json: Dictionary containing the JSON response
    convenience init(from json: [String: Any]) {
        // Safely handle other properties and email directly
        self.init(
            responseText: json["responseText"] as? String ?? "Unknown",  // Provide default value if missing
            response: json["response"] as? Int ?? 0,  // Provide default value if missing
            responseCode: json["responseCode"] as? Int ?? 0,  // Provide default value if missing
            object: json["object"] as? String  // Extract email directly
        )
    }
}
