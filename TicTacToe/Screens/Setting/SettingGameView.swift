//
//  SettingGameView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct SettingGameView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
        }
    }
}

#Preview {
    SettingGameView(viewModel: SettingsViewModel(coordinator: Coordinator()))
}
