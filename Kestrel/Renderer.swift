//
//  Renderer.swift
//  Kestrel
//
//  Created by Karl Groff on 2/17/22.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var commandQueue: MTLCommandQueue
    var device: MTLDevice
    var parent: GameView
    
    init(_ view: GameView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else {
            fatalError("Could not initialize render.")
        }
        
        self.device = device
        self.commandQueue = commandQueue
        self.parent = view
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Do nothing
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor
        
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 0.73, green: 0.23, blue: 0.35, alpha: 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        let renderCommandEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
