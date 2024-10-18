

//
//  StateMashine.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 17.10.2024.
//

// MARK: - StateMachine Class (Game State)
final class StateMachine {
    // MARK: - Properties

    private let gameManager: GameManager = .shared
    
    var gameMode: GameMode
    var gameResult: GameResult? = nil
    var winningPattern: [Int]? = nil
    var player: Player
    var opponent: Player
    var isPlayerActive = Bool.random()
    var level: DifficultyLevel
    
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
        case boardBlocked
        case toggleActivePlayer
        case gameOver(_ result: GameResult)
        case outOfTime
    }
    
    // MARK: - Initializer
    init(player: Player, opponent: Player, level: DifficultyLevel, gameMode: GameMode) {
        self.player = player
        self.opponent = opponent
        self.level = level
        self.gameMode = gameMode
    }
    
    // MARK: - Game Reset Methods
    func resetGame() {
        gameManager.resetGame()

        player.isActive = isPlayerActive
        opponent.isActive = !player.isActive
        gameResult = nil
        winningPattern = nil
        boardBlocked = false
    }
    
    func recordRoundResult() {
        let resultString = "\(player.name) : \(player.score) - \(opponent.name) : \(opponent.score) (Duration: \(totalGameDuration) seconds)"
        roundResults.append(resultString)
    }
    
    // MARK: - Reducer Logic
    func reduce(state: State, event: GameEvent) -> State {
        currentState = state
        
        switch (state, event) {
        case (.startGame, .refresh):

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
            ? reduce(state: .gameOver, event: .gameOver(
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
            
            if opponent.isAI && !player.isAI && opponent.isActive {
                boardBlocked = true
                if gameManager.aiMove(for: opponent, against: player, difficulty: level) {
                    
                    return isGameOver
                    ? reduce(
                        state: .gameOver,
                        event: .gameOver(
                            gameManager.getGameResult(
                                player: player,
                                opponent: opponent
                            )
                        )
                    )
                    : reduce(state: state, event: .toggleActivePlayer)
                }
            }
            return .play
        case (.play, .toggleActivePlayer):
            player.isActive.toggle()
            opponent.isActive = !player.isActive
            boardBlocked = false
            
            if opponent.isAI && opponent.isActive {
                return reduce(state: .play, event: .moveAI)
            } else {
                return .play
            }
            
        case (.play, .outOfTime):
            finishGame(with: .draw)
            return .gameOver
            
        case (.gameOver, .gameOver(let result)):
            finishGame(with: result)
            return .gameOver
            
        default:
            return currentState
        }
    }
    
    // MARK: - Finish Game Logic
    private func finishGame(with result: GameResult) {

        winningPattern = gameManager.getWinningPattern()
        gameResult = result
        boardBlocked = true
        }
    

}
