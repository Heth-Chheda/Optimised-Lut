//
//  VoidRefundCompleteExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 29/08/25.
//

import SwiftUI

extension TransactionComplete {

    func updateLocalVariables() {
        let transactionResponse = transactionViewModel.refundResponse

        timezone =
            authenticationViewModel.merchantDetails?.timezone
            ?? "America/New_York"

        label = transactionViewModel.transactionLabel ?? "Transaction"

        amount = String(transactionViewModel.amountForPayment)

        transactionNumber = transactionResponse?.transactionId ?? ""

        date =
            Formatter.convertTimestamp(
                transactionResponse?.transactionDate ?? "", to: timezone) ?? ""

        firstName = transactionResponse?.consumerName ?? ""

        phoneNumber = transactionResponse?.phone ?? ""
    }

    var transactionCompleteView: some View {
        VStack {

            Spacer()

            // label -- decide if Transaction / Void / Refund complete
            Text(
                label == "Transaction"
                    ? "Transaction\nComplete" : "\(label) Complete!"
            )
            .foregroundColor(.white)
            .font(.system(size: 28, weight: .bold))
            .multilineTextAlignment(.center)

            Spacer().frame(height: UIScreen.main.bounds.height * 0.1)

            Image("payment_tick")
                .resizable()
                .frame(width: 109, height: 109)

            Spacer().frame(height: 20)

            Text("\(CurrencyFormatter.formatCurrency(amount))")
                .foregroundColor(.white)
                .font(.system(size: 72))
                .lineLimit(1)

            let capitalizedName =
                firstName.prefix(1).capitalized + firstName.dropFirst()

            Spacer().frame(height: 20)  // Spacer

            // Transaction details
            Text(
                label == "Transaction"
                    ? "Transaction \(transactionNumber.prefix(12))\n\(date) \n\(capitalizedName)    \(ValidationUtils.formatPhoneNumber(phoneNumber))"
                    : "Transaction \(transactionNumber)\n\(date)"
            )
            .foregroundColor(.white)
            .font(.system(size: 20))
            .lineSpacing(5)

            Spacer()

            CustomButton(label: "Close") {
                router.setRoot(to: .payment(.payLanding))
            }

            Spacer().frame(height: 20)

        }
        .padding()
    }

}
