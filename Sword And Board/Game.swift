//
//  Game.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 12/22/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
import MetalKit
class Game: NSObject, MTKViewDelegate {
    
    let gameEngine: GameEngine?
    
    init?(mtkView: MTKView) {
        gameEngine = GameEngine(mtkView: mtkView)
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func pause() {
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        gameEngine?.mtkView(view, drawableSizeWillChange: size)
    }
    
    func draw(in view: MTKView) {
        gameEngine?.draw(in: view)
    }
}
