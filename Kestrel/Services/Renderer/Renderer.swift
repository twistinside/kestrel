import MetalKit

class Renderer: NSObject {
    var commandQueue: MTLCommandQueue
    var device: MTLDevice
    var fragmentFunction: MTLFunction
    var library: MTLLibrary
    var uniforms: Uniforms
    var vertexFunction: MTLFunction
    
    let camera = StandardCamera()
    let cube = KestrelCube()
    let sphere = KestrelSphere()
    
    override init() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "basic_vertex"),
              let fragmentFunction = library.makeFunction(name: "basic_fragment") else {
            fatalError("Could not initialize render.")
        }
        
        self.commandQueue = commandQueue
        self.device = device
        self.fragmentFunction = fragmentFunction
        self.library = library
        self.uniforms = Uniforms()
        self.vertexFunction = vertexFunction
        super.init()
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
        
        sphere.update(deltaTime: 0.01)
        
        uniforms.projectionMatrix = camera.projectionMatrix
        uniforms.viewMatrix = camera.viewMatrix
        
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
        
        renderCommandEncoder?.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 0)
        renderCommandEncoder?.setVertexBuffer(mtkMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        
        sphere.render(renderCommandEncoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
