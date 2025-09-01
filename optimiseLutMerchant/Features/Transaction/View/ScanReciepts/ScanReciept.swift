//
//  ScanReciept.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

struct ScanReciept: View {

    @EnvironmentObject var router: Router
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    // local variables
    @State var errorMessage: String = "jsgfksahfkshfksgksaskghds"
    @State var scannedCode: String?

    var body: some View {
        ZStack {
            // background
            Color.black.ignoresSafeArea()

            // foreground
            VStack {
                scanRecieptView
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
