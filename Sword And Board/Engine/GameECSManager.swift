//
//  GameECSEngine.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
typealias ECSEntity = Int

class GameECSManager: ContainsEntities {
    
    var entityCount: Int { return entityManager.entityCount }
    
    weak var engine: GameEngine?
    
    private let entityManager: ECSEntityManager = ECSEntityManager()
    var systems: [ECSSystemPriorities: [ECSSystem]] = [:]
    
    init(withEngine engine: GameEngine) {
        self.engine = engine
    }
    
    @discardableResult func addSystem(_ system: ECSSystem, withPriority priority: ECSSystemPriorities) -> Bool {
        if system.start() {
            system.entityManager = self.entityManager
            if systems[priority] != nil {
                systems[priority]!.append(system)
            } else {
                systems[priority] = [system]
            }
            return true
        } else {
            return false
        }
    }
    
    @discardableResult func removeSystem(_ systemToBeRemoved: ECSSystem) -> Bool {
        for (_, var systemList) in systems {
            for index in 0..<systemList.count {
                if systemList[index] === systemToBeRemoved {
                    systemList.remove(at: index)
                    return true
                }
            }
        }
        return false
    }
    
    func update(afterTime dt: TimeInterval) {
        entityManager.update()
        for (_, systemList) in systems {
            for system in systemList {
                system.update(afterTime: dt)
            }
        }
    }
    
    func appendComponent(_ component: ECSComponent, toEntity entity: ECSEntity) {
        entityManager.appendComponent(component, toEntity: entity)
    }
    
    func removeComponent(ofType type: ECSComponentType, from entity: ECSEntity) {
        entityManager.removeComponent(ofType: type, from: entity)
    }
    
    func addEntity() -> ECSEntity {
        return entityManager.addEntity()
    }
    
    func addEntityWithComponents(_ components: [ECSComponent]) -> ECSEntity {
        return entityManager.addEntityWithComponents(components)
    }
    
    func removeEntity(_ entity: ECSEntity) {
        entityManager.removeEntity(entity)
    }
    
    func typeOfEntity(_ entity: ECSEntity) -> ECSEntityType {
        return entityManager.typeOfEntity(entity)
    }
    

}
