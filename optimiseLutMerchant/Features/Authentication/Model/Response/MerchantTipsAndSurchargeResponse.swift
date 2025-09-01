//
//  MerchantTipsAndSurchargeResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import Foundation

// MARK: - RESPONSE MODEL FOR TIPS AND SURCHARGE
/// Response that is expected from the api we will be getting
///  - Parameters : response : Integer
///  - Parameters : responseCode : Integer
///  - Parameters : responseText : String
///  - Parameters : responseObject : Object --> This Object will contain the Tips and Surcharge Details

struct MerchantTipsAndSurchargeResponse: Codable {

    var code: String?

    var message: String?

    var responseObject: MerchantTipsAndSurchargeResponseObject?

    init(
        code: String?,
        message: String?,
        responseObject: MerchantTipsAndSurchargeResponseObject?
    ) {
        self.code = code
        self.message = message
        self.responseObject = responseObject
    }
}

struct MerchantTipsAndSurchargeResponseObject: Codable {
    var tip: TipsDto?
    var surcharge: SurChargeDto?
}

struct TipsDto: Codable {
    var enabled: Bool?
    var options: [TipOptionDto]?

    private enum CodingKeys: String, CodingKey {
        case enabled, options
    }
}

struct TipOptionDto: Codable {
    var type: String?
    var value: Double?

    private enum CodingKeys: String, CodingKey {
        case type, value
    }
}

struct SurChargeDto: Codable {
    var enabled: Bool?
    var type: String?
    var value: Double?

    private enum CodingKeys: String, CodingKey {
        case enabled, type, value
    }
}
