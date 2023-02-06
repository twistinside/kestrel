import simd
import YuzuKit

protocol Camera: Rotatable, Translatable {
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
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4.perspective(degreesFov: fov, aspectRatio: aspect, near: near, far: far)
    }

    var viewMatrix: matrix_float4x4 {
        var viewMatrix = matrix_identity_float4x4
        viewMatrix.translate(direction: -position)
        return viewMatrix
    }
}
