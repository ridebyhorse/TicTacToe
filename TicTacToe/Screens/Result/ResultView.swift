//
//  ResultView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct ResultView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    @ObservedObject var viewModel: ResultViewModel
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
        }
        
    }
}

#Preview {
    ResultView(viewModel: ResultViewModel(coordinator: Coordinator()))
}
