//
//  TransactionFormatter.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import Foundation

struct TransactionFormatter {
    
    static func buildTransactionDetailsText(
        transactionType: String?,
        selectedTransaction: MerchantTransactionsDto?,
        referenceTransactionDetails: MerchantTransactionsDto?,
        transactionMessage: String
    ) -> String {
        
        var detailsText = ""
        
        if transactionType?.lowercased() == "sale" {
            detailsText +=
                "Reference No: \(selectedTransaction?.transactionId?.prefix(12) ?? "")\n"
            detailsText +=
                "Date: \(Formatter.formatDateAndTime(selectedTransaction?.createdAt ?? "")?.date ?? "Unknown") \n"
            detailsText +=
                "Time: \(Formatter.formatDateAndTime(selectedTransaction?.createdAt ?? "")?.time ?? "Unknown") \n"
        } else {
            if let transactionDetails = referenceTransactionDetails,
               let displayTransactionId = transactionDetails.displayTransactionId {
                detailsText += "Reference No: \(displayTransactionId.prefix(12))\n"
            }
            
            detailsText +=
                "Date: \(Formatter.formatDateAndTime(referenceTransactionDetails?.createdAt ?? "N/A")?.date ?? "N/A")\n"
            detailsText +=
                "Time: \(Formatter.formatDateAndTime(referenceTransactionDetails?.createdAt ?? "N/A")?.time ?? "N/A")\n\n"
            
            detailsText += transactionMessage + "\n\n"
            
            if transactionType?.lowercased() == "void" {
                if let idPrefix = selectedTransaction?.displayTransactionId?.prefix(12) {
                    detailsText += "Void " + String(idPrefix) + "\n"
                }
            } else if transactionType?.lowercased() == "refund" {
                if let idPrefix = selectedTransaction?.displayTransactionId?.prefix(12) {
                    detailsText += "Refund " + String(idPrefix) + "\n"
                }
            }
            
            detailsText +=
                "Date: \(Formatter.formatDateAndTime(referenceTransactionDetails?.createdAt ?? "N/A")?.date ?? "N/A")\n"
            detailsText +=
                "Time: \(Formatter.formatDateAndTime(referenceTransactionDetails?.createdAt ?? "N/A")?.time ?? "N/A")\n"
            
            detailsText +=
                "\nRemaining Balance: $\(CurrencyFormatter.formatAmount(referenceTransactionDetails?.remainingAmount ?? 0.00)) \n"
        }
        
        return detailsText
    }
}
