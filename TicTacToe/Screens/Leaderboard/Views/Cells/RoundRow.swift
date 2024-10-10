//
//  RoundRow.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//

import SwiftUI

struct RoundRow: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    let round: LeaderboardRound
    let rank = 1
    
    struct DrawingConstants {
        static let circleSize: CGFloat = 45
        static let padding: CGFloat = 12
        static let textPadding: CGFloat = 4
    }
    
    var body: some View {
        ShadowedCardView {
            VStack {
                Text(Resources.Text.bestRounds.localized(language))
                    .font(.headline)
                    .padding(.vertical)
                
                HStack(spacing: DrawingConstants.padding) {

                    ZStack {
                        Circle()
                            .fill(Color.secondaryPurple)
                            .frame(width: DrawingConstants.circleSize, height: DrawingConstants.circleSize)
                        Text("\(rank)")
                            .font(.number)
                            .foregroundStyle(.basicBlack)
                    }
                    
                    LightBlueBackgroundView {
                        HStack {
                      
                            Text(round.player.name)
                                .font(.basicBody)
                                .foregroundStyle(.basicBlack)
                                .padding(.leading, DrawingConstants.textPadding)
                            
                            Spacer()
                            

                            Text("\(Resources.Text.time.localized(language)): \(round.durationRound)")
                                .font(.number)
                                .foregroundStyle(.basicBlack)
                                .padding(.trailing, DrawingConstants.textPadding)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                }
               
            }
        }
    }
}
