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
    var renderPipelineState: MTLRenderPipelineState
    var rotation: SIMD3<Float>
    var scale: SIMD3<Float>

    var isGrowing: Bool = false
    var isShrinking: Bool = true

    // MARK: init()
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

    // MARK: update()
    override func update(deltaTime: Float) {
        KestrelSphere.logger.trace("Updating Kestrel Sphere")

        // MARK: Transformable
        self.rotate(by: SIMD3<Float>(deltaTime, deltaTime/2, deltaTime/3))

        let fKeyIsPressed = ServiceLocator.shared.inputHandler.keyIsPressed(.keyF)
        if fKeyIsPressed {
            KestrelSphere.logger.trace("Setting undefined state")
            self.isGrowing = true
            self.isShrinking = true
        }

        let uKeyIsPressed = ServiceLocator.shared.inputHandler.keyIsPressed(.keyU)
        if uKeyIsPressed {
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

        let spaceBarIsPressed = ServiceLocator.shared.inputHandler.keyIsPressed(.spacebar)
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

        // MARK: Render pipeline state
        var renderPipelineStateName: RenderPipelineStateName

        let rKeyIsPressed = ServiceLocator.shared.inputHandler.keyIsPressed(.keyR)
        let gKeyIsPressed = ServiceLocator.shared.inputHandler.keyIsPressed(.keyG)
        let bKeyIsPressed = ServiceLocator.shared.inputHandler.keyIsPressed(.keyB)

        if rKeyIsPressed {
            renderPipelineStateName = .monoRed
        } else if gKeyIsPressed {
            renderPipelineStateName = .monoGreen
        } else if bKeyIsPressed {
            renderPipelineStateName = .monoBlue
        } else {
            renderPipelineStateName = .basic
        }

        let renderPipelineState = RenderPiplelineStateLibrary.shared.getRenderPipelineStateNamed(renderPipelineStateName)
        self.renderPipelineState = renderPipelineState

        KestrelSphere.logger.trace("Update complete")
    }
}
