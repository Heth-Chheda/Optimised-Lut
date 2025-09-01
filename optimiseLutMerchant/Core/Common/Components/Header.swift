//
//  Header.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

struct Header: View {
    let withProfilePhoto: Bool?
    var onShowMerchantProfileDetails: (() -> Void)?

    init(
        withProfilePhoto: Bool = false,
        onShowMerchantProfileDetails: (() -> Void)? = nil
    ) {
        self.withProfilePhoto = withProfilePhoto
        self.onShowMerchantProfileDetails = onShowMerchantProfileDetails
    }

    var body: some View {
        HStack {
            Image("luttext")
                .resizable()
                .frame(
                    width: UIScreen.main.bounds.width * 0.18,
                    height: UIScreen.main.bounds.height * 0.036
                )
                .padding(.top, UIScreen.main.bounds.height * 0.02)

            Text("M E R C H A N T")
                .font(
                    .system(
                        size: UIScreen.main.bounds.width * 0.045,
                        weight: .regular)
                )
                .foregroundColor(Color.white)
                .padding(.top, UIScreen.main.bounds.height * 0.025)

            Spacer()

            if withProfilePhoto != false {
                Image("profileicon")
                    .resizable()
                    .frame(width: 32, height: 33)
                    .padding(.top, UIScreen.main.bounds.height * 0.02)
                    .foregroundStyle(Color.white)
                    .onTapGesture {
                        onShowMerchantProfileDetails?()
                    }
            }

        }
        .padding()
        .padding(.top, 40)
        .background(Color.black)
        .frame(height: 56)
    }
}
