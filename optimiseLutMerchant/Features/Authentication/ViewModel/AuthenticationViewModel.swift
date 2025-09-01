//
//  AuthenticationViewModel.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Combine
import SwiftUI

@MainActor
class AuthenticationViewModel: ObservableObject {

    // MARK: - PROPERTIES
    /// - Parameter - Login
    @Published var username: String = "johnsmith@gmail.com"
    @Published var password: String = "Admin@123"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var loginResponseCode: Int?
    @Published var logoutResponseCode: Int?
    @Published var accessToken: String?

    /// - Parameter - saved email
    @AppStorage("savedEmail") var savedEmail: String = ""
    @AppStorage("isRememberMe") var isRememberMe: Bool = false

    /// - Parameter - Merchant Details
    @Published var merchantDetails: MerchantDetailsDto?
    @Published var merchantResponseCode: String?

    // MARK: - DEPENDENCIES
    private let authenticationRepository: AuthenticationRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(authenticationRepository: AuthenticationRepositoryProtocol) {
        self.authenticationRepository = authenticationRepository
    }

    // MARK: LOGIN
    func login() {
        errorMessage = nil

        loginResponseCode = nil

        guard validateInputs() else {
            return
        }
        isLoading = true

        Task {
            do {
                let response = try await authenticationRepository.login(
                    username: username,
                    password: password
                )

                // Expose responseCode to the view
                if let code = response.responseCode {
                    loginResponseCode = code

                    // Extract token if available
                    if let object = response.responseObject {
                        switch object {
                        case .tokens(let tokens):
                            accessToken = tokens.accessToken

                        case .jsonString(let str):
                            print(
                                "Server returned JSON string instead of tokens: \(str)"
                            )
                        }
                    }

                    // Optional: handle error message internally if code != 200
                    if code != 100 || code != 1 {
                        errorMessage = response.responseText ?? "Login failed."
                    }
                } else {
                    loginResponseCode = -1
                    errorMessage = "Invalid server response."
                }

            } catch {
                loginResponseCode = -1
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    private func validateInputs() -> Bool {
        // Validate username/email
        let emailResult = ValidationUtils.isValidEmail(username)
        if !emailResult.isValid {
            errorMessage = emailResult.errorMessage
            return false
        }

        // Validate password
        if let passwordError = ValidationUtils.isValidPassword(password) {
            errorMessage = passwordError
            return false
        }

        return true
    }

    // MARK: LOGOUT
    func logout() {
        errorMessage = nil
        logoutResponseCode = nil

        Task {
            do {
                isLoading = true
                let response = try await authenticationRepository.logout(
                    accessToken: accessToken ?? ""
                )

                if let code = response.responseCode {
                    logoutResponseCode = code

                    if code != 100 && code != 1 {
                        errorMessage = response.responseText ?? "Logout failed."
                    }
                } else {
                    logoutResponseCode = -1
                    errorMessage = "Invalid server response."
                }

            } catch {
                logoutResponseCode = -1
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }

    // MARK: REMEMBER ME
    func rememberMyEmail() {
        if isRememberMe {
            if !username.isEmpty {
                savedEmail = username
            } else {
                savedEmail = savedEmail
                username = savedEmail
            }
        } else {
            savedEmail = ""
        }
    }
    // MARK: MERCHANT DETAILS
    func fetchMerchantDetails() async {
        isLoading = true
        do {
            let response =
                try await authenticationRepository.getMerchantDetails(
                    accessToken: accessToken ?? "")

            // update published values
            merchantDetails = response.merchantDetailsDto
            merchantResponseCode = response.code

        } catch {
            errorMessage =
                "Failed to fetch merchant details Error: \(error.localizedDescription)"
        }
        isLoading = false
    }

    // MARK: CLEAR USER DATA
    func clearUserData() {
        accessToken = nil
        merchantDetails = nil
        merchantResponseCode = nil
    }
}
