import MetalKit

class Renderer: NSObject {
    static let shared = Renderer()

    let device = MetalStorage.shared.device
    let commandQueue = MetalStorage.shared.commandQueue

    let camera = StandardCamera()
    let cube = KestrelCube()
    let sphere = KestrelSphere()

    private override init() {
        print("Initializing renderer.")
        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        camera.aspect = Float(size.width) / Float(size.height)
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }

        sphere.update(deltaTime: 0.01)

        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor

        renderPassDescriptor?.colorAttachments[0].clearColor = Kestrel.shared.clearColor
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store

        let renderCommandEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)

        let meshBufferAllocator = MTKMeshBufferAllocator(device: device)

        let mdlMesh = MDLMesh(sphereWithExtent: [0.8, 0.8, 0.8],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: Kestrel.shared.geometryType,
                              allocator: meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: device)

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = MetalStorage.shared.vertexFunction
        renderPipelineDescriptor.fragmentFunction = MetalStorage.shared.fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        let renderPipelineState = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)

        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)

        renderCommandEncoder?.setVertexBuffer(mtkMesh.vertexBuffers[0].buffer, offset: 0, index: 0)

        sphere.render(renderCommandEncoder: renderCommandEncoder!)

        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
