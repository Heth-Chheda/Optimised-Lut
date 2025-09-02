//
//  ScanReciept.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

struct ScanReciept: View {

    @EnvironmentObject var router: Router
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel

    var body: some View {
        ZStack {
            // background
            Color.black.ignoresSafeArea()

            // foreground
            VStack {
                scanRecieptView
            }
        }
        .onChange(of: transactionViewModel.scanReceiptRefundSuccess) { oldValue, newValue in
            if newValue {
                router.navigate(to: .payment(.transactionDetail))
            } else {
                router.navigate(to: .payment(.paymentFailure))
            }
        }
    }
}

#Preview {
    ScanReciept()
        .environmentObject(Router())
        .environmentObject(
            TransactionViewModel(
                transactionRepository: TransactionRepository()
            )
        )
}
