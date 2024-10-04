//
//  SettingsViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    // MARK: Properties
    @Published var selectedIndex: PlayerStyle
    @Published var selectedDuration: Duration
    @Published var selectedMusic: MusicStyle
    @Published var selectedLevel: DifficultyLevel
    @Published var selectedPlayerSymbol: PlayerSymbol
    
    private let coordinator: Coordinator
    private let storageManager: StorageManager
    private var gameSettings: GameSettings

    // MARK: Initialization
    init(storageManager: StorageManager = .shared, coordinator: Coordinator) {
        self.storageManager = storageManager
        self.coordinator = coordinator

        self.gameSettings = storageManager.getSettings()
        
        self.selectedIndex = gameSettings.selectedStyle
        self.selectedDuration = gameSettings.duration
        self.selectedMusic = gameSettings.musicStyle
        self.selectedLevel = gameSettings.level
        self.selectedPlayerSymbol = gameSettings.playerSymbol
    }

    // MARK: Methods
    func saveSettings() {
        gameSettings = GameSettings(
            level: selectedLevel,
            duration: selectedDuration,
            selectedStyle: selectedIndex,
            musicStyle: selectedMusic,
            playerSymbol: selectedPlayerSymbol
        )
        storageManager.saveSettings(gameSettings)
    }

    func resetToDefault() {
        let defaultSettings = GameSettings.defaultGameSettings()
        selectedIndex = defaultSettings.selectedStyle
        selectedDuration = defaultSettings.duration
        selectedMusic = defaultSettings.musicStyle
        selectedLevel = defaultSettings.level
        selectedPlayerSymbol = defaultSettings.playerSymbol
        saveSettings()
    }
    
    // MARK: - NavigationState
    func dissmisSettings() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}
