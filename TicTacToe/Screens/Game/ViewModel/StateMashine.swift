//
//  StateMashine.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 17.10.2024.
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
        return gameManager.isGameOver || gameResult != nil || currentState == .gameOver
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
        case outOfTime
    }
    
    mutating func resetGame() {
        gameResult = nil
        winningPattern = nil
        boardBlocked = false
        timerManager.stopTimer()
    }
    
    mutating func recordRoundResult() {
        let resultString = "\(player.name) : \(player.score) - \(opponent.name) : \(opponent.score) (Duration: \(totalGameDuration) seconds)"
        roundResults.append(resultString)
    }
    
    
    // MARK: - Reducer
    mutating func reduce(state: State, event: GameEvent) -> State {
        let state = state
        print("Текущее состояние: \(state), событие: \(event)")
        
        switch (state, event) {
        case (.startGame, .refresh):
            gameManager.resetGame()
            timerManager.startTimer()
            self.secondsCount = timerManager.secondsCount
            self.resetGame()
            return .play
            
        case (.play, .move(let position)):
            guard !isGameOver else { return .gameOver }
            if currentPlayer.isAI {
                reduce(state: state, event: .moveAI)
            } else {
                gameManager.makeMove(at: position, for: currentPlayer)
            }
            return isGameOver
            ? reduce(state: state, event: .gameOver(
                gameManager.getGameResult(
                    gameMode: gameMode,
                    player: player,
                    opponent: opponent
                )
            )
            )
            : reduce(state: state, event: .toggleActivePlayer)
            
        case (.play, .moveAI):
            guard !isGameOver else { return .gameOver }
            gameManager.aiMove(for: opponent, against: player, difficulty: level)
            return isGameOver
            ? reduce(
                state: state,
                event: .gameOver(
                    gameManager.getGameResult(
                        gameMode: gameMode,
                        player: player,
                        opponent: opponent
                    )
                )
            )
            : reduce(state: state, event: .toggleActivePlayer)
            
        case (.play, .toggleActivePlayer):
            player.isActive.toggle()
            opponent.isActive = !player.isActive
        
            if currentPlayer.isAI {
                return reduce(state: .play, event: .moveAI)
            } else {
                return .play
            }
            
        case (.gameOver, .gameOver(let result)):
            finishGame(with: result)
            return .gameOver
            
        case (.gameOver, .outOfTime):
            finishGame(with: .draw)
            return .gameOver
            
        default:
            return state
        }
    }
    
    private mutating func finishGame(with result: GameResult) {
        musicManager.stopMusic()
        timerManager.stopTimer()
        gameResult = result
        boardBlocked = true
        if result != .draw {
            winningPattern = gameManager.getWinningPattern()
        }
        if let winner = gameManager.winner {
            winner == player
            ? userManager.updatePlayerScore()
            : userManager.updateOpponentScore()
        }
    }
}
