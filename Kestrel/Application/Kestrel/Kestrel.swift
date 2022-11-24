import Foundation
import MetalKit
import os

class Kestrel: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Kestrel.self)
    )

    static let shared = Kestrel()

    var entities: [Entity] = []

    @Published var geometryType: MDLGeometryType = .triangles
    @Published var primitiveType: MTLPrimitiveType = .triangle
    @Published var clearColor: MTLClearColor = MTLClearColor(red: 0.73,
                                                             green: 0.23,
                                                             blue: 0.35,
                                                             alpha: 1.0)

    private init() {
        print("Initializing kestrel game object.")
        entities.append(KestrelSphere())
    }

    func update(deltaTime: Float) {
        Self.logger.trace("Start entity update")
        entities.update(deltaTime: deltaTime)
        Self.logger.trace("End entity update")
    }

    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for entity in entities {
            if let renderable = entity as? Renderable {
                renderable.render(renderCommandEncoder: renderCommandEncoder)
            }
        }
    }
}
