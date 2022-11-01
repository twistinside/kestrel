import simd
import YuzuKit

protocol Camera: Translatable, Rotatable {
    var aspect: Float { get set }
    var fov: Float { get set }
    var far: Float { get set }
    var near: Float { get set }
    var position: SIMD3<Float> { get set }
    var rotation: SIMD3<Float> { get set }
    var projectionMatrix: simd_float4x4 { get }
    var viewMatrix: simd_float4x4 { get }
}

extension Camera {
    var projectionMatrix: simd_float4x4 {
        YZKProjectionMatrix.standard(fov: fov, near: near, far: far, aspect: aspect)
    }

    var viewMatrix: simd_float4x4 {
        YZKViewMatrix.from(position: position, rotation: rotation)
    }
}
