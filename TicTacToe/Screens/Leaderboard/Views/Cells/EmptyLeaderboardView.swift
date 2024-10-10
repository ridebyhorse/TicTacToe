//
//  EmptyLeaderboardView.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//


import SwiftUI

struct EmptyLeaderboardView: View {
    var body: some View {
        VStack {
            Spacer()
            Text(Resources.Text.leaderboardEmptyMessage)
                .font(.basicTitle)
                .foregroundStyle(.basicBlack)
            Image(.emptyLeaderboard)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 106)
            Spacer()
        }
    }
}