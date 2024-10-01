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
        HStack {
            Button(action: {
                viewModel.dismissRules()
            }, label: {
                Image(.backIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 22)
            })
            Spacer()
            Text(Resources.Text.rulesNavigationTitle)
                .font(.navigationTitle)
                .foregroundStyle(.basicBlack)
                .padding(.trailing, 30)
            Spacer()
        }
        .padding(.horizontal, 21)
        .padding(.top, 8)
        ScrollView {
            ForEach(0..<viewModel.rules.count, id: \.self) { index in
                HStack {
                    ZStack {
                        Circle()
                            .fill(.secondaryPurple)
                            .frame(width: 45, height: 45)
                        Text("\(index + 1)")
                            .font(.number)
                            .foregroundStyle(.basicBlack)
                        
                    }
                    .padding(.trailing, 44)
                    Text(viewModel.rules[index])
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
}

#Preview {
    RulesView(viewModel: RulesViewModel(coordinator: Coordinator()))
}
