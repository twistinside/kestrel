import GameController
import MetalKit
import os

class KestrelSphere: Entity, Renderable, Transformable {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: KestrelSphere.self)
    )

    let meshes: [MTKMesh]
    var position: SIMD3<Float>
    let renderPipelineState: MTLRenderPipelineState
    var rotation: SIMD3<Float>
    var scale: SIMD3<Float>

    var isGrowing: Bool = false
    var isShrinking: Bool = true

    init() {
        KestrelSphere.logger.trace("Initializing Kestrel Sphere")
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
        self.renderPipelineState = RenderPiplelineStateLibrary.shared.getRenderPipelineStateNamed(.basic)
        self.rotation = SIMD3<Float>(repeating: 0.0)
        self.scale = SIMD3<Float>(repeating: 1.0)
        KestrelSphere.logger.trace("Initialization complete")
    }

    override func update(deltaTime: Float) {
        KestrelSphere.logger.trace("Updating Kestrel Sphere")
        self.rotate(by: SIMD3<Float>(deltaTime, deltaTime/2, deltaTime/3))

        let fKeyIsPressed: Bool = GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: .keyF)?.isPressed ?? false
        if fKeyIsPressed {
            KestrelSphere.logger.trace("Setting undefined state")
            self.isGrowing = true
            self.isShrinking = true
        }

        let bKeyIsPressed: Bool = GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: .keyB)?.isPressed ?? false
        if bKeyIsPressed {
            KestrelSphere.logger.trace("Setting undefined state")
            self.isGrowing = false
            self.isShrinking = false
        }

        guard isGrowing != isShrinking else {
            KestrelSphere.logger.trace("The sphere must be growing or shrinking only")
            assertionFailure("Entity is in an undefined state")
            return
        }

        if self.scale.x < 0.1 {
            self.isGrowing = true
            self.isShrinking = false
        } else if self.scale.x > 1 {
            self.isGrowing = false
            self.isShrinking = true
        }

        let spaceBarIsPressed: Bool =
        GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: .spacebar)?.isPressed ?? false
        if spaceBarIsPressed {
            if isGrowing {
                KestrelSphere.logger.trace("Grow the sphere")
                self.scale += SIMD3<Float>(repeating: 0.005)
            }
            if isShrinking {
                KestrelSphere.logger.trace("Shrink the sphere")
                self.scale -= SIMD3<Float>(repeating: 0.005)
            }
        }
        KestrelSphere.logger.trace("Update complete")
    }
}
