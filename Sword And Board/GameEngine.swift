//
//  GameEngine.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
import MetalKit

class GameEngine: NSObject, MTKViewDelegate {
    
    let renderer: GameRenderer!
    let ecsEngine: GameECSManager!
    let eventManager: GameEventManager!
    
    init?(mtkView: MTKView) {
        
        if let newRenderer = GameRenderer(metalKitView: mtkView) {
            renderer = newRenderer
            renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        } else {
            fatalError("Unable to initialize renderer")
        }
        
        ecsEngine = GameECSManager()
        eventManager = GameEventManager()
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        return
    }
    
    func draw(in view: MTKView) {
        renderer.draw(in: view)
    }
}
