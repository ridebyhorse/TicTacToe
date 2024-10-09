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
                .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)

            
            content
                .padding()
        }
    }
}
