//
//  optimiseLutMerchantApp.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

@main
struct optimiseLutMerchantApp: App {
    @ObservedObject private var router = Router()
    @StateObject private var authViewModel = AuthenticationViewModel(
        authenticationRepository: AuthenticationRepository())
    var body: some Scene {
        WindowGroup {
            RootNavigation()
                .environmentObject(authViewModel)
                .environmentObject(router)
        }
    }
}
