//
//  GameView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct GameView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack{
            Color("basicBackground")
            VStack{
                HStack(spacing: 32){
                    PlayerSquareView()
                    Text("Time")
                        .font(.basicTitle)
                    PlayerSquareView()
                }
                HStack{
                    Image("crossPink")
                        .resizable()
                        .frame(width: 54, height: 54)
                    Text("Player")
                        .font(.basicTitle)
                }
                .padding(.top, 45)
                GameFieldView()
                    .padding(.top, 20)
                Spacer()
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel(coordinator: Coordinator()))
}
