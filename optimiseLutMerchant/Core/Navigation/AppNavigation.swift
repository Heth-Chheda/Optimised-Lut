//
//  AppNavigation.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

final class Router: ObservableObject {

    @Published var navigationPath = NavigationPath()

    enum AuthenticationFlow: Hashable, Codable {
        case login
        case forgotUsername
        case forgotPassword
        case resetPassword
        case dualLogin
        case payment(TransactionFlow)
    }

    enum TransactionFlow: Hashable, Codable {
        case payLanding
        case merchantProfile
        case amountRegister
        case viewAllTransactions
        case transactionDetail
        case knownTransactionDetail
        case disputeTransaction
        case scanReceipt
        case processRefundAmount
        case confirmRefund
        case transactionComplete
    }

    func setRoot(to destination: AuthenticationFlow) {
        navigationPath = NavigationPath()
        navigationPath.append(destination)
    }

    func navigate(to destination: AuthenticationFlow) {
        navigationPath.append(destination)
    }

    func navigateBack() {
        navigationPath.removeLast()
    }

    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
