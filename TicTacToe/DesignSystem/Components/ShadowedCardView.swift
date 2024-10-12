//
//  ShadowedCardView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 07.10.2024.
//


import SwiftUI

struct ShadowedCardView<Content: View>: View {
    // MARK: - Properties
    let content: Content
    let cornerRadius: CGFloat
    let borderColor: Color
    let borderWidth: CGFloat
    
    // MARK: - Initialization
    init(
        cornerRadius: CGFloat = 30,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.content = content()
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.basicWhite)
                .basicShadow()
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            
            content
                .padding()
        }
    }
}
