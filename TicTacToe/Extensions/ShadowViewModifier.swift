//
//  ShadowViewModifier.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 08.10.2024.
//

import SwiftUI

struct BasicShadowModifier: ViewModifier {
    enum Drawing {
        static let shadowRadius: CGFloat = 15
        static let shadowOffsetX: CGFloat = 4
        static let shadowOffsetY: CGFloat = 4
    }
    
   func body(content: Content) -> some View {
      content
           .shadow(
            color: Color(
                red: 0.6,
                green: 0.62,
                blue: 0.76
            )
            .opacity(0.3),
            radius: Drawing.shadowRadius, 
            x: Drawing.shadowOffsetX,
            y: Drawing.shadowOffsetY
           )
   }
}

extension View {
   func basicShadow() -> some View {
      self.modifier(BasicShadowModifier())
   }
}
