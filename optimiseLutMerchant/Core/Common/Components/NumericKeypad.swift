//
//  NumericKeypad.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 26/08/25.
//

import SwiftUI

struct NumericKeypad: View {
    @Binding var amount: String

    var body: some View {
        keypadRows()
            .padding()
            .cornerRadius(20)
            .padding()
    }

    private func keypadRows() -> some View {
        VStack(spacing: 25) {
            ForEach(0..<3) { row in
                keypadRow(for: row)
            }
            lastRow()
        }
    }

    private func keypadRow(for row: Int) -> some View {
        HStack(spacing: 20) {
            ForEach(0..<3) { column in
                let buttonText = "\(row * 3 + column + 1)"
                keypadButton(title: buttonText, action: { input(buttonText) })
            }
        }
    }

    private func lastRow() -> some View {
        HStack(spacing: 25) {
            Spacer()
                .frame(width: 90)
            keypadButton(title: "0", action: { input("0") })
                .padding(.leading, 10)
            keypadButton(title: "⌫", action: backspace)
                .padding(.leading, -5)
        }
    }

    private func keypadButton(title: String, action: @escaping () -> Void) -> some View {
        GeometryReader { geometry in
            Text(title)
                .font(
                    .system(size: geometry.size.width * 0.45)
                )
                .frame(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.width * 0.8
                )
                .background(Color(hex: "#9747FF"))
                .foregroundColor(.white)
                .cornerRadius(
                    geometry.size.width * 0.15
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: geometry.size.width * 0.15
                    )
                    .stroke(Color.black, lineWidth: 3)
                )
                .onTapGesture(perform: action)
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.25
        )
    }


    private func input(_ text: String) {
        var value = amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(
            of: ",",
            with: ""
        )

        // Check if the value is currently empty or set to "0.00"
        if value.isEmpty || value == "0.00" {
            // Initialize with "0." followed by the new input
            value = "0.0" + text
        } else {
            // Remove existing decimal for processing
            value = value.replacingOccurrences(of: ".", with: "")
            value.append(text) // Append the new digit
        }

        // Limit total digits to 9, but ensure we have at least 2 for decimals
        if value.count > 8 {
            value = String(value.prefix(8))
        }

        // Ensure the last two characters are treated as decimal
        let decimalIndex = max(value.count - 2, 0)
        let integerPart = String(
            value[..<value.index(value.startIndex, offsetBy: decimalIndex)]
        )
        let decimalPart = String(value[value.index(value.startIndex, offsetBy: decimalIndex)...]).prefix(
            2
        )

        // Ensure integer part is not empty
        let formattedIntegerPart = integerPart.isEmpty ? "0" : integerPart
        amount = formatAmount("\(formattedIntegerPart).\(decimalPart)")
    }

    private func backspace() {
        // Remove any existing formatting (like "$" or ",")
        var value = amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")

        // If the value is empty, reset to "0.00"
        if value.isEmpty {
            amount = "$0.00"
            return
        }

        // Remove the last character
        value.removeLast()

        // If the value is empty after removing the last character, reset to "0.00"
        if value.isEmpty {
            amount = "$0.00"
            return
        }

        // Handle the case where we have a decimal part
        let decimalIndex = max(value.count - 1, 0)  // Ensures there's at least space for decimal digits
        let integerPart = String(value[..<value.index(value.startIndex, offsetBy: decimalIndex)])
        let decimalPart = String(value[value.index(value.startIndex, offsetBy: decimalIndex)...]).prefix(2)

        // If the integer part is empty or has only one digit left, replace it with "0"
        let formattedIntegerPart = (integerPart.isEmpty || integerPart.count == 1) ? "0" : integerPart

        // Rebuild the formatted amount (with currency symbol and commas)
        let formattedAmount = formatAmount("\(formattedIntegerPart).\(decimalPart)")

        // Set the final amount with "$" and commas, if needed
        amount = formattedAmount
    }

    private func formatAmount(_ value: String) -> String {
        let digitsOnly = value.filter { "0123456789".contains($0) }
        if digitsOnly.isEmpty {
            return "0.00"
        }

        var integerPart = "0"
        var decimalPart = "00" // Default to two decimal places

        if digitsOnly.count > 2 {
            let splitIndex = digitsOnly.index(digitsOnly.endIndex, offsetBy: -2)
            integerPart = String(digitsOnly[..<splitIndex])
            decimalPart = String(digitsOnly[splitIndex...])
        } else {
            decimalPart = digitsOnly
        }

        let formattedIntegerPart = addCommas(integerPart)
        return "\(formattedIntegerPart).\(decimalPart.padding(toLength: 2, withPad: "0", startingAt: 0))"
    }

    func addCommas(_ integerPart: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        // Explicitly set the locale to ensure Western-style formatting
        numberFormatter.locale = Locale(identifier: "en_US")
        
        if let number = Int(integerPart), integerPart.count > 0 {
            return numberFormatter
                .string(from: NSNumber(value: number)) ?? integerPart
        }
        return integerPart
    }
}

struct NumericKeypad_Previews: PreviewProvider {
    @State static private var amount: String = "0.00"

    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Optional background
            NumericKeypad(amount: $amount)
                .frame(maxHeight: .infinity)
        }
        .previewLayout(.sizeThatFits)
    }
}
