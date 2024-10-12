//
//  GameReducer.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//


// MARK: - GameAction Enum (Действия игры)
enum GameAction {
    case makeMove(position: Int, gameMode: GameMode, level: DifficultyLevel)
    case resetGame
    case endGame(result: GameResult)
    case toggleMusic
    case outOfTime
}

// MARK: - GameState Struct (Состояние игры)
struct GameState {
    var gameBoard: [PlayerSymbol?]
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
    
    mutating func resetGame(firstMovePlayer: Player) {
        gameBoard = Array(repeating: nil, count: 9)
        gameResult = nil
        winningPattern = nil
        player.isActive = firstMovePlayer.symbol == player.symbol
        opponent.isActive = !player.isActive
        boardBlocked = false
        showResultScreen = false
    }

    mutating func recordRoundResult() {
        let resultString = "\(player.name): \(player.score) - \(opponent.name): \(opponent.score) (Duration: \(totalGameDuration) seconds)"
        roundResults.append(resultString)
    }
}

// MARK: - Reducer (Редьюсер для обработки действий и изменения состояния)
func gameReducer(
    action: GameAction,
    state: inout GameState,
    gameManager: GameManager,
    musicManager: MusicManager,
    timerManager: TimerManager
) {
    switch action {
    case .makeMove(let position, let gameMode, let level):
        guard !state.boardBlocked else { return }
        
        let currentPlayer = state.player.isActive ? state.player : state.opponent
        let opponentPlayer = currentPlayer == state.player ? state.opponent : state.player
        
        if gameManager.makeMove(at: position, player: currentPlayer, opponent: opponentPlayer, gameMode: gameMode, level: level  ) {
            if gameManager.isGameOver {
                let result = gameManager.getGameResult(gameMode: .singlePlayer, player: currentPlayer, opponent: opponentPlayer)
                state.totalGameDuration += state.secondsCount
                state.recordRoundResult()
                endGame(result: result, state: &state, gameManager: gameManager, musicManager: musicManager, timerManager: timerManager)
            } else {
                togglePlayer(state: &state)
            }
        }
        
    case .resetGame:
        gameManager.resetGame(firstPlayer: state.player, secondPlayer: state.opponent)
        timerManager.startTimer()
        state.secondsCount = timerManager.secondsCount
        state.resetGame(firstMovePlayer: Bool.random() ? state.player : state.opponent)
        
    case .endGame(let result):
        endGame(result: result, state: &state, gameManager: gameManager, musicManager: musicManager, timerManager: timerManager)
        
    case .toggleMusic:
        toggleMusic(state: &state, musicManager: musicManager)
        
    case .outOfTime:
        timerManager.stopTimer()
        endGame(result: .draw, state: &state, gameManager: gameManager, musicManager: musicManager, timerManager: timerManager)
    }
}

// MARK: - Helper Methods for Game Logic
func endGame(result: GameResult, state: inout GameState, gameManager: GameManager, musicManager: MusicManager, timerManager: TimerManager) {
    musicManager.stopMusic()
    timerManager.stopTimer()
    
    if result != .draw {
        state.winningPattern = gameManager.getWinningPattern()
    }

    state.gameResult = result
    if let winner = gameManager.winner {
        if winner == state.player {
            state.player.score += 1
        } else {
            state.opponent.score += 1
        }
    }
    
    state.boardBlocked = true
    state.showResultScreen = true
}

func togglePlayer(state: inout GameState) {
    state.player.isActive.toggle()
    state.opponent.isActive.toggle()
}

func toggleMusic(state: inout GameState, musicManager: MusicManager) {
    if state.isMusicPlaying {
        musicManager.stopMusic()
    } else {
        musicManager.playMusic()
    }
    state.isMusicPlaying.toggle()
}
