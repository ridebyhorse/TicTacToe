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
    
    @Published var isSelectedDuration: Bool
    @Published var isSelectedMusic: Bool
    
    @Published var raundDuration: Int = 0 {
        didSet {
            updateDuration()
        }
    }
    
    private let coordinator: Coordinator
    private let storageManager: StorageManager
    private var gameSettings: GameSettings

    // MARK: Initialization
    init(storageManager: StorageManager = .shared, coordinator: Coordinator) {
        self.storageManager = storageManager
        self.coordinator = coordinator
        self.gameSettings = storageManager.getSettings()

        self.selectedIndex = gameSettings.selectedStyle ?? .crossFilledPurpleCircleFilledPurple
        self.isSelectedDuration = gameSettings.isSelectedDuration
        self.selectedDuration = gameSettings.duration
        self.isSelectedMusic = gameSettings.isSelecttedMusic
        self.selectedMusic = gameSettings.musicStyle
        self.selectedLevel = gameSettings.level
        self.selectedPlayerSymbol = gameSettings.playerSymbol ?? .cross
    }

    // MARK: Methods
    func updateDuration() {
        if isSelectedDuration {
            selectedDuration = .value
        } else {
            selectedDuration = .none
            raundDuration = 0
        }
    }
    
    func saveSettings() {
        gameSettings = GameSettings(
            level: selectedLevel,
            isSelectedDuration: isSelectedDuration,
            duration: selectedDuration,
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
        selectedPlayerSymbol = defaultSettings.playerSymbol ?? .cross
        raundDuration = (defaultSettings.duration == .value) ? 60 : 0
        saveSettings()
    }
    
    // MARK: - NavigationState
    func dissmisSettings() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
}
