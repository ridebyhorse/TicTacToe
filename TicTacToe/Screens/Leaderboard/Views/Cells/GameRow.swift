//
//  GameRow.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//

import SwiftUI

struct GameRow: View {
    enum DrawingConstants {
        static let circleSize: CGFloat = 38
    }
    
    let game: LeaderboardGame
    let rank: Int
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: game.date)
    }
    
    var body: some View {
        
        LightBlueBackgroundView {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.secondaryPurple)
                        .frame(width: DrawingConstants.circleSize, height: DrawingConstants.circleSize)
                    Text("\(rank)")
                        .font(.number)
                        .foregroundStyle(.basicBlack)
                }
                HStack {
                    HStack(spacing: 4) {
                        Image(game.player.symbol ==
                            .tic ? game.player.style.imageNames.player1
                              : game.player.style.imageNames.player2)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                        .padding(.leading, 4)
                        Text(game.player.name)
                            .font(.basicSubtitle)
                            .foregroundStyle(.basicBlack)
                            .multilineTextAlignment(.center)
                        Text(" / ")
                            .font(.basicSubtitle)
                            .foregroundStyle(.basicBlack)
                            .multilineTextAlignment(.center)
                        Image(game.opponent.symbol ==
                            .tic ? game.player.style.imageNames.player1
                              : game.player.style.imageNames.player2)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                        .padding(.leading, 4)
                        Text(game.opponent.name)
                            .font(.basicSubtitle)
                            .foregroundStyle(.basicBlack)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                    VStack {
                        Text("\(game.score)")
                            .font(.basicSubtitle)
                            .padding(.horizontal, 4)
                            .foregroundStyle(.basicBlack)
                        Text("\(formattedDate)")
                            .font(.caption)
                            .padding(.horizontal, 4)
                            .foregroundStyle(.basicBlue)
                    }
                }
            }
            .layoutPriority(0.1)
        }
    }
}
