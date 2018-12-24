//
//  Processes.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/14/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
 protocol ECSSystem: AnyObject {
    var entityType: ECSEntityType { get }
    
    var entityManager: ECSEntityManager? { get set }
    
    @discardableResult func start() -> Bool
    
    func update(afterTime: TimeInterval)
    
    @discardableResult func pause() -> Bool
    
    @discardableResult func stop() -> Bool
}

/**
Used by ECSSystems to iterate over their respective components
 - Parameters:
    - components : A large array containing all the components from an `ECSEntityManager`.
    - indices :A dictionary with the indices of the components needed, grouped by component type. They are in order by entity, so the first component in one array, corresponds with the first component from the other and so on.
 */

typealias ECSSystemComponentIterator = (_ components: inout [ECSComponent?], _ indices: [ECSComponentType : [ECSEntity : Int]]) -> Void

enum ECSSystemPriorities {
    
    case userInitiated
    case deferrable
    case background
    
}
