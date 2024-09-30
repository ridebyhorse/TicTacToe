//
//  ResultView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

struct ResultView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    ResultView()
}
