//
//  SettingModel.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 02.10.2024.
//

import Foundation

import Foundation

struct GameSettings: Codable {
    let level: DifficultyLevel
    let isSelectedDuration: Bool
    let duration: Duration
    let selectedStyle: PlayerStyle?
    let isSelecttedMusic: Bool
    let musicStyle: MusicStyle
    let playerSymbol: PlayerSymbol?
}

enum PlayerSymbol: String, Codable {
    case cross
    case circle
}

enum Duration: Int, Codable, CaseIterable {
    case none
    case value
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

enum PlayerStyle: Codable, CaseIterable {
    case crossPinkCirclePurple
    case crossYellowCircleGreen
    case crossFilledPurpleCircleFilledPurple
    case starPurpleHeartPink
    case cakeIcecream
    case burgerFries
    
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

extension GameSettings {
    static func defaultGameSettings() -> GameSettings {
        return GameSettings(
            level: .normal,
            isSelectedDuration: false,
            duration: .none,
            selectedStyle: .crossPinkCirclePurple,
            isSelecttedMusic: false,
            musicStyle: .none,
            playerSymbol: .cross
        )
    }
}
