//
//  Nodes.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/14/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
import simd
import Metal

struct ECSComponentType: OptionSet {
    let rawValue: Int
    
    static let NoComponent = 0
    static let Position = 1 << 0
    static let EntityState = 1 << 1
    static let Animatable = 1 << 2
}

class ECSComponent {
    
    let type: ECSComponentType
    
    init(withType type: ECSComponentType) {
        self.type = type
    }
}
