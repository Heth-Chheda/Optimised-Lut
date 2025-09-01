//
//  RootNavigation.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

struct RootNavigation: View {
    @EnvironmentObject private var router: Router
    @StateObject private var transactionViewModel = TransactionViewModel(
        transactionRepository: TransactionRepository())

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ContentView()
                .navigationDestination(for: Router.AuthenticationFlow.self) {
                    destination in
                    switch destination {
                    case .login:
                        Login().navigationBarBackButtonHidden(true)

                    case .forgotPassword:
                        ForgotPassword().navigationBarBackButtonHidden(true)

                    case .forgotUsername:
                        ForgotUsername().navigationBarBackButtonHidden(true)

                    case .resetPassword:
                        ResetPassword().navigationBarBackButtonHidden(true)

                    case .dualLogin:
                        DualLogin().navigationBarBackButtonHidden(true)

                    case .payment(let transactionflow):
                        TransactionNavigation(transactionflow: transactionflow)
                            .navigationBarBackButtonHidden(true)
                            .environmentObject(transactionViewModel)
                    }
                }
        }
    }

}
