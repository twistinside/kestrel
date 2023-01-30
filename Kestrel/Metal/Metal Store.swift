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
    var renderPipelineState: MTLRenderPipelineState
    var vertexFunction: MTLFunction

    init() {
        Self.logger.trace("Initializing metal storage object.")
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "basic_vertex"),
              let fragmentFunction = library.makeFunction(name: "basic_fragment") else {
            Self.logger.critical("Could not initialize metal sub system.")
            fatalError()
        }
        self.commandQueue = commandQueue
        self.device = device
        self.fragmentFunction = fragmentFunction
        self.library = library
        self.vertexFunction = vertexFunction

        let meshBufferAllocator = MTKMeshBufferAllocator(device: device)

        let mdlMesh = MDLMesh(sphereWithExtent: [0.8, 0.8, 0.8],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: Kestrel.shared.geometryType,
                              allocator: meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: device)

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineState = try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        Self.logger.trace("Initialization complete.")
    }
}
