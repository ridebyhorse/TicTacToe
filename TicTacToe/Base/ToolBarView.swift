//
//  ToolBarView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import SwiftUI

struct ToolBarView: View {
    var showBackButton: Bool = false
    var backButtonAction: (() -> Void)?
    
    var showRightButton: Bool = false
    var rightButtonAction: (() -> Void)?
    
    var title: String
    
    var body: some View {
        HStack {
            if showBackButton, let backButtonAction = backButtonAction {
                Button(action: {
                    backButtonAction()
                }) {
                    Image(systemName: Resources.Image.arrowLeft)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .foregroundStyle(.basicBlue)
                }
                .padding(.leading, 16)
            } else {
                Spacer().frame(width: 50)
            }
            
           
            Text(title)
                .font(.navigationTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .lineLimit(1)
            
            if showRightButton, let rightButtonAction = rightButtonAction {
                Button(action: {
                    rightButtonAction()
                }) {
                    Image(.settingsIcon)
                        .foregroundStyle(.basicBlack)
                }
                .padding(.trailing, 16)
            } else {
                Spacer().frame(width: 50)
            }
        }
        .frame(height: 44)
        .background(Color.basicBackground)
    }
}

#Preview {
    VStack {
        ToolBarView(
            showBackButton: true,
            backButtonAction: { print("Back button pressed") },
            showRightButton: true,
            rightButtonAction: { print("Right button pressed") },
            title: "Custom NavBar"
        )
        
        Spacer()
    }
}
