//
//  MerchantProfile.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

struct MerchantProfile: View {
    var merchantName: String?
    var location: String?
    var merchantId: String?
    var onDismiss: (() -> Void)? = nil
    @State private var appVersion: String = "Loading..."
    var body: some View {
        ZStack {
            Color.black.opacity(0.95).ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer().frame(height: 100)
                VStack {
                    Text("John Snow")
                        .foregroundStyle(Color.white)
                        .font(.custom("Poppins", size: 26))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("\(merchantName ?? "Unknown")")
                        .foregroundStyle(Color.white)
                        .font(.custom("Poppins", size: 26))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                // Merchant ID and App Version
                VStack(alignment: .leading, spacing: 50) {
                    MerchantDetailView(label: "Merchant ID", value: "\(merchantId ?? "Unknown")")

                    MerchantDetailView(label: "App Version", value: "\(appVersion)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 80)
                
                Spacer().frame(height: 30)

                // Close Button
                VStack(alignment: .center) {
                    CustomButton(label: "Close") {
                        onDismiss?()
                    }
                }
                Spacer()
            }
        }

    }
    private struct MerchantDetailView: View {
        let label: String
        let value: String

        var body: some View {
            VStack(alignment: .leading) {
                Text("\(label)")
                    .font(.custom("Poppins", size: 18))
                    .foregroundStyle(Color.gray)

                Text("\(value)")
                    .font(.custom("Poppins", size: 18))
                    .foregroundStyle(Color.white)

            }
        }
    }
}


#Preview {
    MerchantProfile()
}
