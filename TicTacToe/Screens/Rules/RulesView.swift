//
//  RulesView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct RulesView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: RulesViewModel
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
    }
}

#Preview {
    RulesView(viewModel: RulesViewModel(coordinator: Coordinator()))
}
