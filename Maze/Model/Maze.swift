//
//  Maze.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

class Maze {
    let rows: Int
    let cols: Int
    private var rooms: [[Room]]
    private var allRooms: [Room] = []
    typealias Wall = (current: Room, neighbor: Room, direction: Direction)
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.rooms = Array(repeating: Array(repeating: Room(id: 0, row: 0, col: 0), count: cols), count: rows)
        generateMaze()
        placeItems()
    }
    
    func getRoom(atRow row: Int, col: Int) -> Room? {
        guard row >= 0 && row < rows && col >= 0 && col < cols else { return nil }
        return rooms[row][col]
    }
    
    func getNeighbor(of room: Room, direction: Direction) -> Room? {
        let newRow = room.row + direction.delta.row
        let newCol = room.col + direction.delta.col
        return getRoom(atRow: newRow, col: newCol)
    }
    
    private func generateMaze() {
        var id = 0
        for row in 0..<rows {
            for col in 0..<cols {
                let room = Room(id: id, row: row, col: col)
                rooms[row][col] = room
                allRooms.append(room)
                id += 1
            }
        }
        
        var walls: [Wall] = []
        var visited = Set<Room>()
        
        let startRoom = rooms[0][0]
        visited.insert(startRoom)
        addWalls(from: startRoom, to: &walls)
        
        while !walls.isEmpty {
            let randomIndex = Int.random(in: 0..<walls.count)
            let wall = walls.remove(at: randomIndex)
            
            if !visited.contains(wall.neighbor) {
                connectRooms(wall.current, wall.neighbor, wall.direction)
                visited.insert(wall.neighbor)
                addWalls(from: wall.neighbor, to: &walls)
            }
        }
        
        ensureAllRoomsHaveDoors()
    }
    
    private func addWalls(from room: Room, to walls: inout [Wall]) {
        for direction in Direction.allCases {
            if let neighbor = getNeighbor(of: room, direction: direction) {
                if !room.hasDoor(direction) && !neighbor.hasDoor(direction.opposite) {
                    walls.append((current: room, neighbor: neighbor, direction: direction))
                }
            }
        }
    }
    
    private func connectRooms(_ room1: Room, _ room2: Room, _ direction: Direction) {
        room1.addDoor(direction)
        room2.addDoor(direction.opposite)
    }
    
    private func ensureAllRoomsHaveDoors() {
        for room in allRooms {
            if room.getDoorCount() == 0 {
                for direction in Direction.allCases.shuffled() {
                    if let neighbor = getNeighbor(of: room, direction: direction) {
                        connectRooms(room, neighbor, direction)
                        break
                    }
                }
            }
        }
    }
    
    private func placeItems() {
        let key = GameObject(type: .key, name: "key", description: "Key")
        let chest = GameObject(type: .chest, name: "chest", description: "Chest")
        let grail = GameObject(type: .grail, name: "grail", description: "Grail")
        
        var availableRooms = allRooms.shuffled()
        
        if let room = availableRooms.popLast() {
            room.addItem(key)
        }
        
        if let room = availableRooms.popLast() {
            room.addItem(chest)
            room.addItem(grail)
        }
    }
    
    func getStartRoom() -> Room {
        return rooms[0][0]
    }
    
    func getRoomDescription(_ room: Room) -> String {
        let coordinates = "[\(room.row),\(room.col)]"
        let doorCount = room.getDoorCount()
        let doorsDesc = room.getDoorsDescription()
        let itemsDesc = room.getItemsDescription()
        
        return "You are in the room \(coordinates). There are \(doorCount) doors: \(doorsDesc). Items in the room: \(itemsDesc)."
    }
    
    func getRandomRoom() -> Room {
        return allRooms.randomElement()!
    }
}
