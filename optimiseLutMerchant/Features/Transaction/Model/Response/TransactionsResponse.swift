//
//  TransactionsResponse.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

class TransactionsResponse: Codable {
    var code: String?
    var merchantTransactionsDtos: [MerchantTransactionsDto]?
    var message: String?

    /// Constructor for creating a PaymentTransactionResponse instance.
    init(
        code: String? = nil,
        merchantTransactionsDtos: [MerchantTransactionsDto]? = nil,
        message: String? = nil
    ) {
        self.code = code
        self.merchantTransactionsDtos = merchantTransactionsDtos
        self.message = message
    }

    /// Factory initializer from a dictionary
    convenience init(from json: [String: Any]) {
        let code = json["code"] as? String
        let message = json["message"] as? String
        let transactionsJson =
            json["merchantTransactionsDtos"] as? [[String: Any]] ?? []
        let merchantTransactionsDtos = transactionsJson.map {
            MerchantTransactionsDto(from: $0)
        }

        self.init(
            code: code, merchantTransactionsDtos: merchantTransactionsDtos,
            message: message)
    }

    /// Method to convert the PaymentTransactionResponse instance to a JSON map.
    func toJson() -> [String: Any] {
        return [
            "code": code as Any,
            "merchantTransactionsDtos": merchantTransactionsDtos?.map {
                $0.toJson()
            } ?? [],
            "message": message as Any,
        ]
    }

    /// String representation for debugging.
    var description: String {
        let transactions =
            merchantTransactionsDtos?.map { $0.description }.joined(
                separator: ", ") ?? "[]"
        return
            "PaymentTransactionResponse{code: \(code ?? ""), message: \(message ?? ""), transactions: [\(transactions)]}"
    }
}
