protocol Rotatable: Entity {
    var rotation: SIMD3<Float> { get set }

    func rotate(by vector: SIMD3<Float>)
}

extension Rotatable {
    func rotate(by vector: SIMD3<Float>) {
        self.rotation += vector
    }
}
