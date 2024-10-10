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
            VStack {
                HeaderView()
                if viewModel.bestGames.isEmpty && viewModel.bestRound == nil {
                    EmptyLeaderboardView()
                } else {
                    VStack {
                        BestRoundsSection()
                            .padding(.top, DrawingConstants.roundsSectionTopPadding)
                        
                        BestGamesSection()
                            .padding(.top, DrawingConstants.gamesSectionTopPadding)
                    }
                    .padding(.bottom, DrawingConstants.roundsSectionBottomPadding)
                }
            }
            .padding(.horizontal)
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
            ScrollView {
                VStack(spacing: DrawingConstants.gamesSectionBottomPadding) {
                    Text(Resources.Text.bestGames.localized(language))
                        .font(.headline)
                        .padding(.vertical)
                    
                    ForEach(viewModel.bestGames, id: \.id) { game in
                        GameRow(game: game, rank: viewModel.bestGames.firstIndex(where: { $0.player == game.player })! + 1)
                    }
                }
            }
            .padding(.bottom, DrawingConstants.gamesSectionBottomPadding)
        }
    }
}
