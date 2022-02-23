import MetalKit

class Renderer: NSObject {
    var commandQueue: MTLCommandQueue
    var device: MTLDevice
    var fragmentFunction: MTLFunction
    var library: MTLLibrary
    var vertexFunction: MTLFunction
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "basic_vertex"),
              let fragmentFunction = library.makeFunction(name: "basic_fragment") else {
            fatalError("Could not initialize render.")
        }
        
        self.device = device
        self.commandQueue = commandQueue
        self.fragmentFunction = fragmentFunction
        self.library = library
        self.vertexFunction = vertexFunction
        super.init()
        
        metalView.delegate = self
        metalView.device = device
        metalView.clearColor = MTLClearColor(red: 0.73, green: 0.23, blue: 0.35, alpha: 1.0)
        
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
}

extension Renderer: MTKViewDelegate {
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
        
        let meshBufferAllocator = MTKMeshBufferAllocator(device: device)
        
        let mdlMesh = MDLMesh(sphereWithExtent: [0.8, 0.8, 0.8], segments: [100, 100], inwardNormals: false, geometryType: .triangles, allocator: meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: device)
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)
        
        let renderPipelineState = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
        renderCommandEncoder?.setVertexBuffer(mtkMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        
        guard let submesh = mtkMesh.submeshes.first else {
            fatalError()
        }
        
        renderCommandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: 0)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        print("Drawing")
    }
}
