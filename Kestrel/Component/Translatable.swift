protocol Translatable: Entity {
    var position: SIMD3<Float> { get set }
    
    func translate(by vector: SIMD3<Float>)
}

extension Translatable {
    func translate(by vector: SIMD3<Float>) {
        self.position += vector
    }
}
