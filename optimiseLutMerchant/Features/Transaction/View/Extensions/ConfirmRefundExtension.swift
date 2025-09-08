//
//  ConfirmRefundExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 28/08/25.
//

import SwiftUI

extension ConfirmRefundOrVoid {

    private func generateTransactionId() -> String {
        let chars = Array(
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

        guard let type = transactionViewModel.transactiontype?.lowercased()
        else {
            return transactionViewModel.referenceTransaction?.refundable
                ?? false ? "refund" : "void"
        }

        let (prefix, length): (String, Int)

        switch type {
        case "void":
            (prefix, length) = ("VOID", 8)
        case "refund":
            (prefix, length) = ("REF", 9)
        default:
            return ""
        }

        let suffix = (0..<length)
            .compactMap { _ in chars.randomElement() }
            .map(String.init)
            .joined()

        return prefix + suffix
    }

    func voidTransaction() {

        // generate the transaction id
        let newVoidTransactionId = generateTransactionId()

        Task {
            await transactionViewModel.performVoidTransaction(
                accessToken: authenticationViewModel.accessToken ?? "",
                transactionId: newVoidTransactionId,
                referenceTransactionId: transactionViewModel
                    .referenceTransaction?.transactionId ?? ""
            )
        }

    }

    func refundTransaction() {

        // generate the transaction id
        let newRefundTransactionId = generateTransactionId()

        Task {
            await transactionViewModel.performRefundTransaction(
                accessToken: authenticationViewModel.accessToken ?? "",
                transactionId: newRefundTransactionId,
                referenceTransactionId: transactionViewModel
                    .referenceTransaction?.transactionId ?? ""
            )
        }

    }

    var confirmRefundView: some View {
        HStack {

            VStack(alignment: .leading, spacing: 16) {
                let confirmationText =
                    transactionViewModel.transactiontype == "Void"
                    ? "Confirm Void" : "Process Refund"

                Text(confirmationText)
                    .foregroundColor(Color(hex: "#9747FF"))
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.leading)

                Text(
                    "\(String(format: "%.2f", transactionViewModel.amountForPayment))"
                )
                .foregroundColor(.white)
                .font(.system(size: 72))

                Text(transactionViewModel.referenceTransaction?.name ?? "")
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 18))

                Text(
                    "\(ValidationUtils.formatPhoneNumber(transactionViewModel.referenceTransaction?.phone ?? ""))"
                )
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 18))
                .padding(.top, -16)

                Text(
                    "Reference No: \(transactionViewModel.referenceTransaction?.displayTransactionId ?? "")"
                )
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 18))
                .padding(.top, 20)

                Text(
                    "Date: \(Formatter.formatDateAndTime(transactionViewModel.referenceTransaction?.createdAt ?? "")?.date ?? "Unknown")"
                )
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 18))
                .padding(.top, -16)

                Text(
                    "Time: \(Formatter.formatDateAndTime(transactionViewModel.referenceTransaction?.createdAt ?? "")?.time ?? "Unknown")"
                )
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 18))
                .padding(.top, -16)

                if let errorMessage = errorMesssage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                }

                Spacer()

                actionButtons
                    .padding(.bottom, 100)
            }

            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            transactionType = transactionViewModel.transactiontype ?? ""
        }
    }

    var actionButtons: some View {
        VStack {
            Button {
                // button action based on the type VOID or REFUND
                transactionType.lowercased() == "void"
                    ? voidTransaction() : refundTransaction()
            } label: {
                Text(
                    transactionType == "Void"
                        ? "Confirm Void" : "Confirm Refund"
                )
                .frame(minWidth: 230, minHeight: 43)
                .background(
                    Color(
                        red: 73 / 255,
                        green: 21 / 255,
                        blue: 158 / 255
                    )
                )
                .font(.custom("Poppins", size: 16))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .cornerRadius(8)
                .clipShape(Capsule())
            }

            Button {
                // button action based on the type VOID or REFUND
                router.navigateBack()
            } label: {
                Text(
                    transactionViewModel.transactiontype == "Void"
                        ? "Cancel Void" : "Cancel Refund"
                )
                .frame(minWidth: 230, minHeight: 43)
                .background(
                    Color(red: 0 / 255, green: 133 / 255, blue: 255 / 255)
                )
                .font(.custom("Poppins", size: 16))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .cornerRadius(8)
                .clipShape(Capsule())
            }

        }
    }

}
