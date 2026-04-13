//
//  GameObject.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

class GameObject {
    let type: ItemType
    let name: String
    let description: String
    
    init(type: ItemType, name: String, description: String) {
        self.type = type
        self.name = name
        self.description = description
    }
}
