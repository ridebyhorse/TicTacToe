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
    
    var body: some View {
        ZStack {
            Color.basicBackground
                .ignoresSafeArea()
            HStack{
                VStack {
                    
                    ToolBarView(
                        showBackButton: true,
                        backButtonAction: { viewModel.dismissLeaderboard() },
                        title: Resources.Text.leaderboard.localized(language)
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
                        ForEach(viewModel.gameResults) { gameResult in
                                               HStack(spacing: 12) {

                                                   ZStack {
                                                       Circle()
                                                           .fill(.secondaryPurple)
                                                           .frame(width: 45, height: 45)
                                                       
                                                       Text("\(viewModel.gameResults.firstIndex(where: { $0.id == gameResult.id })! + 1)")
                                                           .font(.number)
                                                           .foregroundStyle(.basicBlack)
                                                   }
                                                   ZStack {
                                                       RoundedRectangle(cornerRadius: 30)
                                                           .fill(.basicLightBlue)
                                                       Text(gameResult.player.name)
                                                       .font(.basicBody)
                                                           .foregroundStyle(.basicBlack)
                       //
                                                   }
                                                   .frame(maxWidth: .infinity)
                                                   .layoutPriority(0.1)
                                                   ZStack {
                                                       RoundedRectangle(cornerRadius: 30)
                                                           .fill(.basicBlue)
                                                       Text("\(gameResult.player.score)")
                                                           .font(.number)
                                                           .foregroundStyle(.white)
                                                   }
                                                   .layoutPriority(0)
                                                   .frame(minWidth: 75)
                                               }
                                           }
                                       }
                    //поставил снизу разделение где будет duration но к сожалению не сохраняет duration
//                                           VStack{
//                                               Divider()
//                                                       .padding(.vertical, 10)
//                                                                   HStack {
//                                                                       Text("Game Duration:")
//                                                                           .font(.basicBody)
//                                                                           .foregroundStyle(.basicBlack)
//                                                                       Spacer()
//                                                                       Text("\(viewModel.gameDuration)")
//                                                                           .font(.number)
//                                                                           .foregroundStyle(.basicBlack)
//                                                                   }
//                                           }
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
//                           let settingsViewModel = SettingsViewModel(coordinator: Coordinator())
//                           let leaderboardViewModel = LeaderboardViewModel(coordinator: Coordinator(), settingsViewModel: settingsViewModel)
//                           LeaderboardView(viewModel: leaderboardViewModel)
                           
    LeaderboardView(viewModel: LeaderboardViewModel(coordinator: Coordinator()))
                           
}
