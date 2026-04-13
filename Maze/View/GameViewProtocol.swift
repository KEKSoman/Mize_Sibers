//
//  GameViewProtocol.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

protocol GameViewProtocol: AnyObject {
    func showWelcome()
    func showHelp()
    func showRoomDescription(_ description: String)
    func showPlayerStatus(steps: Int, stepsLeft: Int, hasKey: Bool, hasGrail: Bool)
    func showInventory(_ items: [String])
    func showMessage(_ message: String)
    func showError(_ error: String)
    func showVictory(steps: Int)
    func showGameOver(steps: Int)
    func getCommand() -> String?
    func getMazeSize() -> (rows: Int, cols: Int, maxSteps: Int)?
}
