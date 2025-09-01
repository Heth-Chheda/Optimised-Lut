//
//  TransactionDetail.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//
 
import SwiftUI

struct TransactionDetail: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    @State var canVoid: Bool = false
    @State var canRefund: Bool = false
    @State var transactionStatusLabel: String = ""
    // NOTE: WHILE NAVIGATING BACK TO THE LIST CLEAR THE SELECTED TRANSACTION
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 100)
                transactionDetailView
                Spacer()
                
                actionButtons
                    .padding(.bottom, 100)
            }
        }
        .onAppear{
            updateTransactionStatus()
        }
    }
}

#Preview {
    TransactionDetail()
}
