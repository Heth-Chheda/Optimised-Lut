//
//  KnownTransactionDetail.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

struct KnownTransactionDetail: View {
    // NOTE: WHILE NAVIGATING BACK TO THE LIST CLEAR THE SELECTED TRANSACTION
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    @State var referenceTransactionDetails: MerchantTransactionsDto?
    @State var transactionType: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                knownTransactionDetailView
            }
        }
        .onAppear {
            transactionType =
                transactionViewModel.selectedTransaction?.type ?? ""
            fetchTransactionDetailsByReferenceId()
        }
    }
}

#Preview {
    KnownTransactionDetail()
}
