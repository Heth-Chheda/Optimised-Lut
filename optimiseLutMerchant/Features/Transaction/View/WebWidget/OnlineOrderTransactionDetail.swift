//
//  OnlineOrderTransactionDetail.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 09/09/25.
//

import SwiftUI

struct OnlineOrderTransactionDetail: View {
    
    @EnvironmentObject var authenticaionViewModel: AuthenticationViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            ScrollView {
                HStack {
                    
                    content
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .onChange(of: transactionViewModel.refundSuccess) { oldValue, newValue in
            if newValue {
                transactionViewModel.refundSuccess = false
                router.navigate(to: .payment(.transactionComplete))
            }
        }
    }
}
