//
//  TransactionNavigation.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

struct TransactionNavigation: View {
    let transactionflow: Router.TransactionFlow

    var body: some View {
        Group {

            switch transactionflow {

            case .payLanding:
                PayLanding()

            case .amountRegister:
                AmountRegister()

            case .merchantProfile:
                MerchantProfile()
                
            case .viewAllTransactions:
                ViewAllTransaction()
                
            case .transactionDetail:
                TransactionDetail()
                
            case .knownTransactionDetail:
                KnownTransactionDetail()
                
            case .disputeTransaction:
                Disputes()
                
            case .scanReceipt:
                ScanReciept()
                
            case .processRefundAmount:
                ProcessRefundAmount()
                
            case .confirmRefund:
                ConfirmRefundOrVoid()
                
            case .transactionComplete:
                TransactionComplete()
                
            case .paymentFailure:
                PaymentDeclined()
                
            case .webWidgetScanner:
                ScanningQR()
            }
        }
    }

}
