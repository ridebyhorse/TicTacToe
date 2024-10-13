//
//  GameReducer.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//


// MARK: - GameAction Enum (Действия игры)
enum GameAction {
    case resetGame(currentPlayer: Player)
    case makeMove(currentPlayer: Player, position: Int, gameMode: GameMode, level: DifficultyLevel)
    case endGame(result: GameResult)
    case outOfTime
}

// MARK: - GameState Struct (Состояние игры)
struct GameState {
    var gameResult: GameResult? = nil
    var winningPattern: [Int]? = nil
    var player: Player
    var opponent: Player
    var secondsCount = 0
    var totalGameDuration = 0
    var roundResults: [String] = []
    var boardBlocked = false
    var isMusicPlaying = true
    var showResultScreen = false
    
    mutating func resetGame() {
        gameResult = nil
        winningPattern = nil
        boardBlocked = false
        showResultScreen = false
    }
    
    mutating func recordRoundResult() {
        let resultString = "\(player.name): \(player.score) - \(opponent.name): \(opponent.score) (Duration: \(totalGameDuration) seconds)"
        roundResults.append(resultString)
    }
}

// MARK: - Reducer
func gameReducer(
    action: GameAction,
    state: inout GameState,
    userManager: UserManager,
    gameManager: GameManager,
    musicManager: MusicManager,
    timerManager: TimerManager
) {
    switch action {
    case .resetGame(_):
        gameManager.resetGame()
        timerManager.startTimer()
        state.secondsCount = timerManager.secondsCount
        state.resetGame()
        
    case .makeMove(let currentPlayer, let position, let gameMode, let level):
        guard !state.boardBlocked else { return }
        // Make move for the active player
        
        switch gameMode {
        case .singlePlayer:
            if state.player.isActive {
                gameManager.makeMove(at: position, for: state.player)
                print("player")
            } else {
                gameManager.aiMove(for: state.opponent, against: state.player, difficulty: level)
                print("ai")
            }
        case .twoPlayer:
            gameManager.makeMove(at: position, for: currentPlayer)
        }
        if gameManager.isGameOver {
            let result = gameManager.getGameResult(gameMode: gameMode, player: state.player, opponent: state.opponent)
            state.totalGameDuration += state.secondsCount
            state.recordRoundResult()
            endGame(result: result, state: &state, userManager: userManager, gameManager: gameManager, musicManager: musicManager, timerManager: timerManager)
        } else {
            togglePlayer(state: &state)
        }
        
    case .endGame(let result):
        endGame(
            result: result,
            state: &state,
            userManager: userManager,
            gameManager: gameManager,
            musicManager: musicManager,
            timerManager: timerManager
        )
        
        
    case .outOfTime:
        timerManager.stopTimer()
        endGame(
            result: .draw,
            state: &state,
            userManager: userManager,
            gameManager: gameManager,
            musicManager: musicManager,
            timerManager: timerManager
        )
    }
}

// MARK: - Helper Methods for Game Logic
func endGame(
    result: GameResult,
    state: inout GameState,
    userManager: UserManager,
    gameManager: GameManager,
    musicManager: MusicManager,
    timerManager: TimerManager
) {
    musicManager.stopMusic()
    timerManager.stopTimer()
    
    if result != .draw {
        state.winningPattern = gameManager.getWinningPattern()
    }
    
    state.gameResult = result
    if let winner = gameManager.winner {
        if winner == state.player {
            userManager.updatePlayerScore()
        } else {
            userManager.updateOpponentScore()
        }
    }
    
    state.boardBlocked = true
    state.showResultScreen = true
}

func togglePlayer(state: inout GameState) {
    state.player.isActive.toggle()
    state.opponent.isActive.toggle()
}


