//
//  Processes.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/14/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
class ECSSystem {
    let componentMask: ECSComponentType
    
    var nodes: [Int : ECSSystemNode] = [:]
    
    init(withComponentMask componentMask: ECSComponentType) {
        
        self.componentMask = componentMask
        
    }
    
    func accepts(_ componentMask: ECSComponentType) -> Bool {
        if (componentMask.isSuperset(of: self.componentMask)) {
            return true
        }
        return false
    }
    
    func addEntity(withComponents components: [ECSComponent], withId id: Int) {
        return
    }
    
    func changed(entity: Int, componentsMask: ECSComponentType) {
        return
    }
    
    func removeEntity(withId id: Int) {
        return
    }
    
    func start() -> Bool {
        return false
    }
    
    func update(afterTime: TimeInterval) {
        return
    }
    
    func pause() -> Bool {
        return false
    }
    
    func stop() -> Bool {
        return false
    }
    
}

class ECSExtensibleSystem: ECSSystem {
    
    let updateFunction: (TimeInterval) -> Void
    
    init(withComponentMask componentMask: ECSComponentType, withUpdateFunction updateFunction: @escaping (TimeInterval) -> Void) {
        
        self.updateFunction = updateFunction
        super.init(withComponentMask: componentMask)
        
    }
    
    override func update(afterTime dt: TimeInterval) {
        self.updateFunction(dt)
    }
}

enum ECSSystemPriorities {
    
    case background
    case deferred
    case userInteractions
    
}
