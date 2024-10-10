//
//  LeaderboardViewModel.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 01.10.2024.
//

import Foundation

final class LeaderboardViewModel: ObservableObject {
    // MARK: Properties
      @Published var gameResults: [LeaderboardGameRound] = []
      private let coordinator: Coordinator
    // попытка получение данных с settingsViewModel
//      var settingsViewModel: SettingsViewModel
    
//      var gameDuration: String {
//              return "\(settingsViewModel.selectedDuration.valueDuration ?? 0) seconds"
//          }
          
     
      
      // MARK: Initialization
      init(coordinator: Coordinator /*settingsViewModel: SettingsViewModel*/) {
          self.coordinator = coordinator
//          self.settingsViewModel = settingsViewModel
          gameResults = StorageManager.shared.getLeaderboards()
          gameResults.sort(by: {$0.player.score > $1.player.score})
      }
    // попытка сохранить gameDuration
//      func saveLeaderboard(player: Player, opponent: Player) {
//             let gameDuration = "\(settingsViewModel.selectedDuration.valueDuration ?? 0) seconds"
//             
//             StorageManager.shared.saveUsersScore(
//                 player: player,
//                 opponent: opponent,
//                 gameScore: "\(player.score)",
//                 gameDuration: gameDuration
//             )
//         }
      
      //MARK: - NavigationState
      func dismissLeaderboard() {
          coordinator.updateNavigationState(action: .showOnboarding)
      }
  }

