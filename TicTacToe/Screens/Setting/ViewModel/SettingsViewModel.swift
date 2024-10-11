//
//  SettingsViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation
import SwiftUI


final class SettingsViewModel: ObservableObject {
    // MARK: Properties
    @Published var selectedIndex: PlayerStyle
    @Published var selectedDuration: Duration
    @Published var selectedMusic: MusicStyle
    @Published var selectedLevel: DifficultyLevel
    @Published var selectedPlayerSymbol: PlayerSymbol
    @Published var hasAppliedTheme: Bool = false
    @Published var isSelectedMusic: Bool
    //UserTheme
    @AppStorage("user_theme") var userTheme: Theme = .systemDefaut {
          didSet {
              applyTheme()
          }
      }
    
    private let coordinator: Coordinator
    private let storageManager: StorageManager
    private var gameSettings: GameSettings
    var duration: Int {
        get {
            return selectedDuration.valueDuration ?? 0
        } set {
            selectedDuration.valueDuration = newValue
        }
    }
    
    // MARK: Initialization
    init(storageManager: StorageManager = .shared, coordinator: Coordinator) {
        self.storageManager = storageManager
        self.coordinator = coordinator
        self.gameSettings = storageManager.getSettings()

        self.selectedIndex = gameSettings.selectedStyle ?? .crossFilledPurpleCircleFilledPurple
        self.selectedDuration = gameSettings.duration
        self.isSelectedMusic = gameSettings.isSelecttedMusic
        self.selectedMusic = gameSettings.musicStyle
        self.selectedLevel = gameSettings.level
        self.selectedPlayerSymbol = gameSettings.playerSymbol ?? .tic
        // Theme apply
        applyTheme()
    }
    // Apply the selected theme to the app
     func applyTheme() {
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first {
            switch userTheme {
            case .light:
                window.overrideUserInterfaceStyle = .light
            case .dark:
                window.overrideUserInterfaceStyle = .dark
            default:
                window.overrideUserInterfaceStyle = .unspecified
            }
            
        }
         hasAppliedTheme = true
    }

    
    func saveSettings() {
        let duration = selectedDuration.isSelectedDuration
        ? selectedDuration
        : Duration(isSelectedDuration: false, valueDuration: nil)
        
        gameSettings = GameSettings(
            level: selectedLevel,
            duration: duration,
            selectedStyle: selectedIndex,
            isSelecttedMusic: isSelectedMusic,
            musicStyle: selectedMusic,
            playerSymbol: selectedPlayerSymbol
        )
        storageManager.saveSettings(gameSettings)
    }

    func resetToDefault() {
        let defaultSettings = GameSettings.defaultGameSettings()
        selectedIndex = defaultSettings.selectedStyle ?? .crossFilledPurpleCircleFilledPurple
        selectedDuration = defaultSettings.duration
        selectedMusic = defaultSettings.musicStyle
        selectedLevel = defaultSettings.level
        selectedPlayerSymbol = defaultSettings.playerSymbol ?? .tic
        saveSettings()
    }
    
    // MARK: - NavigationState
    func dissmisSettings() {
        coordinator.updateNavigationState(action: .backFromSettings)
    }
}
