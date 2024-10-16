//
//  GameReducer.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//

// MARK: - GameState Struct (Состояние игры)
struct StateMashine {
    let timerManager: TimerManager
    let gameManager: GameManager
    let userManager: UserManager
    let musicManager: MusicManager
    
    var gameMode: GameMode
    var gameResult: GameResult? = nil
    var winningPattern: [Int]? = nil
    var player: Player
    var opponent: Player
    var level: DifficultyLevel
    var secondsCount = 0
    var totalGameDuration = 0
    var roundResults: [String] = []
    var boardBlocked = false
    var isMusicPlaying = true
    var currentState: State = .startGame
    var currentPlayer: Player {
        player.isActive ? player : opponent
    }
    
    var isGameOver: Bool {
        return gameResult != nil || currentState == .gameOver
    }
    
    enum State {
        case startGame
        case play
        case gameOver
    }
    
    enum GameEvent {
        case refresh
        case move(_ position: Int)
        case moveAI
        case toggleActivePlayer
        case gameOver(_ result: GameResult)
        case handleOutOfTime
    }
    
    mutating func resetGame() {
        gameResult = nil
        winningPattern = nil
        boardBlocked = false
        timerManager.stopTimer()
    }
    
    mutating func recordRoundResult() {
        let resultString = "\(player.name): \(player.score) - \(opponent.name): \(opponent.score) (Duration: \(totalGameDuration) seconds)"
        roundResults.append(resultString)
    }
    
    
    // MARK: - Reducer
    mutating func reduce(state: State, event: GameEvent) -> State {
        var state = state
        
        switch state {
            
        case .startGame:
            switch event {
            case .refresh:
                gameManager.resetGame()
                timerManager.startTimer()
                self.secondsCount = timerManager.secondsCount
                self.resetGame()
                state = .play
            default:
                return state
            }
            
        case .play:
            switch event {
            case .move(position: let position):
                guard !boardBlocked else { return .gameOver }
                
                gameManager.makeMove(at: position, for: currentPlayer)
             
            case .moveAI:
                guard !boardBlocked else { return .gameOver }
                
                gameManager.aiMove(for: opponent, against: player, difficulty: level)
                
            case .toggleActivePlayer:
                player.isActive.toggle()
                opponent.isActive = !player.isActive
                
            default:
                return state
            }
        case .gameOver:
            
            switch event {
                
            case .gameOver(result: let result):
                musicManager.stopMusic()
                timerManager.stopTimer()
                
                if result != .draw {
                    winningPattern = gameManager.getWinningPattern()
                }
                
                gameResult = result
                if let winner = gameManager.winner {
                    if winner == player {
                        userManager.updatePlayerScore()
                    } else {
                        userManager.updateOpponentScore()
                    }
                }
                boardBlocked = true
                
            case .handleOutOfTime:
                musicManager.stopMusic()
                timerManager.stopTimer()
                
                boardBlocked = true
                gameResult = .draw
            default:
                return state
            }
        }
        return state
    }
}
