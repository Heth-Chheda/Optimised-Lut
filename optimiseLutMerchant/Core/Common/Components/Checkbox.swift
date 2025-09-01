//
//  Checkbox.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            ZStack {
                Rectangle()
                    .stroke(Color.white, lineWidth: 3)  // Outer border
                    .frame(width: 20, height: 20)
                    .cornerRadius(2)

                if configuration.isOn {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 14, height: 14)  // Inner rectangle with padding
                        .cornerRadius(2)  // Slight rounding for a cleaner look
                }
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }

            configuration.label
                .foregroundColor(.white)
                .font(.custom("Poppins", size: 16))
                .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)  // Align to the left
        .padding(.leading, 50)
    }
}
