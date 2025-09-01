//
//  ViewAllTransactionExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

extension ViewAllTransaction {

    var viewAllTransactionHeader: some View {
        VStack {
            Text("Transaction List")
                //                .font(.custom("Poppins", size: 24))
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer().frame(height: UIScreen.main.bounds.width * 0.1)

            SearchField(text: $searchText, labelText: "Search")

            DividerView()

        }
    }

    var filteredTransactions: [MerchantTransactionsDto] {
        let transactions = transactionViewModel.transactions
        if searchText.isEmpty {
            return transactions
        } else {
            let query = searchText.lowercased()
                .replacingOccurrences(
                    of: "[\\s,\\.]", with: "", options: .regularExpression)

            return transactions.filter { transaction in
                let transactionId =
                    transaction.displayTransactionId?.lowercased()
                    .replacingOccurrences(
                        of: "[\\s,\\.]", with: "", options: .regularExpression)
                    ?? ""

                let amountString = String(
                    format: "%.2f", transaction.amount ?? 0.0
                )
                .replacingOccurrences(
                    of: "[\\s,\\.]", with: "", options: .regularExpression)

                return transactionId.contains(query)
                    || amountString.contains(query)
            }
        }
    }

    func navigateForTransaction(_ transaction: MerchantTransactionsDto) {
        let label = transaction.label ?? ""
        let status = transaction.status ?? ""
        let isRefundable = transaction.refundable ?? false
        let isVoided = transaction.voided ?? false

        // Optional: validate fields (currently unused)
        let emptyFields = [
            transaction.displayTransactionId?.isEmpty ?? true
                ? "Transaction ID" : nil,
            transaction.amount == nil ? "Amount" : nil,
            transaction.remainingAmount == nil ? "Remaining Amount" : nil,
            transaction.createdAt?.isEmpty ?? true ? "Date" : nil,
            transaction.name?.isEmpty ?? true ? "Name" : nil,
            transaction.phone?.isEmpty ?? true ? "Phone" : nil,
            transaction.type?.isEmpty ?? true ? "Status" : nil,
        ].compactMap { $0 }

        // Could show alert if needed:
        // if !emptyFields.isEmpty { showAlert(emptyFields) ; return }

        // Decide navigation
        switch true {
        case ["Dispute Submitted", "Decline claw back", "Dispute Cancelled"]
            .contains(label):
            router.navigate(to: .payment(.disputeTransaction))
        case status == "VOID" || status == "REFUND":
            router.navigate(to: .payment(.transactionDetail))
        case !isRefundable && !isVoided:
            router.navigate(to: .payment(.knownTransactionDetail))
        default:
            router.navigate(to: .payment(.transactionDetail))
        }
    }
}

// MARK: DIVIDER
struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundColor(Color(hex: "#9747FF"))
            .padding(.vertical, 8)
    }
}

// MARK: TRANSACTION LIST
struct TransactionList: View {
    let transactions: [MerchantTransactionsDto]
    let isLoadingMore: Bool
    let hasMorePages: Bool
    var onTransactionTap: (MerchantTransactionsDto) -> Void
    var onLoadMore: () -> Void
    let searchText: String

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(transactions.enumerated()), id: \.offset) {
                    index, transaction in
                    VStack(spacing: 0) {
                        TransactionItem(transaction: transaction) {
                            onTransactionTap(transaction)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.black)
                        .onTapGesture {
                            onTransactionTap(transaction)
                        }
                        .onAppear {
                            // Trigger pagination when near last 5 items
                            if searchText.isEmpty
                                && index >= transactions.count - 5
                                && hasMorePages
                                && !isLoadingMore
                            {
                                onLoadMore()
                            }
                        }

                        Divider()
                            .background(Color(hex: "#3B3B3B"))
                            .frame(height: 0.5)
                            .padding(.horizontal, 16)
                    }
                    .background(Color.black)
                }

                // Loading indicator
                if isLoadingMore && hasMorePages {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: Color(.purple))
                            )
                            .scaleEffect(0.8)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(Color.black)
                }
            }
        }
        .background(Color.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: TRANSACTION ITEM
struct TransactionItem: View {
    let transaction: MerchantTransactionsDto
    var onTap: () -> Void

    var textColor: Color {
        if transaction.label == "Transfer Pending" {
            return .white
        } else if transaction.entryType == "debit" {
            return .red
        } else if transaction.entryType == "credit" {
            return .green
        } else {
            return .white
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    let displayTransactionId = firstTwelveCharacters(
                        of: transaction.displayTransactionId ?? "N/A")
                    Text(displayTransactionId)
                        .font(.custom("Poppins", size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.white)

                    if let createdAt = transaction.createdAt {
                        Text(Formatter.FormatDateTransaction(createdAt))
                            .font(.custom("Poppins", size: 14))
                            .foregroundColor(.white)
                    } else {
                        Text("Date not available")
                            .font(.custom("Poppins", size: 14))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                Group {
                    if let amount = transaction.amount {
                        let formattedAmount = String(format: "%.2f", amount)

                        VStack(alignment: .trailing, spacing: 3) {
                            Text("$\(formattedAmount)")
                                .font(.custom("Poppins", size: 18))
                                .fontWeight(.regular)
                                .foregroundColor(textColor)
                                .lineLimit(1)
                                .multilineTextAlignment(.trailing)

                            let displayLabel =
                                (transaction.label?.isEmpty ?? true
                                    || transaction.label == "<null>")
                                ? ""
                                : transaction.label!

                            Text(displayLabel)
                                .font(.custom("Poppins", size: 10))
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding([.leading, .trailing], 10)
                    } else {
                        Text("Amount not available")
                            .font(.custom("Poppins", size: 18))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onTapGesture {
            onTap()
        }
    }

    private func firstTwelveCharacters(of text: String) -> String {
        return String(text.prefix(12))
    }
}
