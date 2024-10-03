//
//  SettingsViewModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import Foundation

import Foundation

final class SettingsViewModel: ObservableObject {
    // MARK: Properties
    @Published var selectedIndex: PlayerStyle
    @Published var selectedDuration: Duration
    @Published var selectedMusic: MusicStyle
    @Published var selectedLevel: DifficultyLevel
    @Published var singlePlayerName: String
    @Published var playerOneName: String
    @Published var playerTwoName: String
    @Published var selectedGameMode: String
    @Published var selectedSymbol: String
    @Published var secondPlayerSymbol: String
    
    
    
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
        self.singlePlayerName = UserDefaults.standard.string(forKey: "singlePlayerName") ?? ""
        self.playerOneName = UserDefaults.standard.string(forKey: "playerOneName") ?? ""
        self.playerTwoName = UserDefaults.standard.string(forKey: "playerTwoName") ?? ""
        self.selectedGameMode = UserDefaults.standard.string(forKey: "selectedGameMode") ?? "Standard"
        self.selectedSymbol = UserDefaults.standard.string(forKey: "selectedSymbol") ?? "cross"
        self.secondPlayerSymbol = UserDefaults.standard.string(forKey: "secondPlayerSymbol") ?? "circle"
    }
    
    

    
    func updateGameMode(_ mode: String) {
        selectedGameMode = mode
        UserDefaults.standard.set(mode, forKey: "selectedGameMode")
    }


    func updateSymbol(_ symbol: String) {
        selectedSymbol = symbol
        UserDefaults.standard.set(symbol, forKey: "selectedSymbol")
    }
    func updateSecondPlayerSymbol(_ symbol: String) {
        secondPlayerSymbol = symbol
        UserDefaults.standard.set(symbol, forKey: "secondPlayerSymbol")
    }

    
    // MARK: Methods
    func saveSettings() {
        gameSettings = GameSettings(
            level: selectedLevel,
            duration: selectedDuration,
            selectedStyle: selectedIndex,
            musicStyle: selectedMusic,
            singlePlayerName: singlePlayerName,
            playerOneName: playerOneName,
            playerTwoName: playerTwoName
        )
        storageManager.saveSettings(gameSettings)
        UserDefaults.standard.set(singlePlayerName, forKey: "singlePlayerName")
        UserDefaults.standard.set(playerOneName, forKey: "playerOneName")
        UserDefaults.standard.set(playerTwoName, forKey: "playerTwoName")
        UserDefaults.standard.set(selectedGameMode, forKey: "selectedGameMode")
        UserDefaults.standard.set(selectedSymbol, forKey: "selectedSymbol")
        UserDefaults.standard.set(secondPlayerSymbol, forKey: "secondPlayerSymbol")
    }

    func resetToDefault() {
        let defaultSettings = GameSettings.defaultGameSettings()
        selectedIndex = defaultSettings.selectedStyle
        selectedDuration = defaultSettings.duration
        selectedMusic = defaultSettings.musicStyle
        selectedLevel = defaultSettings.level
        
        singlePlayerName = ""
        playerOneName = ""
        playerTwoName = ""
        selectedGameMode = "Standard"
        selectedSymbol = "cross"
        saveSettings()
    }
    //MARK: - Navigate to Start
    func startGame() {
        coordinator.updateNavigationState(action: .startGame)
    }
    //MARK: - Navigate to Settings
    func showSettings() {
        coordinator.updateNavigationState(action: .showSettings)
    }

    // MARK: - NavigationState
    func dissmisSettings() {
        coordinator.updateNavigationState(action: .showOnboarding)
    }
    

}
