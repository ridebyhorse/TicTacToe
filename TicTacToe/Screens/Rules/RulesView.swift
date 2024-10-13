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
        ZStack(alignment: .top) {
            Color.basicBackground.ignoresSafeArea(.all)
            // Scrollable content
            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: 44) 
                    ForEach(0..<viewModel.rules.count, id: \.self) { index in
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(.secondaryPurple)
                                    .frame(width: 45, height: 45)
                                Text("\(index + 1)".localized(language))
                                    .font(.number)
                                    .foregroundStyle(.basicBlack)
                            }
                            .padding(.trailing, 44)
                            Text(viewModel.rules[index].localized(language))
                                .font(.basicBody)
                                .foregroundStyle(.basicBlack)
                                .background {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(.basicLightBlue)
                                        .padding(.horizontal, -24)
                                        .padding(.vertical, -12)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.trailing, 45)
                        }
                        .padding(.vertical, 16)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 21)
            }
            
            // Toolbar fixed at the top
            ToolBarView(
                showBackButton: true,
                backButtonAction: viewModel.dismissRules,
                title: Resources.Text.rulesNavigationTitle.localized(language)
            )
            .frame(height: 44)
            .zIndex(1)
        }
    }
}

#Preview {
    RulesView(viewModel: RulesViewModel(coordinator: Coordinator()))
}
