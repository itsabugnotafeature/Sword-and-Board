//
//  GameEntityManager.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/30/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//

typealias ECSEntityType = Set<ECSComponentType>

protocol ContainsEntities: AnyObject {
    var entityCount: Int { get }
    
    func appendComponent(_ component: ECSComponent, toEntity entity: ECSEntity)
    
    func removeComponent(ofType type: ECSComponentType, from entity: ECSEntity)
    
    func addEntity() -> ECSEntity
    
    func addEntityWithComponents(_ components: [ECSComponent]) -> ECSEntity
    
    func removeEntity(_ entity: ECSEntity)
    
    func typeOfEntity(_ entity: ECSEntity) -> ECSEntityType
}

class ECSEntityManager: ContainsEntities {
    var nextEntityID = 0
    
    var entityCount: Int {
        var uniqueIDs: Set<Int> = []
        for (_, typeArray) in entityIndices {
            for (entity, _) in typeArray {
                uniqueIDs.insert(entity)
            }
        }
        return uniqueIDs.count
    }
    
    private var components: [ECSComponent?] = []
    private var entityIndices: [ECSComponentType : [ECSEntity : Int]] = [:]
    private var availableIndices: [Int] = []
    
    private var entitiesToBeRemoved: [ECSEntity] = []
    private var componentsToBeRemoved: [ECSComponentType : [ECSEntity]] = [:]
    
    private var componentsToBeAdded: [ECSEntity : [ECSComponent]] = [:]
    
    func appendedComponent(_ component: ECSComponent, toEntity entity: ECSEntity) {
        let availableIndex = getAvailableComponentIndex()
        components.insert(component, at: availableIndex)
        if entityIndices[component.type!] != nil {
            entityIndices[component.type!]![entity] = availableIndex
        } else {
            entityIndices[component.type!] = [entity : availableIndex]
        }
    }
    
    func appendComponent(_ component: ECSComponent, toEntity entity: ECSEntity) {
        if componentsToBeAdded[entity] != nil {
            componentsToBeAdded[entity]?.append(component)
        } else {
            componentsToBeAdded[entity] = [component]
        }
    }
    
    //TODO: This should be thread safe
    private func removedComponent(ofType type: ECSComponentType, from entity: ECSEntity) {
        if var indexArray = entityIndices[type] {
            if let componentIndex = indexArray[entity] {
                availableIndices.insert(componentIndex, at: 0)
                entityIndices[type]!.removeValue(forKey: entity)
            }
        }
    }
    
    func removeComponent(ofType type: ECSComponentType, from entity: ECSEntity) {
        if componentsToBeRemoved[type] != nil {
            componentsToBeRemoved[type]?.append(entity)
        } else {
            componentsToBeRemoved[type] = [entity]
        }
    }
    
    func getAvailableComponentIndex() -> Int {
        return availableIndices.popLast() ?? components.endIndex
    }
    
    //TODO: Save previous results for later, until they've changed
    func getEntitiesWithType(_ entityType: ECSEntityType) -> [ECSEntity] {
        var possibleEntitiesSet: Set<ECSEntity> = []
        //Get all possible entities
        for type in entityType {
            if let typeDict = entityIndices[type] {
                possibleEntitiesSet = possibleEntitiesSet.union(Array(typeDict.keys))
            }
        }
        //Remove any that don't have every type of component
        for type in entityType {
            if let typeDict = entityIndices[type] {
                possibleEntitiesSet = possibleEntitiesSet.intersection(Array(typeDict.keys))
            }
        }
        return Array(possibleEntitiesSet)
    }
    
    //TODO: Save previous results for later, until they've changed
    func getComponentIndices(ofType entityType: ECSEntityType, fromEntities selectedEntities: [ECSEntity]) -> [ECSComponentType : [ECSEntity : Int]] {
        var selectedComponentIndices: [ECSComponentType : [ECSEntity : Int]] = [:]
        for type in entityType {
            selectedComponentIndices[type] = [:]
        }
        for entity in selectedEntities {
            for type in entityType {
                let componentIndex = entityIndices[type]![entity]!
                selectedComponentIndices[type]![entity] = componentIndex
            }
        }
        return selectedComponentIndices
    }
    
    func forEachEntity(ofType entityType: ECSEntityType, _ function: ECSSystemComponentIterator) {
        let selectedEntities = getEntitiesWithType(entityType)
        let selectedComponentIndices = getComponentIndices(ofType: entityType, fromEntities: selectedEntities)
        function(&components, selectedComponentIndices)
    }
    
    func addEntity() -> ECSEntity {
        let entity: ECSEntity = nextEntityID
        nextEntityID += 1
        return entity
    }
    
    func addEntityWithComponents(_ components: [ECSComponent]) -> ECSEntity {
        let entity = addEntity()
        for component in components {
            appendComponent(component, toEntity: entity)
        }
        return entity
    }
    
    private func removedEntity(_ entity: ECSEntity) {
        for (type, _) in entityIndices {
            removeComponent(ofType: type, from: entity)
        }
    }
    
    func removeEntity(_ entity: ECSEntity) {
        entitiesToBeRemoved.append(entity)
    }
    
    func typeOfEntity(_ entity: ECSEntity) -> ECSEntityType {
        var entityType: ECSEntityType = []
        for (type, typeArray) in entityIndices {
            if typeArray[entity] != nil {
                entityType.insert(type)
            }
        }
        return entityType
    }
    
    func update() {
        for entity in entitiesToBeRemoved {
            removedEntity(entity)
        }
        entitiesToBeRemoved.removeAll()
        for (type, typeArray) in componentsToBeRemoved {
            for entity in typeArray {
                removedComponent(ofType: type, from: entity)
            }
        }
        componentsToBeRemoved.removeAll()
        for (entity, compArray) in componentsToBeAdded {
            for component in compArray {
                appendedComponent(component, toEntity: entity)
            }
        }
        componentsToBeAdded.removeAll()
    }
    
}
