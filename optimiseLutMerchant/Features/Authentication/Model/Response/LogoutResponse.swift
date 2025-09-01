//
//  LogoutResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

/// Represents the response received after a logout attempt.
struct LogoutResponse: Codable {
    var responseText: String?  // Message providing additional information about the response
    var response: Int?  // General response code indicating the status of the logout
    var responseCode: Int?  // Specific code indicating the success or failure of the logout
    var responseObject: [String: AnyCodable]?  // Additional data returned in the response, if applicable

    // Custom coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case responseText, response, responseCode, responseObject
    }

    // Custom initializer to decode from a Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        responseText = try container.decodeIfPresent(
            String.self, forKey: .responseText)
        response = try container.decodeIfPresent(Int.self, forKey: .response)
        responseCode = try container.decodeIfPresent(
            Int.self, forKey: .responseCode)
        responseObject = try container.decodeIfPresent(
            [String: AnyCodable].self, forKey: .responseObject)
    }

    init(
        responseText: String? = nil,
        response: Int? = nil,
        responseCode: Int? = nil,
        responseObject: [String: AnyCodable]? = nil
    ) {
        self.responseText = responseText
        self.response = response
        self.responseCode = responseCode
        self.responseObject = responseObject
    }

    // Custom function to encode to an Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(responseText, forKey: .responseText)
        try container.encodeIfPresent(response, forKey: .response)
        try container.encodeIfPresent(responseCode, forKey: .responseCode)
        try container.encodeIfPresent(responseObject, forKey: .responseObject)
    }
}

/// A wrapper to encode and decode dynamic types.
struct AnyCodable: Codable {
    let value: Any  // Stores a value of any type

    // Initializes with any value
    init(_ value: Any) {
        self.value = value
    }

    // Custom decoding logic to handle various types
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Bool.self) {
            self.value = value
        } else if let value = try? container.decode(Int.self) {
            self.value = value
        } else if let value = try? container.decode(Double.self) {
            self.value = value
        } else if let value = try? container.decode(String.self) {
            self.value = value
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Cannot decode value")
        }
    }

    // Custom encoding logic for different types
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as Bool:
            try container.encode(v)
        case let v as Int:
            try container.encode(v)
        case let v as Double:
            try container.encode(v)
        case let v as String:
            try container.encode(v)
        default:
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "Cannot encode value"))
        }
    }
}

/// Converts a JSON string to a `LogoutMerchantResponse` object.
/// - Parameter jsonString: The JSON string to be converted.
/// - Returns: An optional `LogoutMerchantResponse` object if decoding is successful.
func logoutMerchantResponseFromJson(_ jsonString: String) -> LogoutResponse? {
    let data = jsonString.data(using: .utf8)!  // Convert the string to Data
    let decoder = JSONDecoder()
    return try? decoder.decode(LogoutResponse.self, from: data)  // Decode and return the LogoutMerchantResponse
}

/// Converts a `LogoutMerchantResponse` object to a JSON string.
/// - Parameter response: The `LogoutMerchantResponse` object to be converted.
/// - Returns: An optional JSON string if encoding is successful.
func logoutMerchantResponseToJson(_ response: LogoutResponse) -> String? {
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(response) {
        return String(data: jsonData, encoding: .utf8)  // Convert Data back to JSON string
    }
    return nil  // Return nil if encoding fails
}
