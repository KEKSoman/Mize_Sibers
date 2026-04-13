//
//  Direction.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

enum Direction: String, CaseIterable {
    case north = "N"
    case south = "S"
    case west = "W"
    case east = "E"
    
    var fullName: String {
        switch self {
        case .north: return "north"
        case .south: return "south"
        case .west: return "west"
        case .east: return "east"
        }
    }
    
    var opposite: Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .west: return .east
        case .east: return .west
        }
    }
    
    var delta: (row: Int, col: Int) {
        switch self {
        case .north: return (-1, 0)
        case .south: return (1, 0)
        case .west: return (0, -1)
        case .east: return (0, 1)
        }
    }
}
