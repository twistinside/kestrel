import Metal
import MetalKit
import os

class VertexDescriptorLibrary {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: VertexDescriptorLibrary.self)
    )

    static let shared = VertexDescriptorLibrary()

    private let vertexDescriptors: [VertexDescriptorName: MTLVertexDescriptor]

    init() {
        VertexDescriptorLibrary.logger.trace("Initializing vertex descriptor library")

        let mdlMesh = MDLMesh(sphereWithExtent: [0.8, 0.8, 0.8],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: .triangles,
                              allocator: MetalStore.shared.meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: MetalStore.shared.device)
        let vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)
        var vertexDescriptors: [VertexDescriptorName: MTLVertexDescriptor] = [:]
        vertexDescriptors[.mdlMesh] = vertexDescriptor

        self.vertexDescriptors = vertexDescriptors

        // Validate the vertex descriptor library is complete
        for name in VertexDescriptorName.allCases where vertexDescriptors[name] == nil {
            assertionFailure("Initialization failed, \(name.rawValue) was not present in the library")
        }

        VertexDescriptorLibrary.logger.trace("Initialization complete")
    }

}

enum VertexDescriptorName: String, CaseIterable {
    case mdlMesh
}
