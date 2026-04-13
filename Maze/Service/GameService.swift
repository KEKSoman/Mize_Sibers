//
//  GameService.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

protocol GameServiceProtocol {
    func createMaze(rows: Int, cols: Int) -> Maze
    func processMove(player: Player, maze: Maze, direction: Direction) -> MoveResult
    func processGetItem(player: Player, itemName: String) -> ItemActionResult
    func processDropItem(player: Player, itemName: String) -> ItemActionResult
    func processOpenChest(player: Player) -> ChestActionResult
}

enum MoveResult {
    case success(newRoom: Room)
    case noDoor(direction: Direction)
    case gameOver
}

enum ItemActionResult {
    case success(item: GameObject)
    case itemNotFound(name: String)
    case cannotPickupChest
}

enum ChestActionResult {
    case success(grail: GameObject)
    case noChest
    case noKey
}

class GameService: GameServiceProtocol {
    func createMaze(rows: Int, cols: Int) -> Maze {
        return Maze(rows: rows, cols: cols)
    }
    
    func processMove(player: Player, maze: Maze, direction: Direction) -> MoveResult {
        guard player.currentRoom.hasDoor(direction) else {
            return .noDoor(direction: direction)
        }
        
        guard let newRoom = maze.getNeighbor(of: player.currentRoom, direction: direction) else {
            return .noDoor(direction: direction)
        }
        
        player.move(to: newRoom)
        
        if !player.isAlive() {
            return .gameOver
        }
        
        return .success(newRoom: newRoom)
    }
    
    func processGetItem(player: Player, itemName: String) -> ItemActionResult {
       
        guard let item = player.currentRoom.items.first(where: { $0.name.lowercased() == itemName }) else {
            return .itemNotFound(name: itemName)
        }
        
        if item.type == .chest {
            return .cannotPickupChest
        }
        
        player.pickUpItem(item)
        return .success(item: item)
    }
    
    func processDropItem(player: Player, itemName: String) -> ItemActionResult {
  
        guard let item = player.inventory.first(where: { $0.name.lowercased() == itemName }) else {
            return .itemNotFound(name: itemName)
        }
        
        player.dropItem(item)
        return .success(item: item)
    }
    
    func processOpenChest(player: Player) -> ChestActionResult {
        guard player.currentRoom.hasItem(.chest) else {
            return .noChest
        }
        
        guard player.hasKey else {
            return .noKey
        }
        
        let success = player.openChest()
        if success, let grail = player.inventory.first(where: { $0.type == .grail }) {
            return .success(grail: grail)
        }
        
        return .noChest
    }
}
