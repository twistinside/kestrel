import Foundation
import MetalKit
import os

class Kestrel: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Kestrel.self)
    )

    static let shared = Kestrel()

    let camera: Camera
    var entities: [Entity] = []

    private init() {
        Kestrel.logger.trace("Initializing kestrel game object")

        // initialize the camera
        let camera = StandardCamera()
        self.camera = camera
        entities.append(camera)

        // initialize other entities
        entities.append(KestrelSphere())
        Kestrel.logger.trace("Initialization complete")
    }

    func update(deltaTime: Float) {
        Kestrel.logger.trace("Start entity update")
        entities.update(deltaTime: deltaTime)
        Kestrel.logger.trace("End entity update")
    }

    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        Kestrel.logger.trace("Start entity render")
        for entity in entities {
            if let renderable = entity as? Renderable {
                Kestrel.logger.trace("Rendering entity")
                renderable.render(renderCommandEncoder: renderCommandEncoder)
                Kestrel.logger.trace("Rendering complete")
            }
        }
        Kestrel.logger.trace("End entity render")
    }
}
