//
//  GameEventManager.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

class GameEventManager {
    
    weak var engine: GameEngine?
    
    init(withEngine engine: GameEngine) {
        self.engine = engine
    }
    
    
}
