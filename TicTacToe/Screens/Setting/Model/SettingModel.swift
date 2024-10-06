//
//  SettingModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import Foundation

struct GameSettings: Codable {
    let level: DifficultyLevel
    let duration: Duration
    let selectedStyle: PlayerStyle
    let musicStyle: MusicStyle
    let playerSymbol: PlayerSymbol
}

enum PlayerSymbol: String, Codable {
    case cross
    case circle
}

enum Duration: String, Codable, CaseIterable {
    case none = "none"
    case fast = "30 sec"
    case normal = "60 sec"
    case long = "120 sec"
}

enum MusicStyle: String, Codable, CaseIterable {
    case none
    case classical
    case instrumentals
    case nature
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case easy
    case normal
    case hard
}

// Перечисление для стилей игроков
enum PlayerStyle: Codable, CaseIterable {
    case crossPinkCirclePurple
    case crossYellowCircleGreen
    case crossFilledPurpleCircleFilledPurple
    case starPurpleHeartPink
    case cakeIcecream
    case burgerFries

    // Возвращает изображение для каждого стиля (для игрока 1 и игрока 2)
    var imageNames: (player1: String, player2: String) {
        switch self {
        case .crossPinkCirclePurple:
            return ("crossPink", "circlePurple")
        case .crossYellowCircleGreen:
            return ("crossYellow", "circleGreen")
        case .crossFilledPurpleCircleFilledPurple:
            return ("crossFilledPurple", "circleFilledPurple")
        case .starPurpleHeartPink:
            return ("starPurple", "heartPink")
        case .cakeIcecream:
            return ("cake", "icecream")
        case .burgerFries:
            return ("burger", "fries")
        }
    }
}

// Расширение для создания настроек по умолчанию
extension GameSettings {
    static func defaultGameSettings() -> GameSettings {
        let settings = GameSettings(
            level: .normal,
            duration: .none,
            selectedStyle: .crossPinkCirclePurple,
            musicStyle: .none, 
            playerSymbol: .cross
        )
        return settings
    }
}
