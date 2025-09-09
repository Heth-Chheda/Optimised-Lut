//
//  QrScanBox.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 09/09/25.
//

import SwiftUI

struct QRCodeBox: View {
    let onScan: (String) -> Void
    
    // fixed constants
    private let size = UIScreen.main.bounds.width * 0.7
    private let cornerRadius: CGFloat = 12
    private let lineWidth: CGFloat = 3
    private let borderColor = Color(
        red: 151 / 255.0,
        green: 71 / 255.0,
        blue: 255 / 255.0
    )

    var body: some View {
        ZStack {
            // QR Scanner
            QRScannerView { code in
                onScan(code)
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            // Border Box
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: lineWidth)
                .frame(width: size, height: size)
        }
    }
}
