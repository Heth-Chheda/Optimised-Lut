//
//  ConfirmRefund.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 28/08/25.
//

import SwiftUI

struct ConfirmRefundOrVoid: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router

    // local variables
    @State var transactionType: String = ""
    @State var errorMesssage: String? = nil
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer().frame(height: 100)

                confirmRefundView

                Spacer()
            }

            if transactionViewModel.isLoading {

                ZStack {
                    Color.black.ignoresSafeArea(.all)

                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .purple)
                        )
                        .scaleEffect(2)
                }

            }
        }
        .onChange(of: transactionViewModel.refundSuccess) {
            oldValue, newValue in
            let success = newValue

            if success {
                transactionViewModel.refundSuccess = false  // setting it false, for showing the complete screen for next transactions
                router.navigate(to: .payment(.transactionComplete))
            }
        }
        .onChange(of: transactionViewModel.errorMessage) { oldValue, newValue in
            errorMesssage = newValue
        }
    }
}

#Preview {
    ConfirmRefundOrVoid()
}
