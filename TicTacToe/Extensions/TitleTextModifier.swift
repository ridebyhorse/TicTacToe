//
//  TitleTextModifier.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 07.10.2024.
//

import SwiftUI

struct TitleTextModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight))
            .foregroundStyle(.basicBlack)
    }
}

extension View {
    func titleText(size: CGFloat = 20, weight: Font.Weight = .semibold) -> some View {
        self.modifier(TitleTextModifier(size: size, weight: weight))
    }
}

struct SubtitleTextModifier: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .foregroundStyle(.basicBlack)
    }
}

extension View {
    func subtitleText(size: CGFloat = 20) -> some View {
        self.modifier(SubtitleTextModifier(size: size))
    }
}
