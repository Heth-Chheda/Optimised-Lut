//
//  MerchantTransactionsDto.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import Foundation

class MerchantTransactionsDto: Codable, Identifiable, Equatable {
    var id: String { displayTransactionId ?? UUID().uuidString }

    var merchantId: String?
    var name: String?
    var phone: String?
    var createdAt: String?
    var amount: Double?
    var actualAmount: Double?
    var tip: Double?
    var surcharge: Double?
    var transactionId: String?
    var displayTransactionId: String?
    var status: String?
    var refundable: Bool?
    var remainingAmount: Double?
    var referenceTransactionId: String?
    var type: String?
    var entryType: String?
    var label: String?
    var voided: Bool?

    /// Initializer
    init(
        merchantId: String? = nil,
        name: String? = nil,
        phone: String? = nil,
        createdAt: String? = nil,
        amount: Double? = nil,
        actualAmount: Double? = nil,
        tip: Double? = nil,
        surcharge: Double? = nil,
        transactionId: String? = nil,
        displayTransactionId: String? = nil,
        status: String? = nil,
        refundable: Bool? = nil,
        remainingAmount: Double? = nil,
        referenceTransactionId: String? = nil,
        type: String? = nil,
        entryType: String? = nil,
        label: String? = nil,
        voided: Bool? = nil
    ) {
        self.merchantId = merchantId
        self.name = name
        self.phone = phone
        self.createdAt = createdAt
        self.amount = amount
        self.actualAmount = actualAmount
        self.tip = tip
        self.surcharge = surcharge
        self.transactionId = transactionId
        self.displayTransactionId = displayTransactionId
        self.status = status
        self.refundable = refundable
        self.remainingAmount = remainingAmount
        self.referenceTransactionId = referenceTransactionId
        self.type = type
        self.entryType = entryType
        self.label = label
        self.voided = voided
    }

    /// Factory initializer from a dictionary
    convenience init(from json: [String: Any]) {
        let merchantId = json["merchantId"] as? String
        let name = json["name"] as? String
        let phone = json["phone"] as? String
        let createdAt = json["createdAt"] as? String
        let amount = json["amount"] as? Double
        let actualAmount = json["actualAmount"] as? Double
        let tip = json["tip"] as? Double
        let surcharge = json["surcharge"] as? Double
        let transactionId = json["transactionId"] as? String
        let displayTransactionId = json["displayTransactionId"] as? String
        let status = json["status"] as? String
        let refundable = json["refundable"] as? Bool
        let remainingAmount = json["remainingAmount"] as? Double
        let referenceTransactionId = json["referenceTransactionId"] as? String
        let type = json["type"] as? String
        let entryType = json["entryType"] as? String
        let label = json["label"] as? String
        let voided = json["voided"] as? Bool

        self.init(
            merchantId: merchantId,
            name: name,
            phone: phone,
            createdAt: createdAt,
            amount: amount,
            actualAmount: actualAmount,
            tip: tip,
            surcharge: surcharge,
            transactionId: transactionId,
            displayTransactionId: displayTransactionId,
            status: status,
            refundable: refundable,
            remainingAmount: remainingAmount,
            referenceTransactionId: referenceTransactionId,
            type: type,
            entryType: entryType,
            label: label,
            voided: voided
        )
    }
    
    static func == (lhs: MerchantTransactionsDto, rhs: MerchantTransactionsDto) -> Bool {
        return lhs.merchantId == rhs.merchantId && lhs.name == rhs.name
            && lhs.phone == rhs.phone && lhs.createdAt == rhs.createdAt
            && lhs.amount == rhs.amount
            && lhs.actualAmount == rhs.actualAmount
            && lhs.tip == rhs.tip
            && lhs.surcharge == rhs.surcharge
            && lhs.transactionId == rhs.transactionId
            && lhs.displayTransactionId == rhs.displayTransactionId
            && lhs.status == rhs.status && lhs.refundable == rhs.refundable
            && lhs.remainingAmount == rhs.remainingAmount
            && lhs.referenceTransactionId == rhs.referenceTransactionId
            && lhs.type == rhs.type && lhs.entryType == rhs.entryType
            && lhs.label == rhs.label && lhs.voided == rhs.voided
    }

    /// Converts to dictionary
    func toJson() -> [String: Any] {
        var json: [String: Any] = [:]
        json["merchantId"] = merchantId
        json["name"] = name
        json["phone"] = phone
        json["createdAt"] = createdAt
        json["amount"] = amount
        json["actualAmount"] = actualAmount
        json["tip"] = tip
        json["surcharge"] = surcharge
        json["transactionId"] = transactionId
        json["displayTransactionId"] = displayTransactionId
        json["status"] = status
        json["refundable"] = refundable
        json["remainingAmount"] = remainingAmount
        json["referenceTransactionId"] = referenceTransactionId
        json["type"] = type
        json["label"] = label
        json["entryType"] = entryType
        json["voided"] = voided
        return json
    }

    /// Debug description
    var description: String {
        return """
            MerchantTransactionsDto {
                merchantId: \(merchantId ?? "nil"),
                name: \(name ?? "nil"),
                phone: \(phone ?? "nil"),
                createdAt: \(createdAt ?? "nil"),
                amount: \(amount != nil ? String(amount!) : "nil"),
                actualAmount: \(actualAmount != nil ? String(actualAmount!) : "nil"),
                tip: \(tip != nil ? String(tip!) : "tip"),
                surcharge: \(surcharge != nil ? String(surcharge!) : "nil"),
                transactionId: \(transactionId ?? "nil"),
                displayTransactionId: \(displayTransactionId ?? "nil"),
                status: \(status ?? "nil"),
                refundable: \(refundable != nil ? String(refundable!) : "nil"),
                remainingAmount: \(remainingAmount != nil ? String(remainingAmount!) : "nil"),
                referenceTransactionId: \(referenceTransactionId ?? "nil"),
                type: \(type ?? "nil"),
                entryType: \(entryType ?? "nil"),
                label: \(label ?? "nil"),
                voided: \(voided != nil ? String(voided!) : "nil")
            }
            """
    }
}
