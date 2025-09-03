//
//  PaymentDeclined.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

struct PaymentDeclined: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var transactionViewModel: TransactionViewModel

    @State private var declinedCode: String? = ""

    // Centralized sizing constants
    private var textSize: CGFloat { UIScreen.main.bounds.width * 0.06 }
    private var lineHeight: CGFloat { textSize * 1.5 }
    private var iconSize: CGFloat { UIScreen.main.bounds.width * 0.27 }
    private var tryAgainBoxWidth: CGFloat { UIScreen.main.bounds.width * 0.7 }

    // Map of decline messages
    private let declineMessages: [String: String] = [
        "203": "Consumer transaction limit reached",
        "204": "QR code has expired",
        "221": "Invalid card",
        "223": "Card expired",
        "226": "Insufficient balance",
        "300": "The server is not responding. Please try again.",
        "400": "Transaction failed. Please try again.",
        "410": "Card type not accepted by the merchant",
        "411": "Transaction Error – please quit and relaunch the app",
        "413": "Merchant transaction limit reached",
        "414": "Card number is invalid.",
        "421":
            "We were unable to process the transaction. If the issue persists, please contact Lüt support.",
        "441": "Transaction failed.",
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        router.navigateBack()
                    }) {
                        Image("close")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .padding(.top, 40)
                            .padding(.trailing, 16)
                    }
                }
                .padding(.bottom, 100)

                // Title
                Text("We couldn’t process \nthis transaction")
                    .font(.custom("Poppins", size: textSize))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineSpacing(lineHeight - textSize)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)

                // Icon
                Image("yellow_cross")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .padding(.bottom, 20)

                // Declined Code message
                Text(
                    "Transaction could not be processed. \nDeclined code: \(declinedCode ?? "")"
                )
                .font(.custom("Poppins", size: textSize * 0.88))
                .foregroundColor(.white)
                .lineSpacing(lineHeight - textSize * 1.8)
                .frame(maxWidth: tryAgainBoxWidth, alignment: .leading)
                .padding(.bottom, 12)

                // Error Message from dictionary
                Text(
                    declineMessages[declinedCode ?? ""]
                        ?? "Unknown error occurred."
                )
                .font(.custom("Poppins", size: textSize * 0.85))
                .foregroundColor(.white)
                .lineSpacing(lineHeight - textSize * 1.8)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: tryAgainBoxWidth, alignment: .leading)

                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
        }
        .onAppear {
            declinedCode = transactionViewModel.declinedCode
        }
    }
}
