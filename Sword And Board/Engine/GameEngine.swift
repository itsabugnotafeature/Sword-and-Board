//
//  GameEngine.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
import MetalKit

class GameEngine: NSObject, MTKViewDelegate {
    
    var renderer: GameRenderer?
    var ecsEngine: GameECSManager?
    var eventManager: GameEventManager?
    var audioPlayer: GameAudio?
    
    init?(mtkView: MTKView) {
        
        super.init()
        
        if let newRenderer = GameRenderer(metalKitView: mtkView) {
            renderer = newRenderer
            renderer?.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        } else {
            fatalError("Unable to initialize renderer")
        }
        
        ecsEngine = GameECSManager(withEngine: self)
        eventManager = GameEventManager(withEngine: self)
        audioPlayer = GameAudio(withEngine: self)
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer?.mtkView(view, drawableSizeWillChange: size)
    }
    
    func draw(in view: MTKView) {
        renderer?.draw(in: view)
    }
}
