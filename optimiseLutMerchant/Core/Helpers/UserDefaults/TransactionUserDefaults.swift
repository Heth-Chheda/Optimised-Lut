//
//  TransactionUserDefaults.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import Foundation

class TransactionUserDefaults: UserDefaultsManager {

    /// Save a single transaction
    func saveTransaction(_ transaction: MerchantTransactionsDto) {
        guard let transactionId = transaction.transactionId else { return }
        let key = "transaction_\(transactionId)"
        saveObject(transaction, forKey: key)
    }

    /// Fetch a single transaction
    func fetchTransaction(transactionId: String) -> MerchantTransactionsDto? {
        let key = "transaction_\(transactionId)"
        return fetchObject(forKey: key, as: MerchantTransactionsDto.self)
    }

    /// Save a list of transactions
    func saveTransactionsList(_ transactions: [MerchantTransactionsDto]) {
        let key = "savedTransactionsList"
        saveObject(transactions, forKey: key)
    }

    /// Fetch the list of transactions
    func fetchTransactionsList() -> [MerchantTransactionsDto]? {
        let key = "savedTransactionsList"
        return fetchObject(forKey: key, as: [MerchantTransactionsDto].self)
    }

    /// Remove a transaction by ID
    func removeTransaction(transactionId: String) {
        let key = "transaction_\(transactionId)"
        removeObject(forKey: key)
    }
}
