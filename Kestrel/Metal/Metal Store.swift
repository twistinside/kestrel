import Foundation
import Metal
import MetalKit
import os

class MetalStore: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: MetalStore.self)
    )

    static let shared = MetalStore()

    let commandQueue: MTLCommandQueue
    let device: MTLDevice
    var fragmentFunction: MTLFunction
    var library: MTLLibrary
    let meshBufferAllocator: MTKMeshBufferAllocator
    var renderPipelineState: MTLRenderPipelineState
    var vertexFunction: MTLFunction

    init() {
        MetalStore.logger.trace("Initializing metal store.")
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "basic_vertex"),
              let fragmentFunction = library.makeFunction(name: "basic_fragment") else {
            MetalStore.logger.critical("Could not initialize metal sub system")
            fatalError()
        }
        self.commandQueue = commandQueue
        self.device = device
        self.fragmentFunction = fragmentFunction
        self.library = library
        self.meshBufferAllocator = MTKMeshBufferAllocator(device: device)
        self.vertexFunction = vertexFunction

        let mdlMesh = MDLMesh(sphereWithExtent: [0.8, 0.8, 0.8],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: .triangles,
                              allocator: meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: device)

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineState = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        MetalStore.logger.trace("Initialization complete.")
    }
}
