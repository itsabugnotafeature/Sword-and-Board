//
//  RenderSystem.swift
//  Sword And Board
//
//  Created by Max Sonderegger on 11/26/18.
//  Copyright © 2018 Max Sonderegger. All rights reserved.
//
import MetalKit

class RenderSystem: ECSSystem {
    var entityType: ECSEntityType = [.Renderable]
    
    weak var entityManager: ECSEntityManager?
    
    weak var view: MTKView?
    weak var device: MTLDevice?
    var commandQueue: MTLCommandQueue?
    var pipelineState: MTLRenderPipelineState
    var vertexDescriptor: MTLVertexDescriptor?
    
    init(withView view: MTKView, andDevice device: MTLDevice) {
        self.view = view
        self.device = device
        commandQueue = device.makeCommandQueue()
        vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(RenderSystem.buildVertexDescriptor())
        pipelineState = RenderSystem.buildPipeline(device: device, view: view, vertexDescriptor: vertexDescriptor)
        
    }
    
    func start() -> Bool {
        return true
    }
    
    func update(afterTime: TimeInterval) {
        let commandBuffer = commandQueue?.makeCommandBuffer()
        if let renderPassDescriptor = view?.currentRenderPassDescriptor {
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            commandEncoder?.setRenderPipelineState(pipelineState)
            commandEncoder?.endEncoding()
            commandBuffer?.present((view?.currentDrawable)!)
            commandBuffer?.commit()
            commandBuffer?.waitUntilCompleted()
        }
    }
    
    func pause() -> Bool {
        return true
    }
    
    func stop() -> Bool {
        return true
    }
    
    static func buildPipeline(device: MTLDevice, view: MTKView, vertexDescriptor: MTLVertexDescriptor?) -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Could not load default library from main bundle")
        }
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat
        
        do {
            return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create render pipeline state object: \(error)")
        }
    }
    
    static func buildVertexDescriptor() -> MDLVertexDescriptor {
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                            format: .float3,
                                                            offset: 0,
                                                            bufferIndex: 0)
        vertexDescriptor.attributes[1] = MDLVertexAttribute(name: MDLVertexAttributeNormal,
                                                            format: .float3,
                                                            offset: MemoryLayout<Float>.size * 3,
                                                            bufferIndex: 0)
        vertexDescriptor.attributes[2] = MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate,
                                                            format: .float2,
                                                            offset: MemoryLayout<Float>.size * 6,
                                                            bufferIndex: 0)
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: MemoryLayout<Float>.size * 8)
        return vertexDescriptor
    }
    
}
