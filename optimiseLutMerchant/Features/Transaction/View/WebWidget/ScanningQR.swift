//
//  ScanningQR.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 09/09/25.
//

import SwiftUI

struct ScanningQR: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            webWidgetScanningContent
        }
        .onChange(of: transactionViewModel.scanReceiptRefundSuccess) { oldValue, newValue in
            switch newValue {
                
                // When the case is true navigate to the transaction detail page (web widget)
            case true:
                router.navigate(to: .payment(.transactionDetail))
                
                // default navigate to payment failure.
            default:
                router.navigate(to: .payment(.paymentFailure))
            }
            
        }
    }
}
