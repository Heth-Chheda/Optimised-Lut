//
//  SearchField.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 27/08/25.
//

import SwiftUI

struct SearchField: View {
    @Binding var text: String
    var labelText: String

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Text(labelText)
                    .font(.custom("Poppins", size: 15))
                    .foregroundColor(.white)
                    .lineSpacing(1)
                    .padding(.top, -10)
                    .padding(.leading, 10)
                    .opacity(text.isEmpty ? 1 : 1)
                    .offset(y: text.isEmpty ? 0 : -20)

                HStack {
                    TextField("", text: $text)
                        .font(.custom("Poppins", size: 18))
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .padding(.top, -10)
                        .padding(.leading, 10)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .textFieldStyle(PlainTextFieldStyle())

                    // Trailing cross icon
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image("close_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 10)
                    }
                }
            }

            if text.isEmpty {
                Image("underline")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, -25)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }
}
