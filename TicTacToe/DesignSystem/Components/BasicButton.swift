//
//  BasicButton.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 29.09.2024.
//

import SwiftUI

struct BasicButton: View {
    let styleType: BasicButtonStyleType
    let title: String
    let tapHandler: () -> Void

    var body: some View {
        Button(action: tapHandler) {
            HStack {
                Text(title)
            }
            .frame(height: 72)
            .frame(
                maxWidth: .infinity
            )
            .padding(.horizontal, 16)
        }
        .buttonStyle(BasicButtonStyle.get(type: styleType))
    }

    init(
        styleType: BasicButtonStyleType,
        title: String,
        tapHandler: @escaping () -> Void
    ) {
        self.styleType = styleType
        self.title = title
        self.tapHandler = tapHandler
    }
}
