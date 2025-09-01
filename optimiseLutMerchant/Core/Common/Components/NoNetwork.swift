//
//  NoNetwork.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

struct NoNetwork: View {
    // Properties
    let wifiIconBoxTopPadding: CGFloat = 10
    let titleBoxTopPadding: CGFloat = 20
    let textBoxTopPadding: CGFloat = 10
    let textBoxStartPadding: CGFloat = 20
    let textBoxEndPadding: CGFloat = 20
    let textSize: CGFloat = 24

    let NO_NETWORK_TITLE = "You don’t seem to be\nconnected to a network"
    let NO_NETWORK_ERROR =
        "Please check your\nnetwork connection and\ntry relaunching the app."

    var body: some View {
        ZStack {
            // Background
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 80) {
                // Title
                Text(NO_NETWORK_TITLE)
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Regular", size: textSize))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)

                // Wi-Fi Icon
                Image("wifi-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 136, height: 109)

                // Error Message
                Text(NO_NETWORK_ERROR)
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Regular", size: textSize))
                    .fontWeight(.light)
                    .lineSpacing(2)
                    .padding(.leading, textBoxStartPadding)
                    .padding(.trailing, textBoxEndPadding)
                    .multilineTextAlignment(.leading)
            }
            .padding(.bottom, 200)
        }
    }
}

#Preview {
    NoNetwork()
}
