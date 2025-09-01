//
//  MerchantDetailResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

/// Represents the response received when fetching merchant details.
struct MerchantDetailResponse: Codable {
    var code: String?  // Optional field for the response code
    var merchantDetailsDto: MerchantDetailsDto?  // Optional field containing detailed information about the merchant
    var message: String?  // Optional field for any additional message

    private enum CodingKeys: String, CodingKey {
        case code, merchantDetailsDto, message
    }
}

/// Represents detailed information about a merchant.
struct MerchantDetailsDto: Codable {
    var merchantAddress: String?  // The address of the merchant
    var merchantId: String?  // Unique identifier for the merchant
    var merchantName: String?  // The name of the merchant
    var mid: String?  // Merchant ID used for transactions
    var narration: String?  // Additional information or narration about the merchant
    var phone: String?
    var timezone: String?

    private enum CodingKeys: String, CodingKey {
        case merchantAddress, merchantId, merchantName, mid, narration, phone,
            timezone
    }
}

/// Converts a JSON string to a `MerchantDetailResponse` object.
/// - Parameter jsonString: The JSON string to be converted.
/// - Returns: An optional `MerchantDetailResponse` object if decoding is successful.
func merchantDetailResponseFromJson(_ jsonString: String)
    -> MerchantDetailResponse?
{
    let data = jsonString.data(using: .utf8)!  // Convert the JSON string to Data
    let decoder = JSONDecoder()
    return try? decoder.decode(MerchantDetailResponse.self, from: data)  // Decode and return the MerchantDetailResponse
}

/// Converts a `MerchantDetailResponse` object to a JSON string.
/// - Parameter response: The `MerchantDetailResponse` object to be converted.
/// - Returns: An optional JSON string if encoding is successful.
func merchantDetailResponseToJson(_ response: MerchantDetailResponse) -> String?
{
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(response) {
        return String(data: jsonData, encoding: .utf8)  // Convert Data back to JSON string
    }
    return nil  // Return nil if encoding fails
}
