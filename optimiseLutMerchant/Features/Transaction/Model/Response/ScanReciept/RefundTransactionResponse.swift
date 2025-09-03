//
//  RefundTransactionResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 02/09/25.
//

class RefundTransactionResponse: Codable {
    
    var code: String?
    var responseObject: MerchantTransactionsDto?
    var message: String?
    
    init(code: String? = nil, responseObject: MerchantTransactionsDto? = nil, message: String? = nil) {
        self.code = code
        self.responseObject = responseObject
        self.message = message
    }
}
