//
//  ConfirmRefundExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 28/08/25.
//

import SwiftUI

extension ProcessRefundAmount {

    func processRefund() {
        validateAmount()
        let amount = transactionViewModel.amountForPayment

        switch true {
        case amount > remainingAmount:
            errorMessage = "The refund amount exceeds the available balance."

        case amount <= 0:
            errorMessage = "Please enter a valid refund amount."

        default:
            errorMessage = nil
            transactionViewModel.transactiontype =
                transactionViewModel.referenceTransaction?.refundable ?? false
                ? "Refund" : "Void"
            router.navigate(to: .payment(.confirmRefund))
        // navigate to next screen
        }
    }
    func validateAmount() {
        let cleanedAmount = confirmRefundAmount.replacingOccurrences(
            of: "$", with: ""
        )
        .replacingOccurrences(of: ",", with: "")
        if let parsedAmount = Double(cleanedAmount), parsedAmount > 0 {
            errorMessage = ""
            transactionViewModel.amountForPayment = parsedAmount
        } else {
            errorMessage = "Invalid amount or amount cannot be zero."
        }
    }

    func updateVariables() {
        // remainingAmount
        if let remainingAmountFromSelectedTransaction = transactionViewModel
            .referenceTransaction?.remainingAmount
        {
            remainingAmount = remainingAmountFromSelectedTransaction
            print(remainingAmount)
        }

        // confirm refund Amount
        confirmRefundAmount = String(format: "%.2f", remainingAmount)

    }

    var confirmRefundView: some View {

        VStack {
            Text("Confirm Refund Amount")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Text(
                "Remaining balance: $\(String(format: "%.2f", transactionViewModel.referenceTransaction?.remainingAmount ?? 0))"
            )
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)

            HStack {

                Text("$")
                    .font(.system(size: 72))
                    .foregroundStyle(.white)

                Spacer()

                TextField("", text: $confirmRefundAmount)
                    .font(.system(size: 72))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 8)

            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundStyle(.red)
            }

            NumericKeypad(amount: $confirmRefundAmount)
                .padding(.horizontal, -10)
                .padding(.top, -20)

            if let buttonColor = Color(hex: "#49159E") {
                Button {
                    processRefund()
                } label: {
                    Text("Process Refund")
                        .frame(minWidth: 190, minHeight: 43)
                        .background(
                            buttonColor
                        )
                        .foregroundColor(.white)
                        .font(.custom("Poppins", size: 16))
                        .fontWeight(.semibold)
                        .cornerRadius(8)
                        .clipShape(Capsule())
                }
            }

            Button {
                //                cancelPressed()
                transactionViewModel.amountForPayment = 0.00
                transactionViewModel.referenceTransaction = nil
                router.navigateBack()
            } label: {
                Text("Cancel Refund")
                    .frame(minWidth: 190, minHeight: 43)
                    .background(
                        Color(
                            hex: "#0085FF"
                        )
                    )
                    .foregroundColor(.white)
                    .font(.custom("Poppins", size: 16))
                    .fontWeight(.semibold)
                    .cornerRadius(8)
                    .clipShape(Capsule())
            }
        }

    }

}
