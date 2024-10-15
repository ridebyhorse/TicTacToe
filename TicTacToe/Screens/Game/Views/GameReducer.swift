//
//  GameReducer.swift
//  TicTacToe
//
//  Created by Келлер Дмитрий on 10.10.2024.
//


struct GameReducer {
    typealias Reducer = (GameState, GameAction) -> GameState

    // MARK: - Game State
    struct GameState {
        let gameManager: GameManager
        var gameResult: GameResult? = nil
        var gameMode: GameMode
        var winningPattern: [Int]? = nil
        var player: Player
        var opponent: Player
        var level: DifficultyLevel
        var secondsCount: Int = 0
        var isBoardBlocked: Bool = false
        var state: GameStateEnum = .idle
        
        var currentPlayer: Player {
            player.isActive ? player : opponent
        }

        var isGameOver: Bool {
            return gameResult != nil || state == .finished
        }
        
        enum GameStateEnum {
            case idle
            case playing
            case finished
        }
    }

    // MARK: - Game Actions
    enum GameAction {
        case startGame
        case resetGame
        case playerMove(Int)
        case aiMove
        case endGame(GameResult)
        case togglePlayer
        case updateTime(Int)
        case handleOutOfTime
    }

    // MARK: - Game Reducer Function
    static func reduce(_ state: GameState, _ action: GameAction) -> GameState {
        var state = state
        
        print("Получено действие: \(action)")
        
        switch action {
        case .startGame:
            return startGame(state)
            
        case .resetGame:
            return resetGame(state, state.gameManager)
            
        case .playerMove(let position):
            print("Ход игрока на позицию: \(position)")
            return handlePlayerMove(state, position, state.gameManager)
            
        case .aiMove:
            print("Ход ИИ")
            return handleAIMove(state, state.gameManager)
            
        case .endGame(let result):
            print("Игра завершена с результатом: \(result)")
            return handleEndGame(state, result)
            
        case .togglePlayer:
            print("Переключение игрока")
            return togglePlayer(state)
            
        case .updateTime(let seconds):
            print("Обновление времени: \(seconds) секунд")
            state.secondsCount = seconds
            return state
            
        case .handleOutOfTime:
            print("Время истекло, ничья")
            return handleOutOfTime(state)
        }
    }

    // MARK: - Private Helper Methods
    private static func startGame(_ state: GameState) -> GameState {
        var newState = state
        
        guard state.state == .idle else {
            print("Невозможно начать игру: текущий статус — \(state.state)")
            return newState
        }
        
        if state.gameMode == .singlePlayer && newState.opponent.isAI && newState.opponent.isActive {
            print("Начало игры, ИИ делает первый ход")
            return reduce(newState, .aiMove)
        }
        
        newState.state = .playing
        print("Игра началась")
        return newState
    }
    
    private static func resetGame(_ state: GameState, _ gameManager: GameManager) -> GameState {
        print("Сброс игры")
        gameManager.resetGame()
        
        return GameState(
            gameManager: gameManager,
            gameMode: state.gameMode,
            player: state.player,
            opponent: state.opponent,
            level: state.level
        )
    }

    private static func handlePlayerMove(_ state: GameState, _ position: Int, _ gameManager: GameManager) -> GameState {
        let newState = state
        
        guard !newState.isBoardBlocked, !newState.isGameOver else {
            print("Доска заблокирована или игра завершена")
            return newState
        }
        
        let moveSuccess = gameManager.makeMove(at: position, for: newState.currentPlayer)
        if moveSuccess {
            print("Игрок успешно сделал ход")
            return processGameAfterMove(newState, gameManager)
        } else {
            print("Невозможно сделать ход на позицию: \(position)")
        }
        
        return newState
    }
    
    private static func handleAIMove(_ state: GameState, _ gameManager: GameManager) -> GameState {
        let newState = state
        
        guard !newState.isBoardBlocked, !newState.isGameOver else {
            print("Доска заблокирована или игра завершена")
            return newState
        }
        
        let moveSuccess = gameManager.aiMove(for: newState.opponent, against: newState.player, difficulty: newState.level)
        if moveSuccess {
            print("ИИ успешно сделал ход")
            return processGameAfterMove(newState, gameManager)
        } else {
            print("ИИ не смог сделать ход")
        }
        
        return newState
    }
    
    private static func processGameAfterMove(_ state: GameState, _ gameManager: GameManager) -> GameState {
        var newState = state
        
        newState.winningPattern = gameManager.getWinningPattern()
        newState.isBoardBlocked = gameManager.isGameOver
        
        if gameManager.isGameOver {
            print("Игра завершена, проверка результата")
            return handleEndGame(newState, gameManager.getGameResult(gameMode: newState.gameMode, player: newState.player, opponent: newState.opponent))
        }
        
        print("Игра продолжается, переключение игрока")
        return togglePlayer(newState)
    }

    private static func handleEndGame(_ state: GameState, _ result: GameResult) -> GameState {
        var newState = state
        
        newState.gameResult = result
        newState.state = .finished
        newState.isBoardBlocked = true
        
        print("Итог игры: \(result)")
        
        if result == .win(name: newState.player.name) {
            print("Игрок выиграл! Обновление счета")
            UserManager.shared.updatePlayerScore()
        } else if result == .lose {
            print("Игрок проиграл. Обновление счета соперника")
            UserManager.shared.updateOpponentScore()
        }
        return newState
    }
    
    private static func togglePlayer(_ state: GameState) -> GameState {
        var newState = state
        
        newState.player.isActive.toggle()
        newState.opponent.isActive = !newState.player.isActive
        
        print("Игрок активен: \(newState.player.isActive ? newState.player.name : newState.opponent.name)")
        
        return newState
    }

    private static func handleOutOfTime(_ state: GameState) -> GameState {
        var newState = state
        
        newState.state = .finished
        newState.gameResult = .draw
        newState.isBoardBlocked = true
        
        print("Игра завершена из-за окончания времени. Результат: ничья")
        
        return newState
    }
}
