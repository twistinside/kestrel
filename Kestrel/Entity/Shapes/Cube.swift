import MetalKit

class KestrelCube: Entity, Renderable, Transformable {
    var meshes: [MTKMesh]
    var position: SIMD3<Float>
    var rotation: SIMD3<Float>
    var scale: SIMD3<Float>
    
    init() {
        let device = MTLCreateSystemDefaultDevice()!
        let meshBufferAllocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh(boxWithExtent: [0.8, 0.8, 0.8], segments: [10, 10, 10], inwardNormals: false, geometryType: .triangles, allocator: meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: device)
        self.meshes = [mtkMesh]
        self.position = SIMD3<Float>(repeating: 0.0)
        self.rotation = SIMD3<Float>(repeating: 0.0)
        self.scale = SIMD3<Float>(repeating: 1.0)
    }
}
