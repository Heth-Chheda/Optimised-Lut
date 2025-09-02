//
//  TransactionViewModel.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import Combine
import SwiftUI

@MainActor
class TransactionViewModel: ObservableObject {

    // MARK: PROPERTIES
    // tips
    @Published var tipsEnabled: Bool = false
    @Published var tipOptions: [TipOptionDto] = []

    // surcharge
    @Published var surchargeEnabled: Bool = false
    @Published var surchargeType: String? = nil
    @Published var surchargeValue: Double? = nil

    // general
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var declinedCode: String? = ""

    // amount
    @Published var amount: String = "0.00"
    @Published var amountForPayment: Double = 0.00

    // get all transactions
    @Published var transactions: [MerchantTransactionsDto] = []
    @Published var loadMore: Bool = false
    @State private var limit: Int = 100
    private var page: Int = 1

    // selectedTransaction
    @Published var selectedTransaction: MerchantTransactionsDto? = nil

    // reference Transaction
    @Published var referenceTransaction: MerchantTransactionsDto? = nil

    // transaction type
    @Published var transactiontype: String? = nil

    // refund response
    @Published var refundResponse: TransactionRefundVoidResponse? = nil
    @Published var refundSuccess: Bool = false

    // transaction label -- update to get transaction complete or void complete or refund complete
    @Published var transactionLabel: String? = nil

    // scan reciepts
    @Published var scanReceiptRefundResponse: RefundTransactionResponse? = nil
    @Published var scanReceiptRefundSuccess: Bool = false

    // user defaults
    let transactionDefaults = TransactionUserDefaults()

    // MARK: DEPENDENCY
    private let transactionRepository: TransactionRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(transactionRepository: TransactionRepositoryProtocol) {
        self.transactionRepository = transactionRepository
    }

    // MARK: MERCHANT TIPS AND SURCHARGE
    func getMerchantTipsAndSurcharge(accessToken: String) async {
        do {
            let merchantTipsAndSurchargeResponse =
                try await transactionRepository
                .getMerchantTipsAndSurchargeDetails(accessToken: accessToken)

            if let obj = merchantTipsAndSurchargeResponse.responseObject {

                // Tips
                if let tips = obj.tip {
                    tipsEnabled = tips.enabled ?? false
                    tipOptions = tips.options ?? []
                }

                DatadogLogging.info(
                    "TransactionViewModel => getMerchantTipsAndSurcharge => Successfully fetched merchant tips"
                )

                // Surcharge
                if let surcharge = obj.surcharge {
                    surchargeEnabled = surcharge.enabled ?? false
                    surchargeType = surcharge.type
                    surchargeValue = surcharge.value
                }

                DatadogLogging.info(
                    "TransactionViewModel => getMerchantTipsAndSurcharge => Successfully fetched merchant surcharge"
                )
            }

        } catch {
            DatadogLogging.error(
                "TransactionViewModel => getMerchantTipsAndSurcharge => Failed to fetch merchant tips and surcharge : \(error.localizedDescription)"
            )
        }
    }

    // MARK: FETCH TRANSACTIONS
    func fetchTransactions(accessToken: String, reset: Bool = false) async {
        if reset {
            page = 1
            transactions.removeAll()
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let fetchTransactionsResponse =
                try await transactionRepository.getAllTransactions(
                    accessToken: accessToken,
                    limit: limit,
                    page: page
                )

            if let newTransactions = fetchTransactionsResponse
                .merchantTransactionsDtos
            {
                if reset {
                    transactions = newTransactions
                } else {
                    transactions.append(contentsOf: newTransactions)
                }

                for transaction in newTransactions {
                    transactionDefaults.saveTransaction(transaction)
                }

                loadMore = newTransactions.count == limit
                page += 1
            } else {
                loadMore = false
            }
        } catch {
            DatadogLogging.error(
                "TransactionViewModel => fetchTransactions => Failed to fetch transactions : \(error.localizedDescription)"
            )
        }
    }

    // MARK: FETCH SINGLE TRANSACTION FROM USERDEFAULTS
    func fetchTransactionFromUserDefaults(transactionId: String)
        -> MerchantTransactionsDto?
    {
        return transactionDefaults.fetchTransaction(
            transactionId: transactionId)
    }

    // MARK: REFUND TRANSACTION
    func performRefundTransaction(
        accessToken: String,
        transactionId: String,
        referenceTransactionId: String
    ) async {

        isLoading = true
        defer { isLoading = false }

        do {

            let response = try await transactionRepository.refundTransaction(
                accessToken: accessToken,
                referenceTransactionId: referenceTransactionId,
                amount: String(amountForPayment),
                transactionId: transactionId
            )

            refundResponse = response

            switch response.response {
            case 1:
                errorMessage = "Refund processed successfully."
                transactionLabel = "Refund"
                refundSuccess = true

            default:
                errorMessage = response.responseText
                refundSuccess = false
            }
        } catch {

            DatadogLogging.error(
                "TransactionViewModel => performRefundTransaction => error: \(error.localizedDescription)"
            )
            refundSuccess = false
            errorMessage = "Something went wrong. Please try again later."
        }

    }

    // MARK: SCAN RECIEPTS
    func handleRefundQrCode(
        transactionId: String,
        accessToken: String,
        resetScanner: (() -> Void)? = nil
    ) async {
        isLoading = true
        defer { isLoading = false }

        do {

            // decoding of the transaction Id from base 64
            guard
                let decodedTransactionIdData = Data(
                    base64Encoded: transactionId),
                let decodedTransactionIdString = String(
                    data: decodedTransactionIdData, encoding: .utf8)
            else {
                errorMessage = "Invalid transaction id."
                return
            }

            // repo call
            let handleRefundQrCodeResponse =
                try await transactionRepository.getPaymentForRefund(
                    accessToken: accessToken,
                    transactionId: decodedTransactionIdString
                )

            scanReceiptRefundResponse = handleRefundQrCodeResponse

            // Things to change on success
            /*
             1. selected transaction for transaction detail view
             2. transaction label for the detail view title
             3. onFailure update the declined code which will be the code for payment declined.
             */
            if handleRefundQrCodeResponse.code == "1" {
                // setting up the varibles
                errorMessage = nil
                scanReceiptRefundSuccess = true
                selectedTransaction = handleRefundQrCodeResponse.responseObject

                // transactionLabel
                switch (
                    handleRefundQrCodeResponse.responseObject?.refundable,
                    handleRefundQrCodeResponse.responseObject?.voided
                ) {
                case (true, _):
                    transactionLabel = "Refundable"

                case (false, true):
                    transactionLabel = "Voided"

                default:
                    transactionLabel = "None"
                }

                declinedCode = nil

            } else {

                scanReceiptRefundSuccess = false

                errorMessage =
                    handleRefundQrCodeResponse.message
                    ?? "Something went wrong. Please try again later."

                // update the declined code.
                declinedCode = handleRefundQrCodeResponse.code
            }

        } catch {
            scanReceiptRefundSuccess = false
            declinedCode = "500"
            selectedTransaction = nil
            errorMessage = "Something went wrong. Please try again later."
            DatadogLogging.error(
                "TransactionViewModel => handleRefundQrCode => Something went wrong. \(error)"
            )
        }
    }
}
