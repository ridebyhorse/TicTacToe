//
//  GameRow.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//

import SwiftUI

struct GameRow: View {
    
    let game: LeaderboardGame
    let rank: Int
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: game.date)
    }
    
    var body: some View {

        LightBlueBackgroundView {
            HStack {
                Text("\(rank)")
                    .font(.number)
                    .frame(width: 30, alignment: .leading)
                
                Text(game.player.name)
                    .font(.basicBody)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(game.score) : \(game.opponent.name)")
                    .font(.number)
                
                Text(formattedDate)
                    .font(.basicBody)
            }
            .padding()
        }
    }
}


