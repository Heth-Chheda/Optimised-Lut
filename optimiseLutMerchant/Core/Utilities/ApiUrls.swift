//
//  ApiUrls.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation

/// This class is designed to centralize API URL definitions, making it easier to manage and update them as needed.
/// A class that holds the base URL and endpoint paths for the API.
class ApiUrls {
    // Development environment base URL
    static let devUrl = "https://switch.np-orlando.payresults.ai"
    
    // Staging environment base URL
    static let stagingUrl = "https://payment-switch.stage-orlando.payresults.ai"
    
    // User Acceptance Testing (UAT) environment base URL
    static let uatUrl = "https://payment-switch.uat-orlando.payresults.ai"
    
    // Vulnerability Assessment and Penetration Testing (VAPT) environment base URL
    static let vaptUrl = "https://switch-acquiring.vapt.mylut.com"
    
    static let preProductionUrl = "https://switch-acquiring.preprod.mylut.com"
    
    static let prodUrl = "https://switch-acquiring.mylut.com"
    
    // Default base URL for the API
    static var baseUrl = devUrl
    // MARK: - Onboarding Module Endpoints
    /// Endpoint for user login
    static let endPointLogin = "login"

    // MARK: - User Endpoints
    /// Endpoint to get merchant details
    static let endPointGetMerchantInfo = "getMerchantDetails"
    
    /// Endpoint for user logout
    static let endPointLogoutUser = "merchant/logout"

    // MARK: - Payment Transaction Endpoints
    /// Endpoint to retrieve payment transaction details
    static let endPointGetPaymentTransaction = "getPaymentTransactions"
    
    /// Endpoint for refund payment transaction using scan reciepts
    static let endPointGetPaymentTransactionForRefund = "getPaymentTransactionForRefund"
    
    /// Endpoint to create a void transaction
    static let endPointCreateVoid = "voids"
    
    /// Endpoint to create a refund transaction
    static let endPointCreateRefund = "refunds"
    
    /// Endpoint to create a new transaction
    static let endPointCreateTransaction = "transactions"
    
    static let endPointGetTrasactionDetails = "getPaymentTransactionForRefund"
    
    static func setBaseUrl(for environment: String) {
        switch environment {
        case "development":
            baseUrl = devUrl
        case "staging":
            baseUrl = stagingUrl
        case "UAT":
            baseUrl = uatUrl
        case "VAPT":
            baseUrl = vaptUrl
        case "pre-production":
            baseUrl = preProductionUrl
        case "production":
            baseUrl = prodUrl
        default:
            baseUrl = vaptUrl
        }
        print(baseUrl)
    }
    static let endPointGenerateAccessToken = "generateAccessToken"
    
    static let endPointForgotUsername = "forgotUsername"
    
    static let endPointForgotPassword = "forgotPassword"
    
    static let endPointResetPassword = "resetPassword"
    
    static let endPointValidateResetPasswordCode = "validateCode"
    
    
    /// Endpoint for fetching the details for the merchant tips and surcharge amount
    static let endPointGetMerchantTipsAndSurchargeDetails = "getMerchantChargesConfig"
    
    
    static let endPointReleaseTransaction = "releaseTransaction"
}
