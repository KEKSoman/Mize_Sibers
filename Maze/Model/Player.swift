//
//  Player.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

class Player {
    var currentRoom: Room
    var inventory: [GameObject] = []
    var steps: Int = 0
    var maxSteps: Int
    var hasKey: Bool = false
    var hasGrail: Bool = false
    
    init(startRoom: Room, maxSteps: Int) {
        self.currentRoom = startRoom
        self.maxSteps = maxSteps
        self.currentRoom.isVisited = true
    }
    
    func move(to room: Room) {
        currentRoom = room
        currentRoom.isVisited = true
        steps += 1
    }
    
    func pickUpItem(_ item: GameObject) {
        inventory.append(item)
        currentRoom.removeItem(item)
        
        if item.type == .key {
            hasKey = true
        }
    }
    
    func dropItem(_ item: GameObject) {
        inventory.removeAll { $0.type == item.type }
        currentRoom.addItem(item)
        
        if item.type == .key {
            hasKey = false
        }
    }
    
    func canOpenChest() -> Bool {
        return currentRoom.hasItem(.chest) && hasKey
    }
    
    func openChest() -> Bool {
        guard let chest = currentRoom.getItem(byType: .chest),
              let grail = currentRoom.getItem(byType: .grail) else {
            return false
        }
        
        currentRoom.removeItem(chest)
        currentRoom.removeItem(grail)
        inventory.append(grail)
        hasGrail = true
        
        return true
    }
    
    func isAlive() -> Bool {
        return steps < maxSteps
    }
    
    func getStepsLeft() -> Int {
        return maxSteps - steps
    }
}
