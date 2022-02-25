protocol Scalable: Entity {
    var scale: SIMD3<Float> { get set }
    
    func scale(by factor: SIMD3<Float>)
    func scaleUniformly(by factor: Float)
}

extension Scalable {
    func scale(by factor: SIMD3<Float>) {
        self.scale += factor
    }
    
    func scaleUniformly(by factor: Float) {
        self.scale += SIMD3<Float>(repeating: factor)
    }
}
