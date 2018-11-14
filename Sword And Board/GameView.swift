//
//  GameView.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

import MetalKit

class GameView: MTKView {
    
    override var acceptsFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func keyDown(with event: NSEvent) {
        nextResponder?.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        nextResponder?.keyUp(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        print(event.locationInWindow)
    }
    
    override func flagsChanged(with event: NSEvent) {
        print("Flags changed")
        nextResponder?.flagsChanged(with: event)
    }
}
