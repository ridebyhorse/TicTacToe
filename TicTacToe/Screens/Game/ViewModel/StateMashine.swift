

//
//  StateMashine.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 17.10.2024.
//

// MARK: - StateMachine Class (Game State)
final class StateMashine {
    // MARK: - Properties
    let timerManager: TimerManager
    let gameManager: GameManager
    
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
    
    var currentState: State = .startGame
    
    // MARK: - Computed Properties

    var isGameOver: Bool {
        return gameManager.isGameOver || gameResult != nil || currentState == .gameOver
    }
    
    // MARK: - State and Event Enums
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
    
    // MARK: - Initializer
    init(timerManager: TimerManager, gameManager: GameManager, userManager: UserManager, gameMode: GameMode, player: Player, opponent: Player, level: DifficultyLevel) {
        self.timerManager = timerManager
        self.gameManager = gameManager
        self.gameMode = gameMode
        self.player = player
        self.opponent = opponent
        self.level = level
    }
    
    // MARK: - Game Reset Methods
    func resetGame() {
        gameResult = nil
        winningPattern = nil
        boardBlocked = false
        timerManager.startTimer()
    }
    
    func recordRoundResult() {
        let resultString = "\(player.name) : \(player.score) - \(opponent.name) : \(opponent.score) (Duration: \(totalGameDuration) seconds)"
        roundResults.append(resultString)
    }
    
    // MARK: - Reducer Logic
    func reduce(state: State, event: GameEvent) -> State {
        currentState = state
        print("Current state: \(currentState), event: \(event)")
        
        switch (state, event) {
        case (.startGame, .refresh):
            gameManager.resetGame()
            timerManager.startTimer()
            self.secondsCount = timerManager.secondsCount
            self.resetGame()
            
            if opponent.isActive && opponent.isAI {
                return reduce(state: .play, event: .moveAI)
            } else {
                return .play
            }
            
        case (.play, .move(let position)):
            guard !isGameOver else { return .gameOver }
            
            gameManager.makeMove(at: position, for: player.isActive ? player : opponent)
            
            return isGameOver
            ? reduce(state: state, event: .gameOver(
                gameManager.getGameResult(
                    player: player,
                    opponent: opponent
                    )
                )
            )
            : reduce(state: state, event: .toggleActivePlayer)
            
        case (.play, .moveAI):
            guard !isGameOver else { return .gameOver }
            guard gameMode == .singlePlayer else { return .play }
            
            if opponent.isAI && !player.isAI {
                boardBlocked = true
                gameManager.aiMove(for: opponent, against: player, difficulty: level)
            }
            return isGameOver
            ? reduce(
                state: state,
                event: .gameOver(
                    gameManager.getGameResult(
                        player: player,
                        opponent: opponent
                    )
                )
            )
            : reduce(state: state, event: .toggleActivePlayer)
            
        case (.play, .toggleActivePlayer):
            boardBlocked = false
            
            player.isActive.toggle()
            opponent.isActive = !player.isActive
           
            if opponent.isAI && opponent.isActive {
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
            return currentState
        }
    }
    
    // MARK: - Finish Game Logic
    private func finishGame(with result: GameResult) {
        timerManager.stopTimer()
        currentState = .gameOver
        gameResult = result
        boardBlocked = true
        if gameResult != .draw {
            winningPattern = gameManager.getWinningPattern()
        }

    }
}
