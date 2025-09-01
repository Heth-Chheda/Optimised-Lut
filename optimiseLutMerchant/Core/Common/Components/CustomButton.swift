//
//  CustomButton.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

struct CustomButton: View {
    var label: String
    var action: () -> Void
    var color: Color = Color(red: 0 / 255, green: 133 / 255, blue: 255 / 255)  // Default color

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 20, weight: .bold))
                .font(.custom("Poppins", size: 20))
                .foregroundColor(.white)
                .frame(width: 125, height: 20)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(color)  // Use the provided color
                .clipShape(Capsule())
        }
    }
}
