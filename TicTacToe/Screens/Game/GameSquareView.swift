//
//  GameSquareView.swift
//  TicTacToe
//
//  Created by Kate Kashko on 30.09.2024.
//

import SwiftUI

struct GameSquareView: View {
    
    @Binding var value: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 74, height: 74)
                .foregroundColor(Color("basicLightBlue"))
            
            if let iconName = value {
                Image(iconName)
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
        .onTapGesture {
            if value == nil {
                value = "crossPink"
            }
        }
    }
}

#Preview {
    @State var squareValue: String? = "crossPink"
    return GameSquareView(value: $squareValue)
}
