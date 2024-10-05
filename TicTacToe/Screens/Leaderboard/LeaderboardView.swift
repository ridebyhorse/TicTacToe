//
//  LeaderboardView.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 01.10.2024.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var viewModel: LeaderboardViewModel
    
    var body: some View {
        ZStack {
            Color.basicBackground
                .ignoresSafeArea()
            HStack{
                VStack {
                    
                    ToolBarView(
                        showBackButton: true,
                        backButtonAction: { viewModel.dismissLeaderboard() },
                        title: Resources.Text.leaderboard
                    )
                    
                    .padding(.horizontal)
                    .padding(.bottom,20 )
                   
                    //            Text(Resources.Text.leaderboardNavigationTitle)
                    //                .font(.navigationTitle)
                    //                .foregroundStyle(.basicBlack)
                    //                .padding(.trailing, 30)
                    Spacer()
                    
                }
            }
            Spacer().padding()
            .padding(.horizontal, 21)
            .padding(.top, 8)
            if viewModel.gameResults.isEmpty {
                EmptyLeaderboardView()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(0..<viewModel.gameResults.count, id: \.self) { index in
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(.secondaryPurple)
                                        .frame(width: 45, height: 45)
                                    Text("\(index + 1)")
                                        .font(.number)
                                        .foregroundStyle(.basicBlack)
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(.basicLightBlue)
                                    Text(viewModel.gameResults[index].name)
                                        .font(.basicBody)
                                        .foregroundStyle(.basicBlack)
                                       
                                }
                                .frame(maxWidth: .infinity)
                                .layoutPriority(0.1)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(.basicBlue)
                                    Text("\(viewModel.gameResults[index].score)")
                                        .font(.number)
                                        .foregroundStyle(.white)
                                        
                                }
                                .layoutPriority(0)
                                .frame(minWidth: 75)
                            }
                        }
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 21)
            }
            }
        }
    }
    
    private struct EmptyLeaderboardView: View {
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


#Preview {
    LeaderboardView(viewModel: LeaderboardViewModel(coordinator: Coordinator()))
}
