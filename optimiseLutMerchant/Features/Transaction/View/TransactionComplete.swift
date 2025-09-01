//
//  VoidRefundComplete.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 29/08/25.
//

import SwiftUI

struct TransactionComplete: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    
    // local variables
    @State var label: String = ""
    @State var amount: String = "0.00"
    @State var transactionNumber: String = ""
    @State var date: String = ""
    @State var firstName: String = ""
    @State var phoneNumber: String = ""
    @State var timezone: String = ""
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                transactionCompleteView
            }
        }
        .onAppear {
            updateLocalVariables()
        }
    }
}

#Preview {
    TransactionComplete()
}
