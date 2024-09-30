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
            HStack {
                Button(action: {
                    print("rules tapped")
                }, label: {
                    NavigationLink(
                        destination: {
                            Color(.basicBlack)
                                .navigationTitle("Rules")
                        }) {
                            Image(.rulesIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                    }
                })
                Spacer()
                Button(action: {
                    print("settings tapped")
                }, label: {
                    NavigationLink(
                        destination: {
                            Color(.basicBlue)
                                .navigationTitle("Settings")
                        }) {
                            Image(.settingsIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 38, height: 36)
                    }
                })
            }
            Spacer()
            Image(.mainIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 48)
            Text(Recources.Text.ticTacToe)
                .font(.mainTitle)
                .padding(30)
            Spacer()
            BasicButton(
                styleType: .primary,
                title: Recources.Text.letsPlay,
                tapHandler: { print("Let's") }
            )
        }
        .padding(.horizontal, 21)
        
    }
}

#Preview {
    NavigationView {
        StartView()
    }
}
