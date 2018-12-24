//
//  GameViewController.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

import Cocoa
import MetalKit

// Our macOS specific view controller
class GameViewController: NSViewController {

    var game: Game?
    var mtkView: MTKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let mtkView = self.view as? MTKView else {
            print("View attached to GameViewController is not an MTKView")
            return
        }
        
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.depthStencilPixelFormat = .depth32Float
        mtkView.clearColor = MTLClearColorMake(0.4, 0.5, 0.8, 0)

        // Select the device to render with.  We choose the default device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return
        }

        mtkView.device = defaultDevice

        guard let newGame = Game(mtkView: mtkView) else {
            print("Engine cannot be initialized")
            return
        }

        game = newGame
        
        mtkView.delegate = game
    }
}
