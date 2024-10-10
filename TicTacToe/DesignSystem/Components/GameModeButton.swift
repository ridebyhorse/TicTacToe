//
//  GameModeButton.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//


import SwiftUI

// MARK: - GameModeButton
struct GameModeButton: View {
    // MARK: - Properties
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Drawing Constants
    private struct Drawing {
        static let buttonWidth: CGFloat = 245
        static let buttonHeight: CGFloat = 70
        static let buttonCornerRadius: CGFloat = 35
        static let shadowRadius: CGFloat = 2
        static let padding10: CGFloat = 10
        static let iconWidth: CGFloat = 38
        static let iconHeight: CGFloat = 29
    }

    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Drawing.iconWidth, height: Drawing.iconHeight)

                Text(title)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .basicBlack)
            }
        }
        .frame(width: Drawing.buttonWidth, height: Drawing.buttonHeight)
        .background(isSelected ? Color.basicBlue : Color.basicLightBlue)
        .cornerRadius(Drawing.buttonCornerRadius)
        .shadow(radius: Drawing.shadowRadius)
        .padding(Drawing.padding10)
    }
}

// MARK: - Preview
#Preview {
    GameModeButton(
        icon: "singlePlayerIcon",
        title: "Single Player",
        isSelected: true
    ) {
        print("Button pressed")
    }
}