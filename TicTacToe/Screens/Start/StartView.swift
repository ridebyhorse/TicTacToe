//
//  StartView.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 29.09.2024.
//

import SwiftUI

struct StartView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            Spacer()
            Image(.mainIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 48)
            Text("TIC-TAC-TOE")
                .font(.mainTitle)
                .padding(30)
            Spacer()
            BasicButton(
                styleType: .primary,
                title: "Let's play",
                tapHandler: { print("Let's") }
            )
        }
        .padding(.horizontal, 21)
        
    }
}

#Preview {
    StartView()
}
