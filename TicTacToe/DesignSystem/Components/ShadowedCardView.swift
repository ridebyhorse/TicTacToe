//
//  ShadowedCardView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 07.10.2024.
//


import SwiftUI

struct ShadowedCardView<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat = 30, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        ZStack {
         
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.white)
                .basicShadow()

            
            content
                .padding()
        }
    }
}
