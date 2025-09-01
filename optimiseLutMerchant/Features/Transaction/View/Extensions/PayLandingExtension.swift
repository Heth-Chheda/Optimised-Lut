//
//  PayLandingExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

extension PayLanding {
    var payLandingContent: some View {
        VStack {
            Header(withProfilePhoto: true) {
                showMerchantProfileDetails = true
            }

            Spacer().frame(height: 54)

            Text("John Snow")
                .font(.custom("Poppins", size: 24))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding()

            Spacer().frame(height: 56)

            Button(action: {
                // Open the AmountRegister view
                router.navigate(to: .payment(.amountRegister))
            }) {
                Image("inStorePurchase")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 141.11, height: 140.84)
            }

            Spacer().frame(height: 48)

            Button(action: {
                // Open the scanner view for online order
            }) {
                Image("onlineOrder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 141.11, height: 140.84)
            }

            Spacer().frame(height: 48)

            Button(action: {
                // navigating to the transaction list screen
                router.navigate(to: .payment(.viewAllTransactions))
            }) {
                Text("View All Transactions")
                    .font(.custom("Poppins-Semibold", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .frame(width: 226)
                    .background(
                        Color(red: 73 / 255, green: 21 / 255, blue: 158 / 255)
                    )
                    .clipShape(Capsule())
            }
            .padding(.horizontal)

            Spacer().frame(height: 10)

            Button(action: {
                // navigate to scan receipt
                router.navigate(to: .payment(.scanReceipt))
            }) {
                Text("Scan Receipt")
                    .font(.custom("Poppins-Semibold", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .frame(width: 226)
                    .background(
                        Color(red: 73 / 255, green: 21 / 255, blue: 158 / 255)
                    )
                    .clipShape(Capsule())
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                // logout
                showLogoutOverlay = true
            }) {
                Text("Logout")
                    .font(.custom("Poppins-Semibold", size: 16))
                    .foregroundColor(.white)
                    .frame(width: 132, height: 20)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        Color(red: 0 / 255, green: 133 / 255, blue: 255 / 255)
                    )
                    .clipShape(Capsule())
            }
            .padding(.bottom, 32)
        }
        .padding()
        .ignoresSafeArea()
    }
}
