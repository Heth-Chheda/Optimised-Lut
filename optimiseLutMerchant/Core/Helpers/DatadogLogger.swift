//
//  DatadogLogger.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import Foundation
import DatadogCore
import DatadogCrashReporting
import DatadogLogs
import DatadogRUM

class DatadogLogger: ObservableObject {
    static let shared = DatadogLogger()

    var logger: DatadogLogs.LoggerProtocol?

    private let appID = "edc337c1-bb59-4c24-8491-8b011286adc9"
    private let clientToken = "pubc2efd2e434964c28d878ba28b3488acb"
    private var environment: String {
        return UserDefaults.standard.string(forKey: "selectedEnvironment")
            ?? "production"
    }
    private let service = "lüt-terminal-ios"

    private init() {
        initializeDatadog()
    }

    private func initializeDatadog() {
        do {
            // Initialize Datadog SDK
            Datadog.initialize(
                with: Datadog.Configuration(
                    clientToken: clientToken,
                    env: environment,
                    site: .us1,
                    service: service
                ),
                trackingConsent: .granted
            )
            
            
            // Enable Logging
            Logs.enable()

            // Enable RUM (Real User Monitoring)
            RUM.enable(
                with: RUM.Configuration(
                    applicationID: appID,
                    uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                    uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate(),
                    urlSessionTracking: RUM.Configuration.URLSessionTracking(),
                    appHangThreshold: 0.25,
                    trackWatchdogTerminations: true
                )
            )
            
            // Enable Crash Reporting
            CrashReporting.enable()

            // Create the logger
            logger = DatadogLogs.Logger.create(
                with: DatadogLogs.Logger.Configuration(
                    service: "lüt-terminal-ios",
                    networkInfoEnabled: true
                )
            )
        }
    }
}
