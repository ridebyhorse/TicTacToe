//
//  LeaderboardView.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 01.10.2024.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var viewModel: LeaderboardViewModel
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language

    struct DrawingConstants {
        static let headerBottomPadding: CGFloat = 20
        static let roundsSectionTopPadding: CGFloat = 30
        static let gamesSectionTopPadding: CGFloat = 20
        static let roundsSectionBottomPadding: CGFloat = 10
        static let gamesSectionBottomPadding: CGFloat = 10
        static let sectionSpacing: CGFloat = 20
    }

    var body: some View {
        ZStack {
            Color.basicBackground
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HeaderView()
                if viewModel.bestGames.isEmpty && viewModel.bestRound == nil {
                    EmptyLeaderboardView()
                } else {
                    VStack {
                        if viewModel.bestRound != nil {
                            BestRoundsSection()
                                .padding(.top, 5)
                        }
                        if !viewModel.bestGames.isEmpty {
                            BestGamesSection()
                                .padding(.top, DrawingConstants.gamesSectionTopPadding)
                                .frame(maxHeight: .infinity)
                                .layoutPriority(0.1)
                        }
                    }
                    .padding(.bottom, DrawingConstants.roundsSectionBottomPadding)
                    .padding(.horizontal, 21)
                }
            }
        }
    }

    private func HeaderView() -> some View {
        ToolBarView(
            showBackButton: true,
            backButtonAction: { viewModel.dismissLeaderboard() },
            title: Resources.Text.leaderboard.localized(language)
        )
        .padding(.horizontal)
        .padding(.bottom, DrawingConstants.headerBottomPadding)
    }

    private func BestRoundsSection() -> some View {
        VStack(spacing: DrawingConstants.roundsSectionBottomPadding) {
            if let bestRound = viewModel.bestRound {
                RoundRow(round: bestRound)
            }
        }
        .padding(.bottom, DrawingConstants.roundsSectionBottomPadding)
    }

    private func BestGamesSection() -> some View {
        ShadowedCardView {
                VStack(spacing: DrawingConstants.gamesSectionBottomPadding) {
                    Text(Resources.Text.bestGames.localized(language))
                        .font(.headline)
                        .foregroundStyle(.basicBlack)
                        .padding(.vertical)
                    ScrollView {
                        ForEach(0..<viewModel.bestGames.count, id: \.self) { index in
                            GameRow(game: viewModel.bestGames[index], rank: index + 1)
                        }
                    }
                    .padding(.bottom, DrawingConstants.gamesSectionBottomPadding)
                }
            
            
        }
    }
}

#Preview {
    LeaderboardView(viewModel: LeaderboardViewModel(coordinator: Coordinator()))
}
