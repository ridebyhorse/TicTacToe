//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 29.09.2024.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @State private var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LaunchScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                CoordinatorView()
            }
        }
    }
}
