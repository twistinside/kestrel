import Foundation
import os

class StandardCamera: Entity, Camera {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: StandardCamera.self)
    )

    var aspect: Float = 1.0 {
        didSet {
            StandardCamera.logger.trace("Aspect ratio updated to \(self.aspect)")
        }
    }

    var fov: Float = 100.0
    var far: Float = 100.0
    var near: Float = 0.01
    var position: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, 10.0)
    var rotation: SIMD3<Float> = SIMD3<Float>(repeating: 0.0)

    override func update(deltaTime: Float) {
        if ServiceLocator.shared.inputHandler.keyIsPressed(.upArrow) {
            position.y += deltaTime
        }
        if ServiceLocator.shared.inputHandler.keyIsPressed(.downArrow) {
            position.y -= deltaTime
        }
        if ServiceLocator.shared.inputHandler.keyIsPressed(.rightArrow) {
            position.x += deltaTime
        }
        if ServiceLocator.shared.inputHandler.keyIsPressed(.leftArrow) {
            position.x -= deltaTime
        }
        if ServiceLocator.shared.inputHandler.keyIsPressed(.keyI) {
            position.z += deltaTime
        }
        if ServiceLocator.shared.inputHandler.keyIsPressed(.keyO) {
            position.z -= deltaTime
        }
    }
}
