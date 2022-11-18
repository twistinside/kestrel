import MetalKit
import YuzuKit

protocol Renderable: Entity {
    var meshes: [MTKMesh] { get }
    var position: SIMD3<Float> { get }
    var rotation: SIMD3<Float> { get }
    var scale: SIMD3<Float> { get }

    func render(renderCommandEncoder: MTLRenderCommandEncoder)
}

extension Renderable {
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for mesh in meshes {
            for vertexBuffer in mesh.vertexBuffers {
                var modelMatrix = YZKModelMatrix.from(position: position, rotation: rotation, scale: scale)
                renderCommandEncoder.setVertexBytes(&modelMatrix,
                                                    length: MemoryLayout<matrix_float4x4>.stride,
                                                    index: 1)
                renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                for submesh in mesh.submeshes {
                    renderCommandEncoder.drawIndexedPrimitives(type: Kestrel.shared.primitiveType,
                                                               indexCount: submesh.indexCount,
                                                               indexType: submesh.indexType,
                                                               indexBuffer: submesh.indexBuffer.buffer,
                                                               indexBufferOffset: submesh.indexBuffer.offset,
                                                               instanceCount: 1)
                }
            }
        }
    }
}

extension Array where Element: Renderable {
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        self.forEach { $0.render(renderCommandEncoder: renderCommandEncoder) }
    }
}
