//
//  Login.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

extension Login {
    // MARK: USERNAME
    var usernameField: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Text("Username")
                    .font(.custom("Poppins", size: 18))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .lineSpacing(9)
                    .multilineTextAlignment(.leading)
                    .padding(.top, -10)
                    .padding(.leading, 10)
                    .opacity(viewModel.username.isEmpty ? 1 : 0)
                    .offset(y: viewModel.username.isEmpty ? 0 : -20)

                TextField("", text: $viewModel.username)
                    .font(.custom("Poppins", size: 18))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .background(Color.clear)
                    .padding(.top, -10)
                    .padding(.leading, 10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: viewModel.username) {
                        oldValue, newValue in
                        viewModel.username = newValue.lowercased()
                    }
            }

            // Conditionally show the underline when the username is empty
            if viewModel.username.isEmpty {
                Image("underline")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, -20)
            }
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.15)
        .frame(maxWidth: .infinity)
    }

    // MARK: PASSWORD
    var passwordField: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {

                if viewModel.password.isEmpty {
                    Text("Password")
                        .font(.custom("Poppins", size: 18))
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .lineSpacing(9)
                        .multilineTextAlignment(.leading)
                        .padding(.top, -10)
                        .padding(.leading, 10)
                }

                // Password input field
                HStack {
                    // Toggle between TextField and SecureField based on password visibility
                    if passwordVisibility {
                        TextField("Password", text: $viewModel.password)
                            .font(.custom("Poppins", size: 18))
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .background(Color.clear)
                            .padding(.top, -10)
                            .padding(.leading, 10)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                            .font(.custom("Poppins", size: 18))
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .background(Color.clear)
                            .padding(.top, -10)
                            .padding(.leading, 10)
                    }

                    // Password visibility toggle button
                    Button(action: {
                        passwordVisibility.toggle()
                    }) {
                        if !viewModel.password.isEmpty {
                            Image(
                                systemName: passwordVisibility
                                    ? "eye.slash" : "eye"
                            )
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                            .padding(.bottom, 5)
                        }
                    }
                }
            }

            // Underline image only when the password is empty
            if viewModel.password.isEmpty {
                Image("underline")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, -20)
            }
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.15)
        .frame(maxWidth: .infinity)
    }

    // MARK: REMEMBER
    var rememberMyEmail: some View {
        Toggle(isOn: $viewModel.isRememberMe) {
            Text("Remember my email")
        }
        .toggleStyle(CheckboxToggleStyle())
        .padding(.horizontal)
        .onChange(of: viewModel.isRememberMe) {
            viewModel.rememberMyEmail()
        }
    }

    // MARK: LOGIN BUTTON
    var loginButton: some View {
        ZStack {
            Button(action: {
                viewModel.login()
            }) {
                Text(viewModel.isLoading ? "" : "Log in")
                    .font(.custom("Poppins", size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineSpacing(8)
                    .multilineTextAlignment(.center)
                    .frame(width: 165, height: 40)
                    .background(Color(red: 73/255, green: 21/255, blue: 158/255))
                    .cornerRadius(20)
            }
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
            }
        }
    }

    // MARK: FORGOT CREDENTIALS
    var forgotCredentials: some View {
        HStack(spacing: 0) {
            Text("Forgot your ")
                .font(.custom("Poppins", size: 12))
                .fontWeight(.light)
                .foregroundColor(.white)
                .lineSpacing(6)

            Text("username")
                .font(.custom("Poppins", size: 12))
                .fontWeight(.light)
                .foregroundColor(.white)
                .underline()
                .lineSpacing(6)
                .onTapGesture {
                    // using router navigate to forgot username
                    router.navigate(to: .forgotUsername)
                }

            Text(" or ")
                .font(.custom("Poppins", size: 12))
                .fontWeight(.light)
                .foregroundColor(.white)
                .lineSpacing(6)

            Text("password?")
                .font(.custom("Poppins", size: 12))
                .fontWeight(.light)
                .foregroundColor(.white)
                .underline()
                .lineSpacing(6)
                .onTapGesture {
                    // using router navigate to forgot password
                    router.navigate(to: .forgotPassword)
                }
        }
        .lineLimit(1)
        .multilineTextAlignment(.center)
    }
    
    // MARK: - Merchant Registration Link
    var merchantRegistration: some View {
        VStack(spacing: 15) {
            Text("Don’t offer Lüt?")
                .font(.custom("Poppins", size: 14))
                .foregroundColor(.white)
                .lineSpacing(1)
                .multilineTextAlignment(.center)

            Text("Tap here to become a \nLüt merchant!")
                .font(.custom("Poppins", size: 14))
                .underline()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .onTapGesture {
                    // showing the toast message
                }
        }
    }
    
    // MARK: VERSION INFO
    var versionInfo: some View {
        HStack {
            Text("Version 1.2.2")
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 14))

            Spacer()

            Text("Environment: Development")
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 14))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
