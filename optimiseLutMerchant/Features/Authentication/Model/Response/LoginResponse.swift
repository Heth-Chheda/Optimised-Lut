//
//  LoginResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

/// Represents the response received after a login attempt.
struct LoginResponse: Codable {
    var responseText: String?  // Message providing additional information about the response
    var response: Int?  // General response code
    var responseCode: Int?  // Specific code indicating the success or failure of the login
    var responseObject: ResponseObject?  // Encapsulates either a string or tokens

    private enum CodingKeys: String, CodingKey {
        case responseText, response, responseCode, responseObject
    }
}

/// A type to encapsulate the response object, which can be either tokens or a JSON string.
enum ResponseObject: Codable {
    case tokens(Tokens)  // Represents token details
    case jsonString(String)  // Represents a JSON string

    // Custom decoding logic to handle the different possible formats of ResponseObject
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let tokens = try? container.decode(Tokens.self) {
            self = .tokens(tokens)  // Decode as Tokens if successful
        } else if let jsonString = try? container.decode(String.self) {
            self = .jsonString(jsonString)  // Decode as String if successful
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Invalid ResponseObject format"
            )
        }
    }

    // Custom encoding logic to encode the appropriate format of ResponseObject
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .tokens(let tokens):
            try container.encode(tokens)  // Encode as Tokens
        case .jsonString(let jsonString):
            try container.encode(jsonString)  // Encode as String
        }
    }
}

/// Represents the token details returned upon a successful login.
struct Tokens: Codable {
    var accessToken: String  // The access token used for authenticated requests
    var refreshToken: String  // The refresh token used to obtain new access tokens

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"  // JSON key mapping for accessToken
        case refreshToken = "refresh_token"  // JSON key mapping for refreshToken
    }
}

/// Converts a JSON string to a `LoginResponse` object.
/// - Parameter jsonString: The JSON string to be converted.
/// - Returns: An optional `LoginResponse` object if decoding is successful.
func loginResponseFromJson(_ jsonString: String) -> LoginResponse? {
    let data = jsonString.data(using: .utf8)!  // Convert the string to Data
    let decoder = JSONDecoder()
    return try? decoder.decode(LoginResponse.self, from: data)  // Decode and return the LoginResponse
}

/// Converts a `LoginResponse` object to a JSON string.
/// - Parameter response: The `LoginResponse` object to be converted.
/// - Returns: An optional JSON string if encoding is successful.
func loginResponseToJson(_ response: LoginResponse) -> String? {
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(response) {
        return String(data: jsonData, encoding: .utf8)  // Convert Data back to JSON string
    }
    return nil  // Return nil if encoding fails
}
