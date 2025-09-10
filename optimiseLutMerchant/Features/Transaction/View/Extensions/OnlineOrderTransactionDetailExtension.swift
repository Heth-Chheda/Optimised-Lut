//
//  OnlineOrderTransactionDetailExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 09/09/25.
//

import SwiftUI

extension OnlineOrderTransactionDetail {

    var content: some View {

        VStack {

            switch transactionViewModel.selectedTransaction?.status {

            case "VOID":
                voidContent

            case nil:
                // show nil content
                Text("Transaction details not available.")
                    .foregroundStyle(Color.white)

            default:
                // show the content if not nil and not void.
                onlineOrderTransactionDetailContent

            }

        }

    }

    private var voidContent: some View {
        VStack(spacing: 20) {

            Spacer().frame(height: 40)
            Text("Transaction Details")
                .font(.custom("Poppins", size: 24))
                .foregroundColor(Color(hex: "#9747FF") ?? .purple)
                .fontWeight(.heavy)

            Text(
                "$\(String(format: "%.2f", transactionViewModel.selectedTransaction?.amount ?? 0.00))"
            )
            .foregroundStyle(Color.white)
            .font(.custom("Poppins", size: 72))

            VStack {
                Text(
                    "Name: \(transactionViewModel.selectedTransaction?.name ?? "N/A")"
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
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))

                Text(
                    "Date: \(Formatter.formatDateAndTime(transactionViewModel.selectedTransaction?.createdAt ?? "")?.date ?? "N/A")"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))

                Text(
                    "Time: \(Formatter.formatDateAndTime(transactionViewModel.selectedTransaction?.createdAt ?? "")?.time ?? "N/A")"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))
            }

            Spacer().frame(height: 3)

            Text(
                "This transaction has expired \nand no funds have been \ndebited from the customer."
            )
            .foregroundColor(.white)
            .font(.custom("Poppins", size: 18))
            .padding(.top, 20)

            Spacer().frame(height: 10)

            CustomButton(label: "Close") {
                router.setRoot(to: .payment(.payLanding))
            }

            Spacer()
        }
    }

    private var onlineOrderTransactionDetailContent: some View {

        VStack(alignment: .leading ,spacing: 20) {
            Spacer().frame(height: 40)
            Text("Transaction Details")
                .font(.custom("Poppins", size: 24))
                .foregroundColor(Color(hex: "#9747FF") ?? .purple)
                .fontWeight(.heavy)

            Text(
                "$\(String(format: "%.2f", transactionViewModel.selectedTransaction?.amount ?? 0.00))"
            )
            .foregroundStyle(Color.white)
            .font(.custom("Poppins", size: 72))

            VStack (alignment: .leading) {
                Text(
                    "Name: \(transactionViewModel.selectedTransaction?.name ?? "N/A")"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))

                Text(
                    "Phone: \(ValidationUtils.formatPhoneNumber(transactionViewModel.selectedTransaction?.phone ?? ""))"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))

            }

            VStack (alignment: .leading) {
                Text(
                    "Reference No: \(transactionViewModel.selectedTransaction?.transactionId ?? "N/A")"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))

                Text(
                    "Date: \(Formatter.formatDateAndTime(transactionViewModel.selectedTransaction?.createdAt ?? "")?.date ?? "N/A")"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))

                Text(
                    "Time: \(Formatter.formatDateAndTime(transactionViewModel.selectedTransaction?.createdAt ?? "")?.time ?? "N/A")"
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 18))
            }

            Spacer().frame(height: 3)

            CustomButton(
                label: "Complete Transaction",
                action: {
                    // some action to complete the transaction
                },
                color: Color(hex: "#49159E") ?? .purple
            )
            
            CustomButton(
                label: "Change Payment Method",
                action: {
                    // some action to change payment method
                },
                color: Color(hex: "#49159E") ?? .purple
            )
            
            CustomButton(
                label: "Change Order",
                action: {
                    // some action to change order
                },
                color: Color(hex: "#49159E") ?? .purple
            )
            
            CustomButton(label: "Cancel") {
                // navigate to pay landing
                router.setRoot(to: .payment(.payLanding))
            }
        }
    }

}

#Preview {
    OnlineOrderTransactionDetail()
        .environmentObject(
            AuthenticationViewModel(
                authenticationRepository: AuthenticationRepository())
        )
        .environmentObject(
            TransactionViewModel(transactionRepository: TransactionRepository())
        )
        .environmentObject(Router())
}
