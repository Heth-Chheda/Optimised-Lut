//
//  OnlineOrderConfirmChangeOrderExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 10/09/25.
//

import SwiftUI

extension OnlineOrderConfirmChangeOrder {

    private func generateTransactionId() -> String {
        let chars = Array(
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        var randomStr = "VOID"
        for _ in 0..<8 {
            randomStr += String(chars.randomElement()!)
        }
        return randomStr
    }

    private func confirmChange() {

        let newTransactionId = generateTransactionId()

        Task {
            await transactionViewModel.performVoidTransaction(
                accessToken: authenticationViewModel.accessToken ?? "",
                transactionId: newTransactionId,
                referenceTransactionId: transactionViewModel
                    .selectedTransaction?.transactionId ?? ""
            )
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 20) {

            Spacer().frame(height: 80)

            Text("Change Order")
                .font(.custom("Poppins", size: 24))
                .fontWeight(.semibold)
                .foregroundStyle(Color(hex: "#9747FF") ?? .purple)

            Text(
                "$\(String(format: "%.2f", transactionViewModel.selectedTransaction?.amount ?? 0.00))"
            )
            .foregroundStyle(Color.white)
            .font(.custom("Poppins", size: 64))

            VStack {

                Text(
                    "Name: \(transactionViewModel.selectedTransaction?.name ?? "")"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))

                Text(
                    "Phone: \(ValidationUtils.formatPhoneNumber(transactionViewModel.selectedTransaction?.phone ?? ""))"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))
            }

            VStack {

                Text(
                    "Reference No: \(transactionViewModel.selectedTransaction?.transactionId ?? "N/A")"
                )
                .font(.custom("Poppins", size: 18))
                .foregroundStyle(Color.white)

                Text(
                    "Date: \(Formatter.formatDateAndTime(transactionViewModel.selectedTransaction?.createdAt ?? "")?.date ?? "N/A")"
                )
                .font(.custom("Poppins", size: 18))
                .foregroundStyle(Color.white)

                Text(
                    "Time: \(Formatter.formatDateAndTime(transactionViewModel.selectedTransaction?.createdAt ?? "")?.time ?? "N/A")"
                )
                .font(.custom("Poppins", size: 18))
                .foregroundStyle(Color.white)
            }
            
            Text("\(transactionViewModel.errorMessage ?? "")")
                .foregroundStyle(Color.red)
                .font(.custom("Poppins", size: 16))

            Spacer().frame(height: 30)
            
            CustomButton(
                label: "Confirm Change",
                action: {
                    confirmChange()
                },
                color: Color(hex: "#49159E") ?? .purple
            )

            CustomButton(label: "Cancel Change") {
                router.navigateBack()
            }

            Spacer()
        }
    }

}
