//
//  ConfirmRefund.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 28/08/25.
//

import SwiftUI

struct ProcessRefundAmount: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    
    @State var errorMessage: String?
    
    @State var confirmRefundAmount: String = "0.00"
    @State var remainingAmount: Double = 0.00

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                confirmRefundView
                
                Spacer()
            }
        }
        .onAppear {
            updateVariables()
        }
    }
}
