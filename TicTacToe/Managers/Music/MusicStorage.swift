//
//  MusicStorage.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 02.10.2024.
//

import Foundation

enum SoundState {
    case moveUser1
    case moveUser2
    case final
}

struct MusicStorage {
    static func getMusicFor(_ style: MusicStyle) -> URL? {
        switch style {
        case .none:
            return nil
        case .classical:
            return Bundle.main.url(forResource: "classic", withExtension: "mp3")
        case .instrumentals:
            return Bundle.main.url(forResource: "instrumental", withExtension: "mp3")
        case .nature:
            return Bundle.main.url(forResource: "nature", withExtension: "mp3")
        }
    }
    
    static func getSoundFor(_ state: SoundState) -> URL? {
        switch state {
        case .moveUser1:
            return Bundle.main.url(forResource: "move1", withExtension: "mp3")
        case .moveUser2:
            return Bundle.main.url(forResource: "move2", withExtension: "mp3")
        case .final:
            return Bundle.main.url(forResource: "final", withExtension: "mp3")
        }
    }
}
