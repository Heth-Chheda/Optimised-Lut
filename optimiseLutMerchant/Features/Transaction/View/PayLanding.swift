//
//  PayLanding.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 25/08/25.
//

import SwiftUI

struct PayLanding: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router
    @State var showMerchantProfileDetails: Bool = false
    @State var showLogoutOverlay: Bool = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            payLandingContent
                .overlay {
                    if showMerchantProfileDetails {
                        MerchantProfile {
                            showMerchantProfileDetails = false
                        }
                    }
                    
                    if showLogoutOverlay {
                        Logout(onDismiss: {
                            showLogoutOverlay = false
                        })
                    }
                }
        }
        .onAppear{
            Task {
                await authenticationViewModel.fetchMerchantDetails()
            }
        }
    }
}

#Preview {
    PayLanding()
}
