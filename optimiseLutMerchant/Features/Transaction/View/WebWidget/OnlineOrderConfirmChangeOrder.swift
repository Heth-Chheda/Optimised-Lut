//
//  OnlineOrderConfirmChangeOrder.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 10/09/25.
//

import SwiftUI

struct OnlineOrderConfirmChangeOrder: View {
    
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            HStack {
                
                content
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .onChange(of: transactionViewModel.refundSuccess) { oldValue, newValue in
            if newValue {
                transactionViewModel.refundSuccess = false
                router.navigate(to: .payment(.transactionComplete))
            }
        }
    }
}
