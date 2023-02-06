import MetalKit
import ModelIO
import os

class MeshStore: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: MeshStore.self)
    )

    static let shared = MeshStore()

    private let meshes: [MeshNames: MTKMesh]

    init() {
        MeshStore.logger.trace("Initializing mesh store")
        var meshes: [MeshNames: MTKMesh] = [:]

        let vertexDescriptor = MTLVertexDescriptor()

        var offset: Int = 0

        // position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = offset
        vertexDescriptor.attributes[0].bufferIndex = 0
        offset += MemoryLayout<SIMD3<Float>>.stride

        vertexDescriptor.layouts[0].stride = offset

        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition

        for name in MeshNames.allCases {
            MeshStore.logger.trace("Initializing \(name.rawValue)")
            guard let meshURL = Bundle.main.url(forResource: name.rawValue, withExtension: "obj") else {
                fatalError()
            }

            let asset = MDLAsset(url: meshURL,
                                 vertexDescriptor: meshDescriptor,
                                 bufferAllocator: MetalStore.shared.meshBufferAllocator)
            let modelIOMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
            do {
                meshes[name] = try MTKMesh(mesh: modelIOMesh, device: MetalStore.shared.device)
            } catch {
                fatalError("couldn't load mesh")
            }
            MeshStore.logger.trace("Initialization of \(name.rawValue) complete")
        }
        self.meshes = meshes
        MeshStore.logger.trace("Initialization complete")
    }

    func getMeshNamed(_ name: MeshNames) -> MTKMesh {
        return meshes[name]!
    }
}

enum MeshNames: String, CaseIterable {
    case sphere = "sphere"
    case star   = "star"
    case teapot = "teapot"
}
