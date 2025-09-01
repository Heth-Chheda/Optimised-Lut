//
//  ViewAllTransaction.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

struct ViewAllTransaction: View {
    // MARK: PROPERTIES
    // Environment variables
    @EnvironmentObject var router: Router
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel

    @State var searchText: String = ""

    // View
    var body: some View {
        VStack {
            Header()

            Spacer().frame(height: UIScreen.main.bounds.width * 0.1)

            viewAllTransactionHeader

            TransactionList(
                transactions: filteredTransactions,
                isLoadingMore: transactionViewModel.isLoading,
                hasMorePages: transactionViewModel.loadMore,
                onTransactionTap: { transaction in
                    transactionViewModel.selectedTransaction = transaction
                    navigateForTransaction(transaction)
                },
                onLoadMore: {
                    // Load next page when scrolling near the bottom
                    Task {
                        await transactionViewModel.fetchTransactions(
                            accessToken: authenticationViewModel.accessToken
                                ?? ""
                        )
                    }
                },
                searchText: searchText
            )

            Spacer()

            CustomButton(label: "Cancel") {
                router.navigateBack()
            }
            Spacer().frame(height: 20)
        }
        .padding(.vertical)
        .background(Color.black)
        .ignoresSafeArea()
        .onAppear {
            Task {
                await transactionViewModel.fetchTransactions(
                    accessToken: authenticationViewModel.accessToken ?? "",
                    reset: true
                )
            }
        }
    }
}

#Preview {
    ViewAllTransaction()
}
