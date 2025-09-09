//
//  WebWidgetScanningExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 09/09/25.
//

import SwiftUI

extension ScanningQR {

    var webWidgetScanningContent: some View {
        VStack {
            Spacer().frame(height: 16)

            Text("Scan QR Code for Pickup")
                .foregroundStyle(.white)
                .font(.custom("Poppins", size: 24))
                .fontWeight(.semibold)

            Spacer().frame(height: 40)

            Text(
                "Scan the QR Code on your\ncustomer’s mobile device to\ncomplete the purchase"
            )
            .foregroundStyle(.white)
            .font(.custom("Poppins", size: 18))
            .fontWeight(.light)

            Spacer().frame(height: 80)

            Text(transactionViewModel.errorMessage ?? "")
                .font(.custom("Poppins", size: 18))
                .foregroundColor(.red)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            QRCodeBox { code in
                Task {
                    await transactionViewModel.handleRefundQrCode(
                        transactionId: code,
                        accessToken: authenticationViewModel.accessToken ?? ""
                    )
                }
            }

            Spacer()

            CustomButton(label: "Cancel") {
                router.navigateBack()
            }
            .safeAreaPadding(.bottom)
            .padding(.bottom)
        }
    }
}

#Preview {
    ScanningQR()
}
