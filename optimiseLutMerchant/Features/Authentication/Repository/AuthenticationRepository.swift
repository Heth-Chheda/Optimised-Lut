//
//  AuthenticationRepository.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation
import UIKit

protocol AuthenticationRepositoryProtocol {
    func login(username: String, password: String) async throws -> LoginResponse

    func logout(accessToken: String) async throws -> LogoutResponse

    func forgotUsername(phone: String, accessToken: String?) async throws
        -> ForgotUsernameResponse

    func getMerchantDetails(accessToken: String) async throws
        -> MerchantDetailResponse

    func forgotPassword(email: String) async throws -> ForgotPasswordResponse

    func resetPassword(
        email: String,
        password: String,
        code: String,
        sourceUrl: String?
    ) async throws -> ForgotPasswordResponse

    func validateResetPasswordCode(
        username: String,
        code: String
    ) async throws -> ValidateCodeResponse

}

class AuthenticationRepository: BaseRepository, ObservableObject,
    AuthenticationRepositoryProtocol
{

    // MARK: LOGIN
    func login(username: String, password: String) async throws -> LoginResponse
    {
        let url = "\(ApiUrls.baseUrl)/\(ApiUrls.endPointLogin)"
        let uuid = await UIDevice.current.identifierForVendor?.uuidString

        let body: [String: Any] = [
            "username": username,
            "password": password,
        ]

        // Encode Basic Auth
        let credentials = "\(username):\(password)"
        let encodedCredentials = credentials.data(using: .utf8)?
            .base64EncodedString()

        var headers: [String: String] = [
            "deviceid": uuid ?? ""
        ]
        if let encoded = encodedCredentials {
            headers["Authorization"] = "Basic \(encoded)"
        }

        return try await performRequest(
            url: url,
            method: .post,
            body: body,
            responseType: LoginResponse.self,
            extraHeaders: headers
        )
    }

    // MARK: LOGOUT
    func logout(accessToken: String) async throws -> LogoutResponse {
        let logouturl = "\(ApiUrls.baseUrl)/\(ApiUrls.endPointLogoutUser)"

        let response: LogoutResponse = try await performRequest(
            url: logouturl,
            method: .post,
            accessToken: accessToken,
            responseType: LogoutResponse.self
        )

        return response
    }

    // MARK: FORGOT USERNAME
    func forgotUsername(phone: String, accessToken: String?) async throws
        -> ForgotUsernameResponse
    {
        let forgortUsernameUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointForgotUsername)"

        let formattedPhoneNumber = Formatter.convertNumberToApiFormat(phone)

        let body: [String: Any] = ["phone": "+1 \(formattedPhoneNumber)"]

        return try await performRequest(
            url: forgortUsernameUrl,
            method: .post,
            body: body,
            responseType: ForgotUsernameResponse.self

        )
    }

    // MARK: MERCHANT DETAILS
    func getMerchantDetails(accessToken: String) async throws
        -> MerchantDetailResponse
    {
        let getMerchantDetailUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointGetMerchantInfo)"

        return try await performRequest(
            url: getMerchantDetailUrl,
            method: .get,
            accessToken: accessToken,
            responseType: MerchantDetailResponse.self
        )
    }

    // MARK: FORGOT PASSWORD
    func forgotPassword(email: String) async throws -> ForgotPasswordResponse {
        let forgotPasswordUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointForgotPassword)"

        let body: [String: Any] = ["username": email]

        return try await performRequest(
            url: forgotPasswordUrl,
            method: .post,
            body: body,
            responseType: ForgotPasswordResponse.self
        )
    }

    // MARK: RESET PASSWORD
    func resetPassword(
        email: String, password: String, code: String, sourceUrl: String?
    ) async throws -> ForgotPasswordResponse {
        let resetPasswordUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointResetPassword)"

        let encodedPassword = Data(password.utf8).base64EncodedString()

        let body: [String: Any] = [
            "email": email,
            "password": encodedPassword,
        ]

        return try await performRequest(
            url: resetPasswordUrl,
            method: .post,
            body: body,
            responseType: ForgotPasswordResponse.self
        )
    }

    // MARK: VALIDATE CODE
    /// Reset password code validation
    func validateResetPasswordCode(username: String, code: String) async throws
        -> ValidateCodeResponse
    {
        let validateCodeUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointValidateResetPasswordCode)"

        let body: [String: Any] = [
            "username": username,
            "code": code,
        ]

        return try await performRequest(
            url: validateCodeUrl,
            method: .post,
            body: body,
            responseType: ValidateCodeResponse.self
        )
    }
}
