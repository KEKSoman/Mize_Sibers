//
//  main.swift
//  Maze
//
//  Created by Евгений колесников on 12.04.2026.
//

import Foundation

let view = ConsoleView()
let presenter = GamePresenter(view: view)

presenter.start()

