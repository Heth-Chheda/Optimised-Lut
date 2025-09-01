//
//  Logout.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

struct Logout: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    var onDismiss: (() -> Void)? = nil
    var body: some View {
        ZStack {
            Color.black.opacity(0.79).ignoresSafeArea()

            VStack {
                Text(
                    "You have chosen to log out from the Lüt application. You will need to log back in with your email & password to use the app."
                )
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 18))
                .lineSpacing(1.5)
                .padding(.horizontal, 50)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)

                Spacer().frame(height: 40)

                ZStack{
                    Button(action: {
                        // logout functionality
                        authViewModel.logout()
                    }) {
                        Text(authViewModel.isLoading ? "" : "Yes, Log Out")
                            .foregroundColor(.white)
                            .font(.custom("Poppins-Semibold", size: 16))
                            .padding(.vertical, 10)
                            .fontWeight(Font.Weight.semibold)
                            .padding(.horizontal, 20)
                            .frame(width: 155, height: 40)
                            .background(
                                Color(
                                    red: 73 / 255, green: 21 / 255, blue: 158 / 255)
                            )
                            .clipShape(Capsule())
                            .opacity(1)
                    }
                    .disabled(authViewModel.isLoading)
                    
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    }
                    
                }

                Button(action: {
                    onDismiss?()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.custom("Poppins-Semibold", size: 16))
                        .padding(.vertical, 10)
                        .fontWeight(Font.Weight.semibold)
                        .padding(.horizontal, 20)
                        .frame(width: 155, height: 40)
                        .background(
                            Color(
                                red: 0 / 255, green: 133 / 255, blue: 255 / 255)
                        )
                        .clipShape(Capsule())
                        .opacity(1)
                        .padding(.top, 20)
                }
            }
        }
        .onChange(of: authViewModel.logoutResponseCode) { oldValue, newValue in
            guard let code = newValue else { return }

            switch code {
            case 100, 1:
                authViewModel.clearUserData()
                router.setRoot(to: .login)

            case 2:
                authViewModel.clearUserData()
                router.setRoot(to: .login)

            default: return
            }
        }
    }
}

#Preview {
    Logout()
        .environmentObject(AuthenticationViewModel(authenticationRepository: AuthenticationRepository()))
}
