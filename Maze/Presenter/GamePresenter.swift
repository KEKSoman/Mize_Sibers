//
//  GamePresenter.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

class GamePresenter {
    private weak var view: GameViewProtocol?
    private var maze: Maze?
    private var player: Player?
    private let gameService: GameServiceProtocol
    private var isGameRunning = true
    private var gameWon = false
    
    init(view: GameViewProtocol, gameService: GameServiceProtocol = GameService()) {
        self.view = view
        self.gameService = gameService
    }
    
    func start() {
        view?.showWelcome()
        
        guard let size = view?.getMazeSize() else {
            return
        }
        
        maze = gameService.createMaze(rows: size.rows, cols: size.cols)
        
        guard let maze = maze else {
            view?.showError("Failed to create maze!")
            return
        }
        
        player = Player(startRoom: maze.getStartRoom(), maxSteps: size.maxSteps)
        
        view?.showHelp()
        
        if let currentPlayer = player {
            view?.showRoomDescription(maze.getRoomDescription(currentPlayer.currentRoom))
        }
        
        gameLoop()
    }
    
    private func gameLoop() {
        while isGameRunning {
            updateStatus()
            
            guard let command = view?.getCommand() else {
                continue
            }
            
            processCommand(command)
        }
        
        if gameWon {
            view?.showVictory(steps: player?.steps ?? 0)
        } else {
            view?.showGameOver(steps: player?.steps ?? 0)
        }
    }
    
    private func updateStatus() {
        guard let player = player else { return }
        view?.showPlayerStatus(
            steps: player.steps,
            stepsLeft: player.getStepsLeft(),
            hasKey: player.hasKey,
            hasGrail: player.hasGrail
        )
    }
    
    private func processCommand(_ command: String) {
        let lowerCommand = command.lowercased().trimmingCharacters(in: .whitespaces)
        
        switch lowerCommand {
        case "help", "h":
            view?.showHelp()
            
        case "inventory", "i":
            showInventory()
            
        case "quit", "q", "exit":
            isGameRunning = false
            
        case "open chest":
            openChest()
            
        case let cmd where cmd.hasPrefix("get "):
            let itemName = String(cmd.dropFirst(4))
            getItem(itemName)
            
        case let cmd where cmd.hasPrefix("drop "):
            let itemName = String(cmd.dropFirst(5))
            dropItem(itemName)
            
        case "n", "s", "w", "e":
            move(directionString: lowerCommand)
            
        default:
            view?.showError("Unknown command. Type 'help' for available commands.")
        }
    }
    
    private func showInventory() {
        guard let player = player else { return }
        let items = player.inventory.map { $0.name }
        view?.showInventory(items)
    }
    
    private func getItem(_ itemName: String) {
        guard let player = player else { return }
        
        let result = gameService.processGetItem(player: player, itemName: itemName)
        
        switch result {
        case .success(let item):
            view?.showMessage("You picked up \(item.name).")
            if let maze = maze {
                view?.showRoomDescription(maze.getRoomDescription(player.currentRoom))
            }
        case .itemNotFound(let name):
            view?.showError("There is no \(name) here!")
        case .cannotPickupChest:
            view?.showError("You cannot pick up the chest! Use 'open chest' command instead.")
        }
    }
    
    private func dropItem(_ itemName: String) {
        guard let player = player else { return }
        
        let result = gameService.processDropItem(player: player, itemName: itemName)
        
        switch result {
        case .success(let item):
            view?.showMessage("You dropped \(item.name).")
            if let maze = maze {
                view?.showRoomDescription(maze.getRoomDescription(player.currentRoom))
            }
        case .itemNotFound(let name):
            view?.showError("You don't have \(name)!")
        case .cannotPickupChest:
            break
        }
    }
    
    private func openChest() {
        guard let player = player else { return }
        
        let result = gameService.processOpenChest(player: player)
        
        switch result {
        case .success:
            view?.showMessage("You opened the chest with the key! Inside, you found the sacred GRAIL!")
            gameWon = true
            isGameRunning = false
            
        case .noChest:
            view?.showError("There is no chest here!")
        case .noKey:
            view?.showError("The chest is locked. You need a key to open it!")
        }
    }
    
    private func move(directionString: String) {
        
        guard let player = player else {
            view?.showError("Player not initialized!")
            return
        }
        
        guard let maze = maze else {
            view?.showError("Maze not initialized!")
            return
        }
        
        let direction: Direction
        switch directionString {
        case "n": direction = .north
        case "s": direction = .south
        case "w": direction = .west
        case "e": direction = .east
        default: return
        }
        
        
        let result = gameService.processMove(player: player, maze: maze, direction: direction)
        
        switch result {
        case .success(let newRoom):
            view?.showMessage("You move \(direction.fullName)...")
            view?.showRoomDescription(maze.getRoomDescription(newRoom))
            
        case .noDoor(let dir):
            view?.showError("There is no door to the \(dir.fullName)!")
            
        case .gameOver:
            isGameRunning = false
        }
    }
}
