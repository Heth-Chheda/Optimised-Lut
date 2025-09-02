//
//  TransactionRepository.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import Foundation
import UIKit

protocol TransactionRepositoryProtocol {
    func getMerchantTipsAndSurchargeDetails(
        accessToken: String
    ) async throws -> MerchantTipsAndSurchargeResponse

    func getAllTransactions(accessToken: String, limit: Int, page: Int)
        async throws -> TransactionsResponse

    func refundTransaction(
        accessToken: String, referenceTransactionId: String, amount: String,
        transactionId: String
    ) async throws -> TransactionRefundVoidResponse

    func getPaymentForRefund(
        accessToken: String,
        transactionId: String
    ) async throws -> RefundTransactionResponse
}

class TransactionRepository: BaseRepository, ObservableObject,
    TransactionRepositoryProtocol
{

    // MARK: MERCHANT TIPS AND SURCHARGE
    func getMerchantTipsAndSurchargeDetails(accessToken: String) async throws
        -> MerchantTipsAndSurchargeResponse
    {

        let tipsAndSurchargeUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointGetMerchantTipsAndSurchargeDetails)"

        return try await performRequest(
            url: tipsAndSurchargeUrl,
            method: .get,
            accessToken: accessToken,
            responseType: MerchantTipsAndSurchargeResponse.self
        )
    }

    // MARK: GET ALL TRANSACTIONS
    func getAllTransactions(accessToken: String, limit: Int, page: Int)
        async throws -> TransactionsResponse
    {
        let getAllTransactionsUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointGetPaymentTransaction)?limit=\(limit)&page=\(page)"

        return try await performRequest(
            url: getAllTransactionsUrl,
            method: .get,
            accessToken: accessToken,
            responseType: TransactionsResponse.self
        )
    }

    // MARK: REFUND TRANSACTION
    func refundTransaction(
        accessToken: String, referenceTransactionId: String, amount: String,
        transactionId: String
    ) async throws -> TransactionRefundVoidResponse {

        let refundTransactionUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointCreateRefund)"

        let body: [String: Any] = [
            "type": "refund",
            "transaction_id": transactionId,
            "reference_transaction_id": referenceTransactionId,
            "payment": "creditcard",
            "amount": amount,
        ]

        DatadogLogging.info(
            "TransactionRepository ==> refundTransaction ==> Initiating refund for Transaction ID: \(transactionId)"
        )

        return try await performRequest(
            url: refundTransactionUrl,
            method: .post,
            accessToken: accessToken,
            body: body,
            responseType: TransactionRefundVoidResponse.self
        )

    }

    // MARK: SCAN RECIEPTS
    func getPaymentForRefund(
        accessToken: String,
        transactionId: String
    ) async throws -> RefundTransactionResponse {

        /// Note: The transaction Id should be decoded. Should be handled in the TransactionViewModel.

        let getPaymentForRefundUrl =
            "\(ApiUrls.baseUrl)/\(ApiUrls.endPointGetPaymentTransactionForRefund)?transactionId=\(transactionId)"

        return try await performRequest(
            url: getPaymentForRefundUrl,
            method: .get,
            accessToken: accessToken,
            responseType: RefundTransactionResponse.self
        )
    }
}
