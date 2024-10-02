//
//  Untitled.swift
//  TicTacToe
//
//  Created by Ylyas Abdywahytow on 10/1/24.
//

import Foundation
import SwiftUI


final class GameSelectViewModel: ObservableObject {
    // MARK: Properties
    @AppStorage("singlePlayerName") var singlePlayerName: String = ""
    @AppStorage("playerOneName") var playerOneName: String = ""
    @AppStorage("playerTwoName") var playerTwoName: String = ""
    
    @Published var selectedGameMode: String = UserDefaults.standard.string(forKey: "selectedGameMode") ?? "Standard"
    @Published var selectedSymbol: String = UserDefaults.standard.string(forKey: "selectedSymbol") ?? "cross"
    
    func updateGameMode(_ mode: String) {
        selectedGameMode = mode
        UserDefaults.standard.set(mode, forKey: "selectedGameMode")
    }


    func updateSymbol(_ symbol: String) {
        selectedSymbol = symbol
        UserDefaults.standard.set(symbol, forKey: "selectedSymbol")
    }
    
    
    private let coordinator: Coordinator
  
    
    // MARK: Initialization
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
        


    //MARK: - NavigationState
    
}

