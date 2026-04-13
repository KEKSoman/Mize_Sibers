//
//  ConsoleView.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

class ConsoleView: GameViewProtocol {
    func showWelcome() {
        print("""
        \n WELCOME TO THE DRAGON'S CAVE LABYRINTH!
        ═══════════════════════════════════════════════════
        You find yourself in a mysterious labyrinth.
        Your mission:
        1. Find the KEY
        2. Find the CHEST
        3. Open the chest with the key
        4. Claim the HOLY GRAIL
        
        WARNING: You have a limited number of steps!
        If you run out of steps, you will die of hunger.
        
        """)
    }
    
    func showHelp() {
        print("""
        
        COMMANDS:
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        • N / S / W / E     - Move in direction
        • get [item]        - Pick up an item
        • drop [item]       - Drop an item
        • open chest        - Open the chest (requires key)
        • inventory / i     - Show inventory
        • help / h          - Show this help
        • quit / q          - Exit game
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        
        """)
    }
    
    func showRoomDescription(_ description: String) {
        print("\n" + description)
    }
    
    func showPlayerStatus(steps: Int, stepsLeft: Int, hasKey: Bool, hasGrail: Bool) {
        print("\n Steps taken: \(steps)/\(steps + stepsLeft) (Steps left: \(stepsLeft))")
        print("Key: \(hasKey ? "✓" : "✗") | Grail: \(hasGrail ? "✓" : "✗")")
    }
    
    func showInventory(_ items: [String]) {
        if items.isEmpty {
            print("Your inventory is empty.")
        } else {
            print("Your inventory: \(items.joined(separator: ", "))")
        }
    }
    
    func showMessage(_ message: String) {
        print(message)
    }
    
    func showError(_ error: String) {
        print("\(error)")
    }
    
    func showVictory(steps: Int) {
        print("\n CONGRATULATIONS! ")
        print(" YOU HAVE FOUND THE HOLY GRAIL! ")
        print("Final steps: \(steps)")
        print("\n YOU ARE VICTORIOUS! The Holy Grail is yours! ")
    }
    
    func showGameOver(steps: Int) {
        print("\n GAME OVER ")
        print("You ran out of steps and died of hunger in the dark dungeons of the dragon's cave!")
        print("You survived \(steps) steps.")
    }
    
    func getCommand() -> String? {
        print("\n Your command: ", terminator: "")
        return readLine()
    }
    
    func getMazeSize() -> (rows: Int, cols: Int, maxSteps: Int)? {
        print("""
        ╔═══════════════════════════════════════════════════╗
        ║             LABYRINTH GENERATOR                   ║
        ╚═══════════════════════════════════════════════════╝
        """)
        
        print("Enter the number of rows (3-8): ", terminator: "")
        guard let rowsInput = readLine(),
              let rows = Int(rowsInput),
              rows >= 3 && rows <= 8 else {
            print("Invalid input. Using default: 5")
            let rows = 5
            print("Enter the number of columns (3-8): ", terminator: "")
            guard let colsInput = readLine(),
                  let cols = Int(colsInput),
                  cols >= 3 && cols <= 8 else {
                print("Invalid input. Using default: 5")
                print("Enter maximum steps (20-100): ", terminator: "")
                let steps = Int(readLine() ?? "") ?? 50
                return (rows, 5, steps)
            }
            print("Enter maximum steps (20-100): ", terminator: "")
            let steps = Int(readLine() ?? "") ?? 50
            return (rows, cols, steps)
        }
        
        print("Enter the number of columns (3-8): ", terminator: "")
        guard let colsInput = readLine(),
              let cols = Int(colsInput),
              cols >= 3 && cols <= 8 else {
            print("Invalid input. Using default: 5")
            print("Enter maximum steps (20-100): ", terminator: "")
            let steps = Int(readLine() ?? "") ?? 50
            return (rows, 5, steps)
        }
        
        print("Enter maximum steps (20-100): ", terminator: "")
        guard let stepsInput = readLine(),
              let steps = Int(stepsInput),
              steps >= 20 && steps <= 100 else {
            print("Invalid input. Using default: 50")
            return (rows, cols, 50)
        }
        
        return (rows, cols, steps)
    }
}
