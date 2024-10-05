//
//  Resources.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 29.09.2024.
//

import Foundation

enum Resources {
    enum Text {
        static let selectGame = "Select Game"
        static let singlePlayer = "Single Player"
        static let twoPlayers = "Two Players"
        static let next = "Next"
        static let enterYourName = "Enter your name"
        static let enterYourNameAlert = "Please enter your name"
        static let player1Name = "Player 1 Name"
        static let player2Name = "Player 2 Name"
        static let ai = "AI"
        static let choose = "Choose"
        static let picked = "Picked"
        static let you = "You"
        static let settings = "Settings"
        static let howToPlay = "How to Play"
        static let ticTacToe = "TIC-TAC-TOE"
        static let letsPlay = "Let's play"
        static let winResult = " Win!"
        static let loseResult = "You lose!"
        static let drawResult = "Draw!"
        static let playAgain = "Play again"
        static let back = "Back"
        static let leaderboard = "Leaderboard"
        static let rulesNavigationTitle = "How to play"
        static let rule1 = "Draw a grid with three rows and three columns, creating nine squares in total."
        static let rule2 = "Players take turns placing their marker (X or O) in an empty square. To make a move, a player selects a number corresponding to the square where they want to place their marker."
        static let rule3 = "Player X starts by choosing a square (e.g., square 5). Player O follows by choosing an empty square (e.g., square 1). Continue alternating turns until the game ends."
        static let rule4 = "The first player to align three of their markers horizontally, vertically, or diagonally wins.Examples of Winning Combinations: Horizontal: Squares 1, 2, 3 or 4, 5, 6 or 7, 8, 9. Vertical: Squares 1, 4, 7 or 2, 5, 8 or 3, 6, 9.Diagonal: Squares 1, 5, 9 or 3, 5, 7."
        static let leaderboardEmptyMessage = "No game history"
        
        static let turnOnTime = "Time:"
        static let selectMusicStyle = "Music:"
        static let selectDifficultyLevel = "Difficulty:"
        static let selectPlayerStyle = "Player Style:"
        static let selectedLanguage = "Language:"
        static let time = "Time"
        static let selectSymbol = "Select Your Symbol:"
    }
    
    enum Image {
        static let arrowLeft = "arrowshape.backward.circle"
    }
}
