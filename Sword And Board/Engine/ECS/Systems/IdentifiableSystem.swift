//
//  IdentifiableSystem.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 12/22/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

class IdentifiableSystem: ECSSystem {
    var entityType: ECSEntityType = [.Identifiable]
    
    weak var entityManager: ECSEntityManager?
    
    var counter: Int = 0
    
    func start() -> Bool {
        return true
    }
    
    func update(afterTime: TimeInterval) {
        entityManager?.forEachEntity(ofType: entityType) { components, indices in
            for (entity, index) in indices[.Identifiable]! {
                let identityComponent: Identifiable = components[index] as! Identifiable
                print(identityComponent.name!)
                if identityComponent.name == "Max" {
                    counter += 1;
                    if counter > 120 {
                        print("I'm done with Max!")
                        entityManager?.removeEntity(entity)
                    }
                }
            }
        }
    }
    
    func pause() -> Bool {
        return true
    }
    
    func stop() -> Bool {
        return true
    }
    
    
}
