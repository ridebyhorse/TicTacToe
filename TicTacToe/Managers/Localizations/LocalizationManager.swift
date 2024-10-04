//
//  LocalizationManager.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 30.09.2024.
//

import SwiftUI

// MARK: - Language Enum
// Enum representing supported languages, conforming to CaseIterable and Identifiable protocols
enum Language: String, CaseIterable, Codable, Identifiable {
    var id: String { self.rawValue }  // Identifier for each language case
    case ru = "ru"  // Russian
    case en = "en"  // English
}

// MARK: - LocalizationService
// A service class responsible for managing the app's language settings
final class LocalizationService {
    
    // MARK: - Properties
    // Singleton instance of LocalizationService
    public static let shared = LocalizationService()
    
    // The currently selected language
    var language: Language {
        get {
            // Retrieves the selected language from UserDefaults, or defaults to English if not set
            guard let languageString = UserDefaults.standard.string(forKey: "selectedLanguage") else {
                saveLanguage(.en)
                return .en
            }
            
            // Returns the stored language or defaults to English if the value is invalid
            return Language(rawValue: languageString) ?? .en
        }
        set {
            // Updates the language if it has changed
            if newValue != language {
                saveLanguage(newValue)
            }
        }
    }
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Methods
    // Saves the selected language to UserDefaults and updates the system language setting
    private func saveLanguage(_ language: Language) {
        UserDefaults.standard.setValue(language.rawValue, forKey: "selectedLanguage")
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
    }
}
