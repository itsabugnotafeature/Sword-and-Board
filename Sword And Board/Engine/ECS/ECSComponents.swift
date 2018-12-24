//
//  Nodes.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/14/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

enum ECSComponentType {
    
    //There should be one case corresponding to each component type
    case Identifiable
    case Renderable
    case Damagable
}

protocol ECSComponent {
    
    var type: ECSComponentType? { get }
    
    func printInfo()
    
}

struct Identifiable: ECSComponent {
    var type: ECSComponentType? = .Identifiable
    
    var name: String?
    
    func printInfo() {
        print(name ?? "No name provided for \(self)")
    }
}

struct Renderable: ECSComponent {
    var type: ECSComponentType? = .Renderable
    
    func printInfo() {
        return
    }
}
