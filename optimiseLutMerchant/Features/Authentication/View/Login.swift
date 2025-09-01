//
//  Login.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    @State var error: Bool = false
    @State var passwordVisibility: Bool = false

    var body: some View {
        VStack {
            Header()
            Spacer()

            VStack {
                Spacer().frame(height: 100)
                Text("Welcome to \nLüt Merchant!")
                    .font(.custom("Poppins", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)

                Text(viewModel.errorMessage ?? "")
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .light))
                    .padding(.horizontal, 60)
                    .frame(height: 40)
                Spacer().frame(height: 24)

                usernameField
                Spacer().frame(height: 50)
                passwordField
                Spacer().frame(height: 36)
                rememberMyEmail
                Spacer().frame(height: 20)
                loginButton
                Spacer().frame(height: 24)
                forgotCredentials
                Spacer().frame(height: 50)
                merchantRegistration

                Spacer()

                versionInfo
            }

            Spacer()

        }
        .padding()
        .ignoresSafeArea()
        .background(Color.black)
        .onChange(of: viewModel.loginResponseCode) { oldValue, newValue in
            guard let code = newValue else { return }

            switch code {
            case 100, 1:
                router.setRoot(to: .payment(.payLanding))

            case 403:
                router.navigate(to: .dualLogin)

            default: return
            }
        }
    }
}

#Preview {
    Login()
        .environmentObject(Router())
}
