//
//  TransactionDetailExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

extension TransactionDetail {

    // MARK: UPDATE TRANSACTION STATUS
    func updateTransactionStatus() {
        let transaction = transactionViewModel.selectedTransaction

        let isRefundable = transaction?.refundable == true
        let isVoided = transaction?.voided == true

        print(isRefundable)
        print(isVoided)

        switch (isRefundable, isVoided) {
        case (true, _):
            transactionStatusLabel = "Refundable"
            canRefund = true
            canVoid = false

        case (_, true):
            transactionStatusLabel = "Voided"
            canRefund = false
            canVoid = true

        default:
            transactionStatusLabel = "None"
            canRefund = false
            canVoid = false
        }
    }

    // MARK: TRANSACTION DETIAL VIEW
    var transactionDetailView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Transaction Details")
                    .foregroundColor(Color(hex: "#9747FF"))
                    .font(.custom("Poppins", size: 24))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)

                Text(
                    "\(CurrencyFormatter.formatCurrency(transactionViewModel.selectedTransaction?.amount ?? 0))"
                )
                .foregroundColor(.white)
                .font(.custom("Poppins-Bold", size: 72))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.top, 30)
                .fontWeight(.ultraLight)

                if let surchargeAmount = transactionViewModel
                    .selectedTransaction?.surcharge,
                    surchargeAmount > 0
                {
                    Text(
                        "includes $ \(String(format: "%.2f", surchargeAmount)) processing fee"
                    )
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Regular", size: 18))
                    .padding(.top, -20)
                }

                if let tipAmount = transactionViewModel.selectedTransaction?
                    .tip, tipAmount > 0
                {
                    let originalAmount =
                        transactionViewModel.selectedTransaction?.actualAmount
                        ?? 0
                    Text(
                        "$ \(CurrencyFormatter.formatAmount(originalAmount)) + $ \(String(format: "%.2f", tipAmount)) tip"
                    )
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 18))
                    .fontWeight(.ultraLight)
                    .padding(.top, -20)
                }

                let formattedDate = Formatter.formatDateAndTime(
                    transactionViewModel.selectedTransaction?.createdAt ?? "")

                let truncatedTransactionId =
                    (transactionViewModel.selectedTransaction?
                        .displayTransactionId ?? "").count > 12
                    ? "\((transactionViewModel.selectedTransaction?.displayTransactionId ?? "").prefix(12))..."
                    : transactionViewModel.selectedTransaction?
                        .displayTransactionId

                let maxNameLength = 25

                let cleanName =
                    (transactionViewModel.selectedTransaction?.name ?? "")
                    .prefix(1).capitalized
                    + (transactionViewModel.selectedTransaction?.name ?? "")
                    .dropFirst()

                let capitalizedName =
                    cleanName.count > maxNameLength
                    ? String(cleanName.prefix(maxNameLength)) + "..."
                    : cleanName

                Text(capitalizedName)
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 18))
                    .fontWeight(.light)
                    .padding(.top, 10)

                Text(
                    ValidationUtils.formatPhoneNumber(
                        transactionViewModel.selectedTransaction?.phone ?? "")
                )
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 18))
                .fontWeight(.light)
                .padding(.top, -20)

                Text("Reference No: \(truncatedTransactionId ?? "")")
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 18))
                    .fontWeight(.light)
                    .padding(.top, 10)

                Text("Date: \(formattedDate?.date ?? "N/A")")
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 18))
                    .fontWeight(.light)
                    .padding(.top, -20)

                Text("Time: \(formattedDate?.time ?? "N/A")")
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 18))
                    .fontWeight(.light)
                    .padding(.top, -20)

                Spacer()

            }
            Spacer()
        }
        .padding(.horizontal)
    }

    // MARK: ACTION BUTTONS
    var actionButtons: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Spacer().frame(height: 16)

                if canVoid {
                    Button {
                        // navigate to confirm void
                    } label: {
                        Text("Void Transaction")
                            .frame(minWidth: 179, minHeight: 43)
                            .background(
                                Color(
                                    red: 73 / 255, green: 21 / 255,
                                    blue: 158 / 255)
                            )
                            .foregroundColor(.white)
                            .font(.custom("Poppins", size: 16))
                            .fontWeight(.semibold)
                            .cornerRadius(8)
                            .clipShape(Capsule())
                    }
                } else if canRefund {
                    Button {
                        transactionViewModel.referenceTransaction = transactionViewModel.selectedTransaction
                        router.navigate(to: .payment(.processRefundAmount))
                    } label: {
                        Text("Process Refund")
                            .frame(minWidth: 165, minHeight: 43)
                            .background(
                                Color(
                                    red: 73 / 255, green: 21 / 255,
                                    blue: 158 / 255)
                            )
                            .foregroundColor(.white)
                            .font(.custom("Poppins", size: 18))
                            .fontWeight(.semibold)
                            .cornerRadius(8)
                            .clipShape(Capsule())
                    }
                }

                CustomButton(label: "Close") {
                    transactionViewModel.selectedTransaction = nil
                    router.navigateBack()
                }
            }

            Spacer()
        }
        .padding(.horizontal)
    }

}
