//
//  CustomAlertView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 06.10.2024.
//

import SwiftUI

struct CustomAlertView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(Resources.Text.warning.localized(language))
                .font(.navigationTitle)
                .foregroundStyle(.secondaryPink)
                .multilineTextAlignment(.center)
            Text(message)
                .font(.title3)
                .multilineTextAlignment(.center)
            
            BasicButton(
                styleType: .primary,
                title: "ok",
                tapHandler: onDismiss
            )

        }
        .padding()
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color(red: 0.6, green: 0.62, blue: 0.76).opacity(0.3), radius: 15, x: 4, y: 4)
    }
}

#Preview {
    CustomAlertView(message: "sdd", onDismiss: {})
}
