class StandardCamera: Entity, Camera {
    var aspect: Float = 1.0
    var fov: Float = 100.0
    var far: Float = 100.0
    var near: Float = 0.01
    var position: SIMD3<Float> = SIMD3<Float>(-1.0, 0.0, 0.0)
    var rotation: SIMD3<Float> = SIMD3<Float>(repeating: 0.0)
}
