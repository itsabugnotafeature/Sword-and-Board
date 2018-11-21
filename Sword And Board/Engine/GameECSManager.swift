//
//  GameECSEngine.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

class GameECSManager {
    
    let MAX_ENTITY_COUNT = 100
    var entityCount = 0
    
    let engine: GameEngine
    
    var systems: [ECSSystemPriorities: [ECSSystem]] = [:]
    var entityMasks: [Int : ECSComponentType] = [:]
    var entityComponents: [Int : [ECSComponent]] = [:]
    
    init(withEngine engine: GameEngine) {
        self.engine = engine
    }
    
    func addSystem(_ system: ECSSystem, withPriority priority: ECSSystemPriorities) -> Bool {
        if system.start() {
            systems[priority]?.append(system)
        } else {
            return false
        }
        
        for (id, componentMask) in entityMasks {
            if system.accepts(componentMask) {
                system.addEntity(withComponents: entityComponents[id]!, withId: id)
            }
        }
        return true
    }
    
    func addEntity(withComponents compenentMask: ECSComponentType) -> Int {
        let entityID = entityCount
        entityMasks[entityID] = compenentMask
        entityCount += 1
        entityComponents[entityID] = []
        
        for (priorityLevel, _) in systems {
            for system in systems[priorityLevel]! {
                if system.accepts(compenentMask) {
                    system.addEntity(withComponents: [], withId: entityID)
                }
            }
        }
        
        return entityID
    }
    
    func addComponents(_ components: [ECSComponent], toEntity id: Int) {
        entityComponents[id]?.append(contentsOf: components)
        for component in components {
            entityMasks[id]?.formUnion(component.type)
        }
        for (priorityLevel, _) in systems {
            for system in systems[priorityLevel]! {
                system.changed(entity: id, componentsMask: entityMasks[id]!)
            }
        }
    }
    
    func removeSystem(_ systemToBeRemoved: ECSSystem) -> Bool {
        for (_, var systemList) in systems {
            for index in 0..<systemList.count {
                if systemList[index] === systemToBeRemoved && systemList[index].stop() {
                    return true
                }
            }
        }
        return false
    }
    
    func removeEntity(withID id: Int) {
        entityCount -= 1
        entityMasks.removeValue(forKey: id)
        entityComponents.removeValue(forKey: id)
        
        for (priorityLevel, _) in systems {
            for system in systems[priorityLevel]! {
                system.removeEntity(withId: id)
            }
        }
    }
    
    func removeComponents(ofTypes types: [ECSComponentType], fromEntity id: Int) {
        for type in types {
            entityMasks[id]?.remove(type)
        }
        
        entityComponents.removeValue(forKey: id)
        
        for (priorityLevel, _) in systems {
            for system in systems[priorityLevel]! {
                system.changed(entity: id, componentsMask: entityMasks[id]!)
            }
        }
    }
    
    func update(afterTime dt: TimeInterval) {
        for (_, systemList) in systems {
            for system in systemList {
                system.update(afterTime: dt)
            }
        }
    }

}
