//
//  Room.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

class Room: Hashable {
    let id: Int
    let row: Int
    let col: Int
    var doors: [Direction: Bool] = [:]
    var items: [GameObject] = []
    var isVisited: Bool = false
    
    init(id: Int, row: Int, col: Int) {
        self.id = id
        self.row = row
        self.col = col
        for direction in Direction.allCases {
            doors[direction] = false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addDoor(_ direction: Direction) {
        doors[direction] = true
    }
    
    func hasDoor(_ direction: Direction) -> Bool {
        return doors[direction] ?? false
    }
    
    func getAvailableDirections() -> [Direction] {
        return Direction.allCases.filter { hasDoor($0) }
    }
    
    func getDoorCount() -> Int {
        return getAvailableDirections().count
    }
    
    func addItem(_ item: GameObject) {
        items.append(item)
    }
    
    func removeItem(_ item: GameObject){
        if let index = items.firstIndex(where: { $0.type == item.type }) {
            items.remove(at: index)
        }
    }
    
    func getItem(byType type: ItemType) -> GameObject? {
        return items.first(where: { $0.type == type })
    }
    
    func hasItem(_ type: ItemType) -> Bool {
        return items.contains { $0.type == type }
    }
    
    func getItemsDescription() -> String {
        if items.isEmpty {
            return "nothing"
        }
        return items.map { $0.name }.joined(separator: ", ")
    }
    
    func getDoorsDescription() -> String {
        let directions = getAvailableDirections().map { $0.rawValue }
        return directions.joined(separator: ", ")
    }
}
