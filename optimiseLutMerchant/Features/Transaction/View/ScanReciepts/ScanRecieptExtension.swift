//
//  ScanRecieptExtension.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 01/09/25.
//

import AVFoundation
import SwiftUI

extension ScanReciept {

    var scanRecieptView: some View {
        VStack {
            Header()
            Spacer().frame(height: 90)

            VStack(spacing: 30) {
                Text("Scan QR Code for Refund")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Text(
                    "Scan the QR Code on your customer’s mobile device to begin the refund process."
                )
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7)

                if let errorMessage = transactionViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.red)
                        .padding()
                }

                qrCodeBox

            }

            Spacer()

            CustomButton(label: "Cancel") {
                router.navigateBack()
            }
            .safeAreaPadding(.bottom)
            .padding(.bottom, 16)
        }
        .ignoresSafeArea()
        .padding(.horizontal)
    }

    private var qrCodeBox: some View {
        ZStack {
            // qr scanner
            QRScannerView { code in

                Task {
                    await transactionViewModel.handleRefundQrCode(
                        transactionId: code,
                        accessToken: authenticationViewModel.accessToken ?? ""
                    )
                }
            }
            .frame(
                width: UIScreen.main.bounds.width * 0.7,
                height: UIScreen.main.bounds.width * 0.7
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // qr code box
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color(
                        red: 151 / 255.0,
                        green: 71 / 255.0,
                        blue: 255 / 255.0
                    ),
                    lineWidth: 3
                )
                .frame(
                    width: UIScreen.main.bounds.width * 0.7,
                    height: UIScreen.main.bounds.width * 0.7
                )
        }
    }
}

#Preview {
    ScanReciept()
        .environmentObject(Router())
        .environmentObject(
            TransactionViewModel(
                transactionRepository: TransactionRepository()
            )
        )
}
