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
        VStack {
            Text("GameView")
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel(coordinator: Coordinator()))
}
