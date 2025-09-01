//
//  DualLogin.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

struct DualLogin: View {
    @EnvironmentObject var router: Router
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // navigate back to login logic
                        router.navigateBack()
                    }) {
                        Image("close")
                            .resizable()
                            .frame(width: 27, height: 27)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    }
                    .padding()
                    .padding(.top, 50)
                }

                Text("This account is \nalready logged in\non another device")
                    .font(.custom("Poppins", size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .padding()

                Image("account_lock")
                    .frame(width: 120, height: 120)
                    .padding(50)

                Text(
                    "In order to use Lüt on this \ndevice, please log out of \nany other devices you \nmight be using. \n \nIf you have any \nquestions or concerns, \nplease contact Lüt \nat  877-LUT-4-ALL."
                )
                .foregroundStyle(Color.white)
                .font(.custom("Poppins", size: 20))
                .fontWeight(.light)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
    }
}

#Preview {
    DualLogin ()
}
