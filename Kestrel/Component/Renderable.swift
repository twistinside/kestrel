import GameController
import MetalKit
import YuzuKit

protocol Renderable: Entity {
    var meshes: [MTKMesh] { get }
    var position: SIMD3<Float> { get }
    var renderPipelineState: MTLRenderPipelineState { get }
    var rotation: SIMD3<Float> { get }
    var scale: SIMD3<Float> { get }

    func render(renderCommandEncoder: MTLRenderCommandEncoder)
}

extension Renderable {
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for mesh in meshes {
            for vertexBuffer in mesh.vertexBuffers {
                let modelMatrix = YZKModelMatrix.from(position: position, rotation: rotation, scale: scale)
                let projectionMatrix = Kestrel.shared.camera.projectionMatrix
                let viewMatrix = Kestrel.shared.camera.viewMatrix
                var uniforms = Uniforms(modelMatrix: modelMatrix,
                                        projectionMatrix: projectionMatrix,
                                        viewMatrix: viewMatrix)

                let depthStencilDescriptor = MTLDepthStencilDescriptor()
                depthStencilDescriptor.isDepthWriteEnabled = true
                depthStencilDescriptor.depthCompareFunction = .less
                let depthStencilState =
                    MetalStore.shared.device.makeDepthStencilState(descriptor: depthStencilDescriptor)
                renderCommandEncoder.setDepthStencilState(depthStencilState)

                renderCommandEncoder.setRenderPipelineState(renderPipelineState)

                renderCommandEncoder.setVertexBytes(&uniforms,
                                                    length: MemoryLayout<Uniforms>.stride,
                                                    index: 1)
                renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                for submesh in mesh.submeshes {
                    renderCommandEncoder.drawIndexedPrimitives(type: RenderSettings.shared.primitiveType,
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
