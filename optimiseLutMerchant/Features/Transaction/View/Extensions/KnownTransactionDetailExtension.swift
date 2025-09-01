//
//  KnownTransactionDetailExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

extension KnownTransactionDetail {

    func fetchTransactionDetailsByReferenceId() {
        guard
            let referenceId = transactionViewModel.selectedTransaction?
                .referenceTransactionId
        else { return }

        if let fetchedTransaction =
            transactionViewModel.fetchTransactionFromUserDefaults(
                transactionId: referenceId)
        {
            referenceTransactionDetails = fetchedTransaction
        } else {
            DatadogLogging.error(
                "KnownTransactionDetail => Reference transaction not found for id: \(referenceId)"
            )
        }
    }

    var knownTransactionDetailView: some View {
        let transaction =
            referenceTransactionDetails
            ?? transactionViewModel.selectedTransaction
        let transactionAmount: String
        if let amount = transactionViewModel.selectedTransaction?.amount {
            transactionAmount = String(format: "%.2f", amount)
        } else {
            transactionAmount = "0.00"
        }
        let formattedInput = formatInput(transactionAmount)
        let formattedAmount = formatAmount(formattedInput)
        let formattedName = transaction?.name?.capitalized ?? ""
        let transactionMessage = getTransactionMessage()
        let transactionFormattedDate = formatTransactionDate()
        let transactionDetailsText =
            TransactionFormatter.buildTransactionDetailsText(
                transactionType: transactionType,
                selectedTransaction: transactionViewModel.selectedTransaction,
                referenceTransactionDetails: referenceTransactionDetails,
                transactionMessage: transactionMessage
            )

        return HStack {
            VStack(alignment: .leading, spacing: 15) {
                Spacer().frame(height: 100)
                Text("Transaction Details")
                    .foregroundColor(Color(hex: "#9747FF"))
                    .font(.system(size: 26, weight: .heavy))
                    .font(.custom("Poppins", size: 26))
                    .multilineTextAlignment(.leading)

                Text("\(CurrencyFormatter.formatCurrency(formattedAmount))")
                    .foregroundColor(.white)
                    //                .font(.custom("Poppins", size: 72))
                    .font(.system(size: 72))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)

                Text(formattedName)
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 20))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)

                Text(
                    Formatter.formatPhoneNumber(
                        transactionViewModel.selectedTransaction?.phone ?? "")
                )
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 20))
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .padding(.top, -20)
                .padding(.bottom, 20)

                Text(transactionDetailsText)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .font(.custom("Poppins", size: 20))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)

                if transactionType?.lowercased() == "refund"
                    && referenceTransactionDetails?.remainingAmount != 0.00
                {
                    Button(action: {
                        // navigate to process refund
                        transactionViewModel.referenceTransaction =
                            referenceTransactionDetails
                        transactionViewModel.transactiontype = referenceTransactionDetails?.type
                        router.navigate(to: .payment(.processRefundAmount))
                    }) {
                        Text("Process Refund")
                            .frame(minWidth: 165, minHeight: 43)
                            .background(
                                Color(
                                    red: 73 / 255,
                                    green: 21 / 255,
                                    blue: 158 / 255
                                )
                            )
                            .foregroundColor(.white)
                            .font(.custom("Poppins", size: 18))
                            .fontWeight(.semibold)
                            .cornerRadius(8)
                            .clipShape(Capsule())
                    }
                }

                CustomButton(
                    label: "Close",
                    action: {
                        router.navigateBack()
                    }
                )
                .padding(.bottom, 32)

                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal)

    }

    private func formatInput(_ amount: String) -> String {
        return amount
    }

    private func formatAmount(_ amount: String) -> String {
        return amount
    }

    private func getTransactionMessage() -> String {
        switch transactionType?.lowercased() {
        case "void":
            return "This transaction has been voided:"
        case "refund":
            return "This transaction has been refunded:"
        default:
            return ""
        }
    }

    private func formatTransactionDate() -> String {
        // Safely unwrap createdAt first
        guard let createdAt = referenceTransactionDetails?.createdAt else {
            return "Date not available"  // Default string if the date is nil
        }

        // If createdAt is non-nil, call toISOString() on it
        return Formatter.FormatDate(createdAt)
    }

}
