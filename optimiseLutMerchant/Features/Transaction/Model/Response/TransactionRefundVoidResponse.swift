//
//  TransactionRefundVoidResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 29/08/25.
//

import Foundation

/// Represents the response for a refund or void transaction.
struct TransactionRefundVoidResponse: Codable {
    let authCode: String?
    let avResponse: String?
    let avResponseText: String?
    let cvResponseText: String?
    let cvvResponse: String?
    let emvAuthResponseData: String?
    let phone: String?
    let response: Int
    let responseCode: String
    let responseText: String
    let transactionDate: String
    let transactionId: String?
    let consumerName: String?
    
    enum CodingKeys: String, CodingKey {
        case authCode = "authcode"
        case avResponse = "avresponse"
        case avResponseText = "avresponsetext"
        case cvResponseText = "cvresponsetext"
        case cvvResponse = "cvvresponse"
        case emvAuthResponseData = "emv_auth_response_data"
        case phone
        case response
        case responseCode = "response_code"
        case responseText = "responsetext"
        case transactionDate = "transaction_date"
        case transactionId = "transaction_id"
        case consumerName = "consumer_name"
    }
}
