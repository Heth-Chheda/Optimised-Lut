//
//  SessionManager.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 29/08/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SessionManager: ObservableObject {
    @Published var accessToken: String?
    @Published var isLoggedIn: Bool = false
    
    private var refreshTimer: Timer?
    private var inactivityTimer: Timer?
    
    private let tokenExpiry: TimeInterval = 15 * 60 // 15 mins
    private let refreshThreshold: TimeInterval = 14 * 60 // refresh before expiry
    private let inactivityThreshold: TimeInterval = 15 * 60 // logout after inactivity
    
    // MARK: - Login
    func login(with token: String) {
        accessToken = token
        isLoggedIn = true
        
        startRefreshTimer()
        startInactivityTimer()
    }
    
    // MARK: - Refresh Token
    private func startRefreshTimer() {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshThreshold, repeats: true) { [weak self] _ in
            self?.refreshAccessToken()
        }
    }
    
    private func refreshAccessToken() {
        guard isLoggedIn else { return }
        print("🔄 Refreshing token before expiry...")
        
        // TODO: Replace with your refresh API call
        // Example:
        // apiClient.refreshToken(currentToken: accessToken) { newToken in
        //     DispatchQueue.main.async {
        //         self.accessToken = newToken
        //     }
        // }
    }
    
    // MARK: - Inactivity Tracking
    func startInactivityTimer() {
        inactivityTimer?.invalidate()
        inactivityTimer = Timer.scheduledTimer(withTimeInterval: inactivityThreshold, repeats: false) { [weak self] _ in
            self?.logout()
        }
    }
    
    func resetInactivityTimer() {
        startInactivityTimer()
    }
    
    /// Call this on any user interaction (via InteractionDetector)
    func userDidInteract() {
        if isLoggedIn {
            print("👆 User interacted, resetting inactivity timer")
            resetInactivityTimer()
        }
    }
    
    // MARK: - Logout
    func logout() {
        print("🚪 Logging out due to inactivity or manual logout")
        
        refreshTimer?.invalidate()
        inactivityTimer?.invalidate()
        refreshTimer = nil
        inactivityTimer = nil
        
        accessToken = nil
        isLoggedIn = false
        
        // TODO: Call your logout API here if needed
    }
}
