//
//  AmountRegister.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

struct AmountRegister: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    var onFundsSubtracted: (Double, Bool) -> Void = { _, _ in }

    var body: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: UIScreen.main.bounds.width * 0.04)

            Header()

            Spacer().frame(height: UIScreen.main.bounds.width * 0.1)

            // Display the amount input
            HStack(spacing: 10) {
                Text("$")
                    .font(.system(size: 60, weight: .regular))
                    .foregroundColor(.white)

                Spacer()

                Text(transactionViewModel.amount)
                    .font(.system(size: 60, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top, 20)

            // Error message
            if let error = transactionViewModel.errorMessage, !error.isEmpty {
                Text(error)
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                    .padding(.top, 3)
            } else {
                Spacer()
                    .frame(height: 10)
            }
            // Numeric keypad
            NumericKeypad(amount: $transactionViewModel.amount)
                .padding(.top, 10)

            // Continue Button
            if let buttonColor = Color(hex: "#49159E") {
                CustomButton(
                    label: "Continue",
                    action: continuePressed,
                    color: buttonColor
                )
                .padding(.top, 10)
            }

            Spacer().frame(height: 1)

            // Cancel Button
            CustomButton(label: "Cancel", action: cancelPressed)
                .padding(.top, 10)

            Spacer().frame(height: 20)
        }
        .onAppear {
            Task {
                await transactionViewModel.getMerchantTipsAndSurcharge(
                    accessToken: authenticationViewModel.accessToken ?? "")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }

    private func continuePressed() {
        // Remove dollar sign for parsing
        let amountValueString = transactionViewModel.amount
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(
                of: ",",
                with: ""
            )

        guard let amountValue = Double(amountValueString), amountValue > 0
        else {
            transactionViewModel.errorMessage =
                amountValueString.isEmpty
                ? "Invalid amount." : "The amount cannot be zero."
            return
        }
        transactionViewModel.errorMessage = nil
        transactionViewModel.amountForPayment = amountValue
        // instead of closure navigating directly using router
        //        onFundsSubtracted(transactionViewModel.amountForPayment, true)
        if transactionViewModel.tipsEnabled
            && transactionViewModel.surchargeEnabled
        {
            // navigate to merchant tip and surcharge screen
        } else if !transactionViewModel.tipsEnabled
            && transactionViewModel.surchargeEnabled
        {
            // navigate to qr payment screen with the amount value added with the surcharge value
        } else {
            // navigate to qr payment screen with amount value.
        }
    }

    private func cancelPressed() {
        router.navigateBack()
    }
}
