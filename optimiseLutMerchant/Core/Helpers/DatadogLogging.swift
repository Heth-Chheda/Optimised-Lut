//
//  DatadogLogging.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import DatadogCore
import DatadogLogs
import DatadogRUM
import Foundation

class DatadogLogging {
    private static let Logger = DatadogLogger.shared

    // Static method for info logs
    static func info(_ message: String, attributes: [String: Encodable]? = nil)
    {
        Logger.logger?.info(message, attributes: attributes)
    }

    // Static method for warning logs
    static func warning(
        _ message: String, attributes: [String: Encodable]? = nil
    ) {
        Logger.logger?.warn(message, attributes: attributes)
    }

    // Static method for error logs
    static func error(_ message: String, attributes: [String: Encodable]? = nil)
    {
        Logger.logger?.error(message, attributes: attributes)
    }
}
