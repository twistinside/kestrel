import GameController
import MetalKit

class KestrelSphere: Entity, Renderable, Transformable {
    var meshes: [MTKMesh]
    var position: SIMD3<Float>
    var rotation: SIMD3<Float>
    var scale: SIMD3<Float>

    var isGrowing: Bool = false
    var isShrinking: Bool = true

    init() {
        let device = MTLCreateSystemDefaultDevice()!
        let meshBufferAllocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh(sphereWithExtent: [0.8, 0.8, 0.8],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: .triangles,
                              allocator: meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: device)
        self.meshes = [mtkMesh]
        self.position = SIMD3<Float>(repeating: 0.0)
        self.rotation = SIMD3<Float>(repeating: 0.0)
        self.scale = SIMD3<Float>(repeating: 1.0)
    }

    override func update(deltaTime: Float) {
        self.rotate(by: SIMD3<Float>(deltaTime, deltaTime/2, deltaTime/3))
        if self.scale.x < 0.1 {
            self.isGrowing = true
            self.isShrinking = false
        }
        if self.scale.x > 1 {
            self.isGrowing = false
            self.isShrinking = true
        }
        let keysPressed: Bool = GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: .spacebar)?.isPressed ?? false
        if keysPressed {
            if isGrowing {
                self.scale += SIMD3<Float>(repeating: 0.005)
            }
            if isShrinking {
                self.scale -= SIMD3<Float>(repeating: 0.005)
            }
        }
    }
}
