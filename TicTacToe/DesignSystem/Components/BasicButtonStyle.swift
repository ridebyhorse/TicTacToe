//
//  BasicButtonStyle.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 29.09.2024.
//

import SwiftUI

enum BasicButtonStyleType {
    case primary
    case secondary
}

struct BasicButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let strokeColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .lineLimit(1)
            .foregroundColor(foregroundColor)
            .font(.buttonTitle)
            .background(backgroundColor)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(strokeColor, lineWidth: 2)
            )
    }

    static func get(type: BasicButtonStyleType) -> Self {
        switch type {
        case .primary:
            return BasicButtonStyle(
                backgroundColor: .basicBlue,
                foregroundColor: .white,
                strokeColor: .clear
            )
        case .secondary:
            return BasicButtonStyle(
                backgroundColor: .basicWhite,
                foregroundColor: .basicBlue,
                strokeColor: .basicBlue
            )
        }
    }
}
