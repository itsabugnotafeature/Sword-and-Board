//
//  GameEngine.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/13/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
import MetalKit

class GameEngine: NSObject, MTKViewDelegate, ContainsEntities {
    var ecsManager: GameECSManager?
    var eventManager: GameEventManager?
    
    var currentDelta: TimeInterval = 0
    var lastFrameTime: DispatchTime = DispatchTime.now()
    
    var entityCount: Int { return (ecsManager?.entityCount)! }
    
    init?(mtkView: MTKView) {
        
        super.init()
        
        ecsManager = GameECSManager(withEngine: self)
        eventManager = GameEventManager(withEngine: self)
        
        ecsManager?.addSystem(RenderSystem(withView: mtkView, andDevice: mtkView.device!), withPriority: .userInitiated)
        ecsManager?.addSystem(IdentifiableSystem(), withPriority: .userInitiated)
        var testComp: Identifiable = Identifiable()
        testComp.name = "Max"
        var anotherComp = Identifiable()
        anotherComp.name = "Myana"
        let anotherComp2 = Renderable()
        _ = ecsManager?.addEntityWithComponents([testComp])
        _ = ecsManager?.addEntityWithComponents([anotherComp, anotherComp2])
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //code
    }
    
    func draw(in view: MTKView) {
        currentDelta = Double(DispatchTime.now().uptimeNanoseconds - lastFrameTime.uptimeNanoseconds)
        ecsManager?.update(afterTime: currentDelta)
        lastFrameTime = DispatchTime.now()
    }
    
    func appendComponent(_ component: ECSComponent, toEntity entity: ECSEntity) {
        ecsManager?.appendComponent(component, toEntity: entity)
    }
    
    func removeComponent(ofType type: ECSComponentType, from entity: ECSEntity) {
        ecsManager?.removeComponent(ofType: type, from: entity)
    }
    
    func addEntity() -> ECSEntity {
        return (ecsManager?.addEntity())!
    }
    
    func addEntityWithComponents(_ components: [ECSComponent]) -> ECSEntity {
        return (ecsManager?.addEntityWithComponents(components))!
    }
    
    func removeEntity(_ entity: ECSEntity) {
        ecsManager?.removeEntity(entity)
    }
    
    func typeOfEntity(_ entity: ECSEntity) -> ECSEntityType {
        return (ecsManager?.typeOfEntity(entity))!
    }
}
