//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Мария Нестерова on 29.09.2024.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : Font.navigationTitle
        ]
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
        }
    }
}
