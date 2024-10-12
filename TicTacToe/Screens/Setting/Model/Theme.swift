//
//  Theme.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 12.10.2024.
//

import SwiftUI

enum Theme: String, CaseIterable {
    case systemDefaut = "system"
    case light = "light"
    case dark = "dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .systemDefaut:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
