//
//  OnlineOrderConfirmPaymentChange.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 10/09/25.
//

import SwiftUI

struct OnlineOrderConfirmPaymentChange: View {
    @EnvironmentObject var authenticaionViewModel: AuthenticationViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)

            HStack {
                content
            }
            .padding(.horizontal)
        }
        .onChange(of: transactionViewModel.refundSuccess) {
            oldValue, newValue in
            if newValue {
                transactionViewModel.refundSuccess = false
                router.navigate(to: .payment(.transactionComplete))
            }
        }
    }
}
